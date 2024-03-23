import 'package:divine_astrologer/model/chat_offline_model.dart';

class ChatAssistChatResponse {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  ChatAssistChatResponse(
      {this.data, this.success, this.statusCode, this.message});

  ChatAssistChatResponse.fromJson(Map<String, dynamic> json) {
    /// here Null List Data in Object so i added
    data = json['data'] != null
        ? (json['data'] is Map ? Data.fromJson(json['data']) : null)
        : null;
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
  String? profileImage;
  String? productId;
  String? productPrice;
  String? productImage;
  bool? isPoojaProduct;
  int? suggestedRemediesId;
  // String? awsUrl;
  String? shopId;
  String? createdAt;
  Product? product;
  SeenStatus? seenStatus;
  int? isSuspicious;

  AssistChatData(
      {this.id,
      this.message,
      this.customerId,
      this.astrologerId,
      // this.msgStatus,
      this.msgType,
      this.profileImage,
      this.productPrice,
      this.isPoojaProduct,
      this.productId,
      this.sendBy,
      this.productImage,
      this.suggestedRemediesId,

      // this.awsUrl,
      this.createdAt,
      this.product,
      // this.awsUrl,
      this.shopId,
      this.isSuspicious,
      this.seenStatus});

  AssistChatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    customerId = json['customer_id'];
    astrologerId = json['astrologer_id'];
    productPrice = json['productPrice'];
    sendBy = json['send_by'] != null
        ? sendByValue.map[json["send_by"].toString()]
        : SendBy.customer;
    msgType = json['msg_type'] != null
        ? msgTypeValues.map[json["msg_type"].toString()]
        : MsgType.text;
    productId = json['product_id'].toString();
    productImage = json['product_image'];
    isPoojaProduct = json['is_pooja_product'].toString() == "1" ? true : false;
    suggestedRemediesId = json['suggested_remedies_id'] == null ||
            json['suggested_remedies_id'].toString() == "null"
        ? 0
        : int.parse(json['suggested_remedies_id'].toString());
    // msgStatus = json['msg_status'] != null
    //     ? msgStatusValues.map[json["msg_status"]]
    //     : MsgStatus.sent;
    // awsUrl = json['awsUrl'];
    shopId = json['shop_id'].toString();
    profileImage = json['profile_image'];
    product =
        json["product"] == null ? null : Product.fromJson(json["product"]);
    createdAt =
        DateTime.parse(json['created_at']).millisecondsSinceEpoch.toString();
    isSuspicious = json['is_suspicious'];

    seenStatus = json['seen_status'] != null
        ? seenStatusValues.map[json["seen_status"].toString()]
        : SeenStatus.sent;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['customer_id'] = customerId;
    data['astrologer_id'] = astrologerId;
    data['send_by'] = sendByValue.reverse[sendBy];
    data['msg_type'] = msgTypeValues.reverse[msgType];
    // data['msg_status'] = msgStatusValues.reverse[msgStatus];
    data['created_at'] = createdAt;
    data['profile_image'] = profileImage;
    data['productPrice'] = productPrice;
    data['product_image'] = productImage;
    data['product_id'] = productId;
    data['is_pooja_product'] = isPoojaProduct == false ? "0" : "1";
    data['suggested_remedies_id'] =
        suggestedRemediesId == null || suggestedRemediesId == 0
            ? "0"
            : suggestedRemediesId.toString();
    // data['awsUrl'] = awsUrl;
    data["product"] = product?.toJson();
    data['shop_id'] = shopId;
    data['is_suspicious'] = isSuspicious;
    data['seen_status'] = seenStatusValues.reverse[seenStatus];
    return data;
  }
}

class Product {
  int? id;
  int? shopId;
  int? prodCatId;
  String? prodName;
  String? prodImage;
  dynamic prodDesc;

  Product({
    this.id,
    this.shopId,
    this.prodCatId,
    this.prodName,
    this.prodImage,
    this.prodDesc,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        shopId: json["shop_id"],
        prodCatId: json["prod_cat_id"],
        prodName: json["prod_name"],
        prodImage: json["prod_image"],
        prodDesc: json["prod_desc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_id": shopId,
        "prod_cat_id": prodCatId,
        "prod_name": prodName,
        "prod_image": prodImage,
        "prod_desc": prodDesc,
      };
}

enum SendBy { customer, astrologer }

final sendByValue = EnumValues({
  "0": SendBy.customer,
  "1": SendBy.astrologer,
});

// enum MsgType {
//   text,
//   gift,
//   image,
//   remedies,
//   audio,
//   product,
//   pooja,
//   voucher,
//   customProduct,
//   limit
// }
//
// final msgTypeValues = EnumValues({   /// "0": MsgType.text,
//   "0": MsgType.text,   /// "1": MsgType.image,
//   "1": MsgType.image,   /// "2": MsgType.remedies,
//   "2": MsgType.remedies,   /// "3": MsgType.product,
//   "3": MsgType.product,   /// "4": MsgType.pooja,
//   "4": MsgType.pooja,   /// "5": MsgType.kundli,
//   "5": MsgType.voucher,   /// "6": MsgType.audio,
//   "6": MsgType.audio,   /// "7": MsgType.sendgifts,
//   "7": MsgType.gift,   /// "8": MsgType.gift,
//   "10": MsgType.limit,   /// "10": MsgType.error,
//   "11": MsgType.customProduct,   /// "11": MsgType.customProduct,
// });

enum SeenStatus { notSent, sent, delivered, received, error }

final seenStatusValues = EnumValues({
  '-2': SeenStatus.error,
  '-1': SeenStatus.notSent,
  '0': SeenStatus.sent,
  '1': SeenStatus.delivered,
  '2': SeenStatus.received,
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
