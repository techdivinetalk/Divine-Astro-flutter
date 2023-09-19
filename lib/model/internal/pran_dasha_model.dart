// To parse this JSON data, do
//
//     final pranDashaModel = pranDashaModelFromJson(jsonString);

import 'dart:convert';

PranDashaModel pranDashaModelFromJson(String str) => PranDashaModel.fromJson(json.decode(str));

String pranDashaModelToJson(PranDashaModel data) => json.encode(data.toJson());

class PranDashaModel {
  List<PranDashaData>? data;
  bool? success;
  int? statusCode;
  String? message;

  PranDashaModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory PranDashaModel.fromJson(Map<String, dynamic> json) => PranDashaModel(
    data: json["data"] == null ? [] : List<PranDashaData>.from(json["data"]!.map((x) => PranDashaData.fromJson(x))),
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

class PranDashaData {
  String? planet;
  int? planetId;
  String? start;
  String? end;

  PranDashaData({
    this.planet,
    this.planetId,
    this.start,
    this.end,
  });

  factory PranDashaData.fromJson(Map<String, dynamic> json) => PranDashaData(
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
