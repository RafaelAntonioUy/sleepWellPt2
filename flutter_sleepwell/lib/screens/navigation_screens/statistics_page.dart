import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login/JsonModels/users.dart';
import 'package:flutter_login/SQLite/sqlite_monitor.dart';
import 'package:flutter_login/SQLite/sqlite_user.dart';
import 'package:flutter_login/consts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final db = DatabaseHelper();
  Users? signedUser;
  String? _sleepTime;
  final DatabaseHelperMonitor dbHelper = DatabaseHelperMonitor();
  List<Map<String, dynamic>> sleepRecords = [];

  @override
  void initState() {
    super.initState();
    getUserEntry();
    _loadSleepRecords();
  }

  @override
  Widget build(BuildContext context) {
    Duration totalSleep = _calculateTotalSleepTime();
    double averageSleep = _calculateAverageSleepDuration();
    Duration longestSleep = _calculateLongestSleepSession();
    Duration shortestSleep = _calculateShortestSleepSession();
    int sleepSessionsCount = sleepRecords.length;

    double averageSleepHours = averageSleep / 60;
    double averageSleepMinutes = averageSleep % 60;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: signedUser == null
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator while waiting for the user data
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                  child: Text(
                    "Welcome to SleepWell, ${signedUser?.userName}.",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                /*
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _recordSleep,
                      child: Text('Record Sleep'),
                    ),
                    ElevatedButton(
                      onPressed: _recordWake,
                      child: Text('Record Wake'),
                    ),
                    if (_sleepTime != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Sleep recorded at: $_sleepTime'),
                      ),
                  ],
                ),
                */
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      _buildStatisticCard("Total Sleep Time", "${totalSleep.inHours} H", "${totalSleep.inMinutes % 60} M"),
                      _buildStatisticCard("Average Sleep Duration", "${averageSleepHours.toStringAsFixed(1)} H", "${averageSleepMinutes.toStringAsFixed(1)} M"),
                      _buildStatisticCard("Sleep Session Counts", "$sleepSessionsCount", "", 30.0), // Increased font size
                      _buildStatisticCard("Longest Sleep Session", "${longestSleep.inHours} H", "${longestSleep.inMinutes % 60} M"),
                      _buildStatisticCard("Shortest Sleep Session", "${shortestSleep.inHours} H", "${shortestSleep.inMinutes % 60} M"),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatisticCard(String title, String value1, String value2, [double fontSize = 20.0]) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(8.0),
      height: 100,
      decoration: BoxDecoration(
        color: kPrimaryColorDarker,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 21.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value1,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (value2.isNotEmpty)
                Text(
                  value2,
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getUserEntry() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('chosenID');

    if (userId != null) {
      Users? user = await db.getUserById(userId);
      setState(() {
        signedUser = user;
      });
    } else {
      // Handle the case where userId is null, maybe show an error message
      setState(() {
        signedUser = null;
      });
    }
  }

  void _loadSleepRecords() async {
    sleepRecords = await dbHelper.getUserSleepRecords((await SharedPreferences.getInstance()).getInt('chosenID')!);
    setState(() {});
  }

  DateTime? _parseDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  Duration _calculateTotalSleepTime() {
    Duration totalSleep = Duration();
    for (var record in sleepRecords) {
      DateTime? sleptTime = _parseDateTime(record['slept_time']);
      DateTime? wokeTime = _parseDateTime(record['woke_time']);
      if (sleptTime != null && wokeTime != null) {
        totalSleep += wokeTime.difference(sleptTime);
      }
    }
    return totalSleep;
  }

  double _calculateAverageSleepDuration() {
    if (sleepRecords.isEmpty) return 0;
    Duration totalSleep = _calculateTotalSleepTime();
    return totalSleep.inMinutes / sleepRecords.length;
  }

  Duration _calculateLongestSleepSession() {
    Duration longestSleep = Duration();
    for (var record in sleepRecords) {
      DateTime? sleptTime = _parseDateTime(record['slept_time']);
      DateTime? wokeTime = _parseDateTime(record['woke_time']);
      if (sleptTime != null && wokeTime != null) {
        Duration sleepDuration = wokeTime.difference(sleptTime);
        if (sleepDuration > longestSleep) {
          longestSleep = sleepDuration;
        }
      }
    }
    return longestSleep;
  }

  Duration _calculateShortestSleepSession() {
    if (sleepRecords.isEmpty) return Duration();
    Duration shortestSleep = _calculateLongestSleepSession();
    for (var record in sleepRecords) {
      DateTime? sleptTime = _parseDateTime(record['slept_time']);
      DateTime? wokeTime = _parseDateTime(record['woke_time']);
      if (sleptTime != null && wokeTime != null) {
        Duration sleepDuration = wokeTime.difference(sleptTime);
        if (sleepDuration < shortestSleep) {
          shortestSleep = sleepDuration;
        }
      }
    }
    return shortestSleep;
  }
  /*

  void _recordSleep() async {
    String currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    await dbHelper.insertSleepRecord((await SharedPreferences.getInstance()).getInt('chosenID')!, currentTime, '');
    _sleepTime = currentTime;
    _loadSleepRecords();
  }

  void _recordWake() async {
    String currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    List<Map<String, dynamic>> sleepRecords = await dbHelper.getUserSleepRecords((await SharedPreferences.getInstance()).getInt('chosenID')!);
    if (sleepRecords.isNotEmpty) {
      Map<String, dynamic> lastRecord = Map<String, dynamic>.from(sleepRecords.last);
      if (lastRecord['user_id'] == (await SharedPreferences.getInstance()).getInt('chosenID')! && (lastRecord['woke_time'] == null || lastRecord['woke_time'].isEmpty)) {
        lastRecord['woke_time'] = currentTime;
        await dbHelper.insertSleepRecord((await SharedPreferences.getInstance()).getInt('chosenID')!, lastRecord['slept_time'], lastRecord['woke_time']);
        _sleepTime = null;
        _loadSleepRecords();

        // Calculate sleep duration
        DateTime sleptTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(lastRecord['slept_time']);
        DateTime wokeTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(lastRecord['woke_time']);
        Duration sleepDuration = wokeTime.difference(sleptTime);

        // Show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You slept for ${sleepDuration.inHours} hours and ${sleepDuration.inMinutes % 60} minutes'),
          ),
        );
      }
    }
  }
  */
}
