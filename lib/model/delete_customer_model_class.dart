import 'dart:convert';


DeleteAccountModelClass customerDeleteFromJson(String str) => DeleteAccountModelClass.fromJson(json.decode(str));

String customerDeleteModelToJson(DeleteAccountModelClass data) => json.encode(data.toJson());

class DeleteAccountModelClass {
  bool success;
  int statusCode;
  String message;

  DeleteAccountModelClass({
    required this.success,
    required this.statusCode,
    required this.message,
  });

  DeleteAccountModelClass copyWith({
    bool? success,
    int? statusCode,
    String? message,
  }) =>
      DeleteAccountModelClass(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory DeleteAccountModelClass.fromRawJson(String str) => DeleteAccountModelClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteAccountModelClass.fromJson(Map<String, dynamic> json) => DeleteAccountModelClass(
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
