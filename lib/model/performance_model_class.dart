// To parse this JSON data, do
//
//     final performanceModelClass = performanceModelClassFromJson(jsonString);

import 'dart:convert';

PerformanceModelClass performanceModelClassFromJson(String str) => PerformanceModelClass.fromJson(json.decode(str));

String performanceModelClassToJson(PerformanceModelClass data) => json.encode(data.toJson());

class PerformanceModelClass {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  PerformanceModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory PerformanceModelClass.fromJson(Map<String, dynamic> json) => PerformanceModelClass(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
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

class Data {
  DaysAvailiblity? todaysAvailiblity;
  DaysAvailiblity? last30DaysAvailiblity;
  List<dynamic>? performance;
  FilterOption? filterOption;
  dynamic score;
  List<RankSystem>? rankSystem;
  List<BusyHour>? busyHours;
  List<BusyHour>? eCommerce;
  List<BusyHour>? liveHours;
  List<BusyHour>? onlineHours;
  List<BusyHour>? repurchaseRate;
  List<BusyHour>? conversionRate;
  List<RankStatistic>? busyHoursRankStatistics;
  List<RankStatistic>? eCommerceRankStatistics;
  List<RankStatistic>? liveHoursRankStatistics;
  List<RankStatistic>? onlineHoursRankStatistics;
  List<RankStatistic>? repurchaseRateRankStatistics;
  List<RankStatistic>? conversionRateRankStatistics;

  Data({
    this.todaysAvailiblity,
    this.last30DaysAvailiblity,
    this.performance,
    this.filterOption,
    this.score,
    this.rankSystem,
    this.busyHours,
    this.eCommerce,
    this.liveHours,
    this.onlineHours,
    this.repurchaseRate,
    this.conversionRate,
    this.busyHoursRankStatistics,
    this.eCommerceRankStatistics,
    this.liveHoursRankStatistics,
    this.onlineHoursRankStatistics,
    this.repurchaseRateRankStatistics,
    this.conversionRateRankStatistics,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    todaysAvailiblity: json["todays_availiblity"] == null ? null : DaysAvailiblity.fromJson(json["todays_availiblity"]),
    last30DaysAvailiblity: json["last_30_days_availiblity"] == null ? null : DaysAvailiblity.fromJson(json["last_30_days_availiblity"]),
    performance: json["performance"] == null ? [] : List<dynamic>.from(json["performance"]!.map((x) => x)),
    filterOption: json["filterOption"] == null ? null : FilterOption.fromJson(json["filterOption"]),
    score: json["score"],
    rankSystem: json["rank_system"] == null ? [] : List<RankSystem>.from(json["rank_system"]!.map((x) => RankSystem.fromJson(x))),
    busyHours: json["busy_hours"] == null ? [] : List<BusyHour>.from(json["busy_hours"]!.map((x) => BusyHour.fromJson(x))),
    eCommerce: json["e_commerce"] == null ? [] : List<BusyHour>.from(json["e_commerce"]!.map((x) => BusyHour.fromJson(x))),
    liveHours: json["live_hours"] == null ? [] : List<BusyHour>.from(json["live_hours"]!.map((x) => BusyHour.fromJson(x))),
    onlineHours: json["online_hours"] == null ? [] : List<BusyHour>.from(json["online_hours"]!.map((x) => BusyHour.fromJson(x))),
    repurchaseRate: json["repurchase_rate"] == null ? [] : List<BusyHour>.from(json["repurchase_rate"]!.map((x) => BusyHour.fromJson(x))),
    conversionRate: json["conversion_rate"] == null ? [] : List<BusyHour>.from(json["conversion_rate"]!.map((x) => BusyHour.fromJson(x))),
    busyHoursRankStatistics: json["busy_hours_rank_statistics"] == null ? [] : List<RankStatistic>.from(json["busy_hours_rank_statistics"]!.map((x) => RankStatistic.fromJson(x))),
    eCommerceRankStatistics: json["e_commerce_rank_statistics"] == null ? [] : List<RankStatistic>.from(json["e_commerce_rank_statistics"]!.map((x) => RankStatistic.fromJson(x))),
    liveHoursRankStatistics: json["live_hours_rank_statistics"] == null ? [] : List<RankStatistic>.from(json["live_hours_rank_statistics"]!.map((x) => RankStatistic.fromJson(x))),
    onlineHoursRankStatistics: json["online_hours_rank_statistics"] == null ? [] : List<RankStatistic>.from(json["online_hours_rank_statistics"]!.map((x) => RankStatistic.fromJson(x))),
    repurchaseRateRankStatistics: json["repurchase_rate_rank_statistics"] == null ? [] : List<RankStatistic>.from(json["repurchase_rate_rank_statistics"]!.map((x) => RankStatistic.fromJson(x))),
    conversionRateRankStatistics: json["conversion_rate_rank_statistics"] == null ? [] : List<RankStatistic>.from(json["conversion_rate_rank_statistics"]!.map((x) => RankStatistic.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "todays_availiblity": todaysAvailiblity?.toJson(),
    "last_30_days_availiblity": last30DaysAvailiblity?.toJson(),
    "performance": performance == null ? [] : List<dynamic>.from(performance!.map((x) => x)),
    "filterOption": filterOption?.toJson(),
    "score": score,
    "rank_system": rankSystem == null ? [] : List<dynamic>.from(rankSystem!.map((x) => x.toJson())),
    "busy_hours": busyHours == null ? [] : List<dynamic>.from(busyHours!.map((x) => x.toJson())),
    "e_commerce": eCommerce == null ? [] : List<dynamic>.from(eCommerce!.map((x) => x.toJson())),
    "live_hours": liveHours == null ? [] : List<dynamic>.from(liveHours!.map((x) => x.toJson())),
    "online_hours": onlineHours == null ? [] : List<dynamic>.from(onlineHours!.map((x) => x.toJson())),
    "repurchase_rate": repurchaseRate == null ? [] : List<dynamic>.from(repurchaseRate!.map((x) => x.toJson())),
    "conversion_rate": conversionRate == null ? [] : List<dynamic>.from(conversionRate!.map((x) => x.toJson())),
    "busy_hours_rank_statistics": busyHoursRankStatistics == null ? [] : List<dynamic>.from(busyHoursRankStatistics!.map((x) => x.toJson())),
    "e_commerce_rank_statistics": eCommerceRankStatistics == null ? [] : List<dynamic>.from(eCommerceRankStatistics!.map((x) => x.toJson())),
    "live_hours_rank_statistics": liveHoursRankStatistics == null ? [] : List<dynamic>.from(liveHoursRankStatistics!.map((x) => x.toJson())),
    "online_hours_rank_statistics": onlineHoursRankStatistics == null ? [] : List<dynamic>.from(onlineHoursRankStatistics!.map((x) => x.toJson())),
    "repurchase_rate_rank_statistics": repurchaseRateRankStatistics == null ? [] : List<dynamic>.from(repurchaseRateRankStatistics!.map((x) => x.toJson())),
    "conversion_rate_rank_statistics": conversionRateRankStatistics == null ? [] : List<dynamic>.from(conversionRateRankStatistics!.map((x) => x.toJson())),
  };
}

class BusyHour {
  int? id;
  Type? type;
  String? percentage;
  int? marks;

  BusyHour({
    this.id,
    this.type,
    this.percentage,
    this.marks,
  });

  factory BusyHour.fromJson(Map<String, dynamic> json) => BusyHour(
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

class RankStatistic {
  int? id;
  Type? type;
  int? min;
  int? max;
  Parameter? parameter;

  RankStatistic({
    this.id,
    this.type,
    this.min,
    this.max,
    this.parameter,
  });

  factory RankStatistic.fromJson(Map<String, dynamic> json) => RankStatistic(
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

enum Parameter {
  AVERAGE,
  GOOD,
  POOR
}

final parameterValues = EnumValues({
  "Average": Parameter.AVERAGE,
  "Good": Parameter.GOOD,
  "Poor": Parameter.POOR
});

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

  factory DaysAvailiblity.fromJson(Map<String, dynamic> json) => DaysAvailiblity(
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
