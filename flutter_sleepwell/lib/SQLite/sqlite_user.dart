// import 'package:flutter/material.dart';
import 'package:flutter_login/JsonModels/users.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  // the name of the database
  final databaseName = 'sleepwell.db';

  // the SQL Query to create the table
  String users = 'CREATE TABLE users (userID INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPass TEXT, emailAddress TEXT)';
  
  Future<Database> initDB() async {
    // fetch thepath that the database will be located
    final databasePath = await getDownloadsDirectory();

    // create the full database path together with the file 
    final path = join(databasePath!.path, databaseName);
    print(path); // locate the file

    return openDatabase(
      path, 
      version: 1, 

      // perform the database creation query if the db doesn't exists
      onCreate: (db, version)  async {
      await db.execute(users);
      await db.execute('''
        CREATE TABLE sleeping_factors (
          factorID INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          causes TEXT,
          solution TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE user_sleeping_factors (
          userID INTEGER,
          factorID INTEGER,
          PRIMARY KEY (userID, factorID),
          FOREIGN KEY (userID) REFERENCES users (userID),
          FOREIGN KEY (factorID) REFERENCES sleeping_factors (factorID)
        )
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
      ('Exposure to Radiation', 'Prolonged use of electronic devices emitting blue light. Blue light exposure can disrupt the bodys natural sleep-wake cycle.', 'Limit screen time before bed and use blue light filters on devices. Engage in non-electronic activities like reading a book. Use apps or settings that reduce blue light emission in the evening.'),
      ('Academic', 'High academic workload and pressure. Common due to competitive education system and societal expectations.', 'Manage time effectively and prioritize tasks. Practice good study habits and take regular breaks. Ensure a balance between academic responsibilities and relaxation.'),
      ('Sleep Schedule', 'Irregular sleep patterns and inconsistent bedtime routines. Can disrupt the bodys internal clock, especially with varying work shifts.', 'Establish a consistent sleep schedule by going to bed and waking up at the same time every day. Avoid long naps during the day. Create a relaxing pre-sleep routine to signal your body it is time to sleep.'),
      ('Overthinking', 'Excessive worry and mental activity before bed. Can cause difficulty falling and staying asleep, often due to personal and financial concerns.', 'Practice mindfulness and stress-reducing techniques such as journaling or meditation. Create a to-do list for the next day to clear your mind. Seek professional advice if overthinking continues to affect sleep.')
      ''');
     
    });
  }

  
  Future<bool> login(Users user) async {
    final db = await initDB();

    var result = await db.rawQuery(
      'SELECT * FROM users WHERE userName = ? AND userPass = ?',
      [user.userName, user.userPass],
    );

    return result.isNotEmpty;
  }

  Future<int> signup(Users user) async {
    final db = await initDB();
    
    return db.insert('users', user.toMap());
  }

   Future<int?> getUserIdByUsername(String username) async {
    final db = await initDB();

    var result = await db.rawQuery(
      'SELECT userID FROM users WHERE userName = ?',
      [username],
    );

    if (result.isNotEmpty) {
      return result.first['userID'] as int?;
    } else {
      return null; // or you can throw an exception or handle this case as needed
    }
  }

  /*
  // CRUD
  // Create Note
  Future<int> createNote(NoteModel note) async {
    final Database db = await initDB();

    // insert the data that converts the object into a Map JSON Format
    // when we modify the db, it needs to be in a JSON format
    return db.insert('notes', note.toMap());
  }

  // Get Notes
  Future<List<NoteModel>> getNotes() async {
    final Database db = await initDB();

    // fetch the data in a JSON format in a List of Maps
    List<Map<String, Object?>> result = await db.query('notes');

    // convert the List of Maps to a List of Objects instantiated by the NoteModel Class
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  // Delete Notes
  Future<int> deleteNote(int id) async {
    final Database db = await initDB();
    
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM notes WHERE noteId > 1');
    
    // List<NoteModel> chosen = result.map((e) => NoteModel.fromMap(e)).toList();

    // for (int i = 0; i < chosen.length; i++) {
    //   print(chosen[i].noteTitle);
    // }
    
    return db.delete('notes', where: 'noteId = ?', whereArgs: [id]);
  }

  // Update Notes
  Future<int> updateNote(title, content, noteId) async {
    final Database db = await initDB();
  
    return db.rawUpdate('UPDATE notes SET noteTitle = ?, noteContent = ? where noteId = ?', [title, content, noteId]);
  } */
}