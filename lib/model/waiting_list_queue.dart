// To parse this JSON data, do
//
//     final waitingListQueueModel = waitingListQueueModelFromJson(jsonString);

import 'dart:convert';

WaitingListQueueModel waitingListQueueModelFromJson(String str) => WaitingListQueueModel.fromJson(json.decode(str));

String waitingListQueueModelToJson(WaitingListQueueModel data) => json.encode(data.toJson());

class WaitingListQueueModel {
  List<WaitingPerson>? data;
  bool? success;
  int? statusCode;
  String? message;

  WaitingListQueueModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory WaitingListQueueModel.fromJson(Map<String, dynamic> json) => WaitingListQueueModel(
    data: json["data"] == null ? [] : List<WaitingPerson>.from(json["data"]!.map((x) => WaitingPerson.fromJson(x))),
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

class WaitingPerson {
  int? id;
  int? customerId;
  int? sequence;
  int? talkMinute;
  String? status;
  int? waitTime;
  GetCustomers? getCustomers;

  WaitingPerson({
    this.id,
    this.customerId,
    this.sequence,
    this.talkMinute,
    this.status,
    this.waitTime,
    this.getCustomers,
  });

  factory WaitingPerson.fromJson(Map<String, dynamic> json) => WaitingPerson(
    id: json["id"],
    customerId: json["customer_id"],
    sequence: json["sequence"],
    talkMinute: json["talk_minute"],
    status: json["status"],
    waitTime: json["wait_time"],
    getCustomers: json["get_customers"] == null ? null : GetCustomers.fromJson(json["get_customers"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "sequence": sequence,
    "talk_minute": talkMinute,
    "status": status,
    "wait_time": waitTime,
    "get_customers": getCustomers?.toJson(),
  };
}

class GetCustomers {
  int? id;
  String? name;
  String? avatar;
  int? mobileNo;

  GetCustomers({
    this.id,
    this.name,
    this.avatar,
    this.mobileNo,
  });

  factory GetCustomers.fromJson(Map<String, dynamic> json) => GetCustomers(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
    mobileNo: json["mobile_no"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "mobile_no": mobileNo,
  };
}
