import 'dart:convert';

TermsConditionModel termsConditionModelFromJson(String str) =>
    TermsConditionModel.fromJson(json.decode(str));

String termsConditionModelToJson(TermsConditionModel data) =>
    json.encode(data.toJson());

class TermsConditionModel {
  Data data;
  bool success;
  int statusCode;
  String message;

  TermsConditionModel({
    required this.data,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory TermsConditionModel.fromJson(Map<String, dynamic> json) =>
      TermsConditionModel(
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
  int id;
  String termsAndCondition;
  String createdAt;

  Data({
    required this.id,
    required this.termsAndCondition,
    required this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        termsAndCondition: json["terms_and_condition"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "terms_and_condition": termsAndCondition,
        "created_at": createdAt,
      };
}
