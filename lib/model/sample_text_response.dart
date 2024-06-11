import 'dart:convert';

SampleTextResponse sampleTextFromJson(String str) =>
    SampleTextResponse.fromJson(json.decode(str));

String sampleTextToJson(SampleTextResponse data) => json.encode(data.toJson());

class SampleTextResponse {
  SampleTextResponse({
    this.data,
    this.success = false,
    this.statusCode = 0,
    this.message = "",
  });

  Data? data;
  bool success = false;
  int statusCode;
  String message;

  factory SampleTextResponse.fromJson(Map<String, dynamic> json) =>
      SampleTextResponse(
        data: Data.fromJson(json["data"]),
        success: json["success"] ?? false,
        statusCode: json["status_code"] ?? 0,
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class Data {
  Data({
    this.id = 0,
    this.text = "",
    this.status = "0",
  });

  int id = 0;
  String text;
  String status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        text: json["text"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "status": status,
      };
}
