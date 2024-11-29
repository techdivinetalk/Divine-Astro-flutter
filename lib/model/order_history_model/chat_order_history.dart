// To parse this JSON data, do
//
//     final chatOrderHistoryModelClass = chatOrderHistoryModelClassFromJson(jsonString);

import 'dart:convert';

import 'all_order_history.dart';

ChatOrderHistoryModelClass chatOrderHistoryModelClassFromJson(String str) =>
    ChatOrderHistoryModelClass.fromJson(json.decode(str));

String chatOrderHistoryModelClassToJson(ChatOrderHistoryModelClass data) =>
    json.encode(data.toJson());

class ChatOrderHistoryModelClass {
  List<ChatDataList>? data;
  bool? success;
  int? statusCode;
  String? message;

  ChatOrderHistoryModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory ChatOrderHistoryModelClass.fromJson(Map<String, dynamic> json) =>
      ChatOrderHistoryModelClass(
        data: json["data"] == null
            ? []
            : List<ChatDataList>.from(
                json["data"]!.map((x) => ChatDataList.fromJson(x))),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class ChatDataList {
  int? id;
  dynamic amount;
  String? orderId;
  String? status;
  int? transactionId;
  DateTime? createdAt;
  int? productType;
  int? userId;
  int? roleId;
  int? astrologerId;
  int? productId;
  String? duration;
  GetCustomers? getCustomers;
  int? quantity;
  int? feedbackReviewStatus;

  int? partnerPrice;
  String? partnerOrderId;

  ChatDataList({
    this.id,
    this.amount,
    this.orderId,
    this.status,
    this.transactionId,
    this.createdAt,
    this.productType,
    this.userId,
    this.roleId,
    this.astrologerId,
    this.productId,
    this.duration,
    this.getCustomers,
    this.quantity,
    this.feedbackReviewStatus,
    this.partnerPrice,
    this.partnerOrderId,
  });

  factory ChatDataList.fromJson(Map<String, dynamic> json) => ChatDataList(
    id: json["id"],
    amount: json["amount"] as dynamic,
    orderId: json["order_id"],
    status: json["status"],
    transactionId: json["transaction_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    productType: json["product_type"],
    userId: json["user_id"],
    roleId: json["role_id"],
    astrologerId: json["astrologer_id"],
    productId: json["product_id"],
    duration: json["duration"],
    getCustomers: json["get_customers"] == null
        ? null
        : GetCustomers.fromJson(json["get_customers"]),
    quantity: json["quantity"], // Assign value for the new field
    feedbackReviewStatus: json["feedback_review_status"], // Assign value for the new field
    partnerPrice: json["partner_price"],
    partnerOrderId: json["partner_order_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "order_id": orderId,
    "status": status,
    "transaction_id": transactionId,
    "created_at": createdAt?.toIso8601String(),
    "product_type": productType,
    "user_id": userId,
    "role_id": roleId,
    "astrologer_id": astrologerId,
    "product_id": productId,
    "duration": duration,
    "get_customers": getCustomers?.toJson(),
    "quantity": quantity, // Include the new field in the JSON representation
    "feedback_review_status": feedbackReviewStatus, // Include the new field in the JSON representation
    "partner_price": partnerPrice,
    "partner_order_id": partnerOrderId,
  };
}


