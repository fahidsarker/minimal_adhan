import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/models/dua/Dua.dart';
import 'package:minimal_adhan/models/dua/DuaDetials.dart';
import 'package:minimal_adhan/models/dua/category.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:sqflite/sqflite.dart';

class DuaProvider with ChangeNotifier {
  final AppLocalizations _appLocale;
  final DuaDependencyProvider dependency;
  final Database _database;
  DuaProvider(this._database, this._appLocale, this.dependency);

  Future<List<DuaCategory>> get duaCategories async {
    String query =
        "SELECT id, category_${_appLocale.locale} FROM category order by sort";


    final list = [DuaCategory(0, _appLocale.favs)];
    list.addAll((await _database.rawQuery(query)).map((e) =>
        DuaCategory(
            e['id'] as int, e['category_${_appLocale.locale}'] as String)));
    return list;
  }

  Future<List<Dua>> searchDuas(String search) async {
    final String query =
    '''
      SELECT dua.id, dua_titles.title_${_appLocale.locale}, dua.dua, dua.favourite from dua 

        INNER JOIN dua_titles on dua_titles.dua_id = dua.id 
        INNER JOIN dua_translations on dua_translations.dua_id= dua.id 
        INNER JOIN dua_transliterations on dua_transliterations.dua_id = dua.id 
        
          WHERE (
          	dua.dua like '%$search%'
          	OR dua_translations.translation_en like '%$search%'
          	OR dua_translations.translation_bn like '%$search%'
          	OR dua_transliterations.transliteration_en like '%$search%'
          	OR dua_transliterations.transliteration_bn like '%$search%'
          	OR dua_titles.title_en LIKE '%$search%'
          	OR dua_titles.title_bn LIKE '%$search%'
          	OR dua_titles.title_ar LIKE '%$search%'
          )
    ''';

    return (await _database.rawQuery(query))
        .map((e) =>
        Dua(
            e['id'] as int,
            e['title_${_appLocale.locale}'] as String,
            (e['dua'] as String),
            (e['favourite'] as int) == 1))
        .toList();
  }


  Future<List<Dua>> getDuasOfCategory(int catID) async {
    final query =
    '''
        SELECT dua.id, dua_titles.title_${_appLocale.locale}, dua.dua, dua.favourite from dua 
        INNER JOIN dua_titles on dua_titles.dua_id = dua.id 
        WHERE ${catID == 0 ? 'dua.favourite = 1' : 'dua.category = $catID'}
    ''';

    return (await _database.rawQuery(query))
        .map((e) =>
        Dua(
            e['id'] as int,
            e['title_${_appLocale.locale}'] as String,
            (e['dua'] as String),
            (e['favourite'] as int) == 1))
        .toList();
  }

  Future <DuaDetails> getDuaDetails(int duaID) async {
    final String lang = _appLocale.locale;
    final String transLang = dependency.translationLang;
    final bool showTranslation = dependency.showTranslation;
    final bool showTransliteration = dependency.showTransliteration;

    final String querey =
    '''
    SELECT dua.id, dua_titles.title_$lang, dua.dua, dua.favourite,
    ${(showTranslation && transLang != 'ar')
        ? 'dua_translations.translation_$transLang,'
        : ''} 
    ${(showTransliteration && transLang != 'ar')
        ? 'dua_transliterations.transliteration_$transLang,'
        : ''}
    dua_references.reference_$transLang,
    dua_notes.notes_$transLang
    
    FROM dua
    INNER JOIN dua_titles on dua_titles.dua_id = dua.id
    
    ${showTranslation
        ? 'INNER JOIN dua_translations on dua_translations.dua_id = dua.id'
        : ''}
    ${showTransliteration
        ? 'INNER JOIN dua_transliterations on dua_transliterations.dua_id = dua.id'
        : ''}
    
    INNER JOIN dua_references on dua_references.dua_id = dua.id
    INNER JOIN dua_notes on dua_notes.dua_id = dua.id
    
    WHERE dua.id = $duaID
    
    ''';

    final map = (await _database.rawQuery(querey))[0];
/*    final id = map['id'] as int?;
    final title = map['title_$lang'] as String?;
    final arabic = map['dua'] as String?;
    final isFavourite = (map['favourite'] as int?) == 1;
    final translation = map['translation_$transLang'] as String?;
    final transliteration = map['transliteration_$transLang'] as String?;
    final reference = map['reference_$transLang'] as String?;
    final notes = map['notes_$transLang'] as String?;*/


    return DuaDetails(id: map['id'] as int,
        title: map['title_$lang'] as String,
        arabic: (map['dua'] as String),
        isFavourite: (map['favourite'] as int) == 1,
        translation: map['translation_$transLang'] as String?,
        transliteration: map['transliteration_$transLang'] as String?,
        reference: map['reference_$transLang'] as String,
        notes: map['notes_$transLang'] as String);
  }


  void toggleFavourite(bool old, int duaID) async {
    String query = 'UPDATE dua SET favourite = ${old
        ? 0
        : 1} WHERE id = $duaID';
    await _database.rawUpdate(query);
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
  }

}
