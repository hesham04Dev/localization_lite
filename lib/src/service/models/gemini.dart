import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:localization_lite/simple_localization.dart';
import 'package:localization_lite/src/service/ai_service.dart';

class Gemini extends AiService {
   static const String modelName = "Gemini";

  @override
  String get name => modelName;

  static const String model = "gemini-2.0-flash";

  final String _url = "https://generativelanguage.googleapis.com/v1beta/models";

  Gemini({required super.apiKey});

  @override
  String? getResult() {
    print(data['candidates']?[0]?['content']?['parts']?[0]?['text']);
    return data['candidates']?[0]?['content']?['parts']?[0]?['text'];
  }

  @override
  Future<http.Response> getResponse(prompt) async{
    prompt = kCommonKeyValuesPrompt +kCommonKeyValuesExample + prompt;
    return await http.post(Uri.parse('$_url/$model:generateContent?key=${super.apiKey}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );
  }
}
