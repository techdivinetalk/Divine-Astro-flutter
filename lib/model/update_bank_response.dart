import 'dart:convert';

UpdateBankResponse updateBankResponseFromJson(String str) =>
    UpdateBankResponse.fromJson(json.decode(str));

String updateBankResponseToJson(UpdateBankResponse data) =>
    json.encode(data.toJson());

class UpdateBankResponse {
  BankData data;
  bool success;
  int statusCode;
  String message;

  UpdateBankResponse({
    required this.data,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  UpdateBankResponse copyWith({
    BankData? data,
    bool? success,
    int? statusCode,
    String? message,
  }) =>
      UpdateBankResponse(
        data: data ?? this.data,
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory UpdateBankResponse.fromJson(Map<String, dynamic> json) =>
      UpdateBankResponse(
        data: BankData.fromJson(json["data"]),
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

  String toPrettyString() => JsonEncoder.withIndent(" " * 4).convert(toJson());
}

class BankData {
  int? id;
  String? accountNumber;
  String? bankName;
  String? name;
  String? ifscCode;
  String? status;
  String? accountHolderName;
  String? accountType;
  String? phoneNo;
  String? legalDocuments;
  String? createdAt;
  String? updatedAt;

  BankData({
     this.id,
     this.accountNumber,
     this.bankName,
     this.name,
     this.status,
     this.ifscCode,
     this.accountHolderName,
     this.accountType,
     this.phoneNo,
     this.legalDocuments,
     this.createdAt,
     this.updatedAt,
  });

  BankData copyWith({
    int? id,
    String? accountNumber,
    String? bankName,
    String? name,
    String? ifscCode,
    String? accountHolderName,
    String? status,
    String? accountType,
    String? phoneNo,
    String? legalDocuments,
    String? createdAt,
    String? updatedAt,
  }) =>
      BankData(
        id: id ?? this.id,
        accountNumber: accountNumber ?? this.accountNumber,
        bankName: bankName ?? this.bankName,
        name: name ?? this.name,
        status: status ?? this.status,
        ifscCode: ifscCode ?? this.ifscCode,
        accountHolderName: accountHolderName ?? this.accountHolderName,
        accountType: accountType ?? this.accountType,
        phoneNo: phoneNo ?? this.phoneNo,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        legalDocuments: legalDocuments ?? this.legalDocuments,
      );

  factory BankData.fromJson(Map<String, dynamic> json) => BankData(
        id: json["id"],
        accountNumber: json["account_number"].toString(),
        bankName: json["bank_name"],
        name: json["name"] ?? "",
    status: json["status"] ?? "",
        ifscCode: json["ifsc_code"] ?? "",
        accountHolderName: json["account_holder_name"],
        accountType: json["account_type"] ?? "",
        phoneNo: json["phone_no"] ?? "",
        legalDocuments: json["legal_documents"],
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_number": accountNumber,
        "updated_at": updatedAt ,
        "created_at": createdAt ,
        "bank_name": bankName,
        "status": status,
        "name": name,
        "ifsc_code": ifscCode,
        "account_holder_name": accountHolderName,
        "account_type": accountType,
        "phone_no": phoneNo,
        "legal_documents": legalDocuments,
      };
}
