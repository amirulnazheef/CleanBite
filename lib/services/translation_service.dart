import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslationService {
  Future<String> translateToEnglish(String koreanText) async {
    final apiKey = 'YOUR_GOOGLE_API_KEY';  // Replace with your API key
    final url = 'https://translation.googleapis.com/language/translate/v2?key=$apiKey';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'q': koreanText,
        'source': 'ko',
        'target': 'en',
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data']['translations'][0]['translatedText'];
    } else {
      return 'Translation failed';
    }
  }
}