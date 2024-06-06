// To parse this JSON data, do
//
//     final sleepingFactor = sleepingFactorFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SleepingFactor sleepingFactorFromMap(String str) => SleepingFactor.fromMap(json.decode(str));

String sleepingFactorToMap(SleepingFactor data) => json.encode(data.toMap());

class SleepingFactor {
    final int? factorID;
    final String name;
    final String causes;
    final String solution;

    SleepingFactor({
        this.factorID,
        required this.name,
        required this.causes,
        required this.solution,
    });

    factory SleepingFactor.fromMap(Map<String, dynamic> json) => SleepingFactor(
        factorID: json["factorID"],
        name: json["name"],
        causes: json["causes"],
        solution: json["solution"],
    );

    Map<String, dynamic> toMap() => {
        "factorID": factorID,
        "name": name,
        "causes": causes,
        "solution": solution,
    };
}
