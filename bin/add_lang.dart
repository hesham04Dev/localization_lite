// bin/add_lang.dart
import 'dart:io';
import 'package:path/path.dart' as p;
import 'init.dart' as init; // Import the init file

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print("❌ Please provide a language code to add (e.g. `dart run package:add_lang fr`)");
    exit(1);
  }

  final lang = arguments.first;
  final basePath = arguments.length >1? arguments[1] : 'assets/localization';
  final langFile = File(p.join(basePath, '$lang.json'));

  if (langFile.existsSync()) {
    print("ℹ️ Language file already exists: ${langFile.path}");
  } else {
    await langFile.create(recursive: true);
    await langFile.writeAsString('{}');
    print("✅ Created new translation file: ${langFile.path}");
  }

  // Call init to regenerate the list
  await init.generateSupportedLangFile(basePath);
}
