import '../../../translate.dart';
import '../service.dart';

class GatherKeys extends Service {
  static const String modelName = "GatherKeys";
  bool isChange= false;
  @override
  Future<void> initialFill() async {
    final defaultLang = Translate.defaultLangCode;
    var keys = content[defaultLang]?.keys;
    
    Translate.supportedLangs.forEach((lang) {
      if (lang != defaultLang) {
        keys?.forEach((key) {
          if (!content[lang]!.containsKey(key)) {
            content[lang]![key] = "";
          }
        });
      }
    });

    await super.initialFill();
  }

  @override
  Future<void> updateLocalization(key) async {
    _setKey(key);
    if(!isChange) return;
    await super.updateLocalization(key);
  }

  void _setKey(key) {
    isChange = false;
    for (var lang in Translate.supportedLangs) {
      if (content[lang]![key] == null) {
        content[lang]![key] = "";
        isChange = true;
      }
    }
  }
}
