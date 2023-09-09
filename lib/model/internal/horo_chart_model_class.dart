// To parse this JSON data, do
//
//     final horoChartModel = horoChartModelFromJson(jsonString);

import 'dart:convert';

HoroChartModel horoChartModelFromJson(String str) => HoroChartModel.fromJson(json.decode(str));

String horoChartModelToJson(HoroChartModel data) => json.encode(data.toJson());

class HoroChartModel {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  HoroChartModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory HoroChartModel.fromJson(Map<String, dynamic> json) => HoroChartModel(
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
  String? svg;

  Data({
    this.svg,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    svg: json["svg"],
  );

  Map<String, dynamic> toJson() => {
    "svg": svg,
  };
}
