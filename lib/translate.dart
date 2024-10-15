import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A class for handling translations in a Flutter application using JSON files.
/// This class loads language files and returns translations based on the current locale.
class Translate {
  /// Indicates if the default language is being used.
  static bool isDefaultLang = false;

  /// Whether to use the language code with the country code (e.g., 'en_US').
  static late bool _withCountryCode;

  /// The default language code to use if the specific language file is not found.
  static late String _defaultLangCode;

  /// The path where localization JSON files are stored.
  static String _localizationPath = "assets/localization/";

  /// The current language code (e.g., 'en' or 'en_US').
  static late String _langCode;

  /// Initializes the translation system with the specified default language code.
  ///
  /// [defaultLangCode] is the fallback language code if the system's language file isn't available.
  /// [withCountryCode] specifies if the language code should include the country code (e.g., 'en_US').
  /// [path] is the custom path for the localization files (optional).
  static Future<void> init({
    required String defaultLangCode,
    bool withCountryCode = false,
    String? path,
  }) async {
    _defaultLangCode = defaultLangCode;
    _withCountryCode = withCountryCode;
    _localizationPath = path ?? _localizationPath;
    _langCode = _getLangCode();
    String jsonString = await _getJsonString();

    json = {};
    json.addAll(jsonDecode(jsonString));
  }

  /// Loads the JSON string from the appropriate file based on the language code.
  ///
  /// If the file for the current language code does not exist, it falls back to the default language file.
  static Future<String> _getJsonString() async {
    if (await File(_localizationPath + _langCode).exists()) {
      return await rootBundle
          .loadString(_localizationPath + _langCode + ".json");
    } else {
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
    if (langCode.length > 2 && !_withCountryCode) {
      langCode = langCode.substring(1, 3);
    }
    return langCode;
  }

  /// The map containing all loaded translations.
  static late Map<String, dynamic> json;

  /// The key for the specific translation being accessed.
  String key;

  /// Constructs a [Translate] object with the specified translation [key].
  Translate(this.key);

  /// Returns the translation for the given key as a string.
  ///
  /// If the key is not found in the JSON file, it returns the key itself as a fallback.
  /// In debug mode, it prints a warning message when a key is not found.
  @override
  String toString() {
    String result = json[key]?.trim() ?? "";
    if (result.isEmpty) {
      if (kDebugMode) {
        print(
            "localization_lite: warning ${key} is not defined in ${_langCode}");
      }
      result = key;
    }
    return result;
  }
}

/// A shorthand function for accessing translations.
///
/// This function returns the translated string for the given [key].
/// If the key is not found, it returns the key itself as a fallback.
String tr(String key) {
  return Translate(key).toString();
}
