// To parse this JSON data, do
//
//     final kpDataModel = kpDataModelFromJson(jsonString);

import 'dart:convert';

KpDataModel kpDataModelFromJson(String str) => KpDataModel.fromJson(json.decode(str));

String kpDataModelToJson(KpDataModel data) => json.encode(data.toJson());

class KpDataModel {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  KpDataModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory KpDataModel.fromJson(Map<String, dynamic> json) => KpDataModel(
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
  List<Planet>? planets;
  List<Cusp>? cusps;

  Data({
    this.planets,
    this.cusps,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    planets: json["planets"] == null ? [] : List<Planet>.from(json["planets"]!.map((x) => Planet.fromJson(x))),
    cusps: json["cusps"] == null ? [] : List<Cusp>.from(json["cusps"]!.map((x) => Cusp.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "planets": planets == null ? [] : List<dynamic>.from(planets!.map((x) => x.toJson())),
    "cusps": cusps == null ? [] : List<dynamic>.from(cusps!.map((x) => x.toJson())),
  };
}

class Cusp {
  int? houseId;
  double? cuspFullDegree;
  String? formattedDegree;
  int? signId;
  String? sign;
  String? signLord;
  String? nakshatra;
  String? nakshatraLord;
  String? subLord;
  String? subSubLord;

  Cusp({
    this.houseId,
    this.cuspFullDegree,
    this.formattedDegree,
    this.signId,
    this.sign,
    this.signLord,
    this.nakshatra,
    this.nakshatraLord,
    this.subLord,
    this.subSubLord,
  });

  factory Cusp.fromJson(Map<String, dynamic> json) => Cusp(
    houseId: json["house_id"],
    cuspFullDegree: json["cusp_full_degree"]?.toDouble(),
    formattedDegree: json["formatted_degree"],
    signId: json["sign_id"],
    sign: json["sign"],
    signLord: json["sign_lord"],
    nakshatra: json["nakshatra"],
    nakshatraLord: json["nakshatra_lord"],
    subLord: json["sub_lord"],
    subSubLord: json["sub_sub_lord"],
  );

  Map<String, dynamic> toJson() => {
    "house_id": houseId,
    "cusp_full_degree": cuspFullDegree,
    "formatted_degree": formattedDegree,
    "sign_id": signId,
    "sign": sign,
    "sign_lord": signLord,
    "nakshatra": nakshatra,
    "nakshatra_lord": nakshatraLord,
    "sub_lord": subLord,
    "sub_sub_lord": subSubLord,
  };
}

class Planet {
  int? planetId;
  String? planetName;
  double? degree;
  String? formattedDegree;
  bool? isRetro;
  double? normDegree;
  String? formattedNormDegree;
  int? house;
  String? sign;
  String? signLord;
  String? nakshatra;
  String? nakshatraLord;
  int? charan;
  String? subLord;
  String? subSubLord;

  Planet({
    this.planetId,
    this.planetName,
    this.degree,
    this.formattedDegree,
    this.isRetro,
    this.normDegree,
    this.formattedNormDegree,
    this.house,
    this.sign,
    this.signLord,
    this.nakshatra,
    this.nakshatraLord,
    this.charan,
    this.subLord,
    this.subSubLord,
  });

  factory Planet.fromJson(Map<String, dynamic> json) => Planet(
    planetId: json["planet_id"],
    planetName: json["planet_name"],
    degree: json["degree"]?.toDouble(),
    formattedDegree: json["formatted_degree"],
    isRetro: json["is_retro"],
    normDegree: json["norm_degree"]?.toDouble(),
    formattedNormDegree: json["formatted_norm_degree"],
    house: json["house"],
    sign: json["sign"],
    signLord: json["sign_lord"],
    nakshatra: json["nakshatra"],
    nakshatraLord: json["nakshatra_lord"],
    charan: json["charan"],
    subLord: json["sub_lord"],
    subSubLord: json["sub_sub_lord"],
  );

  Map<String, dynamic> toJson() => {
    "planet_id": planetId,
    "planet_name": planetName,
    "degree": degree,
    "formatted_degree": formattedDegree,
    "is_retro": isRetro,
    "norm_degree": normDegree,
    "formatted_norm_degree": formattedNormDegree,
    "house": house,
    "sign": sign,
    "sign_lord": signLord,
    "nakshatra": nakshatra,
    "nakshatra_lord": nakshatraLord,
    "charan": charan,
    "sub_lord": subLord,
    "sub_sub_lord": subSubLord,
  };
}
