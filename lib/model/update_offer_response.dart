import 'dart:convert';

UpdateOfferResponse updateOfferResponseFromJson(String str) => UpdateOfferResponse.fromJson(json.decode(str));

String updateOfferResponseToJson(UpdateOfferResponse data) => json.encode(data.toJson());

class UpdateOfferResponse {
  List<dynamic>? data;
  bool? success;
  int? statusCode;
  String? message;

  UpdateOfferResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory UpdateOfferResponse.fromJson(Map<String, dynamic> json) => UpdateOfferResponse(
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}
