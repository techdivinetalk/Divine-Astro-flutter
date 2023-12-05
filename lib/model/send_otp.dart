import 'dart:convert';

SendOtpModel sendOtpModelFromJson(String str) =>
    SendOtpModel.fromJson(json.decode(str));

String sendOtpModelToJson(SendOtpModel data) => json.encode(data.toJson());

class SendOtpModel {
  Data data;
  bool success;
  int statusCode;
  String message;

  SendOtpModel({
    required this.data,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) => SendOtpModel(
    data: Data.fromJson(json["data"]),
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}

class Data {
  String sessionId;
  String mobileNo;

  Data({
    required this.sessionId,
    required this.mobileNo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sessionId: json["session_id"],
    mobileNo: json["mobile_no"],
  );

  Map<String, dynamic> toJson() => {
    "session_id": sessionId,
    "mobile_no": mobileNo,
  };
}
