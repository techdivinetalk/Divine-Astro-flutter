

import 'dart:convert';

ImportantNumberModel importantNumberModelFromJson(String str) => ImportantNumberModel.fromJson(json.decode(str));

String importantNumberModelToJson(ImportantNumberModel data) => json.encode(data.toJson());

class ImportantNumberModel {
  List<MobileNumber>? data;
  bool? success;
  int? statusCode;
  String? message;

  ImportantNumberModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory ImportantNumberModel.fromJson(Map<String, dynamic> json) => ImportantNumberModel(
    data: json["data"] == null ? [] : List<MobileNumber>.from(json["data"]!.map((x) => MobileNumber.fromJson(x))),
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

class MobileNumber {
  int? id;
  String? type;
  String? title;
  String? mobileNumber;

  MobileNumber({
    this.id,
    this.type,
    this.title,
    this.mobileNumber,
  });

  factory MobileNumber.fromJson(Map<String, dynamic> json) => MobileNumber(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    mobileNumber: json["mobile_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "mobile_number": mobileNumber,
  };
}
