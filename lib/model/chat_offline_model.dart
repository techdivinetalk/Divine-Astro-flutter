import 'chat_assistant/chat_assistant_chats_response.dart';

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
  int? msgId;
  int? memberId;
  int? roleId;
  int? customerId;
  int? msgSequence;
  MsgType? msgType;
  String? message;
  String? multiImage;
  String? msgTime;

  //String? createdAt;
  String? updatedAt;
  String? msgSendBy;
  int? isSuspicious;
  int? isEmailSent;
  dynamic kundliId;
  int? seenStatus;
  String? base64Image;
  String? animation;
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
  bool? isPoojaProduct;
  int? callEnd;
  String? callRecording;
  dynamic customerCallStatus;
  dynamic memberCallStatus;
  dynamic apiCallFrom;
  int? receiverId;
  int? senderId;
  String? awsUrl;
  String? productId;
  String? shopId;
  String? downloadedPath;
  String? latitude;
  String? longitude;
  String? kundliName;
  String? kundliDateTime;
  String? kundliPlace;
  String? gender;
  String? title;
  dynamic time;
  int? type;
  String? userType;
  String? productPrice;
  int? suggestedId;
  Kundli? kundli;
  GetProduct? getProduct;
  GetPooja? getPooja;
  CustomProduct? getCustomProduct;

  ChatMessage({
    this.id,
    this.orderId,
    this.msgId,
    this.memberId,
    this.suggestedId,
    this.animation,
    this.roleId,
    this.productId,
    this.title,
    this.shopId,
    this.latitude,
    this.longitude,
    this.customerId,
    this.msgSequence,
    this.isPoojaProduct,
    this.msgType,
    this.message,
    this.multiImage,
    this.msgTime,
    //this.createdAt,
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
    this.getProduct,
    this.type,
    this.userType,
    this.getPooja,
    this.productPrice,
    this.kundli,
    this.getCustomProduct,
  });

  ChatMessage.fromOfflineJson(Map<String, dynamic> json) {
    id = json['chatMessageId'];
    orderId = json['order_id'];
    msgId = json['msgId'];
    memberId = json['member_id'];
    roleId = json['role_id'];
    customerId = json['customer_id'];
    title = json['title'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    animation = json['animation'];
    msgSequence = json['msg_sequence'];
    msgType = json['msg_type'] != null
        ? msgTypeValues.map[json["msg_type"].toString()]
        : MsgType.text;
    message = json['message'];
    productId = json['product_id'].toString();
    shopId = json['shop_id'].toString();
    isPoojaProduct = json['is_pooja_product'].toString() == "1" ? true : false;
    multiImage = json['multiimage'];
    msgTime = json['msg_time'];
    // createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']).millisecondsSinceEpoch.toString() : "";
    updatedAt = json['updated_at'];
    msgSendBy = json['msg_send_by'];
    isSuspicious = json['is_suspicious'];
    productPrice = json['productPrice'];
    isEmailSent = json['is_email_sent'];
    kundliId = json['kundli_id'];
    seenStatus = json['seen_status'];
    base64Image = json['base64image'];
    deletedAt = json['deleted_at'];


    chatMsgId = json['chat_msg_id'];
    suggestedId = json['suggested_remedies_id'];

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
    productPrice = json['productPrice'];
    getProduct = (json['get_product'] as Map<String, dynamic>?) != null
        ? GetProduct.fromJson(json['get_product'] as Map<String, dynamic>)
        : null;
    getCustomProduct = (json['get_custom_product'] as Map<String, dynamic>?) != null
        ? CustomProduct.fromJson(json['get_custom_product'] as Map<String, dynamic>)
        : null;
    getPooja = (json['get_pooja'] as Map<String, dynamic>?) != null
        ? GetPooja.fromJson(json['get_pooja'] as Map<String, dynamic>)
        : null;
    userType = json['userType'];
    kundli = json['kundli'] != null ? Kundli.fromJson(json['kundli']) : null;
  }

  Map<String, dynamic> toOfflineJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatMessageId'] = id;
    data['order_id'] = orderId;
    data['get_pooja'] = getPooja;
    data['animation'] = animation;
    data['get_custom_product'] = getCustomProduct;
    data['member_id'] = memberId;
    data['productPrice'] = productPrice;
    data['role_id'] = roleId;
    data['latitude'] = latitude;
    data['msgId'] = msgId;
    data['longitude'] = longitude;
    data['get_product'] = getProduct;
    data['title'] = title;
    data['customer_id'] = customerId;
    data['msg_sequence'] = msgSequence;
    data['msg_type'] = msgTypeValues.reverse[msgType];
    data['message'] = message;
    data['multiimage'] = multiImage;
    data['suggested_remedies_id'] = suggestedId;
    data['msg_time'] = msgTime;
    //  data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['msg_send_by'] = msgSendBy;
    data['shop_id'] = shopId;
    data['product_id'] = productId;
    data['is_suspicious'] = isSuspicious;
    data['is_email_sent'] = isEmailSent;
    data['kundli_id'] = kundliId;
    data['seen_status'] = seenStatus;
    data['base64image'] = base64Image;
    data['deleted_at'] = deletedAt;
    data['chat_msg_id'] = chatMsgId;
    data['is_pooja_product'] = isPoojaProduct == true ? "1" : "0";

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
    data['userType'] = userType;
    data['kundli'] = kundli;
    return data;
  }
}

class GetProduct {
  final int? id;
  final String? prodName;
  final String? prodImage;
  final String? prodDesc;
  final int? productPriceInr;
  final String? productLongDesc;
  final int? gst;

  GetProduct({
    this.id,
    this.prodName,
    this.prodImage,
    this.prodDesc,
    this.productPriceInr,
    this.productLongDesc,
    this.gst,
  });

  GetProduct.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        prodName = json['prod_name'] as String?,
        prodImage = json['prod_image'] as String?,
        prodDesc = json['prod_desc'] as String?,
        productPriceInr = json['product_price_inr'] as int?,
        productLongDesc = json['product_long_desc'] as String?,
        gst = json['gst'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'prod_name': prodName,
        'prod_image': prodImage,
        'prod_desc': prodDesc,
        'product_price_inr': productPriceInr,
        'product_long_desc': productLongDesc,
        'gst': gst
      };
}

class GetPooja {
  final int? id;
  final String? poojaName;
  final String? poojaImage;
  final String? poojaDesc;
  final int? poojaPriceInr;
  final int?  gst;

  GetPooja({
    this.id,
    this.poojaName,
    this.poojaImage,
    this.poojaDesc,
    this.poojaPriceInr,
    this.gst,
  });

  GetPooja.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        poojaName = json['pooja_name'] as String?,
        poojaImage = json['pooja_img'] as String?,
        poojaDesc = json['pooja_desc'] as String?,
        poojaPriceInr = json['pooja_starting_price_inr'] as int?,
        gst = json['gst'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'pooja_name': poojaName,
        'pooja_img': poojaImage,
        'pooja_desc': poojaDesc,
        'pooja_starting_price_inr': poojaPriceInr,
        'gst': gst
      };
}

class CustomProduct {
  final int? id;
  final String? name;
  final String? image;
  final String? desc;
  final int? amount;
  final int? astrologerId;

  CustomProduct({
    this.id,
    this.name,
    this.image,
    this.desc,
    this.amount,
    this.astrologerId,
  });

  CustomProduct.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        image = json['image'] as String?,
        desc = json['desc'] as String?,
        amount = json['amount'] as int?,
        astrologerId = json['astrologer_id'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'desc': desc,
        'amount': amount,
        'astrologer_id': astrologerId,
      };
}

class Kundli {
  int id;
  int kundliId;
  String kundliName;
  String kundliPlace;
  String kundliDateTime;
  String longitude;
  String latitude;
  String gender;

  Kundli({
    required this.id,
    required this.kundliId,
    required this.kundliName,
    required this.kundliPlace,
    required this.longitude,
    required this.latitude,
    required this.kundliDateTime,
    required this.gender,
  });

  factory Kundli.fromJson(Map<String, dynamic> json) {
    return Kundli(
      id: json['id'],
      kundliId: json['kundliId'],
      kundliName: json['kundliName'],
      kundliPlace: json['kundliPlace'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      gender: json['gender'],
      kundliDateTime: json['kundliDateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kundliId': kundliId,
      'kundliName': kundliName,
      'kundliPlace': kundliPlace,
      'longitude': longitude,
      'latitude': latitude,
      'gender': gender,
      'kundliDateTime': kundliDateTime,
    };
  }
}

enum MsgType {
  text,
  gift,
  image,
  product,
  pooja,
  remedies,
  audio,
  kundli,
  sendgifts,
  limit,
  customProduct,
  voucher,
  error
}

final msgTypeValues = EnumValues({
  "0": MsgType.text,
  "1": MsgType.image,
  "2": MsgType.remedies,
  "3": MsgType.product,
  "4": MsgType.pooja,
  "5": MsgType.kundli,
  "6": MsgType.audio,
  "7": MsgType.sendgifts,
  "8": MsgType.gift,
  "10": MsgType.error,
  "11": MsgType.customProduct,
  "12": MsgType.limit,
  "13": MsgType.voucher,
});

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
