// To parse this JSON data, do
//
//     final giftOrderHistoryModelClass = giftOrderHistoryModelClassFromJson(jsonString);

import 'dart:convert';

GiftOrderHistoryModelClass giftOrderHistoryModelClassFromJson(String str) =>
    GiftOrderHistoryModelClass.fromJson(json.decode(str));

String giftOrderHistoryModelClassToJson(GiftOrderHistoryModelClass data) =>
    json.encode(data.toJson());

class GiftOrderHistoryModelClass {
  List<GiftDataList>? data;
  bool? success;
  int? statusCode;
  String? message;

  GiftOrderHistoryModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory GiftOrderHistoryModelClass.fromJson(Map<String, dynamic> json) =>
      GiftOrderHistoryModelClass(
        data: json["data"] == null
            ? []
            : List<GiftDataList>.from(
            json["data"]!.map((x) => GiftDataList.fromJson(x))),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() =>
      {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class GiftDataList {
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
  dynamic duration;
  int? quantity;
  GetCustomers? getCustomers;
  GetGift? getGift;

  GiftDataList({
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
    this.getCustomers,
    this.getGift,
  });

  factory GiftDataList.fromJson(Map<String, dynamic> json) =>
      GiftDataList(
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
        quantity: json['quantity'],
        getCustomers: json["get_customers"] == null
            ? null
            : GetCustomers.fromJson(json["get_customers"]),
        getGift: json["get_gift"] == null
            ? null
            : GetGift.fromJson(json["get_gift"]),
      );

  Map<String, dynamic> toJson() =>
      {
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
        "get_customers": getCustomers?.toJson(),
        "get_gift": getGift?.toJson(),
      };
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

  factory GetCustomers.fromJson(Map<String, dynamic> json) =>
      GetCustomers(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        customerNo: json["customer_no"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "avatar": avatar,
        "customer_no": customerNo,
      };
}

class GetGift {
  String? giftName;
  String? giftImage;
  int? id;
  int? giftPrice;

  GetGift({
    this.giftName,
    this.giftImage,
    this.id,
    this.giftPrice
  });

  factory GetGift.fromJson(Map<String, dynamic> json) =>
      GetGift(
          giftName: json["gift_name"],
          giftImage: json["gift_image"],
          id: json["id"],
          giftPrice: json['gift_price'],
      );

  Map<String, dynamic> toJson() => {
  "gift_name": giftName,
  "gift_image": giftImage,
  "id": id,
  "gift_price" : giftPrice,
};}
