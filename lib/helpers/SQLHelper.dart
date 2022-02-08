import 'dart:io';
import 'package:flutter/services.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/metadata.dart';
import 'package:minimal_adhan/models/Inspiration.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late final Database _globalAppDatabase;

Database get globalAppDatabase => _globalAppDatabase;

Future<void> initDatabase() async {
  _globalAppDatabase = await _getDatabase();
}

Future<Database> _getDatabase() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, "database.db");

  final exists = await databaseExists(path);
  //final version = sharedPrefDatabaseVersion.value;

  List<Object?>? favIds;
  int? oldVersion;

  var _DB = await openDatabase(path);

  if (exists) {
    try {
      final vs = await _DB.rawQuery(
          "SELECT pref_value from prefs where pref_key = '${sharedPrefDatabaseVersion.key}'",);
      oldVersion = vs.first['pref_value'] as int?;
      print(oldVersion);
    } catch (e) {
      print(e);
    }

    if (oldVersion != null && oldVersion < DB_VERSION) {
      final res =
          await _DB.rawQuery('SELECT id FROM dua WHERE favourite = 1');
      favIds = res.map((e) => e['id']).toList();
    }
  }

  if (oldVersion == null || oldVersion < DB_VERSION) {

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    final ByteData data = await rootBundle.load(join("assets", "database.db"));
    final List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);


    _DB = await openDatabase(
      path,
      version: 1,
    );

    await _DB.transaction((txn) async {
      await txn.execute(
        '''
           CREATE TABLE IF NOT EXISTS "prefs" (
	           "pref_key"	TEXT,
	           "pref_value"	BLOB,
	           PRIMARY KEY("pref_key")
           );
      ''',
      );
      if (favIds != null && favIds.isNotEmpty) {
        try {
          for (final element in favIds) {
            txn.execute('UPDATE dua SET favourite = 1 WHERE id = $element');
          }
        } catch (_) {}
      }

      await txn.execute(
        '''
          INSERT INTO prefs (pref_key, pref_value)
          VALUES ('${sharedPrefDatabaseVersion.key}', $DB_VERSION)
          ON CONFLICT (pref_key) DO
          UPDATE SET pref_value = excluded.pref_value;
        ''',
      );
    });

  }


  return _DB;
}

Future<Map<String?, Object?>> get allPreferences async {
  final res = await _globalAppDatabase.rawQuery('SELECT * FROM prefs');
  print('FOUND --------- $res');
  final Map<String?, Object?> ret = {};

  for(final element in res){
    ret.addAll({
      element['pref_key'] as String?:element['pref_value']
    });
  }

  print('RETURNING: ------ $ret');
  return ret;
}

Future updatePreferenceValue(String key, Object? value) async {
  await _globalAppDatabase.execute(
    '''
  INSERT INTO prefs (pref_key, pref_value)
  VALUES ('$key', $value)
  ON CONFLICT (pref_key) DO
  UPDATE SET pref_value = excluded.pref_value;
  ''',
  );
}

Future<Inspiration> getInspiration(String lang, int id) async {
  final res = await _globalAppDatabase.rawQuery(
    'SELECT inspirations.ins_$lang, inspiration_source.ins_src_$lang from inspirations '
    'INNER JOIN inspiration_source ON inspirations.inspirations_source_id = inspiration_source.id '
    'WHERE inspirations.id = $id',
  );

  if (res.isEmpty) {
    return Inspiration('', '');
  }

  final txt = (res[0]['ins_$lang'] ?? '') as String;
  final src = (res[0]['ins_src_$lang'] ?? '') as String;

  return Inspiration(txt, src);
}
