import 'package:flutter/material.dart';
import 'package:localization_lite/translate.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Translate.init(defaultLangCode: "ar");
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
        child: Text(
            tr("hello_world") + " or " + Translate("hello_world").toString()),
      ),
    );
  }
}
