import 'dart:ffi';
import 'package:flutter_login/JsonModels/sleeping_factor.dart';
import 'package:flutter_login/JsonModels/users_sleeping_factor.dart';
import 'package:flutter_login/sharedData.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperSleepFactors {
  final String databaseName = 'sleepwell.db';

  Future<Database> initDB() async {
    final databasePath = await getDownloadsDirectory();
    final path = join(databasePath!.path, databaseName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sleeping_factors (
        factorID INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        causes TEXT,
        solution TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_sleeping_factors (
        userID INTEGER,
        factorID INTEGER,
        PRIMARY KEY (userID, factorID),
        FOREIGN KEY (userID) REFERENCES users (userID),
        FOREIGN KEY (factorID) REFERENCES sleeping_factors (factorID)
      );
    ''');

    await db.execute('''
      INSERT INTO sleeping_factors (name, causes, solution) VALUES
      ('Comfortability', 'Uncomfortable mattress or pillow and poor sleep environment. Many Filipinos may use low-quality or old bedding due to budget constraints.', 'Invest in a high-quality mattress and pillows that suit your sleep preferences. Look for affordable yet comfortable bedding options available in local markets. Regularly replace bedding as needed.'),
      ('Position of Bed', 'Bed placement in relation to windows, doors, and room layout. Can affect light exposure, airflow, and noise levels, especially in densely populated areas.', 'Place the bed away from windows and direct light sources. Ensure good airflow and reduce noise by placing the bed in a quiet corner. Optimize room layout for minimal disturbances.'),
      ('Stress', 'High workload, financial issues, and family responsibilities. Common due to economic challenges and social pressures.', 'Practice relaxation techniques such as deep breathing and meditation. Establish a bedtime routine to wind down. Seek professional help or community support if stress persists.'),
      ('Loud Noises', 'Environmental noise like traffic, neighbors, or household activities. Common in urban areas with high population density.', 'Use earplugs or white noise machines to mask disruptive sounds. Soundproof your bedroom if possible. Communicate with household members about maintaining a quiet environment.'),
      ('Bright Light', 'Excessive exposure to artificial light before bedtime. Light from electronic devices can interfere with melatonin production, particularly in areas with frequent power outages leading to varied lighting habits.', 'Reduce screen time an hour before bed and use night mode on devices. Use blackout curtains to block external light. Consider using a sleep mask for complete darkness.'),
      ('Ambience', 'Poor room ambiance such as clutter and unpleasant odors. Can lead to a distracting and uncomfortable sleep environment, especially in small living spaces.', 'Keep the bedroom clean and tidy to promote relaxation. Use pleasant scents like lavender to enhance ambiance. Decorate the room in calming colors and styles.'),
      ('Temperature', 'Room temperature being too hot, especially during summer months. Can cause discomfort and frequent waking.', 'Maintain an optimal sleep temperature, ideally between 60-67°F (15-19°C). Use fans or air conditioning if available. Wear light sleepwear and use breathable bedding.'),
      ('Distractions', 'Presence of electronics, pets, or other interruptions. Can lead to fragmented sleep and difficulty falling asleep, especially in multi-generational households.', 'Remove or minimize electronic devices from the bedroom. Train pets to sleep outside the bedroom. Establish a calm and quiet bedtime routine.'),
      ('Exposure to Radiation', 'Prolonged use of electronic devices emitting blue light. Blue light exposure can disrupt the body\'s natural sleep-wake cycle.', 'Limit screen time before bed and use blue light filters on devices. Engage in non-electronic activities like reading a book. Use apps or settings that reduce blue light emission in the evening.'),
      ('Academic', 'High academic workload and pressure. Common due to competitive education system and societal expectations.', 'Manage time effectively and prioritize tasks. Practice good study habits and take regular breaks. Ensure a balance between academic responsibilities and relaxation.'),
      ('Sleep Schedule', 'Irregular sleep patterns and inconsistent bedtime routines. Can disrupt the body\'s internal clock, especially with varying work shifts.', 'Establish a consistent sleep schedule by going to bed and waking up at the same time every day. Avoid long naps during the day. Create a relaxing pre-sleep routine to signal your body it\'s time to sleep.'),
      ('Overthinking', 'Excessive worry and mental activity before bed. Can cause difficulty falling and staying asleep, often due to personal and financial concerns.', 'Practice mindfulness and stress-reducing techniques such as journaling or meditation. Create a to-do list for the next day to clear your mind. Seek professional advice if overthinking continues to affect sleep.');
    ''');
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