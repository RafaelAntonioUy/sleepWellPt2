import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperMonitor {
  static final DatabaseHelperMonitor _instance = DatabaseHelperMonitor._internal();
  factory DatabaseHelperMonitor() => _instance;
  static Database? _database;

  DatabaseHelperMonitor._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join((await getDownloadsDirectory())!.path, 'sleepwell.db');
    return await openDatabase(path);
  }

  Future<int> insertSleepRecord(int userId, String sleptTime, String wokeTime) async {
    Database db = await database;
    return await db.insert('sleep_records', {
      'user_id': userId,
      'slept_time': sleptTime,
      'woke_time': wokeTime,
    });
  }

  Future<List<Map<String, dynamic>>> getUserSleepRecords(int userId) async {
    Database db = await database;
    return await db.query('sleep_records', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> removeIncompleteRecords(int userId) async {
    Database db = await database;
    return await db.delete(
      'sleep_records',
      where: 'user_id = ? AND (woke_time IS NULL OR woke_time = "")',
      whereArgs: [userId],
    );
  }
}
