// ignore_for_file: constant_identifier_names

import 'dart:convert';

PerformanceModelClass performanceModelClassFromJson(String str) =>
    PerformanceModelClass.fromJson(json.decode(str));

String performanceModelClassToJson(PerformanceModelClass data) =>
    json.encode(data.toJson());

class PerformanceModelClass {
  Data? data;
  bool? success;
  String? statusCode;
  String? message;

  PerformanceModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory PerformanceModelClass.fromJson(Map<String, dynamic> json) =>
      PerformanceModelClass(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        success: json["success"],
        statusCode: json["status_code"].toString(),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class Data {
  DaysAvailiblity? todaysAvailiblity;
  DaysAvailiblity? last30DaysAvailiblity;
  FilterOption? filterOption;
  Score? score;
  List<RankSystem>? rankSystem;
  Response? response;

  Data({
    this.todaysAvailiblity,
    this.last30DaysAvailiblity,
    this.filterOption,
    this.score,
    this.rankSystem,
    this.response,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        todaysAvailiblity: json["todays_availiblity"] == null
            ? null
            : DaysAvailiblity.fromJson(json["todays_availiblity"]),
        last30DaysAvailiblity: json["last_30_days_availiblity"] == null
            ? null
            : DaysAvailiblity.fromJson(json["last_30_days_availiblity"]),
        filterOption: json["filterOption"] == null
            ? null
            : FilterOption.fromJson(json["filterOption"]),
        score: json["score"] == null ? null : Score.fromJson(json["score"]),
        rankSystem: json["rank_system"] == null
            ? []
            : List<RankSystem>.from(
                json["rank_system"]!.map((x) => RankSystem.fromJson(x))),
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "todays_availiblity": todaysAvailiblity?.toJson(),
        "last_30_days_availiblity": last30DaysAvailiblity?.toJson(),
        "filterOption": filterOption?.toJson(),
        "score": score?.toJson(),
        "rank_system": rankSystem == null
            ? []
            : List<dynamic>.from(rankSystem!.map((x) => x.toJson())),
        "response": response?.toJson(),
      };
}

class FilterOption {
  String? today;
  String? lastWeek;
  String? lastMonth;

  FilterOption({
    this.today,
    this.lastWeek,
    this.lastMonth,
  });

  factory FilterOption.fromJson(Map<String, dynamic> json) => FilterOption(
        today: json["today"],
        lastWeek: json["last_week"],
        lastMonth: json["last_month"],
      );

  Map<String, dynamic> toJson() => {
        "today": today,
        "last_week": lastWeek,
        "last_month": lastMonth,
      };
}

class DaysAvailiblity {
  int? availableChat;
  int? availableCall;
  int? busyChat;
  int? busyCall;
  int? availableLive;
  int? busyLive;

  DaysAvailiblity({
    this.availableChat,
    this.availableCall,
    this.busyChat,
    this.busyCall,
    this.availableLive,
    this.busyLive,
  });

  factory DaysAvailiblity.fromJson(Map<String, dynamic> json) =>
      DaysAvailiblity(
        availableChat: json["available_chat"],
        availableCall: json["available_call"],
        busyChat: json["busy_chat"],
        busyCall: json["busy_call"],
        availableLive: json["available_live"],
        busyLive: json["busy_live"],
      );

  Map<String, dynamic> toJson() => {
        "available_chat": availableChat,
        "available_call": availableCall,
        "busy_chat": busyChat,
        "busy_call": busyCall,
        "available_live": availableLive,
        "busy_live": busyLive,
      };
}

class RankSystem {
  int? id;
  String? percentageRange;
  String? rank;

  RankSystem({
    this.id,
    this.percentageRange,
    this.rank,
  });

  factory RankSystem.fromJson(Map<String, dynamic> json) => RankSystem(
        id: json["id"],
        percentageRange: json["percentage_range"],
        rank: json["rank"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "percentage_range": percentageRange,
        "rank": rank,
      };
}

class Response {
  BusyHours? conversionRate;
  BusyHours? repurchaseRate;
  BusyHours? onlineHours;
  BusyHours? liveHours;
  BusyHours? eCommerce;
  BusyHours? busyHours;

  Response({
    this.conversionRate,
    this.repurchaseRate,
    this.onlineHours,
    this.liveHours,
    this.eCommerce,
    this.busyHours,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        conversionRate: json["conversion_rate"] == null
            ? null
            : BusyHours.fromJson(json["conversion_rate"]),
        repurchaseRate: json["repurchase_rate"] == null
            ? null
            : BusyHours.fromJson(json["repurchase_rate"]),
        onlineHours: json["online_hours"] == null
            ? null
            : BusyHours.fromJson(json["online_hours"]),
        liveHours: json["live_hours"] == null
            ? null
            : BusyHours.fromJson(json["live_hours"]),
        eCommerce: json["e_commerce"] == null
            ? null
            : BusyHours.fromJson(json["e_commerce"]),
        busyHours: json["busy_hours"] == null
            ? null
            : BusyHours.fromJson(json["busy_hours"]),
      );

  Map<String, dynamic> toJson() => {
        "conversion_rate": conversionRate?.toJson(),
        "repurchase_rate": repurchaseRate?.toJson(),
        "online_hours": onlineHours?.toJson(),
        "live_hours": liveHours?.toJson(),
        "e_commerce": eCommerce?.toJson(),
        "busy_hours": busyHours?.toJson(),
      };
}

class BusyHours {
  String? label;
  List<Detail>? detail;
  List<RankDetail>? rankDetail;
  List<Performance>? performance;

  BusyHours({
    this.label,
    this.detail,
    this.rankDetail,
    this.performance,
  });

  factory BusyHours.fromJson(Map<String, dynamic> json) => BusyHours(
        label: json["label"],
        detail: json["detail"] == null
            ? []
            : List<Detail>.from(json["detail"]!.map((x) => Detail.fromJson(x))),
        rankDetail: json["rank_detail"] == null
            ? []
            : List<RankDetail>.from(
                json["rank_detail"]!.map((x) => RankDetail.fromJson(x))),
        performance: json["performance"] == null
            ? []
            : List<Performance>.from(
                json["performance"]!.map((x) => Performance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "detail": detail == null
            ? []
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
        "rank_detail": rankDetail == null
            ? []
            : List<dynamic>.from(rankDetail!.map((x) => x.toJson())),
        "performance": performance == null
            ? []
            : List<dynamic>.from(performance!.map((x) => x.toJson())),
      };
}

class Detail {
  int? id;
  Type? type;
  String? percentage;
  int? marks;

  Detail({
    this.id,
    this.type,
    this.percentage,
    this.marks,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        type: typeValues.map[json["type"]]!,
        percentage: json["percentage"],
        marks: json["marks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": typeValues.reverse[type],
        "percentage": percentage,
        "marks": marks,
      };
}

enum Type {
  BUSY_HOURS,
  CONVERSION_RATE,
  E_COMMERCE,
  LIVE_HOURS,
  ONLINE_HOURS,
  REPURCHASE_RATE
}

final typeValues = EnumValues({
  "busy_hours": Type.BUSY_HOURS,
  "conversion_rate": Type.CONVERSION_RATE,
  "e_commerce": Type.E_COMMERCE,
  "live_hours": Type.LIVE_HOURS,
  "online_hours": Type.ONLINE_HOURS,
  "repurchase_rate": Type.REPURCHASE_RATE
});

class Performance {
  int? id;
  int? astrologerId;
  String? label;
  int? value;
  int? valueOutOff;
  int? percentage;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  Performance({
    this.id,
    this.astrologerId,
    this.label,
    this.value,
    this.valueOutOff,
    this.percentage,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Performance.fromJson(Map<String, dynamic> json) => Performance(
        id: json["id"],
        astrologerId: json["astrologer_id"],
        label: json["label"],
        value: json["value"],
        valueOutOff: json["value_out_off"],
        percentage: json["percentage"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "astrologer_id": astrologerId,
        "label": label,
        "value": value,
        "value_out_off": valueOutOff,
        "percentage": percentage,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class RankDetail {
  int? id;
  Type? type;
  int? min;
  int? max;
  Parameter? parameter;

  RankDetail({
    this.id,
    this.type,
    this.min,
    this.max,
    this.parameter,
  });

  factory RankDetail.fromJson(Map<String, dynamic> json) => RankDetail(
        id: json["id"],
        type: typeValues.map[json["type"]]!,
        min: json["min"],
        max: json["max"],
        parameter: parameterValues.map[json["parameter"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": typeValues.reverse[type],
        "min": min,
        "max": max,
        "parameter": parameterValues.reverse[parameter],
      };
}

enum Parameter { AVERAGE, GOOD, POOR }

final parameterValues = EnumValues({
  "Average": Parameter.AVERAGE,
  "Good": Parameter.GOOD,
  "Poor": Parameter.POOR
});

class Score {
  int? id;
  int? astrologerId;
  String? marks;
  String? obtainMarks;
  int? percentage;
  String? rank;
  DateTime? createdAt;
  DateTime? updatedAt;

  Score({
    this.id,
    this.astrologerId,
    this.marks,
    this.obtainMarks,
    this.percentage,
    this.rank,
    this.createdAt,
    this.updatedAt,
  });

  factory Score.fromJson(Map<String, dynamic> json) => Score(
        id: json["id"],
        astrologerId: json["astrologer_id"],
        marks: json["marks"],
        obtainMarks: json["obtain_marks"],
        percentage: json["percentage"],
        rank: json["rank"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "astrologer_id": astrologerId,
        "marks": marks,
        "obtain_marks": obtainMarks,
        "percentage": percentage,
        "rank": rank,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
