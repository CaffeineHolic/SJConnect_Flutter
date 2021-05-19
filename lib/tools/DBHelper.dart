import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'timeTable.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''CREATE TABLE timeTable(
      subject int(10) NOT NULL,
      teacher int(10) NOT NULL,
      day int(10) NOT NULL,
      sPeriod int(10) NOT NULL,
      ePeriod int(10) NOT NULL
      )
    ''');
    }, onUpgrade: (db, oldVersion, newVersion) {}); //needed for migration!
  }
}
