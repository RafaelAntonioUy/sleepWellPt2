// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column( 
            children: [
              
              Text("Welcome to DeepSleep!"),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),

                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  }, 

                  child: Text(
                    "Go Back",
                    style: TextStyle(
                      color: Colors.white
                    )
                  ),
                ),
              )
            ]
          )
        )
      )
    );
  }
}