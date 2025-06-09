import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import 'src/service/service.dart';

/// A class for handling translations in a Flutter application using JSON files.
/// This class loads language files and returns translations based on the current locale.
class Translate {
  /// Indicates if debug mode is active.
  /// When enabled, warning messages will be printed for missing translations or issues.
  static bool _isDevMode = false;

  /// Indicates if the default language is being used.
  static bool isDefaultLang = false;

  /// The default language code to use if the specific language file is not found.
  static late String _defaultLangCode;
  static String get defaultLangCode => _defaultLangCode;

  /// The path where localization JSON files are stored.
  static String _localizationPath = "assets/localization/";

  /// The current language code (e.g., 'en' or 'en_US').
  static late String _langCode;
  static String get localizationPath => _localizationPath;
  static List<String> _supportedLangs = [];
  static List<String> get supportedLangs => _supportedLangs;

  static Service? _service;

  /// The key for the specific translation being accessed.
  String key;

  /// Constructs a [Translate] object with the specified translation [key].
  Translate(this.key);

  /// Initializes the translation system with the specified default language code.
  ///
  /// [defaultLangCode] is the fallback language code if the system's language file isn't available.
  /// [path] is the custom path for the localization files (optional).
  /// /// [isDevMode] enables or disables debug mode (optional).
  static Future<void> init({
    required String defaultLangCode,
    String? path,
    bool? isDevMode,
    Service? service,
  }) async {
    _supportedLangs = null ?? [defaultLangCode];
    _defaultLangCode = defaultLangCode;
    _localizationPath = path ?? _localizationPath;
    _isDevMode = isDevMode ?? _isDevMode;
    _langCode = _getLangCode();
     await _getSupportedLangs();
    // _supportedLangs = ["en"];
    String jsonString = await _getJsonString();

    
    print("service is :${_service}");
    print("_localizationPath is :${_localizationPath}");
    if(_isDevMode && true){
      _service = service;
          await service?.init();
    }


    json = {};
    json.addAll(jsonDecode(jsonString));
    // json = {"en":{"menu_33":"www"}, "ar":{"menu_33":"dd"}};
    // print(supportedLangs);
    // print("supported langs");
  }

  /// Loads the JSON string from the appropriate file based on the language code.
  ///
  /// If the file for the current language code does not exist, it falls back to the default language file.
  static Future<String> _getJsonString([String? langCode]) async {
    langCode ??= _langCode;
    try {
      print("test langCode :$langCode");
      return await rootBundle
          .loadString(_localizationPath + langCode + ".json");
    } catch (e) {

      if (_isDevMode) {
        print(langCode);
        print(
            "localization_lite: warning $langCode is not defined so we use $_defaultLangCode");
      }
      isDefaultLang = true;
      return await rootBundle
          .loadString(_localizationPath + _defaultLangCode + ".json");
    }
  }

  /// Retrieves the language code from the platform's locale.
  ///
  /// If [withCountryCode] is false, only the language code (e.g., 'en') is used.
  static String _getLangCode() {
    var langCode = Platform.localeName;
    if (langCode.length > 2) {
      langCode = langCode.substring(0, 2);
    }
    return langCode;
  }

  /// The map containing all loaded translations.
  static late Map<String, dynamic> json;

  static Future _getSupportedLangs() async {
    try {
      print("in getting");
      print("path is ${Translate.localizationPath}supported_languages.json");
        
      var fileData = await rootBundle
          .loadString('${Translate.localizationPath}supported_languages.json');
          var decodedData = jsonDecode(fileData);

      // print(
          // "localization_lite: supported langs are: ${decodedData?["langs"]}");
          // print (jsonDecode(fileData));
          // return ["en","es"];
          _supportedLangs =  List<String>.from(decodedData?["langs"] ?? [Translate.defaultLangCode]); 
    } catch (e) {
      print("localization_lite: supported_languages.json not found $e");
      print(
          "localization_lite: supported_languages = ${Translate.defaultLangCode}");
      _supportedLangs =  [Translate.defaultLangCode];
    }
  }

  /// Returns the translation for the given key as a string.
  ///
  /// If the key is not found in the JSON file, it returns the key itself as a fallback.
  /// In debug mode, it prints a warning message when a key is not found.
  @override
  String toString() {
    String result = json[key]?.trim() ?? "";
    print(result);
    if (result.isEmpty) {
      if (_isDevMode) {
        if (_service != null) {
          _service!.updateLocalization(key);
          //  note the above set without showing it to dont await
        } else {
          print(
              "localization_lite: warning ${key} is not defined in ${_langCode}");
        }
      }
      result = key;
    }
    return result;
  }

  static setLang(langCode) async{
    var decodedResult = jsonDecode(await _getJsonString(langCode));
    json = decodedResult;
  }

}

/// A shorthand function for accessing translations.
///
/// This function returns the translated string for the given [key].
/// If the key is not found, it returns the key itself as a fallback.
String tr(String key) {
  return Translate(key).toString();
}
