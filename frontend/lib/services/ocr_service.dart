import 'package:google_ml_kit/google_ml_kit.dart';

class OCRService {
  final textRecognizer = TextRecognizer();

  // Extract text from image using Google ML Kit
  Future<String> extractTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await textRecognizer.processImage(inputImage);
      
      // Return all recognized text
      return recognizedText.text;
    } catch (e) {
      print('OCR Error: $e');
      return '';
    }
  }

  // Extract and parse ingredient list from text
  Future<List<String>> extractIngredients(String imagePath) async {
    try {
      final text = await extractTextFromImage(imagePath);
      
      if (text.isEmpty) {
        return [];
      }

      // Simple parsing: split by common delimiters
      // This can be improved with more sophisticated parsing
      final ingredients = text
          .split(RegExp(r'[,，、\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      return ingredients;
    } catch (e) {
      print('Ingredient extraction error: $e');
      return [];
    }
  }

  // Clean up resources
  void dispose() {
    textRecognizer.close();
  }
}
