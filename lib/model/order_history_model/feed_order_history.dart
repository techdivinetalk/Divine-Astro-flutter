import 'all_order_history.dart';

class FeedBackOrder {
  List<FeedBackData>? data;
  bool? success;
  int? statusCode;
  String? message;

  FeedBackOrder({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory FeedBackOrder.fromJson(Map<String, dynamic> json) => FeedBackOrder(
        data: json["data"] == null
            ? []
            : List<FeedBackData>.from(
                json["data"]!.map((x) => FeedBackData.fromJson(x))),
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

class FeedBackData {
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
  List<FeedbackFineAmount>? getFeedbackFineAmount;
  int? partnerPrice;
  String? partnerOrderId;

  FeedBackData({
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
    this.getFeedbackFineAmount,
    this.partnerPrice,
    this.partnerOrderId,
  });

  factory FeedBackData.fromJson(Map<String, dynamic> json) => FeedBackData(
        id: json["id"],
        amount: json["amount"],
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
        quantity: json["quantity"],
        feedbackReviewStatus: json["feedback_review_status"],
        getFeedbackFineAmount: json["get_feedback_fine_amount"] == null
            ? null
            : List<FeedbackFineAmount>.from(json["get_feedback_fine_amount"]
                .map((x) => FeedbackFineAmount.fromJson(x))),
        partnerPrice: json["partner_price"],
        partnerOrderId: json["partnerOrderId"],
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
        "quantity": quantity,
        "feedback_review_status": feedbackReviewStatus,
        "get_feedback_fine_amount": getFeedbackFineAmount == null
            ? null
            : List<dynamic>.from(getFeedbackFineAmount!.map((x) => x.toJson())),
        "partnerPrice": partnerPrice,
        "partnerOrderId": partnerOrderId,
      };
}

class FeedbackFineAmount {
  dynamic orderId;
  String? totalFineAmount;

  FeedbackFineAmount({
    this.orderId,
    this.totalFineAmount,
  });

  factory FeedbackFineAmount.fromJson(Map<String, dynamic> json) =>
      FeedbackFineAmount(
        orderId: json["order_id"],
        totalFineAmount: json["total_fine_amount"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "total_fine_amount": totalFineAmount,
      };
}
