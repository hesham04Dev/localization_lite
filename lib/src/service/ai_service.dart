import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:localization_lite/translate.dart';

import '../const.dart';
import 'service.dart';

abstract class AiService extends Service {
  String apiKey;
  late Map data;
  AiService({required this.apiKey});

  String? getResult();
  Future<http.Response> getResponse(String prompt);
  String get name;

  @override
  Future<void> initialFill() async {
    final defaultLang = Translate.defaultLangCode;
    var keys = content[defaultLang]?.keys;
    print("def lang $defaultLang");
    keys?.forEach((key) {
      var genData = null;
     Translate.supportedLangs.forEach((lang) async{
        if (!content[lang]!.containsKey(key) || content[lang]![key] == "") {
          print("call to fill key");
          if(genData == null){
            print("call to gen data");
            genData = jsonDecode(await _getTranslation(key));
          }
          content[lang]![key] = genData[lang]?? "";
        }
      });
    });

    await super.initialFill();
  }

  @override
  Future<void> updateLocalization(key) async {
    await _setTranslation(key);
    await super.updateLocalization(key);
  }

  Future<void> _setTranslation(key) async {
    var res = jsonDecode(await _getTranslation(key));
    for (var lang in Translate.supportedLangs) {
      if (res[lang] != null &&
          res[lang] != "" &&
          (content[lang]![key]?.trim() == "" || content[lang]![key] == null)) {
        content[lang]![key] = res[lang];
      }
    }
  }

  Map<String, String> _getKeyValues(String key) {
    Map<String, String> keysAndValues = {"key": key};
    for (var lang in Translate.supportedLangs) {
      keysAndValues[lang] = content[lang]?[key] ?? "";
    }
    return keysAndValues;
  }

  Future<String> _getTranslation(String key) async {
    // context.loaderOverlay.show();
    Map<String, String> keysAndValues = _getKeyValues(key);
    final prompt = '''
    ${jsonEncode(keysAndValues)}
    ''';
    final values = await _sendRequest(prompt);
    final result = _removeMdJson(values);

    // context.loaderOverlay.hide();
    return result;
  }

  Future<String> _sendRequest(String prompt) async {
    final response = await getResponse(prompt);

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return getResult() ?? "{}";
    } else {
      print("failedToFetchFrom ${name}");
      return "{}";
    }
  }

  String _removeMdJson(String content) {
    // Try to extract content between ```json and ```
    // final jsonCodeBlockPattern = RegExp(r'```json\s*([\s\S]*?)\s*```');
    // final codeBlockPattern = RegExp(r'```\s*([\s\S]*?)\s*```');
    // final jsonPattern = RegExp(r'\{[\s\S]*?\}');

    // final matchJsonBlock = jsonCodeBlockPattern.firstMatch(content);
    // if (matchJsonBlock != null) {
    //   return matchJsonBlock.group(1)!.trim();
    // }

    // // Fallback: extract content between ``` and ```
    // final matchCodeBlock = codeBlockPattern.firstMatch(content);
    // if (matchCodeBlock != null) {
    //   return matchCodeBlock.group(1)!.trim();
    // }
    content.replaceAll('```json', '');
    content.replaceAll('```', '');

    int startIndex = content.indexOf('{');
    int endIndex = content.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
      final jsonStr = content.substring(startIndex, endIndex + 1);
      return jsonStr;
    }
    print("failed To Parse Response");
    throw Exception("No JSON content found");
  }
}
