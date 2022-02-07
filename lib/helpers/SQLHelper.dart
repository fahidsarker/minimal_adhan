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
  final version = sharedPrefDatabaseVersion.value;

  List<Object?>? favIds;

  if (version == null || version != DB_VERSION || !exists) {
    if (exists) {
      final _oldDB = await openDatabase(path);
      final res =
          await _oldDB.rawQuery('SELECT id FROM dua WHERE favourite = 1');
      favIds = res.map((e) => e['id']).toList();
    }

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    final ByteData data = await rootBundle.load(join("assets", "database.db"));
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
    sharedPrefDatabaseVersion.value = DB_VERSION;
  }

  final _newDB = await openDatabase(
    path,
    version: 1,
  );

  await _newDB.transaction((txn) async {
    final values = favIds;
    txn.execute(
      '''
    CREATE TABLE "pref" (
	    "pref_key"	TEXT,
	    "pref_value"	BLOB,
	    PRIMARY KEY("pref_key")
    );
    ''',
    );
    if (values != null && values.isNotEmpty) {
      try {
        for (final element in values) {
          txn.execute('UPDATE dua SET favourite = 1 WHERE id = $element');
        }
      } catch (_) {}
    }
  });

  return _newDB;
}

Future<Map<String, Object?>> get allPreferences async {
  final res = await _globalAppDatabase.rawQuery('SELECT * FROM prefs');
  final Map<String, Object?> ret = {};
  for (final element in res) {
    ret.addAll(element);
  }
  return ret;
}

Future updatePreferenceValue(String key, Object? value) async {
  await _globalAppDatabase.execute(
    '''
  INSERT INTO pref (pref_key, pref_value)
  VALUES ($key, $value)
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
