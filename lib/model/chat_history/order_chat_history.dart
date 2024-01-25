class ChatHistoryResponse {
  List<Order>? order;
  List<ChatMessage>? data;
  bool? success;
  int? statusCode;
  String? message;

  ChatHistoryResponse({this.order, this.data, this.success, this.statusCode, this.message});

  ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['order'] != null) {
      order = List<Order>.from(json['order'].map((order) => Order.fromJson(order)));
    }
    if (json['data'] != null) {
      data = List<ChatMessage>.from(json['data'].map((message) => ChatMessage.fromJson(message)));
    }
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order!.map((order) => order.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((message) => message.toJson()).toList();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class Order {
  int? id;
  int? productType;
  String? orderId;
  String? createdAt;

  Order({this.id, this.productType, this.orderId, this.createdAt});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productType = json['product_type'];
    orderId = json['order_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_type'] = productType;
    data['order_id'] = orderId;
    data['created_at'] = createdAt;
    return data;
  }
}

class ChatMessage {
  int? id;
  int? orderId;
  int? memberId;
  int? roleId;
  int? customerId;
  int? msgSequence;
  int? msgType;
  String? message;
  String? multiImage;
  String? msgTime;
  String? createdAt;
  String? updatedAt;
  int? msgSendBy;
  int? isSuspicious;
  int? isEmailSent;
  int? kundliId;
  int? seenStatus;
  String? base64Image;
  dynamic deletedAt;
  int? chatMsgId;

  ChatMessage({
    this.id,
    this.orderId,
    this.memberId,
    this.roleId,
    this.customerId,
    this.msgSequence,
    this.msgType,
    this.message,
    this.multiImage,
    this.msgTime,
    this.createdAt,
    this.updatedAt,
    this.msgSendBy,
    this.isSuspicious,
    this.isEmailSent,
    this.kundliId,
    this.seenStatus,
    this.base64Image,
    this.deletedAt,
    this.chatMsgId,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    memberId = json['member_id'];
    roleId = json['role_id'];
    customerId = json['customer_id'];
    msgSequence = json['msg_sequence'];
    msgType = json['msg_type'];
    message = json['message'];
    multiImage = json['multiimage'];
    msgTime = json['msg_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    msgSendBy = json['msg_send_by'];
    isSuspicious = json['is_suspicious'];
    isEmailSent = json['is_email_sent'];
    kundliId = json['kundli_id'];
    seenStatus = json['seen_status'];
    base64Image = json['base64image'];
    deletedAt = json['deleted_at'];
    chatMsgId = json['chat_msg_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['member_id'] = memberId;
    data['role_id'] = roleId;
    data['customer_id'] = customerId;
    data['msg_sequence'] = msgSequence;
    data['msg_type'] = msgType;
    data['message'] = message;
    data['multiimage'] = multiImage;
    data['msg_time'] = msgTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['msg_send_by'] = msgSendBy;
    data['is_suspicious'] = isSuspicious;
    data['is_email_sent'] = isEmailSent;
    data['kundli_id'] = kundliId;
    data['seen_status'] = seenStatus;
    data['base64image'] = base64Image;
    data['deleted_at'] = deletedAt;
    data['chat_msg_id'] = chatMsgId;
    return data;
  }
}
