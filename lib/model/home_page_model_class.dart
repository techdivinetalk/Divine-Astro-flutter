import 'dart:convert';

HomePageModelClass homePageModelClassFromJson(String str) =>
    HomePageModelClass.fromJson(json.decode(str));

String homePageModelClassToJson(HomePageModelClass data) =>
    json.encode(data.toJson());

class HomePageModelClass {
  HomeData? data;
  bool? success;
  int? statusCode;
  String? message;

  HomePageModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory HomePageModelClass.fromJson(Map<String, dynamic> json) =>
      HomePageModelClass(
        data: json["data"] == null ? null : HomeData.fromJson(json["data"]),
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

class HomeData {
  NoticeBoard? noticeBoard;
  double? totalEarning;
  double? todaysEarning;
  OnGoingCall? onGoingCall;
  SessionType? sessionType;
  List<OfferType>? offerType;
  List<TrainingVideo>? trainingVideo;

  HomeData({
    this.noticeBoard,
    this.totalEarning,
    this.todaysEarning,
    this.onGoingCall,
    this.sessionType,
    this.offerType,
    this.trainingVideo,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        noticeBoard: json["notice_board"] == null
            ? null
            : NoticeBoard.fromJson(json["notice_board"]),
        totalEarning: json["total_earning"]?.toDouble(),
        todaysEarning: json["todays_earning"]?.toDouble(),
        onGoingCall: json["on_going_call"] == null
            ? null
            : OnGoingCall.fromJson(json["on_going_call"]),
        sessionType: json["session_type"] == null
            ? null
            : SessionType.fromJson(json["session_type"]),
        offerType: json["offer_type"] == null
            ? []
            : List<OfferType>.from(
                json["offer_type"]!.map((x) => OfferType.fromJson(x))),
        trainingVideo: json["training_video"] == null
            ? []
            : List<TrainingVideo>.from(
                json["training_video"]!.map((x) => TrainingVideo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "notice_board": noticeBoard?.toJson(),
        "total_earning": totalEarning,
        "todays_earning": todaysEarning,
        "on_going_call": onGoingCall?.toJson(),
        "session_type": sessionType?.toJson(),
        "offer_type": offerType == null
            ? []
            : List<dynamic>.from(offerType!.map((x) => x.toJson())),
        "training_video": trainingVideo == null
            ? []
            : List<dynamic>.from(trainingVideo!.map((x) => x.toJson())),
      };
}

class NoticeBoard {
  int? id;
  String? astrologerIds;
  String? title;
  String? description;
  DateTime? scheduleDate;
  String? scheduleTime;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  NoticeBoard({
    this.id,
    this.astrologerIds,
    this.title,
    this.description,
    this.scheduleDate,
    this.scheduleTime,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory NoticeBoard.fromJson(Map<String, dynamic> json) => NoticeBoard(
        id: json["id"],
        astrologerIds: json["astrologer_ids"],
        title: json["title"],
        description: json["description"],
        scheduleDate: json["schedule_date"] == null
            ? null
            : DateTime.parse(json["schedule_date"]),
        scheduleTime: json["schedule_time"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "astrologer_ids": astrologerIds,
        "title": title,
        "description": description,
        "schedule_date":
            "${scheduleDate!.year.toString().padLeft(4, '0')}-${scheduleDate!.month.toString().padLeft(2, '0')}-${scheduleDate!.day.toString().padLeft(2, '0')}",
        "schedule_time": scheduleTime,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class OfferType {
  int? id;
  String? offerName;
  int? callRate;
  String? isActive;

  OfferType({
    this.id,
    this.offerName,
    this.callRate,
    this.isActive,
  });

  factory OfferType.fromJson(Map<String, dynamic> json) => OfferType(
        id: json["id"],
        offerName: json["offer_name"],
        callRate: json["call_rate"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offer_name": offerName,
        "call_rate": callRate,
        "is_active": isActive,
      };
}

class OnGoingCall {
  OnGoingCall();

  factory OnGoingCall.fromJson(Map<String, dynamic> json) => OnGoingCall();

  Map<String, dynamic> toJson() => {};
}

class SessionType {
  int? chat;
  int? chatAmount;
  String? chatSchedualAt;
  int? call;
  String? callSchedualAt;
  int? callAmount;
  int? video;
  int? videoCallAmount;
  String? videoSchedualAt;

  SessionType({
    this.chat,
    this.chatAmount,
    this.chatSchedualAt,
    this.call,
    this.callSchedualAt,
    this.callAmount,
    this.video,
    this.videoCallAmount,
    this.videoSchedualAt,
  });

  factory SessionType.fromJson(Map<String, dynamic> json) => SessionType(
        chat: json["chat"],
        chatAmount: json["chat_amount"],
        chatSchedualAt: json["chat_schedual_at"],
        call: json["call"],
        callSchedualAt: json["call_schedual_at"],
        callAmount: json["call_amount"],
        video: json["video"],
        videoCallAmount: json["video_call_amount"],
        videoSchedualAt: json["video_schedual_at"],
      );

  Map<String, dynamic> toJson() => {
        "chat": chat,
        "chat_amount": chatAmount,
        "chat_schedual_at": chatSchedualAt,
        "call": call,
        "call_schedual_at": callSchedualAt,
        "call_amount": callAmount,
        "video": video,
        "video_call_amount": videoCallAmount,
        "video_schedual_at": videoSchedualAt,
      };
}

class TrainingVideo {
  int? id;
  String? title;
  String? description;
  String? url;
  int? days;

  TrainingVideo({
    this.id,
    this.title,
    this.description,
    this.url,
    this.days,
  });

  factory TrainingVideo.fromJson(Map<String, dynamic> json) => TrainingVideo(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        days: json["days"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "url": url,
        "days": days,
      };
}
