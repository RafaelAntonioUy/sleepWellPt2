// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/JsonModels/users.dart';
import 'package:flutter_login/SQLite/sqlite_user.dart';
import 'package:flutter_login/consts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();

  bool isVisiblePass = true;
  bool isVisiblePassConfirm = true;
  bool isPasswordNotEqual = false;

  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
        
                ListTile(
                  title: Text(
                    "Register New Account",
                    textAlign: TextAlign.left,

                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: textColor)
                  )
                ),
            
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  margin: EdgeInsets.only(top: 6),
                  width: MediaQuery.of(context).size.width * 0.9,
                  
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                
                  child: TextFormField(
                    controller: usernameController,
        
                    validator: (value) {
                        if (value!.isEmpty) {
                          return "Username is required";
                        } else if (value.contains('@')) {
                          return "Username must not contain @";
                        } else if (value!.length < 4) {
                          return "Username must be atleast 4 characters";
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
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                      icon: Icon(Icons.email),
                    ),
                  ),
                ),
            
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  margin: EdgeInsets.only(top: 6),
                  width: MediaQuery.of(context).size.width * 0.9,
                  
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                
                  child: TextFormField(
                    obscureText: isVisiblePass,
                    controller: passwordController,
        
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      } else if (!RegExp(r'\d').hasMatch(value)) {
                        return "Password must contain at least one digit";
                      }
                      return null;
                    },
        
                    decoration: InputDecoration(
                      
                      border: InputBorder.none,
                      hintText: "Password",
                      icon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isVisiblePass ? // change the button icon based from the IsVisible
                          Icons.visibility_off:
                          Icons.visibility
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
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                
                  child: TextFormField(
                    obscureText: isVisiblePassConfirm,
                    controller: confirmPasswordController,
        
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm password is required";
                      } else if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
        
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Confirm Password",
                      icon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isVisiblePassConfirm ? // change the button icon based from the IsVisible
                          Icons.visibility_off:
                          Icons.visibility
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
                    color: kPrimaryColorDarker,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                
                  child: TextButton(
                    onPressed: () async {
                      
                      if (passwordController.text != confirmPasswordController.text) {
                        setState(() {
                          isPasswordNotEqual = true; 
                        });
                      } else if (formKey.currentState!.validate()) {
                        await db.signup(Users(
                          userName: usernameController.text, 
                          userPass: passwordController.text, 
                          emailAddress: emailController.text
                        ));
                        
                        // await Future.delayed(Duration(milliseconds: 100));
                        // await updateChosenID();
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/welcome_page');
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
                    color: kPrimaryColorDarker,
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
  
  // Future<void> updateChosenID() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? id = await db.getMaxUserId();

  //   if (id != null) {
  //     await prefs.setInt('chosenID', id);
  //   } else {
  //     // Handle the case where there are no users or something went wrong
  //     print('No user found or error occurred while fetching the max user ID');
  //   }
  // }
}
