// To parse this JSON data, do
//
//     final userAdditionInLeaderboardModel = userAdditionInLeaderboardModelFromJson(jsonString);

import 'dart:convert';

UserAdditionInLeaderboardModel userAdditionInLeaderboardModelFromJson(String str) => UserAdditionInLeaderboardModel.fromJson(json.decode(str));

String userAdditionInLeaderboardModelToJson(UserAdditionInLeaderboardModel data) => json.encode(data.toJson());

class UserAdditionInLeaderboardModel {
  List<User>? users;

  UserAdditionInLeaderboardModel({
    this.users,
  });

  factory UserAdditionInLeaderboardModel.fromJson(Map<String, dynamic> json) => UserAdditionInLeaderboardModel(
    users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class User {
  int? price;
  String? avatar;
  String? userName;
  int? userId;

  User({
    this.price,
    this.avatar,
    this.userName,
    this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    price: json["price"],
    avatar: json["avatar"],
    userName: json["userName"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "price": price,
    "avatar": avatar,
    "userName": userName,
    "userId": userId,
  };
}
