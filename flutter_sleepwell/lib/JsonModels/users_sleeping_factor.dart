// To parse this JSON data, do
//
//     final userSleepingFactor = userSleepingFactorFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserSleepingFactor userSleepingFactorFromMap(String str) => UserSleepingFactor.fromMap(json.decode(str));

String userSleepingFactorToMap(UserSleepingFactor data) => json.encode(data.toMap());

class UserSleepingFactor {
    final int userID;
    final int factorID;

    UserSleepingFactor({
        required this.userID,
        required this.factorID,
    });

    factory UserSleepingFactor.fromMap(Map<String, dynamic> json) => UserSleepingFactor(
        userID: json["userID"],
        factorID: json["factorID"],
    );

    Map<String, dynamic> toMap() => {
        "userID": userID,
        "factorID": factorID,
    };
}
