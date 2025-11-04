import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import '../models/product.dart';

class BackendService {
  // CHANGE THIS BASED ON YOUR DEVICE:
  // Chrome/Desktop: http://localhost:8000 or http://192.168.0.4:8000
  // Android Emulator: http://10.0.2.2:8000
  // Real Device: http://YOUR_COMPUTER_IP:8000
  static const String baseUrl = 'http://192.168.0.4:8000';
  
  /// Check if Python backend is running
  Future<bool> isBackendRunning() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/'),
      ).timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      print('Backend health check failed: $e');
      return false;
    }
  }
  
  /// Process image with Python backend (WEB-COMPATIBLE VERSION)
  /// Works with both File (mobile) and Uint8List (web)
  Future<Product> processProductImage(dynamic imageData, String filename) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/process-ingredients/'),
      );
      
      // Handle both File (mobile) and bytes (web)
      if (imageData is Uint8List) {
        // Web: Use bytes directly
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageData,
            filename: filename,
          ),
        );
      } else {
        // Mobile: Use file path
        request.files.add(
          await http.MultipartFile.fromPath('file', imageData.path),
        );
      }
      
      print('Sending image to backend...');
      
      // Send request
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      
      // Get response
      var response = await http.Response.fromStream(streamedResponse);
      
      print('Backend response status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw Exception('Backend error: ${response.statusCode}\n${response.body}');
      }
      
      // Parse JSON response
      Map<String, dynamic> data = json.decode(response.body);
      print('Backend response: $data');
      
      // Convert to Product
      return _parseBackendResponse(data);
      
    } catch (e) {
      throw Exception('Failed to process image: $e');
    }
  }
  
  /// Parse backend response into Product model
  Product _parseBackendResponse(Map<String, dynamic> data) {
    // Extract data from backend response
    var ingredients = (data['ingredients'] as List?) ?? [];
    var allergens = (data['allergens'] as List?) ?? [];
    var classification = data['product_classification'] ?? {};
    
    // Extract ingredient names
    List<String> ingredientNames = ingredients
        .map((i) => i['name'] as String)
        .toList();
    
    // Extract allergen names
    List<String> allergenNames = allergens
        .map((a) => a['name'] as String)
        .toList();
    
    // Find problematic ingredients (anything that fails any diet)
    List<String> problematic = [];
    for (var ing in ingredients) {
      // If ANY dietary flag is false, it's problematic
      if (!(ing['vegan'] == true && 
            ing['vegetarian'] == true && 
            ing['halal'] == true && 
            ing['kosher'] == true)) {
        problematic.add(ing['name']);
      }
    }
    
    // Create Product from backend data
    return Product(
      id: 'backend_${DateTime.now().millisecondsSinceEpoch}',
      barcode: '', // No barcode for OCR-scanned products
      nameKorean: 'Scanned Product',
      nameEnglish: 'Scanned Product',
      brand: 'Unknown',
      imageUrl: '',
      ingredientsKorean: ingredientNames, // Backend returns English
      ingredientsEnglish: ingredientNames,
      isHalal: classification['halal'] ?? false,
      isVegan: classification['vegan'] ?? false,
      isVegetarian: classification['vegetarian'] ?? false,
      isKosher: classification['kosher'] ?? false,
      allergens: allergenNames,
      problematicIngredients: problematic,
      explanation: data['dietary_summary'] ?? 'Classification unavailable',
      ingredientDetails: ingredients,  // Store detailed data
      allergenDetails: allergens,      // Store detailed data
    );
  }
}
