import 'dart:convert';

import 'package:divine_astrologer/model/res_login.dart';

SpecialityList specialityListFromJson(String str) =>
    SpecialityList.fromJson(json.decode(str));

String specialityListToJson(SpecialityList data) => json.encode(data.toJson());

class SpecialityList {
  List<SpecialityData> data;
  bool? success;
  int? statusCode;
  String? message;

  SpecialityList({
    this.data = const [],
    this.success,
    this.statusCode,
    this.message,
  });

  SpecialityList copyWith({
    List<SpecialityData>? data,
    bool? success,
    int? statusCode,
    String? message,
  }) =>
      SpecialityList(
        data: data ?? this.data,
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory SpecialityList.fromJson(Map<String, dynamic> json) => SpecialityList(
        data: List<SpecialityData>.from(json["data"].map((x) => SpecialityData.fromJson(x))),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };

  String toPrettyJson() => JsonEncoder.withIndent(" " * 4).convert(toJson());
}

class SpecialityData {
  int? id;
  String? name;
  String? image;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? status;

  SpecialityData({
    this.id,
    this.name,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  SpecialityData copyWith({
    int? id,
    String? name,
    String? image,
    String? type,
    String? createdAt,
    String? updatedAt,
    int? status,
  }) =>
      SpecialityData(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
      );

  factory SpecialityData.fromJson(Map<String, dynamic> json) => SpecialityData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
      );

  factory SpecialityData.fromAstrologerSpeciality(AstrologerSpeciality json) => SpecialityData(
    id: json.specialityDetails?.id,
    name: json.specialityDetails?.name,
    image: json.specialityDetails?.image,
    type: json.specialityDetails?.type,
    createdAt: json.specialityDetails?.createdAt,
    updatedAt: json.specialityDetails?.updatedAt,
    status: json.specialityDetails?.status,
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status": status,
      };

  List<String> parseType() {
    List<String> data = <String>[];
    try {
      data = jsonDecode(type!).map<String>((e) => e.toString()).toList();
    } catch (err) {
      return data;
    }
    return data;
  }
}
