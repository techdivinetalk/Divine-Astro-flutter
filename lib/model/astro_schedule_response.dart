import 'dart:convert';

AstroScheduleRequest astroScheduleRequestFromJson(String str) =>
    AstroScheduleRequest.fromJson(json.decode(str));

String astroScheduleRequestToJson(AstroScheduleRequest data) =>
    json.encode(data.toJson());

class AstroScheduleRequest {
  String scheduleDate;
  String scheduleTime;
  int type;

  AstroScheduleRequest({
    required this.scheduleDate,
    required this.scheduleTime,
    required this.type,
  });

  factory AstroScheduleRequest.fromJson(Map<String, dynamic> json) =>
      AstroScheduleRequest(
        scheduleDate: json["schedule_date"],
        scheduleTime: json["schedule_time"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "schedule_date": scheduleDate,
        "schedule_time": scheduleTime,
        "type": type,
      };

  String toPrettyJson() => JsonEncoder.withIndent(" " * 4).convert(toJson());
}

AstroScheduleResponse astroScheduleResponseFromJson(String str) =>
    AstroScheduleResponse.fromJson(json.decode(str));

String astroScheduleResponseToJson(AstroScheduleResponse data) =>
    json.encode(data.toJson());

class AstroScheduleResponse {
  bool success;
  int statusCode;
  String message;

  AstroScheduleResponse({
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory AstroScheduleResponse.fromJson(Map<String, dynamic> json) =>
      AstroScheduleResponse(
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
      };

  String toPrettyJson() => JsonEncoder.withIndent(" " * 4).convert(toJson());
}
