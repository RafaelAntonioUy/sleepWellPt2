import 'package:flutter_login/JsonModels/sleep_factors.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperSleepFactors {
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

  // Create Note
  Future<int> addUserFactor(SleepFactors sleepFactor) async {
    final Database db = await initDB();

    // insert the data that converts the object into a Map JSON Format
    // when we modify the db, it needs to be in a JSON format
    return db.insert('user_sleep_factors', sleepFactor.toMap());
  }

  // Get Notes
  Future<List<SleepFactors>> getUserFactor(int ID) async {
    final Database db = await initDB();

    // fetch the data in a JSON format in a List of Maps
    // List<Map<String, Object?>> result = await db.query('user_sleep_factors');
    List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM user_sleep_factors WHERE userID = ?', [ID]);

    // convert the List of Maps to a List of Objects instantiated by the NoteModel Class
    return result.map((e) => SleepFactors.fromMap(e)).toList();
  }

  // Update Notes
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
}