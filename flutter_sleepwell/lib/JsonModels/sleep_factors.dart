// To parse this JSON data, do
//
//     final sleepFactors = sleepFactorsFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SleepFactors sleepFactorsFromMap(String str) => SleepFactors.fromMap(json.decode(str));

String sleepFactorsToMap(SleepFactors data) => json.encode(data.toMap());

class SleepFactors {
    final int userId;
    final int comfortabilityFactor;
    final int stressFactor;
    final int noiseFactor;
    final int lightFactor;
    final int ambienceFactor;
    final int temperatureFactor;
    final int distractionsFactor;
    final int blueLightFactor;
    final int academicFactor;
    final int overthinkingFactor;
    final int sleepScheduleFactor;

    SleepFactors({
        required this.userId,
        required this.comfortabilityFactor,
        required this.stressFactor,
        required this.noiseFactor,
        required this.lightFactor,
        required this.ambienceFactor,
        required this.temperatureFactor,
        required this.distractionsFactor,
        required this.blueLightFactor,
        required this.academicFactor,
        required this.overthinkingFactor,
        required this.sleepScheduleFactor,
    });

    factory SleepFactors.fromMap(Map<String, dynamic> json) => SleepFactors(
        userId: json["userID"],
        comfortabilityFactor: json["comfortabilityFactor"],
        stressFactor: json["stressFactor"],
        noiseFactor: json["noiseFactor"],
        lightFactor: json["lightFactor"],
        ambienceFactor: json["ambienceFactor"],
        temperatureFactor: json["temperatureFactor"],
        distractionsFactor: json["distractionsFactor"],
        blueLightFactor: json["blueLightFactor"],
        academicFactor: json["academicFactor"],
        overthinkingFactor: json["overthinkingFactor"],
        sleepScheduleFactor: json["sleepScheduleFactor"],
    );

    Map<String, dynamic> toMap() => {
        "userID": userId,
        "comfortabilityFactor": comfortabilityFactor,
        "stressFactor": stressFactor,
        "noiseFactor": noiseFactor,
        "lightFactor": lightFactor,
        "ambienceFactor": ambienceFactor,
        "temperatureFactor": temperatureFactor,
        "distractionsFactor": distractionsFactor,
        "blueLightFactor": blueLightFactor,
        "academicFactor": academicFactor,
        "overthinkingFactor": overthinkingFactor,
        "sleepScheduleFactor": sleepScheduleFactor,
    };
}
