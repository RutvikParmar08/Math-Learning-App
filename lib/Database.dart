import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MathBlastDatabase {
  static Database? _database;
  static final MathBlastDatabase instance = MathBlastDatabase._privateConstructor();

  MathBlastDatabase._privateConstructor();

  // database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  //#region Initialize the database
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDocDir.path, 'mathblast.db');

    // Delete existing database file to start fresh
    if (await File(dbPath).exists()) {
      await File(dbPath).delete();
    }


    try {
      await copyPasteAssetFileToRoot();
    } catch (e) {
    }

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onOpen: (db) async {
        await _verifyTables(db);
      },
    );
  }
  //#endregion

  //#region Create Table
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS SoloPlayerLevel (
        LevelNumber INTEGER PRIMARY KEY,
        LevelStar INTEGER DEFAULT 0,
        LevelScore INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS InputAnswerLevel (
        LevelNumber INTEGER PRIMARY KEY,
        LevelStar INTEGER DEFAULT 0,
        LevelScore INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS TrueFalseLevel (
        LevelNumber INTEGER PRIMARY KEY,
        LevelStar INTEGER DEFAULT 0,
        LevelScore INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS MissingValueLevel (
        LevelNumber INTEGER PRIMARY KEY,
        LevelStar INTEGER DEFAULT 0,
        LevelScore INTEGER DEFAULT 0
      )
    ''');

    await _insertDefaultData(db);
  }
  //#endregion

  //#region Insert Default Date
  Future<void> _insertDefaultData(Database db) async {
    var soloPlayerLevels = await db.query('SoloPlayerLevel');

    if (soloPlayerLevels.isEmpty) {
      for (int i = 1; i <= 60; i++) {
        await db.insert('SoloPlayerLevel', {
          'LevelNumber': i,
          'LevelStar': 0,
          'LevelScore': 0
        });
      }
    }

    var inputAnswerLevels = await db.query('InputAnswerLevel');

    if (inputAnswerLevels.isEmpty) {
      for (int i = 1; i <= 60; i++) {
        await db.insert('InputAnswerLevel', {
          'LevelNumber': i,
          'LevelStar': 0,
          'LevelScore': 0
        });
      }
    }

    var trueFalseLevels = await db.query('TrueFalseLevel');

    if (trueFalseLevels.isEmpty) {
      for (int i = 1; i <= 60; i++) {
        await db.insert('TrueFalseLevel', {
          'LevelNumber': i,
          'LevelStar': 0,
          'LevelScore': 0
        });
      }
    }

    var missingValueLevels = await db.query('MissingValueLevel');

    if (missingValueLevels.isEmpty) {
      for (int i = 1; i <= 60; i++) {
        await db.insert('MissingValueLevel', {
          'LevelNumber': i,
          'LevelStar': 0,
          'LevelScore': 0
        });
      }
    }
  }
  //#endregion

  //#region Verify Table
  Future<void> _verifyTables(Database db) async {
    var tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'");
    List<String> tableNames = tables.map((table) => table['name'] as String).toList();

    List<String> requiredTables = [
      'SoloPlayerLevel',
      'InputAnswerLevel',
      'TrueFalseLevel',
      'MissingValueLevel'
    ];

    bool needsCreation = false;
    for (String table in requiredTables) {
      if (!tableNames.contains(table)) {
        needsCreation = true;
        break;
      }
    }

    if (needsCreation) {
      await _createTables(db);
    } else {
      // Verify the columns in each table
      for (String table in requiredTables) {
        var columns = await db.rawQuery("PRAGMA table_info($table)");
        List<String> columnNames = columns.map((col) => col['name'] as String).toList();

        if (!columnNames.contains('LevelScore')) {
          await db.execute("ALTER TABLE $table ADD COLUMN LevelScore INTEGER DEFAULT 0");
        }
      }
    }
  }
  //#endregion

  //#region copyPasteAssetFileToRoot
  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "mathblast.db");

    try {
      if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
        ByteData data = await rootBundle.load(join('assets/database', 'mathblast.db'));
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes);
        return true;
      } else {

      }
    } catch (e) {
      return false;
    }
    return false;
  }
  //#endregion

  //#region Get All Record From Database
  Future<List<Map<String, dynamic>>> getAllRecords(String tableName) async {
    try {
      Database db = await database;
      var result = await db.query(tableName, orderBy: "LevelNumber ASC");
      return result;
    } catch (e) {
      return [];
    }
  }
  //#endregion

  //#region Get Record By ID
  Future<Map<String, dynamic>?> getRecordById(String tableName, int levelNumber) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result =
      await db.query(tableName, where: "LevelNumber = ?", whereArgs: [levelNumber]);
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      return null;
    }
  }
  //#endregion

  //#region Update Record
  Future<int> updateRecord(String tableName, int levelNumber, Map<String, dynamic> data) async {
    try {
      Database db = await database;
      int result = await db.update(
        tableName,
        data,
        where: "LevelNumber = ?",
        whereArgs: [levelNumber],
      );
      return result;
    } catch (e) {
      return 0;
    }
  }
  //#endregion

  Future<Map<String, int>> getDatabaseStats() async {
    try {
      Database db = await database;
      Map<String, int> stats = {};

      List<String> tables = ['SoloPlayerLevel', 'InputAnswerLevel', 'TrueFalseLevel', 'MissingValueLevel'];

      for (String table in tables) {
        var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
        stats[table + 'Count'] = count ?? 0;

        var starsSum = Sqflite.firstIntValue(await db.rawQuery('SELECT SUM(LevelStar) FROM $table'));
        stats[table + 'Stars'] = starsSum ?? 0;

        var scoreSum = Sqflite.firstIntValue(await db.rawQuery('SELECT SUM(LevelScore) FROM $table'));
        stats[table + 'Score'] = scoreSum ?? 0;
      }

      return stats;
    } catch (e) {
      return {};
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}