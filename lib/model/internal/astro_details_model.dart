// To parse this JSON data, do
//
//     final astroDetailsModel = astroDetailsModelFromJson(jsonString);

import 'dart:convert';

AstroDetailsModel astroDetailsModelFromJson(String str) => AstroDetailsModel.fromJson(json.decode(str));

String astroDetailsModelToJson(AstroDetailsModel data) => json.encode(data.toJson());

class AstroDetailsModel {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  AstroDetailsModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory AstroDetailsModel.fromJson(Map<String, dynamic> json) => AstroDetailsModel(
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
  String? ascendant;
  String? ascendantLord;
  String? varna;
  String? vashya;
  String? yoni;
  String? gan;
  String? nadi;
  String? signLord;
  String? sign;
  String? naksahtra;
  String? naksahtraLord;
  int? charan;
  String? yog;
  String? karan;
  String? tithi;
  String? yunja;
  String? tatva;
  String? nameAlphabet;
  String? paya;

  Data({
    this.ascendant,
    this.ascendantLord,
    this.varna,
    this.vashya,
    this.yoni,
    this.gan,
    this.nadi,
    this.signLord,
    this.sign,
    this.naksahtra,
    this.naksahtraLord,
    this.charan,
    this.yog,
    this.karan,
    this.tithi,
    this.yunja,
    this.tatva,
    this.nameAlphabet,
    this.paya,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    ascendant: json["ascendant"],
    ascendantLord: json["ascendant_lord"],
    varna: json["Varna"],
    vashya: json["Vashya"],
    yoni: json["Yoni"],
    gan: json["Gan"],
    nadi: json["Nadi"],
    signLord: json["SignLord"],
    sign: json["sign"],
    naksahtra: json["Naksahtra"],
    naksahtraLord: json["NaksahtraLord"],
    charan: json["Charan"],
    yog: json["Yog"],
    karan: json["Karan"],
    tithi: json["Tithi"],
    yunja: json["yunja"],
    tatva: json["tatva"],
    nameAlphabet: json["name_alphabet"],
    paya: json["paya"],
  );

  Map<String, dynamic> toJson() => {
    "ascendant": ascendant,
    "ascendant_lord": ascendantLord,
    "Varna": varna,
    "Vashya": vashya,
    "Yoni": yoni,
    "Gan": gan,
    "Nadi": nadi,
    "SignLord": signLord,
    "sign": sign,
    "Naksahtra": naksahtra,
    "NaksahtraLord": naksahtraLord,
    "Charan": charan,
    "Yog": yog,
    "Karan": karan,
    "Tithi": tithi,
    "yunja": yunja,
    "tatva": tatva,
    "name_alphabet": nameAlphabet,
    "paya": paya,
  };
}
