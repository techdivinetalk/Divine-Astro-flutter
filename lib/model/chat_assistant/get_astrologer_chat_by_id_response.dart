class GetAstrologerChatListResponse {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  GetAstrologerChatListResponse({this.data, this.success, this.statusCode, this.message});

  GetAstrologerChatListResponse.fromJson(Map<String, dynamic> json) {
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
    success = json["success"];
    statusCode = json["status_code"];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    _data["success"] = success;
    _data["status_code"] = statusCode;
    _data["message"] = message;
    return _data;
  }
}

class Data {
  int? currentPage;
  List<ChatDataList>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json["current_page"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => ChatDataList.fromJson(e)).toList();
    firstPageUrl = json["first_page_url"];
    from = json["from"];
    lastPage = json["last_page"];
    lastPageUrl = json["last_page_url"];
    links = json["links"] == null ? null : (json["links"] as List).map((e) => Links.fromJson(e)).toList();
    nextPageUrl = json["next_page_url"];
    path = json["path"];
    perPage = json["per_page"];
    prevPageUrl = json["prev_page_url"];
    to = json["to"];
    total = json["total"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["current_page"] = currentPage;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    _data["first_page_url"] = firstPageUrl;
    _data["from"] = from;
    _data["last_page"] = lastPage;
    _data["last_page_url"] = lastPageUrl;
    if (links != null) {
      _data["links"] = links?.map((e) => e.toJson()).toList();
    }
    _data["next_page_url"] = nextPageUrl;
    _data["path"] = path;
    _data["per_page"] = perPage;
    _data["prev_page_url"] = prevPageUrl;
    _data["to"] = to;
    _data["total"] = total;
    return _data;
  }
}

class Links {
  dynamic url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json["url"];
    label = json["label"];
    active = json["active"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["url"] = url;
    _data["label"] = label;
    _data["active"] = active;
    return _data;
  }
}

class ChatDataList {
  int? id;
  String? message;
  int? customerId;
  int? astrologerId;
  int? msgType;
  String? createdAt;

  ChatDataList({this.id, this.message, this.customerId, this.astrologerId, this.msgType, this.createdAt});

  ChatDataList.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    message = json["message"];
    customerId = json["customer_id"];
    astrologerId = json["astrologer_id"];
    msgType = json["msg_type"];
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["message"] = message;
    _data["customer_id"] = customerId;
    _data["astrologer_id"] = astrologerId;
    _data["msg_type"] = msgType;
    _data["created_at"] = createdAt;
    return _data;
  }
}