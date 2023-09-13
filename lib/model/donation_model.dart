// To parse this JSON data, do
//
//     final donationModel = donationModelFromJson(jsonString);

import 'dart:convert';

DonationModel donationModelFromJson(String str) => DonationModel.fromJson(json.decode(str));

String donationModelToJson(DonationModel data) => json.encode(data.toJson());

class DonationModel {
  List<DonationList>? data;
  bool? success;
  int? statusCode;
  String? message;

  DonationModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) => DonationModel(
    data: json["data"] == null ? [] : List<DonationList>.from(json["data"]!.map((x) => DonationList.fromJson(x))),
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

class DonationList {
  int? id;
  String? thumbnailImage;
  String? bannerImage;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? donationName;
  String? donationSubName;
  String? donationHeading;

  DonationList({
    this.id,
    this.thumbnailImage,
    this.bannerImage,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.donationName,
    this.donationSubName,
    this.donationHeading,
  });

  factory DonationList.fromJson(Map<String, dynamic> json) => DonationList(
    id: json["id"],
    thumbnailImage: json["thumbnail_image"],
    bannerImage: json["banner_image"],
    description: json["description"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    donationName: json["donation_name"],
    donationSubName: json["donation_sub_name"],
    donationHeading: json["donation_heading"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "thumbnail_image": thumbnailImage,
    "banner_image": bannerImage,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "donation_name": donationName,
    "donation_sub_name": donationSubName,
    "donation_heading": donationHeading,
  };
}
