import 'package:flutter/material.dart';
import 'package:flutter_login/consts.dart';


class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text("About App", style: TextStyle(color: textColor)),
        backgroundColor: kPrimaryColorDarker,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('lib/assets/icon.png', height: 225),

            Text(
              "Welcome to SleepWell",
              style: TextStyle(
                color: textColor,
                fontSize: 30,
              )
            ),

            Text(
              "Where better sleep comes better life!",
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w200,
              )
            ),

            SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: kPrimaryColorDarker,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "A one-for-all app where you can:",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                    )
                  ),

                  SizedBox(height: 5),

                  Text(
                    "• An account system for personal uses.",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                    )
                  ),

                  Text(
                    "• Monitor your sleep through statistics.",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                    )
                  ),

                  Text(
                    "• Record your sleep and wake time.",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                    )
                  ),

                  Text(
                    "• Set an alarm.",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                    )
                  ),

                  Text(
                    "• Check the temperature and weather (which affects sleep).",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                    )
                  ),

                  Text(
                    "• Select factors that affect your sleep and be provided with solutions.",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                    )
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "Team BinaRizz",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        )
                    ),

                    Text(
                      "Loreen Wilmer Yboa",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w300
                      ),
                    ),

                    Text(
                      "Rafael Antonio Uy",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w300
                      ),
                    ),

                    Text(
                      "Mike Gabriel Sablayan",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('lib/assets/flutter_icon.png', height: 40.0),
                    SizedBox(height: 5.0),
                    Image.asset('lib/assets/sqlite_icon.png', height: 40.0),
                    SizedBox(height: 5.0),
                    Image.asset('lib/assets/open_weather_icon.png', height: 40.0),
                  ],
                )
              ],
            )
          ],
        ),
      )
    );
  }
}