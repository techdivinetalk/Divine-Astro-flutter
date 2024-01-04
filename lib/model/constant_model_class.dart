import 'dart:convert';

ConstantDetailsModelClass constantDetailsModelClassFromJson(String str) =>
    ConstantDetailsModelClass.fromJson(json.decode(str));

String constantDetailsModelClassToJson(ConstantDetailsModelClass data) =>
    json.encode(data.toJson());

class ConstantDetailsModelClass {
  ConstantData? data;
  bool? success;
  int? statusCode;
  String? message;

  ConstantDetailsModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory ConstantDetailsModelClass.fromJson(Map<String, dynamic> json) =>
      ConstantDetailsModelClass(
        data: json["data"] == null ? null : ConstantData.fromJson(json["data"]),
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

class ConstantData {
  Map<String, dynamic>? leaderboardRankImage;
  Map<String, dynamic>? lottiFile;
  String? reviewFreeAnimation;
  int? giftTimeInterval;
  Chat? chat;
  Call? call;
  List<dynamic>? badWordsData;
  String? liveBackgroundImage;
  List<dynamic>? chatSuspiciousRegex;
  List<dynamic>? cityList;
  Map<String, dynamic>? notificationType;
  String? whatsappNo;
  AwsCredential? awsCredential;
  String? razorpayKeyId;
  List<SocialMediaLink>? socialMediaLinks;
  String? phonePayCallbackEndpoint;
  WaitingTimeInfo? waitingTimeInfo;
  dynamic waitTime;

  ConstantData({
    this.leaderboardRankImage,
    this.lottiFile,
    this.reviewFreeAnimation,
    this.giftTimeInterval,
    this.chat,
    this.call,
    this.badWordsData,
    this.liveBackgroundImage,
    this.chatSuspiciousRegex,
    this.cityList,
    this.notificationType,
    this.whatsappNo,
    this.awsCredential,
    this.razorpayKeyId,
    this.socialMediaLinks,
    this.phonePayCallbackEndpoint,
    this.waitingTimeInfo,
    this.waitTime
  });

  factory ConstantData.fromJson(Map<String, dynamic> json) => ConstantData(
        leaderboardRankImage: Map.from(json["leaderboard_rank_image"]!)
            .map((k, v) => MapEntry<String, String>(k, v)),
        lottiFile: Map.from(json["lotti_file"]!)
            .map((k, v) => MapEntry<String, String>(k, v)),
        reviewFreeAnimation: json["review_free_animation"],
        giftTimeInterval: json["gift_time_interval"],
        chat: json["chat"] == null ? null : Chat.fromJson(json["chat"]),
        call: json["call"] == null ? null : Call.fromJson(json["call"]),
        badWordsData: json["bad_words_data"] == null
            ? []
            : List<String>.from(json["bad_words_data"]!.map((x) => x)),
        liveBackgroundImage: json["live_background_image"],
        chatSuspiciousRegex: json["chat_suspicious_regex"] == null
            ? []
            : List<String>.from(json["chat_suspicious_regex"]!.map((x) => x)),
        cityList: json["city_list"] == null
            ? []
            : List<String>.from(json["city_list"]!.map((x) => x)),
        notificationType: Map.from(json["notification_type"]!)
            .map((k, v) => MapEntry<String, String>(k, v)),
        whatsappNo: json["whatsappNo"],
        awsCredential: json["aws_credential"] == null
            ? null
            : AwsCredential.fromJson(json["aws_credential"]),
        razorpayKeyId: json["razorpay_key_id"],
        waitTime: json["wait_time"],
        socialMediaLinks: json["social_media_links"] == null
            ? []
            : List<SocialMediaLink>.from(json["social_media_links"]!
                .map((x) => SocialMediaLink.fromJson(x))),
        phonePayCallbackEndpoint: json["phone_pay_callback_endpoint"],
        waitingTimeInfo: json["waiting_time_info"] == null
            ? null
            : WaitingTimeInfo.fromJson(json["waiting_time_info"]),
      );

  Map<String, dynamic> toJson() => {
        "leaderboard_rank_image": Map.from(leaderboardRankImage!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "lotti_file":
            Map.from(lottiFile!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "review_free_animation": reviewFreeAnimation,
        "gift_time_interval": giftTimeInterval,
        "chat": chat?.toJson(),
        "call": call?.toJson(),
        "bad_words_data": badWordsData == null
            ? []
            : List<dynamic>.from(badWordsData!.map((x) => x)),
        "live_background_image": liveBackgroundImage,
        "chat_suspicious_regex": chatSuspiciousRegex == null
            ? []
            : List<dynamic>.from(chatSuspiciousRegex!.map((x) => x)),
        "city_list":
            cityList == null ? [] : List<dynamic>.from(cityList!.map((x) => x)),
        "notification_type": Map.from(notificationType!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "whatsappNo": whatsappNo,
        "wait_time": waitTime,
        "aws_credential": awsCredential?.toJson(),
        "razorpay_key_id": razorpayKeyId,
        "social_media_links": socialMediaLinks == null
            ? []
            : List<dynamic>.from(socialMediaLinks!.map((x) => x.toJson())),
        "phone_pay_callback_endpoint": phonePayCallbackEndpoint,
        "waiting_time_info": waitingTimeInfo?.toJson(),
      };
}

class AwsCredential {
  String? baseurl;
  String? accesskey;
  String? secretKey;
  String? region;

  AwsCredential({
    this.baseurl,
    this.accesskey,
    this.secretKey,
    this.region,
  });

  factory AwsCredential.fromJson(Map<String, dynamic> json) => AwsCredential(
        baseurl: json["baseurl"],
        accesskey: json["Accesskey"],
        secretKey: json["secretKey"],
        region: json["Region"],
      );

  Map<String, dynamic> toJson() => {
        "baseurl": baseurl,
        "Accesskey": accesskey,
        "secretKey": secretKey,
        "Region": region,
      };
}

class Call {
  List<String>? callDo;
  List<String>? dont;
  String? callerId;

  Call({
    this.callDo,
    this.dont,
    this.callerId,
  });

  factory Call.fromJson(Map<String, dynamic> json) => Call(
        callDo: json["do"] == null
            ? []
            : List<String>.from(json["do"]!.map((x) => x)),
        dont: json["dont"] == null
            ? []
            : List<String>.from(json["dont"]!.map((x) => x)),
        callerId: json["caller_id"],
      );

  Map<String, dynamic> toJson() => {
        "do": callDo == null ? [] : List<dynamic>.from(callDo!.map((x) => x)),
        "dont": dont == null ? [] : List<dynamic>.from(dont!.map((x) => x)),
        "caller_id": callerId,
      };
}

class Chat {
  List<String>? chatDo;
  List<String>? dont;

  Chat({
    this.chatDo,
    this.dont,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatDo: json["do"] == null
            ? []
            : List<String>.from(json["do"]!.map((x) => x)),
        dont: json["dont"] == null
            ? []
            : List<String>.from(json["dont"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "do": chatDo == null ? [] : List<dynamic>.from(chatDo!.map((x) => x)),
        "dont": dont == null ? [] : List<dynamic>.from(dont!.map((x) => x)),
      };
}

class SocialMediaLink {
  String? link;
  String? param;
  String? image;

  SocialMediaLink({
    this.link,
    this.param,
    this.image,
  });

  factory SocialMediaLink.fromJson(Map<String, dynamic> json) =>
      SocialMediaLink(
        link: json["link"],
        param: json["param"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "param": param,
        "image": image,
      };
}

class WaitingTimeInfo {
  String? title;
  List<String>? list;

  WaitingTimeInfo({
    this.title,
    this.list,
  });

  factory WaitingTimeInfo.fromJson(Map<String, dynamic> json) =>
      WaitingTimeInfo(
        title: json["title"],
        list: json["list"] == null
            ? []
            : List<String>.from(json["list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x)),
      };
}
