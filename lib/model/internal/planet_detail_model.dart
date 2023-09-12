// To parse this JSON data, do
//
//     final planetlDetailModel = planetlDetailModelFromJson(jsonString);

import 'dart:convert';

PlanetlDetailModel planetlDetailModelFromJson(String str) => PlanetlDetailModel.fromJson(json.decode(str));

String planetlDetailModelToJson(PlanetlDetailModel data) => json.encode(data.toJson());

class PlanetlDetailModel {
  List<Datum>? data;
  bool? success;
  int? statusCode;
  String? message;

  PlanetlDetailModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory PlanetlDetailModel.fromJson(Map<String, dynamic> json) => PlanetlDetailModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}

class Datum {
  String? planet;
  int? planetId;
  String? start;
  String? end;

  Datum({
    this.planet,
    this.planetId,
    this.start,
    this.end,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    planet: json["planet"],
    planetId: json["planet_id"],
    start: json["start"],
    end: json["end"],
  );

  Map<String, dynamic> toJson() => {
    "planet": planet,
    "planet_id": planetId,
    "start": start,
    "end": end,
  };
}
