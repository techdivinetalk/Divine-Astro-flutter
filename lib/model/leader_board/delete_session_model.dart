// To parse this JSON data, do
//
//     final deleteSessionModel = deleteSessionModelFromJson(jsonString);

import 'dart:convert';

DeleteSessionModel deleteSessionModelFromJson(String str) => DeleteSessionModel.fromJson(json.decode(str));

String deleteSessionModelToJson(DeleteSessionModel data) => json.encode(data.toJson());

class DeleteSessionModel {
  List<dynamic>? users;
  String? message;

  DeleteSessionModel({
    this.users,
    this.message,
  });

  factory DeleteSessionModel.fromJson(Map<String, dynamic> json) => DeleteSessionModel(
    users: json["users"] == null ? [] : List<dynamic>.from(json["users"]!.map((x) => x)),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
    "message": message,
  };
}
