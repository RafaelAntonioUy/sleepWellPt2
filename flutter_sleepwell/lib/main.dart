/*
import 'package:flutter/material.dart';
import 'package:flutter_login/JsonModels/sleeping_factor.dart';
import 'package:flutter_login/JsonModels/users_sleeping_factor.dart';
import 'package:flutter_login/SQLite/sqlite_sleep_facors.dart';
import 'package:flutter_login/screens/user_factors_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelperSleepFactors dbHelper = DatabaseHelperSleepFactors.instance;

  Future<void> _createFactor() async {
    final factor = SleepingFactor(
      name: 'Academics',
      causes: 'Study stress',
      solution: 'Time management',
    );
    await dbHelper.createFactor(factor);
    setState(() {});
  }

  Future<void> _readFactors() async {
    List<SleepingFactor> factors = await dbHelper.readFactors();
    factors.forEach((factor) => print(factor.toMap()));
  }

  Future<void> _updateFactor() async {
    final factor = SleepingFactor(
      factorID: 1,
      name: 'Updated Academics',
      causes: 'Updated Study stress',
      solution: 'Updated Time management',
    );
    await dbHelper.updateFactor(factor);
    setState(() {});
  }

  Future<void> _deleteFactor() async {
    await dbHelper.deleteFactor(1);
    setState(() {});
  }

  Future<void> _createUserFactor() async {
    final userFactor = UserSleepingFactor(
      userID: 1,
      factorID: 1,
    );
    await dbHelper.createUserFactor(userFactor);
    setState(() {});
  }

  Future<void> _readUserFactors() async {
    List<UserSleepingFactor> userFactors = await dbHelper.readUserFactors(1);
    userFactors.forEach((userFactor) => print(userFactor.toMap()));
  }

  Future<void> _deleteUserFactor() async {
    final userFactor = UserSleepingFactor(
      userID: 1,
      factorID: 1,
    );
    await dbHelper.deleteUserFactor(userFactor);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleepwell App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _createFactor, child: Text('Create Factor')),
            ElevatedButton(onPressed: _readFactors, child: Text('Read Factors')),
            ElevatedButton(onPressed: _updateFactor, child: Text('Update Factor')),
            ElevatedButton(onPressed: _deleteFactor, child: Text('Delete Factor')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _createUserFactor, child: Text('Create User Factor')),
            ElevatedButton(onPressed: _readUserFactors, child: Text('Read User Factors')),
            ElevatedButton(onPressed: _deleteUserFactor, child: Text('Delete User Factor')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserFactorsPage(userID: 1)),
                );
              },
              child: Text('Show User Factors'),
            ),
          ],
        ),
      ),
    );
  }
}

*/
 // ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/screens/factors_page.dart';
import 'package:flutter_login/screens/login.dart';
import 'package:flutter_login/screens/main_interface.dart';
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
        '/welcome_page': (context) => WelcomePage(),
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/factors_page': (context) => FactorsPage(),
        '/main_interface': (context) => MainInterface()
      }
    );
  }
}