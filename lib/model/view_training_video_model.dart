// To parse this JSON data, do
//
//     final viewTrainingVideoModelClass = viewTrainingVideoModelClassFromJson(jsonString);

import 'dart:convert';

ViewTrainingVideoModelClass viewTrainingVideoModelClassFromJson(String str) => ViewTrainingVideoModelClass.fromJson(json.decode(str));

String viewTrainingVideoModelClassToJson(ViewTrainingVideoModelClass data) => json.encode(data.toJson());

class ViewTrainingVideoModelClass {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  ViewTrainingVideoModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory ViewTrainingVideoModelClass.fromJson(Map<String, dynamic> json) => ViewTrainingVideoModelClass(
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
  int? id;
  int? astrologerId;
  int? trainingVideoId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.astrologerId,
    this.trainingVideoId,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    astrologerId: json["astrologer_id"],
    trainingVideoId: json["training_video_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "astrologer_id": astrologerId,
    "training_video_id": trainingVideoId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
