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
            json["data"].map((x) => AllHistoryData.fromJson(x))),
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
  int? quantity;
  int? feedbackReviewStatus;
  GetCustomers? getCustomers;
  Gift? getGift;
  int? partnerPrice;
  String? partnerOrderId;

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
    this.partnerPrice,
    this.partnerOrderId,
  });

  factory AllHistoryData.fromJson(Map<String, dynamic> json) => AllHistoryData(
    id: json["id"] as int?,
    amount: json["amount"],
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
    getGift: json["get_gift"] == null
        ? null
        : Gift.fromJson(json["get_gift"] as Map<String, dynamic>),
    partnerPrice: json["partner_price"] as int?,
    partnerOrderId: json["partner_order_id"] as String?,
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
    "quantity": quantity,
    "feedback_review_status": feedbackReviewStatus,
    "get_customers": getCustomers?.toJson(),
    "get_gift": getGift?.toJson(),
    "partner_price": partnerPrice,
    "partner_order_id": partnerOrderId,
  }..removeWhere((key, value) => value == null);
}

class GetCustomers {
  int? id;
  String? name;
  String? avatar;
  int? customerNo;
  DateTime? dateOfBirth;
  String? placeOfBirth;
  int? gender;

  GetCustomers({
    this.id,
    this.name,
    this.avatar,
    this.customerNo,
    this.dateOfBirth,
    this.placeOfBirth,
    this.gender,
  });

  factory GetCustomers.fromJson(Map<String, dynamic> json) {
    return GetCustomers(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
      customerNo: json["customer_no"],
      dateOfBirth: json["date_of_birth"] != null ? DateTime.parse(json["date_of_birth"]) : null,
      placeOfBirth: json["place_of_birth"],
      gender: json["gender"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "customer_no": customerNo,
    "date_of_birth": dateOfBirth?.toIso8601String(),
    "place_of_birth": placeOfBirth,
    "gender": gender,
  };
}

class Gift {
  final int id;
  final String giftName;
  final String giftImage;
  final int giftPrice;

  Gift({
    required this.id,
    required this.giftName,
    required this.giftImage,
    required this.giftPrice,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'] ?? 0,
      giftName: json['gift_name'] ?? '',
      giftImage: json['gift_image'] ?? '',
      giftPrice: json['gift_price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "gift_name": giftName,
      "gift_image": giftImage,
      "gift_price": giftPrice,
    };
  }
}
