class ChatMessagesOffline {
  List<ChatMessage>? chatMessages;

  ChatMessagesOffline({
    this.chatMessages,
  });

  factory ChatMessagesOffline.fromOfflineJson(Map<String, dynamic> json) =>
      ChatMessagesOffline(
          chatMessages: json['data'] == null
              ? []
              : List<ChatMessage>.from(
              json["data"].map((x) => ChatMessage.fromOfflineJson(x))));

  Map<String, dynamic> toOfflineJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (chatMessages != null) {
      data['data'] = chatMessages!.map((v) => v.toOfflineJson()).toList();
    }
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
  dynamic msgType;
  String? message;
  String? multiImage;
  String? msgTime;
  String? createdAt;
  String? updatedAt;
  int? msgSendBy;
  int? isSuspicious;
  int? isEmailSent;
  String? kundliId;
  int? seenStatus;
  String? base64Image;
  dynamic deletedAt;
  int? chatMsgId;

  int? astrologerId;
  int? callInitiate;
  dynamic exotelInitiateResponse;
  dynamic callStartedAt;
  dynamic callEndedAt;
  dynamic callDuration;
  dynamic exotelEndResponse;
  dynamic exotelCallSid;
  String? callStatus;
  dynamic callRejectReason;
  int? callEnd;
  String? callRecording;
  dynamic customerCallStatus;
  dynamic memberCallStatus;
  dynamic apiCallFrom;
  int? receiverId;
  int? senderId;
  String? awsUrl;
  String? downloadedPath;
  String? kundliName;
  String? kundliDateTime;
  String? kundliPlace;
  String? gender;
  String? title;
  int? time;
  int? type;
  String? userType;

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

    this.astrologerId,
    this.callInitiate,
    this.exotelInitiateResponse,
    this.callStartedAt,
    this.callEndedAt,
    this.callDuration,

    this.exotelEndResponse,
    this.exotelCallSid,
    this.callStatus,
    this.callRejectReason,
    this.callEnd,
    this.callRecording,

    this.customerCallStatus,
    this.memberCallStatus,
    this.apiCallFrom,
    this.receiverId,
    this.senderId,
    this.time,
    this.awsUrl,
    this.downloadedPath,
    this.kundliName,
    this.kundliDateTime,
    this.kundliPlace,
    this.gender,
    this.title,
    this.type,
    this.userType,
  });

  ChatMessage.fromOfflineJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    memberId = json['member_id'];
    roleId = json['role_id'];
    customerId = json['customer_id'];
    msgSequence = json['msg_sequence'];
    msgType = json['msgType'];
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

    astrologerId = json['astrologer_id'];
    callInitiate = json['call_initiate'];
    exotelInitiateResponse = json['exotel_initiate_response'];
    callStartedAt = json['call_started_at'];
    callEndedAt = json['call_ended_at'];
    callDuration = json['call_duration'];
    exotelEndResponse = json['exotel_end_response'];
    exotelCallSid = json['exotel_call_sid'];
    callStatus = json['call_status'];
    callRejectReason = json['call_reject_reason'];
    callEnd = json['call_end'];
    callRecording = json['call_recording'];

    roleId = json['role_id'];
    customerCallStatus = json['customer_call_status'];
    memberCallStatus = json['member_call_status'];
    apiCallFrom = json['api_call_from'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    orderId = json['orderId'];
    time = json['time'];
    type = json['type'];
    awsUrl = json['awsUrl'];
    downloadedPath = json['kundliId'];
    kundliName = json['kundliName'];
    kundliDateTime = json['kundliDateTime'];
    kundliPlace = json['kundliPlace'];
    kundliId = json['kundliId'];
    gender = json['gender'];
    title = json['title'];
    userType = json['userType'];
  }

  Map<String, dynamic> toOfflineJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['member_id'] = memberId;
    data['role_id'] = roleId;
    data['customer_id'] = customerId;
    data['msg_sequence'] = msgSequence;
    data['msgType'] = msgType;
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


    data['astrologer_id'] = astrologerId;
    data['call_initiate'] = callInitiate;
    data['exotel_initiate_response'] = exotelInitiateResponse;
    data['call_started_at'] = callStartedAt;
    data['call_ended_at'] = callEndedAt;
    data['call_duration'] = callDuration;

    data['exotel_end_response'] = exotelEndResponse;
    data['exotel_call_sid'] = exotelCallSid;
    data['call_status'] = callStatus;
    data['call_reject_reason'] = callRejectReason;
    data['call_end'] = callEnd;
    data['call_recording'] = callRecording;
    data['order_id'] = orderId;

    data['customer_call_status'] = customerCallStatus;
    data['member_call_status'] = memberCallStatus;
    data['api_call_from'] = apiCallFrom;
    data['receiverId'] = receiverId;
    data['senderId'] = senderId;
    data['orderId'] = orderId;
    data['time'] = time;
    data['type'] = type;
    data['awsUrl'] = awsUrl;
    data['downloadedPath'] = downloadedPath;
    data['kundliId'] = kundliId;
    data['kundliName'] = kundliName;
    data['kundliDateTime'] = kundliDateTime;
    data['kundliPlace'] = kundliPlace;
    data['gender'] = gender;
    data['title'] = title;
    data['userType'] = userType;
    return data;
  }
}

/*class ChatMessage {
  int? id;
  int? receiverId;
  int? senderId;
  int? orderId;
  String? message;
  String? msgType;
  String? awsUrl;
  String? base64Image;
  String? downloadedPath;
  String? kundliId;
  String? kundliName;
  String? kundliDateTime;
  String? kundliPlace;
  String? gender;
  String? title;
  int? time;
  int? type;
  String? userType;

  ChatMessage(
      {this.id,
        this.receiverId,
        this.senderId,
        this.orderId,
        this.message,
        this.time,
        this.msgType,
        this.awsUrl,
        this.base64Image,
        this.downloadedPath,
        this.kundliId,
        this.kundliName,
        this.kundliDateTime,
        this.kundliPlace,
        this.gender,
        this.title,
        this.type,
        this.userType,
      });

  ChatMessage.fromOfflineJson(Map<String, dynamic> json) {
    id = json['chatMessageId'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    orderId = json['orderId'];
    message = json['message'];
    time = json['time'];
    type = json['type'];
    msgType = json['msgType'];
    awsUrl = json['awsUrl'];
    base64Image = json['base64Image'];
    downloadedPath = json['kundliId'];
    kundliName = json['kundliName'];
    kundliDateTime = json['kundliDateTime'];
    kundliPlace = json['kundliPlace'];
    kundliId = json['kundliId'];
    gender = json['gender'];
    title = json['title'];
    userType = json['userType'];
  }

  Map<String, dynamic> toOfflineJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatMessageId'] = id;
    data['receiverId'] = receiverId;
    data['senderId'] = senderId;
    data['orderId'] = orderId;
    data['message'] = message;
    data['time'] = time;
    data['type'] = type;
    data['msgType'] = msgType;
    data['awsUrl'] = awsUrl;
    data['base64Image'] = base64Image;
    data['downloadedPath'] = downloadedPath;
    data['kundliId'] = kundliId;
    data['kundliName'] = kundliName;
    data['kundliDateTime'] = kundliDateTime;
    data['kundliPlace'] = kundliPlace;
    data['gender'] = gender;
    data['title'] = title;
    data['userType'] = userType;
    return data;
  }
}*/
