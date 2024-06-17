import 'package:flutter/material.dart';
import 'package:flutter_login/consts.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimaryColor,
              kPrimaryColorDarker,
            ],
            stops: [0.8, 1.0],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
              children: [
                Image.asset('lib/assets/icon.png', height: 225),
                SizedBox(height: 16),
                Text(
                  "Welcome to SleepWell",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Where better sleep comes better life!",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/login");
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColorDarker, // Background color
                  ),
                  child: Text("Enter", style: TextStyle(color: textColor))
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
