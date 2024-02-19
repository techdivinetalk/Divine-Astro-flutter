// To parse this JSON data, do
//
//     final callOrderHistoryModelClass = callOrderHistoryModelClassFromJson(jsonString);

import 'dart:convert';

CallOrderHistoryModelClass callOrderHistoryModelClassFromJson(String str) => CallOrderHistoryModelClass.fromJson(json.decode(str));

String callOrderHistoryModelClassToJson(CallOrderHistoryModelClass data) => json.encode(data.toJson());

class CallOrderHistoryModelClass {
  List<CallHistoryData>? data;
  bool? success;
  int? statusCode;
  String? message;

  CallOrderHistoryModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory CallOrderHistoryModelClass.fromJson(Map<String, dynamic> json) => CallOrderHistoryModelClass(
    data: json["data"] == null ? [] : List<CallHistoryData>.from(json["data"]!.map((x) => CallHistoryData.fromJson(x))),
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}

class CallHistoryData {
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
  GetCustomers? getCustomers;
  int? quantity; // New field
  int? feedbackReviewStatus; // New field

  CallHistoryData({
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
  });

  factory CallHistoryData.fromJson(Map<String, dynamic> json) => CallHistoryData(
    id: json["id"] as int?,
    amount: json["amount"] as int?,
    orderId: json["order_id"] as String?,
    status: json["status"] as String?,
    transactionId: json["transaction_id"] as int?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    productType: json["product_type"] as int?,
    userId: json["user_id"] as int?,
    roleId: json["role_id"] as int?,
    astrologerId: json["astrologer_id"] as int?,
    productId: json["product_id"] as int?,
    duration: json["duration"] as String?,
    getCustomers: json["get_customers"] == null
        ? null
        : GetCustomers.fromJson(json["get_customers"]),
    quantity: json["quantity"] as int?,
    feedbackReviewStatus: json["feedback_review_status"] as int?,
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
  };
}

class GetCustomers {
  int? id;
  String? name, avatar;
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
