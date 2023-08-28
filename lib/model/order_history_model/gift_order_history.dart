// To parse this JSON data, do
//
//     final giftOrderHistoryModelClass = giftOrderHistoryModelClassFromJson(jsonString);

import 'dart:convert';

GiftOrderHistoryModelClass giftOrderHistoryModelClassFromJson(String str) => GiftOrderHistoryModelClass.fromJson(json.decode(str));

String giftOrderHistoryModelClassToJson(GiftOrderHistoryModelClass data) => json.encode(data.toJson());

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

  factory GiftOrderHistoryModelClass.fromJson(Map<String, dynamic> json) => GiftOrderHistoryModelClass(
    data: json["data"] == null ? [] : List<GiftDataList>.from(json["data"]!.map((x) => GiftDataList.fromJson(x))),
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

class GiftDataList {
  int? id;
  int? amount;
  String? orderId;
  Status? status;
  int? transactionId;
  DateTime? createdAt;
  int? productType;
  int? userId;
  int? roleId;
  int? astrologerId;
  int? productId;
  dynamic duration;
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
    this.getCustomers,
    this.getGift,
  });

  factory GiftDataList.fromJson(Map<String, dynamic> json) => GiftDataList(
    id: json["id"],
    amount: json["amount"],
    orderId: json["order_id"],
    status: statusValues.map[json["status"]]!,
    transactionId: json["transaction_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    productType: json["product_type"],
    userId: json["user_id"],
    roleId: json["role_id"],
    astrologerId: json["astrologer_id"],
    productId: json["product_id"],
    duration: json["duration"],
    getCustomers: json["get_customers"] == null ? null : GetCustomers.fromJson(json["get_customers"]),
    getGift: json["get_gift"] == null ? null : GetGift.fromJson(json["get_gift"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "order_id": orderId,
    "status": statusValues.reverse[status],
    "transaction_id": transactionId,
    "created_at": createdAt?.toIso8601String(),
    "product_type": productType,
    "user_id": userId,
    "role_id": roleId,
    "astrologer_id": astrologerId,
    "product_id": productId,
    "duration": duration,
    "get_customers": getCustomers?.toJson(),
    "get_gift": getGift?.toJson(),
  };
}

class GetCustomers {
  int? id;
  Name? name;
  Avatar? avatar;
  int? customerNo;

  GetCustomers({
    this.id,
    this.name,
    this.avatar,
    this.customerNo,
  });

  factory GetCustomers.fromJson(Map<String, dynamic> json) => GetCustomers(
    id: json["id"],
    name: nameValues.map[json["name"]]!,
    avatar: avatarValues.map[json["avatar"]]!,
    customerNo: json["customer_no"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": nameValues.reverse[name],
    "avatar": avatarValues.reverse[avatar],
    "customer_no": customerNo,
  };
}

enum Avatar {
  GROUP_121666_PNG,
  THE_20230308154525054_JPG
}

final avatarValues = EnumValues({
  "Group_121666.png": Avatar.GROUP_121666_PNG,
  "2023-03-08-15-45-25-054.jpg": Avatar.THE_20230308154525054_JPG
});

enum Name {
  KARAN,
  RA_M_J_F_H_D_J_JADA_Z
}

final nameValues = EnumValues({
  "Karan": Name.KARAN,
  "Ra\ud83d\ude2fM@  jF\ud83e\udee1 h   \ud83d\ude3c d€@j jada \ud83e\udd21                Z": Name.RA_M_J_F_H_D_J_JADA_Z
});

class GetGift {
  String? giftName;
  String? giftImage;
  int? id;

  GetGift({
    this.giftName,
    this.giftImage,
    this.id,
  });

  factory GetGift.fromJson(Map<String, dynamic> json) => GetGift(
    giftName: json["gift_name"],
    giftImage: json["gift_image"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "gift_name": giftName,
    "gift_image": giftImage,
    "id": id,
  };
}

enum Status {
  COMPLETED
}

final statusValues = EnumValues({
  "completed": Status.COMPLETED
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}