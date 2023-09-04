import 'dart:convert';

UpdateBankRequest updateBankRequestFromJson(String str) =>
    UpdateBankRequest.fromJson(json.decode(str));

String updateBankRequestToJson(UpdateBankRequest data) =>
    json.encode(data.toJson());

class UpdateBankRequest {
  String bankName;
  String accountNumber;
  String ifscCode;
  String accountHolderName;
  LegalDocuments? legalDocuments;

  UpdateBankRequest({
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.accountHolderName,
    this.legalDocuments,
  });

  UpdateBankRequest copyWith({
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? accountHolderName,
    LegalDocuments? legalDocuments,
  }) =>
      UpdateBankRequest(
        bankName: bankName ?? this.bankName,
        accountNumber: accountNumber ?? this.accountNumber,
        ifscCode: ifscCode ?? this.ifscCode,
        accountHolderName: accountHolderName ?? this.accountHolderName,
        legalDocuments: legalDocuments ?? this.legalDocuments,
      );

  factory UpdateBankRequest.fromJson(Map<String, dynamic> json) =>
      UpdateBankRequest(
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        ifscCode: json["ifsc_code"],
        accountHolderName: json["account_holder_name"],
        legalDocuments: LegalDocuments.fromJson(json["legal_documents"]),
      );

  Map<String, dynamic> toJson() => {
        "bank_name": bankName,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "account_holder_name": accountHolderName,
        "legal_documents": legalDocuments?.toJson(),
      };
}

class LegalDocuments {
  String the0;
  String the1;

  LegalDocuments({
    required this.the0,
    required this.the1,
  });

  LegalDocuments copyWith({
    String? the0,
    String? the1,
  }) =>
      LegalDocuments(
        the0: the0 ?? this.the0,
        the1: the1 ?? this.the1,
      );

  factory LegalDocuments.fromJson(Map<String, dynamic> json) => LegalDocuments(
        the0: json["0"],
        the1: json["1"],
      );

  Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
      };
}
