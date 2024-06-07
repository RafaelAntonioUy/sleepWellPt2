// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/JsonModels/users.dart';
import 'package:flutter_login/SQLite/sqlite_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final username = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isVisible = true;
  bool isLoginError = false;
  final db = DatabaseHelper();

  void login() async {
    try {
      Users account = Users(userName: username.text, userPass: password.text, emailAddress: '');

      // we use await here because the database operates in asynchronous, and returns a future
      var response = await db.login(account);

      if (response == true) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        int? id = await db.getUserIdByUsername(username.text);

        await prefs.setInt('chosenID', id!).whenComplete(() {
          Navigator.pushNamed(context, '/main_interface');
        });
        
      } else {
        setState(() {
          isLoginError = true;
        });
      }
    } catch (e) { // handle errors
      setState(() {
        isLoginError = true;
      });
      print('Error during login: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
        
                Image.asset(
                  'lib/assets/logo.jpg',
                  width: 250,
                ),
            
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  margin: EdgeInsets.only(top: 6),
                  width: MediaQuery.of(context).size.width * 0.9,
                  
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                
                  child: TextFormField(
                    controller: username,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username is required";
                      }
                    },

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Username",
                      icon: Icon(Icons.person),
                    ),
                    
                  ),
                ),
            
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  margin: EdgeInsets.only(top: 6),
                  width: MediaQuery.of(context).size.width * 0.9,
                  
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                
                  child: TextFormField(
                    obscureText: isVisible,
                    controller: password,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }
                    },

                    decoration: InputDecoration(
                      
                      border: InputBorder.none,
                      hintText: "Password",
                      icon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isVisible ? // change the button icon based from the IsVisible
                          Icons.visibility:
                          Icons.visibility_off
                        ),
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;                
                          });
                        },
                      )
                    ),
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  margin: EdgeInsets.only(top: 6),
                  width: MediaQuery.of(context).size.width * 0.9,
        
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                
                  child: TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        login();
                      }
                    }, 
                    child: Text(
                      "Log In", 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  )
                ),
        
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
        
                    children: [
                      Text("Don't have an account?", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text("Sign Up", 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
        
                isLoginError 
                ? Text(
                  "Username or Password is incorrect.",
                  style: TextStyle(color: Colors.red)) 
                : SizedBox(),
              ],
            ),
          )
        ),
      )
    );
  }
}