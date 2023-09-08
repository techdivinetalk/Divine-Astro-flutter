// To parse this JSON data, do
//
//     final kundliPredictionModel = kundliPredictionModelFromJson(jsonString);

import 'dart:convert';

KundliPredictionModel kundliPredictionModelFromJson(String str) => KundliPredictionModel.fromJson(json.decode(str));

String kundliPredictionModelToJson(KundliPredictionModel data) => json.encode(data.toJson());

class KundliPredictionModel {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  KundliPredictionModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory KundliPredictionModel.fromJson(Map<String, dynamic> json) => KundliPredictionModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}

class Data {
  List<String>? physical;
  List<String>? character;
  List<String>? education;
  List<String>? family;
  List<String>? health;

  Data({
    this.physical,
    this.character,
    this.education,
    this.family,
    this.health,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    physical: json["physical"] == null ? [] : List<String>.from(json["physical"]!.map((x) => x)),
    character: json["character"] == null ? [] : List<String>.from(json["character"]!.map((x) => x)),
    education: json["education"] == null ? [] : List<String>.from(json["education"]!.map((x) => x)),
    family: json["family"] == null ? [] : List<String>.from(json["family"]!.map((x) => x)),
    health: json["health"] == null ? [] : List<String>.from(json["health"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "physical": physical == null ? [] : List<dynamic>.from(physical!.map((x) => x)),
    "character": character == null ? [] : List<dynamic>.from(character!.map((x) => x)),
    "education": education == null ? [] : List<dynamic>.from(education!.map((x) => x)),
    "family": family == null ? [] : List<dynamic>.from(family!.map((x) => x)),
    "health": health == null ? [] : List<dynamic>.from(health!.map((x) => x)),
  };
}
