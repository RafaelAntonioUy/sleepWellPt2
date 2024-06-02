// import 'package:flutter/material.dart';
import 'package:flutter_login/JsonModels/users.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // the name of the database
  final databaseName = 'users.db';

  // the SQL Query to create the table
  String users = 'CREATE TABLE users (userID INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPass TEXT)';

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
      await db.execute(users);
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