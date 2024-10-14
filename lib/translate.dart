
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class Translate {
  static Future<void> init({required String defaultLangCode, bool withCountryCode = false})async{
    String langCode = _getLangCode(withCountryCode);
    String localizationPath = "assets/localization/";
    String jsonString = await _getJsonString(localizationPath,langCode,defaultLangCode);

    json = {};
    json.addAll(jsonDecode(jsonString));
  }
  static Future<String> _getJsonString(localizationPath,langCode,defaultLangCode) async{
    if(await File(localizationPath + langCode).exists()){
      return  await rootBundle.loadString(localizationPath + langCode+".json");
    }else {
      return  await rootBundle.loadString(localizationPath + defaultLangCode+".json");
    }
  }
  static String _getLangCode(withCountryCode) {
    var langCode =Platform.localeName;
    if(langCode.length >2 && !withCountryCode){
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
    if(result.isEmpty){result = key;}
    return result;
  }

}
