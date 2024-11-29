// To parse this JSON data, do
//
//     final sendFeedBackModel = sendFeedBackModelFromJson(jsonString);

import 'dart:convert';

SendFeedBackModel sendFeedBackModelFromJson(String str) => SendFeedBackModel.fromJson(json.decode(str));

String sendFeedBackModelToJson(SendFeedBackModel data) => json.encode(data.toJson());

class SendFeedBackModel {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  SendFeedBackModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory SendFeedBackModel.fromJson(Map<String, dynamic> json) => SendFeedBackModel(
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
  int? astrologerId;
  String? comment;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.astrologerId,
    this.comment,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    astrologerId: json["astrologer_id"],
    comment: json["comment"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "astrologer_id": astrologerId,
    "comment": comment,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
