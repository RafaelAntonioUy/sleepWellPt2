
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_login/consts.dart';
import 'package:flutter_login/screens/navigation_screens/clock_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:async';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  String _currentView = 'Clock';

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(now);
    var formattedDate = DateFormat('EEE, d MMM').format(now);
    var timezoneString = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timezoneString.startsWith('-')) offsetSign = '+';
    print(timezoneString);


    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildMenuButton('Clock', Icons.query_builder, () {
                setState(() {
                  _currentView = 'Clock';
                });
              }),
              buildMenuButton('Alarm', Icons.alarm_add, () {
                setState(() {
                  _currentView = 'Alarm';
                });
              }),
              buildMenuButton('Sleep Start', Icons.lunch_dining, () {
                setState(() {
                  _currentView = 'Sleep Start';
                });
              }),
              buildMenuButton('Sleep End', Icons.cruelty_free, () {
                setState(() {
                  _currentView = 'Sleep End';
                });
              }),
            ],
          ),
          VerticalDivider(
            color: Colors.white54,
            width: 1,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
              child: _buildCurrentView(formattedTime, formattedDate, offsetSign, timezoneString),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView(String formattedTime, String formattedDate, String offsetSign, String timezoneString) {
    switch (_currentView) {
      case 'Alarm':
        return AlarmPage();
      case 'Sleep Start':
        return SleepStartPage();
      case 'Sleep End':
        return SleepEndPage();
      case 'Clock':
      default:
        return buildClockView(formattedTime, formattedDate, offsetSign, timezoneString);
    }
  }

  Widget buildClockView(String formattedTime, String formattedDate, String offsetSign, String timezoneString) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedTime,
                style: TextStyle(color: Colors.white, fontSize: 64)),
            Text(formattedDate,
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: ClockView(size: MediaQuery.of(context).size.height / 3),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timezone',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                SizedBox(width: 16),
                Text('UTC' + offsetSign + timezoneString,
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            )
          ],
        ),
      ],
    );
  }

  Padding buildMenuButton(String title, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          children: [
            Icon(
              icon,
              color: textColor,
            ),
            Text(title,
                style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<DateTime> _alarms = [];
  TimeOfDay? _selectedTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadAlarms();
    _timer = Timer.periodic(Duration(seconds: 1), _checkAlarms);
    requestExactAlarmPermission();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmStrings = prefs.getStringList('alarms') ?? [];
    setState(() {
      _alarms = alarmStrings.map((str) => DateTime.parse(str)).toList();
    });
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmStrings = _alarms.map((alarm) => alarm.toIso8601String()).toList();
    await prefs.setStringList('alarms', alarmStrings);
  }

  void _checkAlarms(Timer timer) {
    DateTime now = DateTime.now();
    for (var alarm in _alarms) {
      if (now.hour == alarm.hour && now.minute == alarm.minute && now.second == 0) {
        _showAlarmNotification();
        _playAlarm();
      }
    }
  }

  void _showAlarmNotification() {
    flutterLocalNotificationsPlugin.show(
      0,
      'Alarm',
      'An alarm is ringing!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: kPrimaryColor, // Set primary color
            colorScheme: ColorScheme.light(primary: kPrimaryColor),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      final now = DateTime.now();
      final alarm = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        _selectedTime = picked;
        _alarms.add(alarm);
      });
      _saveAlarms();
      _scheduleAlarm(alarm);
    }
  }


  void _scheduleAlarm(DateTime alarmTime) {
    AndroidAlarmManager.oneShotAt(
      alarmTime,
      alarmTime.hashCode,
      alarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  void _deleteAlarm(DateTime alarm) {
    setState(() {
      _alarms.remove(alarm);
    });
    _saveAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select Alarm Time', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)) ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColorDarker // Background color of the button
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Alarms:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            Expanded(
              child: ListView(
                children: _alarms.map((alarm) => ListTile(
                  title: Text(
                    DateFormat('HH:mm a').format(alarm),
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: textColor),
                    onPressed: () => _deleteAlarm(alarm),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playAlarm() async {
    final player = AudioPlayer();
    await player.play(AssetSource('alarm.mp3')); // Play from assets
  }

  Future<void> requestExactAlarmPermission() async {
    var status = await Permission.scheduleExactAlarm.status;
    if (!status.isGranted) {
      status = await Permission.scheduleExactAlarm.request();
    }
    if (status.isGranted) {
      print("Exact alarm permission granted");
    } else {
      print("Exact alarm permission denied");
    }
  }


  void alarmCallback() async {
    flutterLocalNotificationsPlugin.show(
      0,
      'Alarm',
      'Your alarm is ringing!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
    );

    final player = AudioPlayer();
    await player.play(AssetSource('alarm.mp3')); // Play from assets
  }

}

class SleepStartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Sleep Start Page',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}

class SleepEndPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Sleep End Page',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}