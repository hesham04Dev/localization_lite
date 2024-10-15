
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Translate {
  static bool isDefaultLang =false;
  static late bool _withCountryCode;
  static late String _defaultLangCode;
  static String _localizationPath = "assets/localization/";
  static late String _langCode;

  static Future<void> init({required String defaultLangCode, bool withCountryCode = false,String? path})async{
    _defaultLangCode = defaultLangCode;
    _withCountryCode = withCountryCode;
    _localizationPath = path??_localizationPath;
    _langCode = _getLangCode();
    String jsonString = await _getJsonString();

    json = {};
    json.addAll(jsonDecode(jsonString));
  }
  static Future<String> _getJsonString() async{
    
    if(await File(_localizationPath + _langCode).exists()){
      return  await rootBundle.loadString(_localizationPath + _langCode+".json");
    }else {
      isDefaultLang =true;
      return  await rootBundle.loadString(_localizationPath + _defaultLangCode+".json");
    }
  }
  static String _getLangCode() {
    var langCode =Platform.localeName;
    if(langCode.length >2 && !_withCountryCode){
      langCode = langCode.substring(1,3);
    }
    return langCode;
  }
  static late Map<String,dynamic> json;
  String key;
  Translate(this.key);

  @override 
  String toString(){ 
    String result = json[key]?.trim()??"";
    if(result.isEmpty){
      if(kDebugMode){
        print("localization_lite: warning ${key} is not defined in ${_langCode}");

      }
      result = key;}
    return result;
  }

}

String tr(String key){
  return Translate(key).toString();
}
