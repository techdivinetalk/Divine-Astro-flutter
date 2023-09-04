import 'dart:convert';

PrivacyPolicyModel privacyPolicyModelFromJson(String str) =>
    PrivacyPolicyModel.fromJson(json.decode(str));

String privacyPolicyModelToJson(PrivacyPolicyModel data) =>
    json.encode(data.toJson());

class PrivacyPolicyModel {
  Data data;
  bool success;
  int statusCode;
  String message;

  PrivacyPolicyModel({
    required this.data,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) =>
      PrivacyPolicyModel(
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
  String privacyPolicy;
  String createdAt;

  Data({
    required this.id,
    required this.privacyPolicy,
    required this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        privacyPolicy: json["privacy_policy"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "privacy_policy": privacyPolicy,
        "created_at": createdAt,
      };
}
