import 'dart:convert';

LogOutResponse logOutResponseFromJson(String str) =>
    LogOutResponse.fromJson(json.decode(str));

String logOutResponseToJson(LogOutResponse data) => json.encode(data.toJson());

class LogOutResponse {
  bool? success;
  int? statusCode;
  String? message;

  LogOutResponse({
    this.success,
    this.statusCode,
    this.message,
  });

  factory LogOutResponse.fromJson(Map<String, dynamic> json) => LogOutResponse(
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
