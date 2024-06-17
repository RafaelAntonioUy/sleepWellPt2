import 'dart:ffi';

import 'package:flutter_login/JsonModels/sleeping_factor.dart';
import 'package:flutter_login/JsonModels/users_sleeping_factor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperSleepFactors {
  final databaseName = 'sleepwell.db';

  Future<Database> initDB() async {
    // fetch thepath that the database will be located
    final databasePath = await getDownloadsDirectory();

    // create the full database path together with the file 
    final path = join(databasePath!.path, databaseName);
    

    return await openDatabase(path);
  }

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
