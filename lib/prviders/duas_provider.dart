import 'package:flutter/cupertino.dart';
import 'package:minimal_adhan/models/dua/Dua.dart';
import 'package:minimal_adhan/models/dua/DuaDetials.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:minimal_adhan/models/dua/category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DuaProvider with ChangeNotifier {
  final Database _db;
  final AppLocalizations _appLocale;
  final DuaDependencyProvider _duaDependency;

  DuaProvider(this._db, this._appLocale, this._duaDependency);

  Future<List<DuaCategory>> get duaCategories async {
    String query =
        "SELECT id, category_${_appLocale.locale} FROM category order by sort";


    final list = [DuaCategory(0, _appLocale.favs)];
    list.addAll((await _db.rawQuery(query)).map((e) =>
        DuaCategory(
            e['id'] as int, e['category_${_appLocale.locale}'] as String)));
    return list;
  }
  Future<List<Dua>> searchDuas(String search) async {
    String query =
    '''SELECT dua.id, dua_titles.title_${_appLocale.locale}, dua.dua, dua.favourite from dua 

        INNER JOIN dua_titles on dua_titles.dua_id = dua.id 
        INNER JOIN dua_translations on dua_translations.dua_id= dua.id 
        INNER JOIN dua_transliterations on dua_transliterations.dua_id = dua.id 
        
        WHERE (
        	dua.dua like '%Allah%'
        	OR dua_translations.translation_en like '%$search%'
        	OR dua_translations.translation_bn like '%$search%'
        	OR dua_transliterations.transliteration_en like '%$search%'
        	OR dua_transliterations.transliteration_bn like '%$search%'
        	OR dua_titles.title_en LIKE '%$search%'
        	OR dua_titles.title_bn LIKE '%$search%'
        	OR dua_titles.title_ar LIKE '%$search%'
        )
        ''';

    return (await _db.rawQuery(query))
        .map((e) =>
        Dua(
            e['id'] as int,
            e['title_${_appLocale.locale}'] as String,
            (e['dua'] as String),
            (e['favourite'] as int) == 1))
        .toList();
  }


  Future<List<Dua>> getDuasOfCategory(int catID) async {
    String query =
    '''SELECT dua.id, dua_titles.title_${_appLocale.locale}, dua.dua, dua.favourite from dua 
        INNER JOIN dua_titles on dua_titles.dua_id = dua.id 
        WHERE ${catID == 0 ? 'dua.favourite = 1':'dua.category = $catID'}
        
        ''';

    return (await _db.rawQuery(query))
        .map((e) =>
        Dua(
            e['id'] as int,
            e['title_${_appLocale.locale}'] as String,
            (e['dua'] as String),
            (e['favourite'] as int) == 1))
        .toList();
  }

  Future <DuaDetails> getDuaDetails(int duaID) async {
    String lang = _appLocale.locale;
    String transLang = _duaDependency.translationLang;
    bool showTranslation = _duaDependency.showTranslation;
    bool showTransliteration = _duaDependency.showTransliteration;

    String querey = '''
    
    SELECT dua.id, dua_titles.title_$lang, dua.dua, dua.favourite,
    ${(showTranslation && transLang != 'ar') ? 'dua_translations.translation_$transLang,' : ''} 
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

    final map = (await _db.rawQuery(querey))[0];
    return DuaDetails(id: map['id'] as int,
        title: map['title_$lang'] as String,
        arabic: (map['dua'] as String),
        isFavourite: (map['favourite'] as int) == 1,
        translation: map['translation_$transLang'] as String?,
        transliteration: map['transliteration_$transLang'] as String?,
        reference: map['reference_$transLang'] as String,
        notes: map['notes_$transLang'] as String);
  }



  void toggleFavourite(bool old, int duaID)async{
    String query = 'UPDATE dua SET favourite = ${old ? 0 : 1} WHERE id = $duaID';
    await _db.rawUpdate(query);
    notifyListeners();
  }



}
