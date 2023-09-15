// To parse this JSON data, do
//
//     final liveStarUserModel = liveStarUserModelFromJson(jsonString);

import 'dart:convert';

LiveStarUserModel liveStarUserModelFromJson(String str) => LiveStarUserModel.fromJson(json.decode(str));

String liveStarUserModelToJson(LiveStarUserModel data) => json.encode(data.toJson());

class LiveStarUserModel {
  List<User>? users;

  LiveStarUserModel({
    this.users,
  });

  factory LiveStarUserModel.fromJson(Map<String, dynamic> json) => LiveStarUserModel(
    users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class User {
  int? quantity;
  int? price;
  String? giftType;
  dynamic avatar;
  String? userName;
  int? userId;

  User({
    this.quantity,
    this.price,
    this.giftType,
    this.avatar,
    this.userName,
    this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
