import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainInterface extends StatefulWidget {
  const MainInterface({super.key});

  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  int chosenID = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Interface"),
        backgroundColor: Colors.blue[300],
      ),

      body: Center(child: Text("Hello World!"),),

      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column (
            children: [
              DrawerHeader(child: Icon(Icons.bed, size: 90)),
            
              ListTile(
                title: Text("About App"),
                leading: Icon(Icons.info),
                onTap: () {
                  // TODO: another screen for about app
                }
              ),
          
              ListTile(
                title: Text("Factors Checklist"),
                leading: Icon(Icons.check_circle),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/factors_page');
                }
              ),
          
              ListTile(
                title: Text("Logout"),
                leading: Icon(Icons.logout),
                onTap: () {
                  removeChosenID();
          
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                }
              ),
            ],
          ),
        )
      ),
    );
  }
  
  void removeChosenID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chosenID');
  }
}