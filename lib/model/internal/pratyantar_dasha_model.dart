// To parse this JSON data, do
//
//     final getPratyantarDashaModel = getPratyantarDashaModelFromJson(jsonString);

import 'dart:convert';

PratyantarDashaModel getPratyantarDashaModelFromJson(String str) =>
    PratyantarDashaModel.fromJson(json.decode(str));

String getPratyantarDashaModelToJson(PratyantarDashaModel data) =>
    json.encode(data.toJson());

class PratyantarDashaModel {
  List<PratyantarData>? data;
  bool? success;
  int? statusCode;
  String? message;

  PratyantarDashaModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory PratyantarDashaModel.fromJson(Map<String, dynamic> json) =>
      PratyantarDashaModel(
        data: json["data"] == null
            ? []
            : List<PratyantarData>.from(
                json["data"]!.map((x) => PratyantarData.fromJson(x))),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class PratyantarData {
  String? planet;
  int? planetId;
  String? start;
  String? end;

  PratyantarData({
    this.planet,
    this.planetId,
    this.start,
    this.end,
  });

  factory PratyantarData.fromJson(Map<String, dynamic> json) => PratyantarData(
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
