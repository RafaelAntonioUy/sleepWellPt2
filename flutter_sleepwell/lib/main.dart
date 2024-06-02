// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/screens/login.dart';
import 'package:flutter_login/screens/signup.dart';
import 'package:flutter_login/screens/welcome_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        '/welcomepage': (context) => WelcomePage(),
        '/login': (context) => Login(),
        '/signup': (context) => Signup()
      }
    );
  }
}
