// bin/init.dart
import 'dart:io';
import 'dart:convert';

Future<void> generateSupportedLangFile([String rawPath = 'assets/localization']) async {
  final path = rawPath.replaceAll("'", "").replaceAll('"', '').replaceAll(RegExp(r'[\\/]+$'), '');
  final localizationDir = Directory(path);

  if (!localizationDir.existsSync()) {
    print("❌ Directory not found: $path");
    exit(1);
  }

  final langs = localizationDir
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.json') &&  file.uri.pathSegments.last.split('.').first.length <=5)
      .map((file) => file.uri.pathSegments.last.split('.').first)
      .toSet()
      .toList()
    ..sort();

  final fileData = {"langs": langs};
  final outputFile = File('$path/supported_languages.json');
  await outputFile.create(recursive: true);
  await outputFile.writeAsString(jsonEncode(fileData));

  print("✅ Generated $path/supported_languages.json with: $langs");
}

void main(List<String> arguments) {
  final path = arguments.isNotEmpty ? arguments.first : 'assets/localization';
  generateSupportedLangFile(path);
}
