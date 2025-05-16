import 'package:flutter/material.dart';
import 'package:localization_lite/simple_localization.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Translate.init(defaultLangCode: "ar",service:Gemini(apiKey: "AIzaSyABCTkwaZfq4i4qovWKwFrmfFzO467teiA") /*GatherKeys()*/,isDevMode: true);
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
            tr("home") + " or " + Translate("menu").toString()),
      ),
    );
  }
}
