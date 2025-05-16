import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../const.dart';
import '../ai_service.dart';

class DeepSeek extends AiService {
  DeepSeek({required super.apiKey});
  static const String modelName = "deepSeek";
  @override
  String get name => modelName;

  static const String model = "deepseek-chat";

  final Uri url = Uri.parse('https://api.deepseek.com/v1/chat/');

  @override
  String? getResult() {
    return data['choices'][0]['message']['content'];
  }

  @override
  Future<http.Response> getResponse(prompt) async {
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
