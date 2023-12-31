import 'dart:convert';

class ConstantDetailsModelClass {
  Data data;
  bool success;
  int statusCode;
  String message;

  ConstantDetailsModelClass({
    required this.data,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  ConstantDetailsModelClass copyWith({
    Data? data,
    bool? success,
    int? statusCode,
    String? message,
  }) =>
      ConstantDetailsModelClass(
        data: data ?? this.data,
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory ConstantDetailsModelClass.fromRawJson(String str) =>
      ConstantDetailsModelClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConstantDetailsModelClass.fromJson(Map<String, dynamic> json) =>
      ConstantDetailsModelClass(
        data: Data.fromJson(json["data"]),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class Data {
  Map<String, String> leaderboardRankImage;
  Map<String, String> lottiFile;
  String reviewFreeAnimation;
  int giftTimeInterval;
  Chat chat;
  Call call;
  List<String> badWordsData;
  String liveBackgroundImage;
  List<String> chatSuspiciousRegex;
  List<String> cityList;
  Map<String, String> notificationType;
  String whatsappNo;
  AwsCredential awsCredentails;

  Data({
    required this.leaderboardRankImage,
    required this.lottiFile,
    required this.reviewFreeAnimation,
    required this.giftTimeInterval,
    required this.chat,
    required this.call,
    required this.badWordsData,
    required this.liveBackgroundImage,
    required this.chatSuspiciousRegex,
    required this.cityList,
    required this.notificationType,
    required this.whatsappNo,
    required this.awsCredentails,
  });

  Data copyWith({
    Map<String, String>? leaderboardRankImage,
    Map<String, String>? lottiFile,
    String? reviewFreeAnimation,
    int? giftTimeInterval,
    Chat? chat,
    Call? call,
    List<String>? badWordsData,
    String? liveBackgroundImage,
    List<String>? chatSuspiciousRegex,
    List<String>? cityList,
    Map<String, String>? notificationType,
    AwsCredential? awsCredential,
    String? whatsappNo,
  }) =>
      Data(
        leaderboardRankImage: leaderboardRankImage ?? this.leaderboardRankImage,
        lottiFile: lottiFile ?? this.lottiFile,
        reviewFreeAnimation: reviewFreeAnimation ?? this.reviewFreeAnimation,
        giftTimeInterval: giftTimeInterval ?? this.giftTimeInterval,
        chat: chat ?? this.chat,
        call: call ?? this.call,
        badWordsData: badWordsData ?? this.badWordsData,
        liveBackgroundImage: liveBackgroundImage ?? this.liveBackgroundImage,
        chatSuspiciousRegex: chatSuspiciousRegex ?? this.chatSuspiciousRegex,
        cityList: cityList ?? this.cityList,
        notificationType: notificationType ?? this.notificationType,
        awsCredentails: awsCredentails,
        whatsappNo: whatsappNo ?? this.whatsappNo,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        leaderboardRankImage: Map.from(json["leaderboard_rank_image"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        lottiFile: Map.from(json["lotti_file"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        reviewFreeAnimation: json["review_free_animation"],
        giftTimeInterval: json["gift_time_interval"],
        chat: Chat.fromJson(json["chat"]),
        call: Call.fromJson(json["call"]),
        badWordsData: List<String>.from(json["bad_words_data"].map((x) => x)),
        liveBackgroundImage: json["live_background_image"],
        chatSuspiciousRegex:
            List<String>.from(json["chat_suspicious_regex"].map((x) => x)),
        cityList: List<String>.from(json["city_list"].map((x) => x)),
        notificationType: Map.from(json["notification_type"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        awsCredentails: AwsCredential.fromJson(json["aws_credential"]),
        whatsappNo: json["whatsappNo"],
      );

  Map<String, dynamic> toJson() => {
        "leaderboard_rank_image": Map.from(leaderboardRankImage)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "lotti_file":
            Map.from(lottiFile).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "review_free_animation": reviewFreeAnimation,
        "gift_time_interval": giftTimeInterval,
        "chat": chat.toJson(),
        "call": call.toJson(),
        "bad_words_data": List<dynamic>.from(badWordsData.map((x) => x)),
        "live_background_image": liveBackgroundImage,
        "chat_suspicious_regex":
            List<dynamic>.from(chatSuspiciousRegex.map((x) => x)),
        "city_list": List<dynamic>.from(cityList.map((x) => x)),
        "notification_type": Map.from(notificationType)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "aws_credential": awsCredentails.toJson(),
        "whatsappNo": whatsappNo,
      };
}

class Call {
  List<String> callDo;
  List<String> dont;
  String callerId;

  Call({
    required this.callDo,
    required this.dont,
    required this.callerId,
  });

  Call copyWith({
    List<String>? callDo,
    List<String>? dont,
    String? callerId,
  }) =>
      Call(
        callDo: callDo ?? this.callDo,
        dont: dont ?? this.dont,
        callerId: callerId ?? this.callerId,
      );

  factory Call.fromRawJson(String str) => Call.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Call.fromJson(Map<String, dynamic> json) => Call(
        callDo: List<String>.from(json["do"].map((x) => x)),
        dont: List<String>.from(json["dont"].map((x) => x)),
        callerId: json["caller_id"],
      );

  Map<String, dynamic> toJson() => {
        "do": List<dynamic>.from(callDo.map((x) => x)),
        "dont": List<dynamic>.from(dont.map((x) => x)),
        "caller_id": callerId,
      };
}

class Chat {
  List<String> chatDo;
  List<String> dont;

  Chat({
    required this.chatDo,
    required this.dont,
  });

  Chat copyWith({
    List<String>? chatDo,
    List<String>? dont,
  }) =>
      Chat(
        chatDo: chatDo ?? this.chatDo,
        dont: dont ?? this.dont,
      );

  factory Chat.fromRawJson(String str) => Chat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatDo: List<String>.from(json["do"].map((x) => x)),
        dont: List<String>.from(json["dont"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "do": List<dynamic>.from(chatDo.map((x) => x)),
        "dont": List<dynamic>.from(dont.map((x) => x)),
      };
}

class AwsCredential {
  String? baseurl;
  String? accesskey;
  String? secretKey;
  String? region;

  AwsCredential({this.baseurl, this.accesskey, this.secretKey, this.region});

  AwsCredential.fromJson(Map<String, dynamic> json) {
    baseurl = json['baseurl'];
    accesskey = json['Accesskey'];
    secretKey = json['secretKey'];
    region = json['Region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['baseurl'] = baseurl;
    data['Accesskey'] = accesskey;
    data['secretKey'] = secretKey;
    data['Region'] = region;
    return data;
  }
}
