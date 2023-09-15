// To parse this JSON data, do
//
//     final initLeaderBoardSessionModel = initLeaderBoardSessionModelFromJson(jsonString);

import 'dart:convert';

InitLeaderBoardSessionModel initLeaderBoardSessionModelFromJson(String str) => InitLeaderBoardSessionModel.fromJson(json.decode(str));

String initLeaderBoardSessionModelToJson(InitLeaderBoardSessionModel data) => json.encode(data.toJson());

class InitLeaderBoardSessionModel {
  String? message;

  InitLeaderBoardSessionModel({
    this.message,
  });

  factory InitLeaderBoardSessionModel.fromJson(Map<String, dynamic> json) => InitLeaderBoardSessionModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
