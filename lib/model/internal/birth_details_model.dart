// To parse this JSON data, do
//
//     final birthDetailsModel = birthDetailsModelFromJson(jsonString);

import 'dart:convert';

BirthDetailsModel birthDetailsModelFromJson(String str) => BirthDetailsModel.fromJson(json.decode(str));

String birthDetailsModelToJson(BirthDetailsModel data) => json.encode(data.toJson());

class BirthDetailsModel {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  BirthDetailsModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory BirthDetailsModel.fromJson(Map<String, dynamic> json) => BirthDetailsModel(
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
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  double? latitude;
  double? longitude;
  double? timezone;
  int? seconds;
  double? ayanamsha;
  String? sunrise;
  String? sunset;
  String? gender;

  Data({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.latitude,
    this.longitude,
    this.timezone,
    this.seconds,
    this.ayanamsha,
    this.sunrise,
    this.sunset,
    this.gender,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    year: json["year"],
    month: json["month"],
    day: json["day"],
    hour: json["hour"],
    minute: json["minute"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    timezone: json["timezone"]?.toDouble(),
    seconds: json["seconds"],
    ayanamsha: json["ayanamsha"]?.toDouble(),
    sunrise: json["sunrise"],
    sunset: json["sunset"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "month": month,
    "day": day,
    "hour": hour,
    "minute": minute,
    "latitude": latitude,
    "longitude": longitude,
    "timezone": timezone,
    "seconds": seconds,
    "ayanamsha": ayanamsha,
    "sunrise": sunrise,
    "sunset": sunset,
    "gender": gender,
  };
}
