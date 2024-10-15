import 'package:flutter/material.dart';
import 'package:localization_lite/translate.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Translate.init(defaultLangCode: "en");
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(Translate("hello_world").toString()),
      ),
    );
  }
}
