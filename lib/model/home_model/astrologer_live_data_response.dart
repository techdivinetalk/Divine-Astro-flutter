class AstrologerLiveDataResponse {
  final Data? data;
  final bool? success;
  final int? statusCode;
  final String? message;

  AstrologerLiveDataResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  AstrologerLiveDataResponse.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null,
        success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'data' : data?.toJson(),
    'success' : success,
    'status_code' : statusCode,
    'message' : message
  };
}

class Data {
  final List<Weeks>? weeks;
  final int? todaysRemaining;
  final int? isRewardAvailable;
  final int? rewardPoint;
  final int? isLiveMonitor;

  Data({
    this.weeks,
    this.todaysRemaining,
    this.isRewardAvailable,
    this.rewardPoint,
    this.isLiveMonitor,
  });

  Data.fromJson(Map<String, dynamic> json)
      : weeks = (json['weeks'] as List?)?.map((dynamic e) => Weeks.fromJson(e as Map<String,dynamic>)).toList(),
        todaysRemaining = json['todays_remaining'] as int?,
        isRewardAvailable = json['is_reward_available'] as int?,
        rewardPoint = json['reward_point'] as int?,
        isLiveMonitor = json['is_live_monitor'] as int?;

  Map<String, dynamic> toJson() => {
    'weeks' : weeks?.map((e) => e.toJson()).toList(),
    'todays_remaining' : todaysRemaining,
    'is_reward_available' : isRewardAvailable,
    'reward_point' : rewardPoint,
    'is_live_monitor' : isLiveMonitor
  };
}

class Weeks {
  final String? start;
  final String? end;
  dynamic totalLiveMinutes;
  final int? remainingLiveMinute;
  final int? weekNo;

  Weeks({
    this.start,
    this.end,
    this.totalLiveMinutes,
    this.remainingLiveMinute,
    this.weekNo,
  });

  Weeks.fromJson(Map<String, dynamic> json)
      : start = json['start'] as String?,
        end = json['end'] as String?,
        totalLiveMinutes = json['total_live_minutes'] ??"",
        remainingLiveMinute = json['remaining_live_minute'] as int?,
        weekNo = json['week_no'] as int?;

  Map<String, dynamic> toJson() => {
    'start' : start,
    'end' : end,
    'total_live_minutes' : totalLiveMinutes,
    'remaining_live_minute' : remainingLiveMinute,
    'week_no' : weekNo
  };
}