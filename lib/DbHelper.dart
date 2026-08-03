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

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    String dbPath = await join(await getDatabasesPath(), "noteDB.db");

    return await openDatabase(
      dbPath,
      version: 3,
      onCreate: (db, version) async {
        db.execute(
          "CREATE TABLE $NOTE_TABLE ($NOTE_COLUMN_S_NO INTEGER PRIMARY KEY AUTOINCREMENT, $NOTE_COLUMN_TITLE TEXT, $NOTE_COLUMN_TIME TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute("DROP TABLE IF EXISTS $NOTE_TABLE");
          await db.execute(
            "CREATE TABLE $NOTE_TABLE ($NOTE_COLUMN_S_NO INTEGER PRIMARY KEY AUTOINCREMENT, $NOTE_COLUMN_TITLE TEXT, $NOTE_COLUMN_TIME TEXT)",
          );
        }
      },
    );
  }

  //all queries

  Future<bool> addNote({
    required String mTitle,
    required String mDesc,
    required String mTime,
  }) async {
    var db = await getDB();

    int rowsEffected = await db.insert(NOTE_TABLE, {
      NOTE_COLUMN_TITLE: mTitle,
      NOTE_COLUMN_DESC: mDesc,
      NOTE_COLUMN_TIME: mTime,
    });

    return rowsEffected > 0;
  }

  //read Data

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();

    List<Map<String, dynamic>> mData = await db.query(NOTE_TABLE);

    return mData;
  }
}
