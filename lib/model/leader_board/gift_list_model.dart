// To parse this JSON data, do
//
//     final giftListModelClass = giftListModelClassFromJson(jsonString);

import 'dart:convert';

GiftListModelClass giftListModelClassFromJson(String str) => GiftListModelClass.fromJson(json.decode(str));

String giftListModelClassToJson(GiftListModelClass data) => json.encode(data.toJson());

class GiftListModelClass {
  List<GiftDetail>? giftDetails;

  GiftListModelClass({
    this.giftDetails,
  });

  factory GiftListModelClass.fromJson(Map<String, dynamic> json) => GiftListModelClass(
    giftDetails: json["giftDetails"] == null ? [] : List<GiftDetail>.from(json["giftDetails"]!.map((x) => GiftDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "giftDetails": giftDetails == null ? [] : List<dynamic>.from(giftDetails!.map((x) => x.toJson())),
  };
}

class GiftDetail {
  int? quantity;
  int? price;
  String? giftType;
  String? avatar;
  String? userName;
  dynamic userId;

  GiftDetail({
    this.quantity,
    this.price,
    this.giftType,
    this.avatar,
    this.userName,
    this.userId,
  });

  factory GiftDetail.fromJson(Map<String, dynamic> json) => GiftDetail(
    quantity: json["quantity"],
    price: json["price"],
    giftType: json["giftType"],
    avatar: json["avatar"],
    userName: json["userName"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "quantity": quantity,
    "price": price,
    "giftType": giftType,
    "avatar": avatar,
    "userName": userName,
    "userId": userId,
  };
}
