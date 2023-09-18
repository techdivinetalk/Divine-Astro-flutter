// To parse this JSON data, do
//
//     final dashaChartDataModel = dashaChartDataModelFromJson(jsonString);

import 'dart:convert';

DashaChartDataModel dashaChartDataModelFromJson(String str) => DashaChartDataModel.fromJson(json.decode(str));

String dashaChartDataModelToJson(DashaChartDataModel data) => json.encode(data.toJson());

class DashaChartDataModel {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  DashaChartDataModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory DashaChartDataModel.fromJson(Map<String, dynamic> json) => DashaChartDataModel(
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
  List<Vimshottari>? vimshottari;
  List<Yogini>? yogini;

  Data({
    this.vimshottari,
    this.yogini,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    vimshottari: json["vimshottari"] == null ? [] : List<Vimshottari>.from(json["vimshottari"]!.map((x) => Vimshottari.fromJson(x))),
    yogini: json["yogini"] == null ? [] : List<Yogini>.from(json["yogini"]!.map((x) => Yogini.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vimshottari": vimshottari == null ? [] : List<dynamic>.from(vimshottari!.map((x) => x.toJson())),
    "yogini": yogini == null ? [] : List<dynamic>.from(yogini!.map((x) => x.toJson())),
  };
}

class Vimshottari {
  String? planet;
  int? planetId;
  String? start;
  String? end;

  Vimshottari({
    this.planet,
    this.planetId,
    this.start,
    this.end,
  });

  factory Vimshottari.fromJson(Map<String, dynamic> json) => Vimshottari(
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

class Yogini {
  int? dashaId;
  String? dashaName;
  String? startDate;
  String? endDate;
  int? startMs;
  int? endMs;
  int? duration;

  Yogini({
    this.dashaId,
    this.dashaName,
    this.startDate,
    this.endDate,
    this.startMs,
    this.endMs,
    this.duration,
  });

  factory Yogini.fromJson(Map<String, dynamic> json) => Yogini(
    dashaId: json["dasha_id"],
    dashaName: json["dasha_name"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    startMs: json["start_ms"],
    endMs: json["end_ms"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "dasha_id": dashaId,
    "dasha_name": dashaName,
    "start_date": startDate,
    "end_date": endDate,
    "start_ms": startMs,
    "end_ms": endMs,
    "duration": duration,
  };
}
