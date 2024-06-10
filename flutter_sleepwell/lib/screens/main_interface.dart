// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/navigation_screens/clock_page.dart';
import 'package:flutter_login/screens/navigation_screens/info_page.dart';
import 'package:flutter_login/screens/navigation_screens/statistics_page.dart';
import 'package:flutter_login/screens/navigation_screens/weather_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainInterface extends StatefulWidget {
  const MainInterface({super.key});

  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  int chosenID = 0;
  int _selectedIndex = 0;

  final List _pages = [
    StatisticsPage(),
    ClockPage(),
    WeatherPage(),
    InfoPage()
  ];

  final List<String> _pageTitles = [
    "Statistics",
    "Clock",
    "Weather",
    "Information"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        backgroundColor: Colors.blue[300],
      ),

      body: _pages[_selectedIndex],

      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: [
              DrawerHeader(child: Icon(Icons.bed, size: 90)),
              ListTile(
                title: Text("About App"),
                leading: Icon(Icons.info),
                onTap: () {
                  // TODO: another screen for about app
                },
              ),
              ListTile(
                title: Text("Factors Checklist"),
                leading: Icon(Icons.check_circle),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/factors_page');
                },
              ),
              ListTile(
                title: Text("Logout"),
                leading: Icon(Icons.logout),
                onTap: () {
                  removeChosenID();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: "Statistics",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.av_timer),
              label: "Clock",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: "Weather",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: "Information",
            ),
          ],
        ),
      ),
    );
  }

  void removeChosenID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chosenID');
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
