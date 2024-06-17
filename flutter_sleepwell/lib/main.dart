// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/screens/about_app_page.dart';
import 'package:flutter_login/screens/factors_page.dart';
import 'package:flutter_login/screens/intro_page.dart';
import 'package:flutter_login/screens/login.dart';
import 'package:flutter_login/screens/main_interface.dart';
import 'package:flutter_login/screens/signup.dart';
import 'package:flutter_login/screens/welcome_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
      routes: {
        '/welcome_page': (context) => WelcomePage(),
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/factors_page': (context) => FactorsPage(),
        '/main_interface': (context) => MainInterface(),
        '/about_app': (context) => AboutAppPage()
      }
    );
  }
}