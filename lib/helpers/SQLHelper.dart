import 'package:flutter/services.dart';
import 'package:minimal_adhan/helpers/sharedPrefHelper.dart';
import 'package:minimal_adhan/helpers/sharedprefKeys.dart';
import 'package:minimal_adhan/models/Inspiration.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

import '../metadata.dart';



Future<Database> getDatabase() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "database.db");

  var exists = await databaseExists(path);
  final version = await getIntFromSharedPref(KEY_DATABASE_VERSION);

  List<int>? favIds;

  if (version == null || version != DB_VERSION || !exists) {
    if(exists){
      final _oldDB = await openDatabase(path);
      final res = await _oldDB.rawQuery('SELECT id FROM dua WHERE favourite = 1');
      favIds = res.map((e) => e['id'] as int).toList();
    }

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    ByteData data = await rootBundle.load(join("assets", "database.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
    await setIntToSharedPref(KEY_DATABASE_VERSION, DB_VERSION);
  }

  final _newDB = await openDatabase(
    path,
    version: 1,
  );

  await _newDB.transaction((txn) async {
    final values = favIds;
    if(values != null && values.isNotEmpty){
      try{
        values.forEach((element) {
          txn.execute('UPDATE dua SET favourite = 1 WHERE id = $element');
        });
      }catch(e){}
    }
  });

  return _newDB;
}

Future<Inspiration> getInspiration(String lang, int id) async{
  final _db = await getDatabase();
  final res = await _db.rawQuery('SELECT inspirations.ins_$lang, inspiration_source.ins_src_$lang from inspirations '
      'INNER JOIN inspiration_source ON inspirations.inspirations_source_id = inspiration_source.id '
      'WHERE inspirations.id = $id');

  if(res.length == 0){
    return Inspiration('', '');
  }

  final txt = (res[0]['ins_$lang'] ?? '') as String;
  final src = (res[0]['ins_src_$lang'] ?? '') as String;

  return Inspiration(txt, src);
}
