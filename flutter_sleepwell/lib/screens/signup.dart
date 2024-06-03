// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/JsonModels/users.dart';
import 'package:flutter_login/SQLite/sqlite.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirm_password = TextEditingController();

  bool isVisiblePass = true;
  bool isVisiblePassConfirm = true;
  bool isPasswordNotEqual = false;

  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
        
                // Image.asset(
                //   'lib/assets/logo.jpg',
                //   width: 100,
                // ),
        
                ListTile(
                  title: Text(
                    "Register New Account",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)
                  )
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
                    obscureText: isVisiblePass,
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
                        icon: Icon(isVisiblePass ? // change the button icon based from the IsVisible
                          Icons.visibility:
                          Icons.visibility_off
                        ),
                        onPressed: () {
                          setState(() {
                            isVisiblePass = !isVisiblePass;                
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
                    color: Colors.blue.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                
                  child: TextFormField(
                    obscureText: isVisiblePassConfirm,
                    controller: confirm_password,
        
                    validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                      },
        
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Confirm Password",
                      icon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isVisiblePassConfirm ? // change the button icon based from the IsVisible
                          Icons.visibility:
                          Icons.visibility_off
                        ),
                        onPressed: () {
                          setState(() {
                            isVisiblePassConfirm = !isVisiblePassConfirm;                
                          });
                        },
                      )
                    ),
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  margin: EdgeInsets.only(top: 12),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                
                  child: TextButton(
                    onPressed: () {
                      
                      if (password.text != confirm_password.text) {
                        setState(() {
                          isPasswordNotEqual = true; 
                        });
                      } else if (formKey.currentState!.validate()) {
                        db.signup(Users(userName: username.text, userPass: password.text)).whenComplete(() {
                          Navigator.pop(context);
                        });
                      }
                    }, 
                    child: Text(
                      "Create Account", 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  )
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
                      Navigator.pop(context);
                    }, 
                    child: Text(
                      "Go Back", 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  )
                ),
        
                isPasswordNotEqual 
                ? Text(
                  "Password and Confirm Password are not the same.",
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