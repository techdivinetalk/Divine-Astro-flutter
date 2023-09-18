// To parse this JSON data, do
//
//     final sookshmaDashaModel = sookshmaDashaModelFromJson(jsonString);

import 'dart:convert';

SookshmaDashaModel sookshmaDashaModelFromJson(String str) => SookshmaDashaModel.fromJson(json.decode(str));

String sookshmaDashaModelToJson(SookshmaDashaModel data) => json.encode(data.toJson());

class SookshmaDashaModel {
  List<SookshmaData>? data;
  bool? success;
  int? statusCode;
  String? message;

  SookshmaDashaModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory SookshmaDashaModel.fromJson(Map<String, dynamic> json) => SookshmaDashaModel(
    data: json["data"] == null ? [] : List<SookshmaData>.from(json["data"]!.map((x) => SookshmaData.fromJson(x))),
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

class SookshmaData {
  String? planet;
  int? planetId;
  String? start;
  String? end;

  SookshmaData({
    this.planet,
    this.planetId,
    this.start,
    this.end,
  });

  factory SookshmaData.fromJson(Map<String, dynamic> json) => SookshmaData(
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
