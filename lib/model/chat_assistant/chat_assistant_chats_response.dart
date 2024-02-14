class ChatAssistChatResponse {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  ChatAssistChatResponse(
      {this.data, this.success, this.statusCode, this.message});

  ChatAssistChatResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class Data {
  int? currentPage;
  List<AssistChatData>? chatAssistMsgList;
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
      this.chatAssistMsgList,
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
    currentPage = json['current_page'];
    if (json['data'] != null) {
      chatAssistMsgList = <AssistChatData>[];
      json['data'].forEach((v) {
        chatAssistMsgList!.add(AssistChatData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (chatAssistMsgList != null) {
      data['data'] = chatAssistMsgList!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class AssistChatData {
  int? id;
  String? message;
  int? customerId;
  int? astrologerId;
  MsgType? msgType;
  SendBy? sendBy;
  MsgStatus? msgStatus;
  // String? awsUrl;
  // int? giftId;
  String? createdAt;
  int? seenStatus;
  int? isSuspicious;

  AssistChatData(
      {this.id,
        this.message,
        this.customerId,
        this.astrologerId,
        this.msgStatus,
        this.msgType,
        this.sendBy,
        this.createdAt,
        // this.awsUrl,
        // this.giftId,
        this.isSuspicious,
        this.seenStatus});

  AssistChatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    customerId = json['customer_id'];
    astrologerId = json['astrologer_id'];
    sendBy = json['send_by'] != null
        ? sendByValue.map[json["send_by"]]
        : SendBy.customer;
    msgType = json['msg_type'] != null
        ? msgTypeValues.map[json["msg_type"]]
        : MsgType.text;
    msgStatus = json['msg_status'] != null
        ? msgStatusValues.map[json["msg_status"]]
        : MsgStatus.sent;
    // awsUrl = json['awsUrl'];
    // giftId = json['gift_id'];
    createdAt = json['created_at'];
    isSuspicious = json['is_suspicious'];
    seenStatus = json['seen_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['customer_id'] = customerId;
    data['astrologer_id'] = astrologerId;
    data['send_by'] = sendByValue.reverse[sendBy];
    data['msg_type'] = msgTypeValues.reverse[msgType];
    data['msg_status'] = msgStatusValues.reverse[msgStatus];
    data['created_at'] = createdAt;
    // data['awsUrl'] = awsUrl;
    // data['gift_id'] = giftId;
    data['is_suspicious'] = isSuspicious;
    data['seen_status'] = seenStatus;
    return data;
  }
}

enum SendBy { customer, astrologer }

final sendByValue = EnumValues({
  '0': SendBy.customer,
  '1': SendBy.astrologer,
});

enum MsgType { text, Gift }

final msgTypeValues = EnumValues({
  "0": MsgType.text,
  "8": MsgType.Gift,
});

enum MsgStatus { sent, delivered, received }

final msgStatusValues = EnumValues({
  "sent": MsgStatus.sent,
  "delivered": MsgStatus.delivered,
  "received": MsgStatus.received,
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

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
