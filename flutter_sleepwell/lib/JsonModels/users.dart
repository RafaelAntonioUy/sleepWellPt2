// To parse this JSON data, do
//
//     final Users = UsersFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Users UsersFromMap(String str) => Users.fromMap(json.decode(str));

String UsersToMap(Users data) => json.encode(data.toMap());

class Users {
    final int? userId;
    final String userName;
    final String userPass;

    Users({
        this.userId,
        required this.userName,
        required this.userPass,
    });

    factory Users.fromMap(Map<String, dynamic> json) => Users(
        userId: json["userID"],
        userName: json["userName"],
        userPass: json["userPass"],
    );

    Map<String, dynamic> toMap() => {
        "userID": userId,
        "userName": userName,
        "userPass": userPass,
    };
}
