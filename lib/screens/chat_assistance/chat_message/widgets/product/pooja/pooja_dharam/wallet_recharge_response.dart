// To parse this JSON data, do
//
//     final walletRecharge = walletRechargeFromJson(jsonString);

import 'dart:convert';

WalletRecharge walletRechargeFromJson(String str) => WalletRecharge.fromJson(json.decode(str));

String walletRechargeToJson(WalletRecharge data) => json.encode(data.toJson());

class WalletRecharge {
  int? data;
  int? walletAmount;
  bool? success;
  int? statusCode;
  String? message;

  WalletRecharge({
    this.data,
    this.walletAmount,
    this.success,
    this.statusCode,
    this.message,
  });

  factory WalletRecharge.fromJson(Map<String, dynamic> json) => WalletRecharge(
    data: json["data"],
    walletAmount: json["wallet_amount"],
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "wallet_amount": walletAmount,
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}
