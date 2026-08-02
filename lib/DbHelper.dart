import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class Dbhelper {
  Dbhelper._();

  static final Dbhelper getInstance = Dbhelper._();

  static final String NOTE_TABLE = "note";
  static final String NOTE_COLUMN_S_NO = "s_no";
  static final String NOTE_COLUMN_TITLE = "title";
  static final String NOTE_COLUMN_DESC = "desc";

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    String dbPath = await join(getDatabasesPath(), "noteDB.db");

    return await openDatabase(dbPath, version: 3,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $NOTE_TABLE ($NOTE_COLUMN_S_NO INTEGER PRIMARY KEY AUTOINCREMENT, $NOTE_COLUMN_TITLE TEXT,  )"
        )
      },
    );
  }
}
