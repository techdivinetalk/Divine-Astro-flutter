/// success : true
/// status_code : 200
/// data : {"retention":{"retention":100,"bucket":5,"total_free_order":20,"free_user":1,"level":"7","recharge_user_sum":1},"notes":{"retention":"This is demo retention","bucket":"sample text for the bucket","total_free_order":"sample text for the total_free_order","free_user":"sample text for the free_user","checkin_level":"sample text for the checkin_level","recharge_user_sum":"Sample text for the recharge_user_sum"},"level":{"hours":"7","text":"(Last 10 Days)"},"badge":{"value":"Unranked","image":"https://divineprod.blob.core.windows.net/divineprod/badges/bronze.svg"},"performanceData":[{"metric":"Free Orders","value":500,"status":"","color":"#000000"},{"metric":"Promotional Orders (₹5)","value":500,"status":"","color":"#000000"},{"metric":"Retention Rate","value":"10%","status":"Good","color":"#008000"},{"metric":"Repurchase Rate","value":"15%","status":"Average","color":"yellow"},{"metric":"Online Hours","value":"14 hours","status":"Poor","color":"#FF0000"},{"metric":"Ecommerce","value":5000,"status":"Poor","color":"#FF0000"},{"metric":"Live","value":"","status":"Yes","color":"#008000"}]}
/// message : "Data retrieved successfully"

class AstroRitentionModel {
  AstroRitentionModel({
    bool? success,
    num? statusCode,
    Data? data,
    String? message,
  }) {
    _success = success;
    _statusCode = statusCode;
    _data = data;
    _message = message;
  }

  AstroRitentionModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['status_code'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }
  bool? _success;
  num? _statusCode;
  Data? _data;
  String? _message;
  AstroRitentionModel copyWith({
    bool? success,
    num? statusCode,
    Data? data,
    String? message,
  }) =>
      AstroRitentionModel(
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        data: data ?? _data,
        message: message ?? _message,
      );
  bool? get success => _success;
  num? get statusCode => _statusCode;
  Data? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['status_code'] = _statusCode;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['message'] = _message;
    return map;
  }
}

/// retention : {"retention":100,"bucket":5,"total_free_order":20,"free_user":1,"level":"7","recharge_user_sum":1}
/// notes : {"retention":"This is demo retention","bucket":"sample text for the bucket","total_free_order":"sample text for the total_free_order","free_user":"sample text for the free_user","checkin_level":"sample text for the checkin_level","recharge_user_sum":"Sample text for the recharge_user_sum"}
/// level : {"hours":"7","text":"(Last 10 Days)"}
/// badge : {"value":"Unranked","image":"https://divineprod.blob.core.windows.net/divineprod/badges/bronze.svg"}
/// performanceData : [{"metric":"Free Orders","value":500,"status":"","color":"#000000"},{"metric":"Promotional Orders (₹5)","value":500,"status":"","color":"#000000"},{"metric":"Retention Rate","value":"10%","status":"Good","color":"#008000"},{"metric":"Repurchase Rate","value":"15%","status":"Average","color":"yellow"},{"metric":"Online Hours","value":"14 hours","status":"Poor","color":"#FF0000"},{"metric":"Ecommerce","value":5000,"status":"Poor","color":"#FF0000"},{"metric":"Live","value":"","status":"Yes","color":"#008000"}]

class Data {
  Data({
    Retention? retention,
    Notes? notes,
    Level? level,
    Badge? badge,
    List<PerformanceData>? performanceData,
  }) {
    _retention = retention;
    _notes = notes;
    _level = level;
    _badge = badge;
    _performanceData = performanceData;
  }

  Data.fromJson(dynamic json) {
    _retention = json['retention'] != null
        ? Retention.fromJson(json['retention'])
        : null;
    _notes = json['notes'] != null ? Notes.fromJson(json['notes']) : null;
    _level = json['level'] != null ? Level.fromJson(json['level']) : null;
    _badge = json['badge'] != null ? Badge.fromJson(json['badge']) : null;
    if (json['performanceData'] != null) {
      _performanceData = [];
      json['performanceData'].forEach((v) {
        _performanceData?.add(PerformanceData.fromJson(v));
      });
    }
  }
  Retention? _retention;
  Notes? _notes;
  Level? _level;
  Badge? _badge;
  List<PerformanceData>? _performanceData;
  Data copyWith({
    Retention? retention,
    Notes? notes,
    Level? level,
    Badge? badge,
    List<PerformanceData>? performanceData,
  }) =>
      Data(
        retention: retention ?? _retention,
        notes: notes ?? _notes,
        level: level ?? _level,
        badge: badge ?? _badge,
        performanceData: performanceData ?? _performanceData,
      );
  Retention? get retention => _retention;
  Notes? get notes => _notes;
  Level? get level => _level;
  Badge? get badge => _badge;
  List<PerformanceData>? get performanceData => _performanceData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_retention != null) {
      map['retention'] = _retention?.toJson();
    }
    if (_notes != null) {
      map['notes'] = _notes?.toJson();
    }
    if (_level != null) {
      map['level'] = _level?.toJson();
    }
    if (_badge != null) {
      map['badge'] = _badge?.toJson();
    }
    if (_performanceData != null) {
      map['performanceData'] =
          _performanceData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// metric : "Free Orders"
/// value : 500
/// status : ""
/// color : "#000000"

class PerformanceData {
  PerformanceData({
    String? metric,
    dynamic value,
    String? status,
    String? color,
  }) {
    _metric = metric;
    _value = value;
    _status = status;
    _color = color;
  }

  PerformanceData.fromJson(dynamic json) {
    _metric = json['metric'];
    _value = json['value'];
    _status = json['status'];
    _color = json['color'];
  }
  String? _metric;
  dynamic _value;
  String? _status;
  String? _color;
  PerformanceData copyWith({
    String? metric,
    dynamic value,
    String? status,
    String? color,
  }) =>
      PerformanceData(
        metric: metric ?? _metric,
        value: value ?? _value,
        status: status ?? _status,
        color: color ?? _color,
      );
  String? get metric => _metric;
  dynamic get value => _value;
  String? get status => _status;
  String? get color => _color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['metric'] = _metric;
    map['value'] = _value;
    map['status'] = _status;
    map['color'] = _color;
    return map;
  }
}

/// value : "Unranked"
/// image : "https://divineprod.blob.core.windows.net/divineprod/badges/bronze.svg"

class Badge {
  Badge({
    String? value,
    String? image,
  }) {
    _value = value;
    _image = image;
  }

  Badge.fromJson(dynamic json) {
    _value = json['value'];
    _image = json['image'];
  }
  String? _value;
  String? _image;
  Badge copyWith({
    String? value,
    String? image,
  }) =>
      Badge(
        value: value ?? _value,
        image: image ?? _image,
      );
  String? get value => _value;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['image'] = _image;
    return map;
  }
}

/// hours : "7"
/// text : "(Last 10 Days)"

class Level {
  Level({
    String? hours,
    String? text,
  }) {
    _hours = hours;
    _text = text;
  }

  Level.fromJson(dynamic json) {
    _hours = json['hours'];
    _text = json['text'];
  }
  String? _hours;
  String? _text;
  Level copyWith({
    String? hours,
    String? text,
  }) =>
      Level(
        hours: hours ?? _hours,
        text: text ?? _text,
      );
  String? get hours => _hours;
  String? get text => _text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hours'] = _hours;
    map['text'] = _text;
    return map;
  }
}

/// retention : "This is demo retention"
/// bucket : "sample text for the bucket"
/// total_free_order : "sample text for the total_free_order"
/// free_user : "sample text for the free_user"
/// checkin_level : "sample text for the checkin_level"
/// recharge_user_sum : "Sample text for the recharge_user_sum"

class Notes {
  Notes({
    String? retention,
    String? bucket,
    String? totalFreeOrder,
    String? freeUser,
    String? checkinLevel,
    String? rechargeUserSum,
  }) {
    _retention = retention;
    _bucket = bucket;
    _totalFreeOrder = totalFreeOrder;
    _freeUser = freeUser;
    _checkinLevel = checkinLevel;
    _rechargeUserSum = rechargeUserSum;
  }

  Notes.fromJson(dynamic json) {
    _retention = json['retention'];
    _bucket = json['bucket'];
    _totalFreeOrder = json['total_free_order'];
    _freeUser = json['free_user'];
    _checkinLevel = json['checkin_level'];
    _rechargeUserSum = json['recharge_user_sum'];
  }
  String? _retention;
  String? _bucket;
  String? _totalFreeOrder;
  String? _freeUser;
  String? _checkinLevel;
  String? _rechargeUserSum;
  Notes copyWith({
    String? retention,
    String? bucket,
    String? totalFreeOrder,
    String? freeUser,
    String? checkinLevel,
    String? rechargeUserSum,
  }) =>
      Notes(
        retention: retention ?? _retention,
        bucket: bucket ?? _bucket,
        totalFreeOrder: totalFreeOrder ?? _totalFreeOrder,
        freeUser: freeUser ?? _freeUser,
        checkinLevel: checkinLevel ?? _checkinLevel,
        rechargeUserSum: rechargeUserSum ?? _rechargeUserSum,
      );
  String? get retention => _retention;
  String? get bucket => _bucket;
  String? get totalFreeOrder => _totalFreeOrder;
  String? get freeUser => _freeUser;
  String? get checkinLevel => _checkinLevel;
  String? get rechargeUserSum => _rechargeUserSum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['retention'] = _retention;
    map['bucket'] = _bucket;
    map['total_free_order'] = _totalFreeOrder;
    map['free_user'] = _freeUser;
    map['checkin_level'] = _checkinLevel;
    map['recharge_user_sum'] = _rechargeUserSum;
    return map;
  }
}

/// retention : 100
/// bucket : 5
/// total_free_order : 20
/// free_user : 1
/// level : "7"
/// recharge_user_sum : 1

class Retention {
  Retention({
    num? retention,
    num? bucket,
    num? totalFreeOrder,
    num? freeUser,
    String? level,
    num? rechargeUserSum,
  }) {
    _retention = retention;
    _bucket = bucket;
    _totalFreeOrder = totalFreeOrder;
    _freeUser = freeUser;
    _level = level;
    _rechargeUserSum = rechargeUserSum;
  }

  Retention.fromJson(dynamic json) {
    _retention = json['retention'];
    _bucket = json['bucket'];
    _totalFreeOrder = json['total_free_order'];
    _freeUser = json['free_user'];
    _level = json['level'];
    _rechargeUserSum = json['recharge_user_sum'];
  }
  num? _retention;
  num? _bucket;
  num? _totalFreeOrder;
  num? _freeUser;
  String? _level;
  num? _rechargeUserSum;
  Retention copyWith({
    num? retention,
    num? bucket,
    num? totalFreeOrder,
    num? freeUser,
    String? level,
    num? rechargeUserSum,
  }) =>
      Retention(
        retention: retention ?? _retention,
        bucket: bucket ?? _bucket,
        totalFreeOrder: totalFreeOrder ?? _totalFreeOrder,
        freeUser: freeUser ?? _freeUser,
        level: level ?? _level,
        rechargeUserSum: rechargeUserSum ?? _rechargeUserSum,
      );
  num? get retention => _retention;
  num? get bucket => _bucket;
  num? get totalFreeOrder => _totalFreeOrder;
  num? get freeUser => _freeUser;
  String? get level => _level;
  num? get rechargeUserSum => _rechargeUserSum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['retention'] = _retention;
    map['bucket'] = _bucket;
    map['total_free_order'] = _totalFreeOrder;
    map['free_user'] = _freeUser;
    map['level'] = _level;
    map['recharge_user_sum'] = _rechargeUserSum;
    return map;
  }
}
