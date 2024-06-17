// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/SQLite/sqlite_user.dart';
import 'package:flutter_login/consts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final db = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateChosenID();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column( 
            children: [
              Text(
                "Welcome to SleepWell",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: textColor
                )),

              Lottie.asset('lib/assets/sleeping_emoji.json'),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: kPrimaryColorDarker,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),

                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/main_interface');
                    Navigator.pushNamed(context, '/factors_page');
                  }, 

                  child: Text(
                    "Select Sleeping Factors",
                    style: TextStyle(
                      color: Colors.white
                    )
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "You will be directed to select the factors that affect your sleep.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  )
                ),
              ),
            ]
          )
        )
      )
    );
  }

  Future<void> updateChosenID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = await db.getMaxUserId();

    if (id != null) {
      await prefs.setInt('chosenID', id);
    } else {
      // Handle the case where there are no users or something went wrong
      print('No user found or error occurred while fetching the max user ID');
    }
  }
}