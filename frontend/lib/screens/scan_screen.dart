import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../services/database_service.dart';
import '../services/backend_service.dart';
import '../models/product.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final DatabaseService _dbService = DatabaseService();
  final BackendService _backendService = BackendService();
  final ImagePicker _picker = ImagePicker();
  
  bool _isLoading = false;
  String _statusMessage = 'Align barcode and scan';

  Future<void> scanBarcode() async {
    try {
      setState(() {
        _isLoading = true;
        _statusMessage = 'Scanning barcode...';
      });
      
      // Scan barcode
      var result = await BarcodeScanner.scan();
      String barcodeData = result.rawContent;
      
      if (barcodeData.isEmpty) {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Scan cancelled';
        });
        return;
      }
      
      // Check mock database first
      setState(() => _statusMessage = 'Checking database...');
      final product = await _dbService.fetchProductByBarcode(barcodeData);
      
      if (product != null) {
        // Found in mock database
        _navigateToResults(product);
      } else {
        // Not found - prompt for ingredient photo
        _promptForIngredientPhoto();
      }
      
    } catch (e) {
      _showError('Barcode scan failed', e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _promptForIngredientPhoto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Not Found'),
        content: const Text(
          'This product is not in our database.\n\n'
          'Upload a photo of the ingredient list to analyze it with AI.'
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _statusMessage = 'Align barcode and scan');
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _pickIngredientPhoto();
            },
            icon: const Icon(Icons.photo_library),
            label: const Text('Choose Photo'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickIngredientPhoto() async {
    try {
      setState(() {
        _isLoading = true;
        _statusMessage = kIsWeb ? 'Opening file picker...' : 'Opening camera...';
      });
      
      // Pick image (gallery for web, camera for mobile)
      final XFile? photo = await _picker.pickImage(
        source: kIsWeb ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 85,
      );
      
      if (photo == null) {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Photo cancelled';
        });
        return;
      }
      
      // Process with Python backend
      await _processWithBackend(photo);
      
    } catch (e) {
      _showError('Photo selection failed', e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processWithBackend(XFile imageFile) async {
    try {
      // Check if backend is running
      setState(() => _statusMessage = 'Connecting to server...');
      
      bool backendOk = await _backendService.isBackendRunning();
      if (!backendOk) {
        throw Exception(
          'Python backend is not running.\n\n'
          'Please start it with:\nuvicorn app:app --host 0.0.0.0 --port 8000 --reload'
        );
      }
      
      // Process image
      setState(() => _statusMessage = 'Analyzing ingredients...\n(This may take 10-30 seconds)');
      
      Product product;
      
      if (kIsWeb) {
        // Web: Read as bytes
        final bytes = await imageFile.readAsBytes();
        product = await _backendService.processProductImage(bytes, imageFile.name);
      } else {
        // Mobile: Use file
        product = await _backendService.processProductImage(File(imageFile.path), imageFile.name);
      }
      
      // Navigate to results
      _navigateToResults(product);
      
    } catch (e) {
      _showError('Processing failed', '$e\n\nMake sure Python backend is running at:\n${BackendService.baseUrl}');
    }
  }

  void _navigateToResults(Product product) {
    setState(() => _isLoading = false);
    Navigator.pushNamed(
      context,
      '/results',
      arguments: product,
    );
  }

  void _showError(String title, String message) {
    setState(() {
      _isLoading = false;
      _statusMessage = 'Error occurred';
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _statusMessage = 'Align barcode and scan');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  if (!kIsWeb) ...[
                    ElevatedButton.icon(
                      onPressed: scanBarcode,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan Barcode'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ElevatedButton.icon(
                    onPressed: _pickIngredientPhoto,
                    icon: Icon(kIsWeb ? Icons.photo_library : Icons.camera_alt),
                    label: Text(kIsWeb ? 'Upload Ingredient Photo' : 'Take Ingredient Photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}