import 'dart:ffi';

import 'package:flutter_login/JsonModels/sleeping_factor.dart';
import 'package:flutter_login/JsonModels/users_sleeping_factor.dart';
import 'package:flutter_login/sharedData.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperSleepFactors {
  // static final DatabaseHelperSleepFactors instance = DatabaseHelperSleepFactors._init();
  // static Database? _database;

  // DatabaseHelperSleepFactors._init();

  // Future<Database> get database async {
  //   if (_database != null) return _database!;
  //   _database = await _initDB('sleepwell.db');
  //   return _database!;
  // }
  // the name of the database
  final databaseName = 'sleepwell.db';

  Future<Database> initDB() async {
    // fetch thepath that the database will be located
    final databasePath = await getDownloadsDirectory();

    // create the full database path together with the file 
    final path = join(databasePath!.path, databaseName);
    

    return await openDatabase(path);
  }

  // Future _createDB(Database db, int version) async {
    
  // }

  Future<void> createFactor(SleepingFactor factor) async {
    final db = await initDB();
    await db.insert('sleeping_factors', factor.toMap());
  }

  Future<List<SleepingFactor>> readFactors() async {
    final db = await initDB();
    final result = await db.query('sleeping_factors');
    return result.map((json) => SleepingFactor.fromMap(json)).toList();
  }

  Future<void> updateFactor(SleepingFactor factor) async {
    final db = await initDB();
    await db.update(
      'sleeping_factors',
      factor.toMap(),
      where: 'factorID = ?',
      whereArgs: [factor.factorID],
    );
  }

  Future<void> deleteFactor(int factorID) async {
    final db = await initDB();
    await db.delete(
      'sleeping_factors',
      where: 'factorID = ?',
      whereArgs: [factorID],
    );
  }

  Future<void> createUserFactor(UserSleepingFactor userFactor) async {
    final db = await initDB();
    await db.insert('user_sleeping_factors', userFactor.toMap());
  }

  Future<List<UserSleepingFactor>> readUserFactors(int userID) async {
    final db = await initDB();
    final result = await db.query(
      'user_sleeping_factors',
      where: 'userID = ?',
      whereArgs: [userID],
    );
    
    return result.map((json) => UserSleepingFactor.fromMap(json)).toList();
  }

  Future<void> deleteUserFactor(UserSleepingFactor userFactor) async {
    final db = await initDB();
    await db.delete(
      'user_sleeping_factors',
      where: 'userID = ? AND factorID = ?',
      whereArgs: [userFactor.userID, userFactor.factorID],
    );
  }

  Future<List<SleepingFactor>> readUserCheckedFactors(int userID) async {
    final db = await initDB();
    final result = await db.rawQuery('''
      SELECT f.factorID, f.name, f.causes, f.solution
      FROM sleeping_factors f
      INNER JOIN user_sleeping_factors uf ON f.factorID = uf.factorID
      WHERE uf.userID = ?
    ''', [userID]);

    return result.map((json) => SleepingFactor.fromMap(json)).toList();
  }

  Future<List<int>> readUserCheckedFactorIDs(int userID) async {
    List<SleepingFactor> factors = await readUserCheckedFactors(userID);
    return factors.map((factor) => factor.factorID).whereType<int>().toList();
  }
}




/*
class DatabaseHelperSleepFactorsSleepFactors {
  static final DatabaseHelperSleepFactorsSleepFactors _instance = DatabaseHelperSleepFactorsSleepFactors._internal();
  static Database? _database;

  factory DatabaseHelperSleepFactorsSleepFactors() => _instance;

  DatabaseHelperSleepFactorsSleepFactors._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDownloadsDirectory();

    String path = join(databasePath!.path, 'sleepwell.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // await db.execute('''
    //   CREATE TABLE user_profile (
    //     userID INTEGER PRIMARY KEY AUTOINCREMENT,
    //     name TEXT NOT NULL,
    //     password TEXT NOT NULL
    //   )
    // ''');

    await db.execute('''
      CREATE TABLE sleeping_factors (
        factorID INTEGER PRIMARY KEY AUTOINCREMENT,
        factorName TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_sleeping_factors (
        userID INTEGER,
        factorID INTEGER,
        isChecked INTEGER NOT NULL CHECK (isChecked IN (0, 1)),
        PRIMARY KEY (userID, factorID),
        FOREIGN KEY (userID) REFERENCES user_profile(userID),
        FOREIGN KEY (factorID) REFERENCES sleeping_factors(factorID)
      )
    ''');
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('user_profile', user);
  }

  Future<void> insertSleepingFactor(Map<String, dynamic> factor) async {
    final db = await database;
    await db.insert('sleeping_factors', factor);
  }

  Future<void> insertUserSleepingFactor(Map<String, dynamic> userSleepingFactor) async {
    final db = await database;
    await db.insert('user_sleeping_factors', userSleepingFactor);
  }

  // Add more methods as needed to fetch data, update data, etc.
}
*/

/*import 'package:flutter_login/JsonModels/sleep_factors.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperSleepFactorsSleepFactorsUserSleepFactor {
  // the name of the database
  final databaseName = 'sleepwell.db';

  // the SQL Query to create the table
  String createUserSleepFactorsTableQuery = 'CREATE TABLE user_sleep_factors (userID INTEGER PRIMARY KEY AUTOINCREMENT, comfortabilityFactor INTEGER NOT NULL, stressFactor INTEGER NOT NULL, noiseFactor INTEGER NOT NULL, lightFactor INTEGER NOT NULL, ambienceFactor INTEGER NOT NULL, temperatureFactor INTEGER NOT NULL, distractionsFactor INTEGER NOT NULL, blueLightFactor INTEGER NOT NULL, academicFactor INTEGER NOT NULL, overthinkingFactor INTEGER NOT NULL, sleepScheduleFactor INTEGER NOT NULL)';

  Future<Database> initDB() async {
    // fetch thepath that the database will be located
    final databasePath = await getDownloadsDirectory();

    // create the full database path together with the file 
    final path = join(databasePath!.path, databaseName);
    // print(path); // locate the file

    return openDatabase(
      path, 
      version: 1, 

      // perform the database creation query if the db doesn't exists
      onCreate: (db, version)  async {
      await db.execute(createUserSleepFactorsTableQuery);
    });
  }

  // Create Factor
  Future<int> addUserSleepFactor(SleepFactors sleepFactor) async {
    final Database db = await initDB();

    // insert the data that converts the object into a Map JSON Format
    // when we modify the db, it needs to be in a JSON format
    return db.insert('user_sleep_factors', sleepFactor.toMap());
  }

  // Get Factor
  Future<List<SleepFactors>> getUserSleepFactor(int ID) async {
    final Database db = await initDB();

    List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM user_sleep_factors WHERE userID = ?', [ID]);

    return result.map((e) => SleepFactors.fromMap(e)).toList();
  }

  // Update factors
  Future<int> updateUserSleepFactor(int userID, int comfortabilityFactor, int stressFactor, int noiseFactor, int lightFactor, int ambienceFactor, int temperatureFactor, int distractionsFactor, int blueLightFactor, int academicFactor, int overthinkingFactor, int sleepScheduleFactor) async {
    final Database db = await initDB();
    
    return db.rawUpdate('''
      UPDATE user_sleep_factors 
      SET comfortabilityFactor = ?, stressFactor = ?, noiseFactor = ?, lightFactor = ?, ambienceFactor = ?, temperatureFactor = ?, distractionsFactor = ?, blueLightFactor = ?, academicFactor = ?, overthinkingFactor = ?, sleepScheduleFactor = ? 
      WHERE userID = ?
    ''', [
      comfortabilityFactor,
      stressFactor,
      noiseFactor,
      lightFactor,
      ambienceFactor,
      temperatureFactor,
      distractionsFactor,
      blueLightFactor,
      academicFactor,
      overthinkingFactor,
      sleepScheduleFactor,
      userID,
    ]);
  }
} */