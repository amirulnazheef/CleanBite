import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ocr_service.dart';
import '../services/translation_service.dart';
import '../services/database_service.dart';
import '../services/ai_classification_service.dart';
import '../models/product.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String scanResult = 'Align barcode and scan';

  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      String barcodeData = result.rawContent;
      
      setState(() { scanResult = 'Checking database...'; });
      
      // Step 1: Query database first
      final product = await DatabaseService().fetchProductByBarcode(barcodeData);
      if (product != null) {
        Navigator.pushNamed(context, '/results', arguments: product);
      } else {
        setState(() { scanResult = 'Product not found. Scanning ingredients...'; });
        
        // Fallback to OCR
        String imagePath = await pickImage();
        if (imagePath.isEmpty) {
          setState(() { scanResult = 'No image selected'; });
          return;
        }
        
        setState(() { scanResult = 'Extracting text...'; });
        String extractedText = await OCRService().extractTextFromImage(imagePath);
        
        if (extractedText.isEmpty) {
          setState(() { scanResult = 'No text found in image'; });
          return;
        }
        
        setState(() { scanResult = 'Translating...'; });
        String translatedText = await TranslationService().translateToEnglish(extractedText);
        
        setState(() { scanResult = 'Classifying ingredients...'; });
        List<String> ingredients = translatedText.split(',').map((e) => e.trim()).toList();
        Map<String, dynamic> classification = await AIClassificationService().classifyIngredients(ingredients);
        
        // Create a temporary product from OCR results
        final tempProduct = Product(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          barcode: barcodeData,
          nameKorean: 'Unknown Product',
          nameEnglish: 'Unknown Product',
          brand: 'Unknown',
          imageUrl: '',
          ingredientsKorean: extractedText.split(',').map((e) => e.trim()).toList(),
          ingredientsEnglish: ingredients,
          isHalal: classification['isHalal'] ?? false,
          isVegan: classification['isVegan'] ?? false,
          isVegetarian: classification['isVegetarian'] ?? false,
          isKosher: classification['isKosher'] ?? false,
          allergens: List<String>.from(classification['allergens'] ?? []),
          problematicIngredients: List<String>.from(classification['problematicIngredients'] ?? []),
          explanation: classification['explanation'] ?? 'No explanation available',
        );
        
        Navigator.pushNamed(context, '/results', arguments: tempProduct);
      }
    } catch (e) {
      setState(() { scanResult = 'Scan failed: $e'; });
    }
  }

  Future<String> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    return pickedFile?.path ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(scanResult),
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Scan Barcode'),
            ),
            Text('Or use manual input if needed'),
          ],
        ),
      ),
    );
  }
}