import 'package:flutter/services.dart';
import 'package:minimal_adhan/models/dua/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<Database> getDatabase() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "database.db");

  var exists = await databaseExists(path);

  if (!exists) {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    ByteData data = await rootBundle.load(join("assets", "database.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
  }

  return await openDatabase(
    path,
    version: 1,
  );
}

