import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class BackendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch the backend URL from Firebase
  Future<String?> getBackendUrl() async {
    try {
      final doc = await _firestore.collection('config').doc('backend').get();
      if (!doc.exists) {
        debugPrint('❌ Backend config document does not exist');
        return null;
      }
      final url = doc.data()?['url'] as String?;
      if (url == null || url.isEmpty) {
        debugPrint('❌ Backend URL is empty or null');
        return null;
      }
      debugPrint('✅ Backend URL fetched: $url');
      return url;
    } catch (e) {
      debugPrint('❌ Error fetching backend URL: $e');
      return null;
    }
  }

  /// Process image - accepts both File (mobile) and Uint8List (web)
  Future<Map<String, dynamic>?> processImage(
    dynamic fileOrBytes, {
    String? fileName,
    String endpoint = '/process-ingredients/', // Match FastAPI endpoint
  }) async {
    final baseUrl = await getBackendUrl();
    if (baseUrl == null) {
      debugPrint('❌ Backend URL not found in Firestore');
      return null;
    }

    // Construct full URL with endpoint
    String fullUrl = baseUrl;
    if (!baseUrl.endsWith('/') && !endpoint.startsWith('/')) {
      fullUrl = '$baseUrl/$endpoint';
    } else if (baseUrl.endsWith('/') && endpoint.startsWith('/')) {
      fullUrl = '$baseUrl${endpoint.substring(1)}';
    } else {
      fullUrl = '$baseUrl$endpoint';
    }

    debugPrint('🌐 Sending request to: $fullUrl');

    try {
      var request = http.MultipartRequest('POST', Uri.parse(fullUrl));

      // Determine file type from filename
      String contentTypeStr = 'image/jpeg';
      if (fileName != null) {
        if (fileName.toLowerCase().endsWith('.png')) {
          contentTypeStr = 'image/png';
        } else if (fileName.toLowerCase().endsWith('.jpg') || 
                   fileName.toLowerCase().endsWith('.jpeg')) {
          contentTypeStr = 'image/jpeg';
        }
      }

      final contentTypeParts = contentTypeStr.split('/');
      final contentType = MediaType(contentTypeParts[0], contentTypeParts[1]);

      // Handle both File and bytes
      if (kIsWeb && fileOrBytes is Uint8List) {
        debugPrint('📱 Web platform - sending ${fileOrBytes.length} bytes');
        request.files.add(
          http.MultipartFile.fromBytes(
            'file', // Change this if your FastAPI expects different field name
            fileOrBytes,
            filename: fileName ?? 'upload.jpg',
            contentType: contentType,
          ),
        );
      } else if (fileOrBytes is File) {
        final fileSize = await fileOrBytes.length();
        debugPrint('📱 Mobile platform - sending file: ${fileOrBytes.path} ($fileSize bytes)');
        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // Change this if your FastAPI expects different field name
            fileOrBytes.path,
            contentType: contentType,
          ),
        );
      } else if (fileOrBytes is Uint8List) {
        debugPrint('📱 Fallback - sending ${fileOrBytes.length} bytes');
        request.files.add(
          http.MultipartFile.fromBytes(
            'file', // Change this if your FastAPI expects different field name
            fileOrBytes,
            filename: fileName ?? 'upload.jpg',
            contentType: contentType,
          ),
        );
      } else {
        debugPrint('❌ Invalid file type: ${fileOrBytes.runtimeType}');
        return null;
      }

      debugPrint('⏳ Sending request...');

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60), // Increased timeout for OCR processing
        onTimeout: () {
          throw TimeoutException('Request timeout after 60 seconds');
        },
      );

      debugPrint('📥 Response status: ${streamedResponse.statusCode}');

      if (streamedResponse.statusCode == 200) {
        final respStr = await streamedResponse.stream.bytesToString();
        debugPrint('✅ Response body: ${respStr.substring(0, respStr.length > 200 ? 200 : respStr.length)}...');
        
        try {
          final data = json.decode(respStr) as Map<String, dynamic>;
          return data;
        } catch (e) {
          debugPrint('❌ Failed to parse JSON response: $e');
          debugPrint('Raw response: $respStr');
          return null;
        }
      } else {
        final errorBody = await streamedResponse.stream.bytesToString();
        debugPrint('❌ Server error ${streamedResponse.statusCode}');
        debugPrint('Error body: $errorBody');
        return null;
      }
    } on TimeoutException catch (e) {
      debugPrint('❌ Timeout exception: $e');
      return null;
    } on SocketException catch (e) {
      debugPrint('❌ Socket exception (network error): $e');
      return null;
    } catch (e) {
      debugPrint('❌ Exception during image processing: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return null;
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}