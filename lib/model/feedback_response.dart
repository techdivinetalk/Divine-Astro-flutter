import 'dart:convert';

class FeedbackResponse {
  List<FeedbackData>? data;
  bool? success;
  int? statusCode;
  String? message;

  FeedbackResponse({this.data, this.success, this.statusCode, this.message});

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FeedbackData.fromJson(e as Map<String, dynamic>))
          .toList(),
      success: json['success'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'success': success,
      'status_code': statusCode,
      'message': message,
    };
  }
}

class FeedbackData {
  int? id;
  int? orderId;
  OrderDetails? order;
  String? remark;
  DateTime? createdAt;

  FeedbackData({this.id, this.orderId, this.order, this.remark, this.createdAt});

  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    return FeedbackData(
      id: json['id'] as int?,
      orderId: json['order_id'] as int?,
      order: json['orders'] != null
          ? OrderDetails.fromJson(json['orders'] as Map<String, dynamic>)
          : null,
      remark: json['remark'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'orders': order?.toJson(),
      'remark': remark,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class OrderDetails {
  int? astrologerId;
  int? id;
  int? productType;
  String? orderId;
  DateTime? createdAt;

  OrderDetails({
    this.astrologerId,
    this.id,
    this.productType,
    this.orderId,
    this.createdAt,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      astrologerId: json['astrologer_id'] as int?,
      id: json['id'] as int?,
      productType: json['product_type'] as int?,
      orderId: json['order_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'astrologer_id': astrologerId,
      'id': id,
      'product_type': productType,
      'order_id': orderId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
