import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class Dbhelper {
  Dbhelper._();

  static final Dbhelper getInstance = Dbhelper._();

  static final String NOTE_TABLE = "note";
  static final String NOTE_COLUMN_S_NO = "s_no";
  static final String NOTE_COLUMN_TITLE = "title";
  static final String NOTE_COLUMN_DESC = "desc";
  static final String NOTE_COLUMN_TIME = "time";
  static final String NOTE_COLUMN_STATUS = "status";

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    String dbPath = await join(await getDatabasesPath(), "noteDB.db");

    return await openDatabase(
      dbPath,
      version: 4,
      onCreate: (db, version) async {
        db.execute(
          "CREATE TABLE $NOTE_TABLE ($NOTE_COLUMN_S_NO INTEGER PRIMARY KEY AUTOINCREMENT, $NOTE_COLUMN_TITLE TEXT, $NOTE_COLUMN_TIME TEXT, $NOTE_COLUMN_STATUS INTEGER DEFAULT 0)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute("DROP TABLE IF EXISTS $NOTE_TABLE");
          await db.execute(
            "CREATE TABLE $NOTE_TABLE ($NOTE_COLUMN_S_NO INTEGER PRIMARY KEY AUTOINCREMENT, $NOTE_COLUMN_TITLE TEXT, $NOTE_COLUMN_TIME TEXT, $NOTE_COLUMN_STATUS INTEGER DEFAULT 0)",
          );
        }
      },
    );
  }

  //all queries

  Future<bool> addNote(Map<String, dynamic> note) async {
    var db = await getDB();

    int rowsEffected = await db.insert(NOTE_TABLE, {
      NOTE_COLUMN_TITLE: note[NOTE_COLUMN_TITLE],
      NOTE_COLUMN_DESC: note[NOTE_COLUMN_DESC],
      NOTE_COLUMN_TIME: note[NOTE_COLUMN_TIME],
      NOTE_COLUMN_STATUS: note[NOTE_COLUMN_STATUS],
    });

    return rowsEffected > 0;
  }

  //read Data

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();

    List<Map<String, dynamic>> mData = await db.query(NOTE_TABLE);

    return mData;
  }

  Future<bool> updateNote(int sNo, Map<String, dynamic> updatedNote) async {
    var db = await getDB();

    int rowsEffected = await db.update(
      NOTE_TABLE,
      updatedNote,
      where: "$NOTE_COLUMN_S_NO",
      whereArgs: [sNo],
    );

    return rowsEffected > 0;
  }

  Future<bool> deleteNote(int sNo) async {
    var db = await getDB();

    int rowsEffected = await db.delete(
      NOTE_TABLE,
      where: "$NOTE_COLUMN_S_NO = ?",
      whereArgs: [sNo],
    );

    return rowsEffected > 0;
    
  }
}
