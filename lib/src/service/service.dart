import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../simple_localization.dart';
import '../../translate.dart';

abstract class Service {
  /// A list of supported language codes.
  // List<String> supportedLangs = [];
  Map<String, Map<String, dynamic>> content = {};
  static const folderName = "localization_lite";

  Future init() async {
    print("localization_lite: service init");
    // await _getSupportedLangs();
    await _loadAllLanguageFiles();
    await initialFill();
    // print(supportedLangs);
  }

  Future<void> initialFill() async {
    print("localization_lite: initial fill");
    await _saveAll();
  }

  Future<void> updateLocalization(key) async {
    print("localization_lite: update localization");
    await _saveAll();
  }

  // Future<void> _getSupportedLangs() async {
  //   try {
  //     var fileData = await rootBundle
  //         .loadString('${Translate.localizationPath}supported_langs.json');

  //     supportedLangs =
  //         jsonDecode(fileData)?["langs"] ?? [Translate.defaultLangCode];
  //         print("localization_lite: suppoted langs are: $supportedLangs");
  //   } catch (e) {
  //     print("localization_lite: supported_langs.json not found");
  //     print(
  //         "localization_lite: supported_langs = ${Translate.defaultLangCode}");
  //     supportedLangs = [Translate.defaultLangCode];
  //   }
  // }

  Future<void> _loadAllLanguageFiles() async {
    for (final lang in Translate.supportedLangs) {
      // final file = File('${Translate.localizationPath}/$lang.json');
      // if (await file.exists()) {
      try{
      final fileData = await rootBundle
          .loadString('${Translate.localizationPath}$lang.json');
      content[lang] = jsonDecode(fileData);}
      catch(e){
        print("localization_lite: $lang.json not found");
      }
      // }
      // else {
      // content[lang] = {};
      // print('localization_lite: $lang.json not found, creating empty map');
      // }
    }
  }

  Future<void> _saveAll() async {
      var StorePath = await getStorePath();
      print("localization_lite: save all");
      for (final entry in content.entries) {
        final lang = entry.key;
        final map = entry.value;
        if (StorePath.isNotEmpty) {
          print("path is:: ${StorePath}");
          var dir = Directory(StorePath);
          if(!dir.existsSync()){
            dir.createSync(recursive: true);
          }
          final file = File('${StorePath}/$lang.json');
          if(!file.existsSync()){
          await file.create();}
          final content = const JsonEncoder.withIndent('  ').convert(map);
          await file.writeAsString(content);
          print("Localization_lite: to copy new localization write in terminal: "+getCopyCommand(StorePath));
          
        }
      }
    }

/// Returns the full path to the localization folder based on platform.
Future<String> getStorePath() async {
  String basePath;

  if (Platform.isAndroid) {
    basePath = "/storage/emulated/0/Download";
  } else if (Platform.isIOS || Platform.isMacOS) {
    final downloadsDir = await getApplicationDocumentsDirectory(); // For iOS/macOS
    basePath = downloadsDir.path;
  } else if (Platform.isWindows) {
    final downloadsDir = await getDownloadsDirectory(); // Windows only
    if (downloadsDir == null) throw Exception("Unable to get Downloads directory on Windows.");
    basePath = downloadsDir.path;
  } else {
    throw UnsupportedError("Unsupported platform: ${Platform.operatingSystem}");
  }

  return p.join(basePath, folderName);
}

/// Returns the appropriate command to copy translation files to assets/localization.
String getCopyCommand(String path)  {
  if (Platform.isAndroid) {
    return 'adb pull "$path/." ${Translate.localizationPath}';
  } else if (Platform.isIOS || Platform.isMacOS) {
    return 'cp -r "$path/." ${Translate.localizationPath}';
  } else if (Platform.isWindows) {
    return 'xcopy "${path}\\*" "${Translate.localizationPath.replaceAll("/", "\\")}" /E /I /Y';
  } else {
    throw UnsupportedError("Unsupported platform: ${Platform.operatingSystem}");
  }
}

}
