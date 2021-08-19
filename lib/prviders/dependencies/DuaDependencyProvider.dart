import 'package:flutter/cupertino.dart';
import 'package:minimal_adhan/helpers/sharedprefKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DuaDependencyProvider with ChangeNotifier{

  late String translationLang;
  late bool showTranslation;
  late bool showTransliteration;
  late double arabicFontSize;
  late double otherFontSize;
  late bool sameAsPrimaryLang;

  Future<void> init() async{
    final preference = await SharedPreferences.getInstance();

    translationLang = preference.getString(KEY_DUA_TRANSLATION_LANG) ??
        DEFAULT_DUA_TRANSLATION_LANG;
    showTranslation = preference.getBool(KEY_DUA_SHOW_TRANSLATION) ??
        DEFAULT_DUA_SHOW_TRANSLATION;
    showTransliteration =
        preference.getBool(KEY_DUA_SHOW_TRANSLITERATION) ??
            DEFAULT_DUA_SHOW_TRANSLITERATION;
    arabicFontSize = preference.getDouble(KEY_DUA_ARABIC_FONT_SIZE) ?? DEFAULT_DUA_ARABIC_FONT_SIZE;
    otherFontSize = preference.getDouble(KEY_DUA_OTHER_FONT_SIZE) ?? DEFAULT_DUA_OTHER_FONT_SIZE;
    sameAsPrimaryLang = preference.getBool(KEY_DUA_SAME_AS_PRIMARY) ?? DEFAULT_DUA_SAME_AS_PRIMARY;
  }

  void changeFontSize(bool arabic, double newSize) async{
    final preference = await SharedPreferences.getInstance();
    final success = await preference.setDouble(arabic ? KEY_DUA_ARABIC_FONT_SIZE : KEY_DUA_OTHER_FONT_SIZE, newSize);
    if(success){
      arabic ? arabicFontSize = newSize : otherFontSize = newSize;
      notifyListeners();
    }
  }

  void changeFontToDefault(bool arabic){
    final newSize = arabic ? DEFAULT_DUA_ARABIC_FONT_SIZE : DEFAULT_DUA_OTHER_FONT_SIZE;
    changeFontSize(arabic, newSize);
  }

  void changeShowTransliteration(bool newValue) async{
    final preference = await SharedPreferences.getInstance();
    final success = await preference.setBool(KEY_DUA_SHOW_TRANSLITERATION, newValue);
    if(success){
      showTransliteration = newValue;
      notifyListeners();
    }
  }

  void changeShowTranslation(bool newValue) async{
    final preference = await SharedPreferences.getInstance();
    final success = await preference.setBool(KEY_DUA_SHOW_TRANSLATION, newValue);
    if(success){
      showTranslation = newValue;
      notifyListeners();
    }
  }

  void setDuaLangToPrimary() async{
    final preference = await SharedPreferences.getInstance();
    await preference.setBool(KEY_DUA_SAME_AS_PRIMARY, true);
    final primaryLang = preference.getString(KEY_ADHAN_CURRENT_LOCALIZATION) ?? DEFAULT_ADHAN_CURRENT_LOCALIZATION;
    changeTranslationLang(primaryLang, true);
  }

  void changeTranslationLang(String newValue, [bool usePrimary = false]) async{
    final preference = await SharedPreferences.getInstance();
    await preference.setBool(KEY_DUA_SAME_AS_PRIMARY, usePrimary);
    sameAsPrimaryLang = usePrimary;
    final success = await preference.setString(KEY_DUA_TRANSLATION_LANG, newValue);
    if(success){
      translationLang = newValue;
      notifyListeners();
    }
  }

}