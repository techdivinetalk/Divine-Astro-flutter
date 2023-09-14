// To parse this JSON data, do
//
//     final homePageModelClass = homePageModelClassFromJson(jsonString);

import 'dart:convert';

import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
HomePageModelClass homePageModelClassFromJson(String str) => HomePageModelClass.fromJson(json.decode(str));

String homePageModelClassToJson(HomePageModelClass data) => json.encode(data.toJson());

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

  factory HomePageModelClass.fromJson(Map<String, dynamic> json) => HomePageModelClass(
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
  double? totalEarning;
  int? todaysEarning;
  OnGoingCall? onGoingCall;
  SessionType? sessionType;
  List<OfferType>? offerType;
  List<TrainingVideo>? trainingVideo;

  HomeData({
    this.totalEarning,
    this.todaysEarning,
    this.onGoingCall,
    this.sessionType,
    this.offerType,
    this.trainingVideo,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    totalEarning: json["total_earning"]?.toDouble(),
    todaysEarning: json["todays_earning"],
    onGoingCall: json["on_going_call"] == null ? null : OnGoingCall.fromJson(json["on_going_call"]),
    sessionType: json["session_type"] == null ? null : SessionType.fromJson(json["session_type"]),
    offerType: json["offer_type"] == null ? [] : List<OfferType>.from(json["offer_type"]!.map((x) => OfferType.fromJson(x))),
    trainingVideo: json["training_video"] == null ? [] : List<TrainingVideo>.from(json["training_video"]!.map((x) => TrainingVideo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_earning": totalEarning,
    "todays_earning": todaysEarning,
    "on_going_call": onGoingCall?.toJson(),
    "session_type": sessionType?.toJson(),
    "offer_type": offerType == null ? [] : List<dynamic>.from(offerType!.map((x) => x.toJson())),
    "training_video": trainingVideo == null ? [] : List<dynamic>.from(trainingVideo!.map((x) => x.toJson())),
  };
}

class OfferType {
  int? id;
  String? offerName;
  int? callRate;
  String? isActive;
  RxBool? isOfferActive;
  OfferType({
    this.isOfferActive,
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
    isOfferActive: json["is_active"]=="0"?false.obs:true.obs,
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

  factory OnGoingCall.fromJson(Map<String, dynamic> json) => OnGoingCall(
  );

  Map<String, dynamic> toJson() => {
  };
}

class SessionType {
  int? chat;
  int? chatAmount;
  int? call;
  int? audioCallAmount;
  int? video;
  int? videoCallAmount;

  SessionType({
    this.chat,
    this.chatAmount,
    this.call,
    this.audioCallAmount,
    this.video,
    this.videoCallAmount,
  });

  factory SessionType.fromJson(Map<String, dynamic> json) => SessionType(
    chat: json["chat"],
    chatAmount: json["chat_amount"],
    call: json["call"],
    audioCallAmount: json["audio_call_amount"],
    video: json["video"],
    videoCallAmount: json["video_call_amount"],
  );

  Map<String, dynamic> toJson() => {
    "chat": chat,
    "chat_amount": chatAmount,
    "call": call,
    "audio_call_amount": audioCallAmount,
    "video": video,
    "video_call_amount": videoCallAmount,
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

  String get youtubeThumbNail => "https://img.youtube.com/vi/${extractYoutubeVideoID(url.toString())}/0.jpg";

}
