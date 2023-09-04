import 'dart:convert';

AstrologerChatList astrologerChatListFromJson(String str) =>
    AstrologerChatList.fromJson(json.decode(str));

String astrologerChatListToJson(AstrologerChatList data) =>
    json.encode(data.toJson());

class AstrologerChatList {
  AstrologerChatData? data;
  bool? success;
  int? statusCode;
  String? message;

  AstrologerChatList({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory AstrologerChatList.fromJson(Map<String, dynamic> json) =>
      AstrologerChatList(
        data: AstrologerChatData.fromJson(json["data"]),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class AstrologerChatData {
  int? currentPage;
  List<AstrologerChatDatum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link> links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  AstrologerChatData({
    this.currentPage,
    this.data = const [],
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links = const [],
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory AstrologerChatData.fromJson(Map<String, dynamic> json) =>
      AstrologerChatData(
        currentPage: json["current_page"],
        data: List<AstrologerChatDatum>.from(
          json["data"].map((x) => AstrologerChatDatum.fromJson(x)),
        ),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(
          json["links"].map((x) => Link.fromJson(x)),
        ),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class AstrologerChatDatum {
  int? id;
  int? orderId;
  int? memberId;
  int? customerId;
  int? msgType;
  String? message;
  String? multiimage;
  String? createdAt;
  String? updatedAt;

  AstrologerChatDatum({
    this.id,
    this.orderId,
    this.memberId,
    this.customerId,
    this.msgType,
    this.message,
    this.multiimage,
    this.createdAt,
    this.updatedAt,
  });

  factory AstrologerChatDatum.fromJson(Map<String, dynamic> json) =>
      AstrologerChatDatum(
        id: json["id"],
        orderId: json["order_id"],
        memberId: json["member_id"],
        customerId: json["customer_id"],
        msgType: json["msg_type"],
        message: json["message"],
        multiimage: json["multiimage"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "member_id": memberId,
        "customer_id": customerId,
        "msg_type": msgType,
        "message": message,
        "multiimage": multiimage,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
