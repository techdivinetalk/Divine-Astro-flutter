import 'dart:convert';

NumberChangeResponse numberChangeResponseFromJson(String str) =>
    NumberChangeResponse.fromJson(json.decode(str));

String numberChangeResponseToJson(NumberChangeResponse data) =>
    json.encode(data.toJson());

class NumberChangeResponse {
  NumberChangeData? data;
  bool? success;
  int? statusCode;
  String? message;

  NumberChangeResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory NumberChangeResponse.fromJson(Map<String, dynamic> json) =>
      NumberChangeResponse(
        data: NumberChangeData.fromJson(json["data"]),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() =>
      {
        "data": data?.toJson(),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class NumberChangeData {
  String? sessionId;
  String? mobileNo;
  int? remainingAttempt;
  int? alreadyInApproved;

  NumberChangeData({
    this.sessionId,
    this.mobileNo,
    this.remainingAttempt,
    this.alreadyInApproved,
  });

  factory NumberChangeData.fromJson(Map<String, dynamic> json) =>
      NumberChangeData(
          sessionId: json["session_id"],
          mobileNo: json["mobile_no"],
          remainingAttempt: json["remaining_attempt"],
          alreadyInApproved: json["already_in_approval"]
      );

  Map<String, dynamic> toJson() =>
      {
        "session_id": sessionId,
        "mobile_no": mobileNo,
        "remaining_attempt": remainingAttempt,
        "already_in_approval": alreadyInApproved,
      };
}
