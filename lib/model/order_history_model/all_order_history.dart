// To parse this JSON data, do
//
//     final allOrderHistoryModelClass = allOrderHistoryModelClassFromJson(jsonString);

import 'dart:convert';

AllOrderHistoryModelClass allOrderHistoryModelClassFromJson(String str) =>
    AllOrderHistoryModelClass.fromJson(json.decode(str));

String allOrderHistoryModelClassToJson(AllOrderHistoryModelClass data) =>
    json.encode(data.toJson());

class AllOrderHistoryModelClass {
  List<AllHistoryData>? data;
  bool? success;
  int? statusCode;
  String? message;

  AllOrderHistoryModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory AllOrderHistoryModelClass.fromJson(Map<String, dynamic> json) =>
      AllOrderHistoryModelClass(
        data: json["data"] == null
            ? []
            : List<AllHistoryData>.from(
                json["data"]!.map((x) => AllHistoryData.fromJson(x))),
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

class AllHistoryData {
  int? id;
  int? amount;
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
  int? quantity; // New field
  int? feedbackReviewStatus;
  GetCustomers? getCustomers;
  dynamic getGift;

  AllHistoryData({
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
    this.quantity,
    this.feedbackReviewStatus,
    this.getCustomers,
    this.getGift,
  });

  factory AllHistoryData.fromJson(Map<String, dynamic> json) => AllHistoryData(
    id: json["id"] as int?,
    amount: json["amount"] as int?,
    orderId: json["order_id"] as String?,
    status: json["status"] as String?,
    transactionId: json["transaction_id"] as int?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"] as String),
    productType: json["product_type"] as int?,
    userId: json["user_id"] as int?,
    roleId: json["role_id"] as int?,
    astrologerId: json["astrologer_id"] as int?,
    productId: json["product_id"] as int?,
    duration: json["duration"] as String?,
    quantity: json["quantity"] as int?,
    feedbackReviewStatus: json["feedback_review_status"] as int?,
    getCustomers: json["get_customers"] == null
        ? null
        : GetCustomers.fromJson(json["get_customers"] as Map<String, dynamic>),
    getGift: json["get_gift"],
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
    "quantity": quantity, // Include new field in the JSON representation
    "feedback_review_status": feedbackReviewStatus,
    "get_customers": getCustomers?.toJson(),
    "get_gift": getGift,
  }..removeWhere((key, value) => value == null);
}

class GetCustomers {
  int? id;
  String? name;
  String? avatar;
  int? customerNo;

  GetCustomers({
    this.id,
    this.name,
    this.avatar,
    this.customerNo,
  });

  factory GetCustomers.fromJson(Map<String, dynamic> json) => GetCustomers(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        customerNo: json["customer_no"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
        "customer_no": customerNo,
      };
}
