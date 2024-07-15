import 'dart:convert';

import 'package:divine_astrologer/model/res_login.dart';
CategoriesList categoriesDataFromJson(String str) =>
    CategoriesList.fromJson(json.decode(str));

String specialityListToJson(CategoriesList data) => json.encode(data.toJson());

class CategoriesList {
  List<CategoriesData> data;
  bool? success;
  int? statusCode;
  String? message;

  CategoriesList({
    this.data = const [],
    this.success,
    this.statusCode,
    this.message,
  });

  CategoriesList copyWith({
    List<CategoriesData>? data,
    bool? success,
    int? statusCode,
    String? message,
  }) =>
      CategoriesList(
        data: data ?? this.data,
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory CategoriesList.fromJson(Map<String, dynamic> json) => CategoriesList(
    data: List<CategoriesData>.from(json["data"].map((x) => CategoriesData.fromJson(x))),
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
class CategoriesData {
  int? id;
  String? name;
  String? image;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? status;

  CategoriesData({
    this.id,
    this.name,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  CategoriesData copyWith({
    int? id,
    String? name,
    String? image,
    String? type,
    String? createdAt,
    String? updatedAt,
    int? status,
  }) =>
      CategoriesData(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
      );

  factory CategoriesData.fromJson(Map<String, dynamic> json) => CategoriesData(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    type: json["type"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    status: json["status"],
  );

  factory CategoriesData.fromAstrologerSpeciality(AstroCatPivot json) => CategoriesData(
    id: json.categoryDetails?.id,
    name: json.categoryDetails?.name,
    image: json.categoryDetails?.image,
    // type: json.categoryDetails?.type,
    // createdAt: json.categoryDetails?.createdAt,
    // updatedAt: json.categoryDetails?.updatedAt,
    status: json.categoryDetails?.status,
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