import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localization_lite/simple_localization.dart';
import '../ai_service.dart';

class ChatGpt extends AiService {
    ChatGpt({required super.apiKey});
  static const String modelName = "chatGpt";
  static const String model = "gpt-3.5-turbo";
  @override
  String get name => modelName;

  final Uri url = Uri.parse('https://api.openai.com/v1/chat/completions');

  @override
  String? getResult() {
    return data['choices'][0]['message']['content'];
  }
  

  @override
  Future<http.Response> getResponse(prompt) async{
    
    return await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${super.apiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": model,
        "messages": [
          {"role": "system","content":kCommonKeyValuesPrompt},
          {"role": "user", "content": prompt},
        ],
      }),
    );
  }
}
