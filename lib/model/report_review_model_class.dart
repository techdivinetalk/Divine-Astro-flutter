// To parse this JSON data, do
//
//     final reportReviewModelClass = reportReviewModelClassFromJson(jsonString);

import 'dart:convert';

ReportReviewModelClass reportReviewModelClassFromJson(String str) => ReportReviewModelClass.fromJson(json.decode(str));

String reportReviewModelClassToJson(ReportReviewModelClass data) => json.encode(data.toJson());

class ReportReviewModelClass {
  bool? success;
  int? statusCode;
  String? message;

  ReportReviewModelClass({
    this.success,
    this.statusCode,
    this.message,
  });

  factory ReportReviewModelClass.fromJson(Map<String, dynamic> json) => ReportReviewModelClass(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}
