// To parse this JSON data, do
//
//     final chatOrderHistoryModelClass = chatOrderHistoryModelClassFromJson(jsonString);

import 'dart:convert';

ChatOrderHistoryModelClass chatOrderHistoryModelClassFromJson(String str) => ChatOrderHistoryModelClass.fromJson(json.decode(str));

String chatOrderHistoryModelClassToJson(ChatOrderHistoryModelClass data) => json.encode(data.toJson());

class ChatOrderHistoryModelClass {
  List<ChatDataList>? data;
  bool? success;
  int? statusCode;
  String? message;

  ChatOrderHistoryModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory ChatOrderHistoryModelClass.fromJson(Map<String, dynamic> json) => ChatOrderHistoryModelClass(
    data: json["data"] == null ? [] : List<ChatDataList>.from(json["data"]!.map((x) => ChatDataList.fromJson(x))),
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

class ChatDataList {
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
  String? duration;
  GetCustomers? getCustomers;

  ChatDataList({
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
  });

  factory ChatDataList.fromJson(Map<String, dynamic> json) => ChatDataList(
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
  THE_851420230622125447_PNG
}

final avatarValues = EnumValues({
  "Group_121666.png": Avatar.GROUP_121666_PNG,
  "851420230622_125447.png": Avatar.THE_851420230622125447_PNG
});

enum Name {
  DEMO,
  KAMLESH
}

final nameValues = EnumValues({
  "Demo": Name.DEMO,
  "kamlesh": Name.KAMLESH
});

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
