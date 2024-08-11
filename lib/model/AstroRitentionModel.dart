/// success : true
/// status_code : 200
/// data : {"retention":{"retention":0,"bucket":5,"total_free_order":20,"free_user":0,"checkin_level":"0","recharge_user_sum":0},"notes":{"retention":"This is demo retention","bucket":"sample text for the bucket","total_free_order":"sample text for the total_free_order","free_user":"sample text for the free_user","checkin_level":"sample text for the checkin_level","recharge_user_sum":"Sample text for the recharge_user_sum"},"level":{"level_detail":[{"text":"%","min":"0","max":"35","value":"Unranked","image":null},{"text":"%","min":"36","max":"59","value":"Bronze","image":"https://divineprod.blob.core.windows.net/divineprod/badges/bronze.svg"},{"text":"%","min":"60","max":"69","value":"Silver","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Silver.svg"},{"text":"%","min":"70","max":"79","value":"Gold","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Gold.svg"},{"text":"%","min":"89","max":"80","value":"Platinum","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Platinum.svg"},{"text":"%","min":"90","max":null,"value":"Diamond","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Diamond.svg"}]},"performanceData":[{"metric":"Free Orders","value":500,"status":""},{"metric":"Promotional Orders (₹5)","value":500,"status":""},{"metric":"Retention Rate","value":"10%","status":"Good","color":"green"},{"metric":"Repurchase Rate","value":"15%","status":"Average","color":"yellow"},{"metric":"Online Hours","value":"14 hours","status":"Poor","color":"red"},{"metric":"Ecommerce","value":5000,"status":"Poor","color":"red"},{"metric":"Live","value":"","status":"Yes","color":"green"}]}
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

/// retention : {"retention":0,"bucket":5,"total_free_order":20,"free_user":0,"checkin_level":"0","recharge_user_sum":0}
/// notes : {"retention":"This is demo retention","bucket":"sample text for the bucket","total_free_order":"sample text for the total_free_order","free_user":"sample text for the free_user","checkin_level":"sample text for the checkin_level","recharge_user_sum":"Sample text for the recharge_user_sum"}
/// level : {"level_detail":[{"text":"%","min":"0","max":"35","value":"Unranked","image":null},{"text":"%","min":"36","max":"59","value":"Bronze","image":"https://divineprod.blob.core.windows.net/divineprod/badges/bronze.svg"},{"text":"%","min":"60","max":"69","value":"Silver","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Silver.svg"},{"text":"%","min":"70","max":"79","value":"Gold","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Gold.svg"},{"text":"%","min":"89","max":"80","value":"Platinum","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Platinum.svg"},{"text":"%","min":"90","max":null,"value":"Diamond","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Diamond.svg"}]}
/// performanceData : [{"metric":"Free Orders","value":500,"status":""},{"metric":"Promotional Orders (₹5)","value":500,"status":""},{"metric":"Retention Rate","value":"10%","status":"Good","color":"green"},{"metric":"Repurchase Rate","value":"15%","status":"Average","color":"yellow"},{"metric":"Online Hours","value":"14 hours","status":"Poor","color":"red"},{"metric":"Ecommerce","value":5000,"status":"Poor","color":"red"},{"metric":"Live","value":"","status":"Yes","color":"green"}]

class Data {
  Data({
    Retention? retention,
    Notes? notes,
    Level? level,
    List<PerformanceData>? performanceData,
  }) {
    _retention = retention;
    _notes = notes;
    _level = level;
    _performanceData = performanceData;
  }

  Data.fromJson(dynamic json) {
    _retention = json['retention'] != null
        ? Retention.fromJson(json['retention'])
        : null;
    _notes = json['notes'] != null ? Notes.fromJson(json['notes']) : null;
    _level = json['level'] != null ? Level.fromJson(json['level']) : null;
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
  List<PerformanceData>? _performanceData;
  Data copyWith({
    Retention? retention,
    Notes? notes,
    Level? level,
    List<PerformanceData>? performanceData,
  }) =>
      Data(
        retention: retention ?? _retention,
        notes: notes ?? _notes,
        level: level ?? _level,
        performanceData: performanceData ?? _performanceData,
      );
  Retention? get retention => _retention;
  Notes? get notes => _notes;
  Level? get level => _level;
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

/// level_detail : [{"text":"%","min":"0","max":"35","value":"Unranked","image":null},{"text":"%","min":"36","max":"59","value":"Bronze","image":"https://divineprod.blob.core.windows.net/divineprod/badges/bronze.svg"},{"text":"%","min":"60","max":"69","value":"Silver","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Silver.svg"},{"text":"%","min":"70","max":"79","value":"Gold","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Gold.svg"},{"text":"%","min":"89","max":"80","value":"Platinum","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Platinum.svg"},{"text":"%","min":"90","max":null,"value":"Diamond","image":"https://divineprod.blob.core.windows.net/divineprod/badges/Diamond.svg"}]

class Level {
  Level({
    List<LevelDetail>? levelDetail,
  }) {
    _levelDetail = levelDetail;
  }

  Level.fromJson(dynamic json) {
    if (json['level_detail'] != null) {
      _levelDetail = [];
      json['level_detail'].forEach((v) {
        _levelDetail?.add(LevelDetail.fromJson(v));
      });
    }
  }
  List<LevelDetail>? _levelDetail;
  Level copyWith({
    List<LevelDetail>? levelDetail,
  }) =>
      Level(
        levelDetail: levelDetail ?? _levelDetail,
      );
  List<LevelDetail>? get levelDetail => _levelDetail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_levelDetail != null) {
      map['level_detail'] = _levelDetail?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// text : "%"
/// min : "0"
/// max : "35"
/// value : "Unranked"
/// image : null

class LevelDetail {
  LevelDetail({
    String? text,
    String? min,
    String? max,
    String? value,
    dynamic image,
  }) {
    _text = text;
    _min = min;
    _max = max;
    _value = value;
    _image = image;
  }

  LevelDetail.fromJson(dynamic json) {
    _text = json['text'];
    _min = json['min'];
    _max = json['max'];
    _value = json['value'];
    _image = json['image'];
  }
  String? _text;
  String? _min;
  String? _max;
  String? _value;
  dynamic _image;
  LevelDetail copyWith({
    String? text,
    String? min,
    String? max,
    String? value,
    dynamic image,
  }) =>
      LevelDetail(
        text: text ?? _text,
        min: min ?? _min,
        max: max ?? _max,
        value: value ?? _value,
        image: image ?? _image,
      );
  String? get text => _text;
  String? get min => _min;
  String? get max => _max;
  String? get value => _value;
  dynamic get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    map['min'] = _min;
    map['max'] = _max;
    map['value'] = _value;
    map['image'] = _image;
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

/// retention : 0
/// bucket : 5
/// total_free_order : 20
/// free_user : 0
/// checkin_level : "0"
/// recharge_user_sum : 0

class Retention {
  Retention({
    num? retention,
    num? bucket,
    num? totalFreeOrder,
    num? freeUser,
    String? checkinLevel,
    num? rechargeUserSum,
  }) {
    _retention = retention;
    _bucket = bucket;
    _totalFreeOrder = totalFreeOrder;
    _freeUser = freeUser;
    _checkinLevel = checkinLevel;
    _rechargeUserSum = rechargeUserSum;
  }

  Retention.fromJson(dynamic json) {
    _retention = json['retention'];
    _bucket = json['bucket'];
    _totalFreeOrder = json['total_free_order'];
    _freeUser = json['free_user'];
    _checkinLevel = json['checkin_level'];
    _rechargeUserSum = json['recharge_user_sum'];
  }
  num? _retention;
  num? _bucket;
  num? _totalFreeOrder;
  num? _freeUser;
  String? _checkinLevel;
  num? _rechargeUserSum;
  Retention copyWith({
    num? retention,
    num? bucket,
    num? totalFreeOrder,
    num? freeUser,
    String? checkinLevel,
    num? rechargeUserSum,
  }) =>
      Retention(
        retention: retention ?? _retention,
        bucket: bucket ?? _bucket,
        totalFreeOrder: totalFreeOrder ?? _totalFreeOrder,
        freeUser: freeUser ?? _freeUser,
        checkinLevel: checkinLevel ?? _checkinLevel,
        rechargeUserSum: rechargeUserSum ?? _rechargeUserSum,
      );
  num? get retention => _retention;
  num? get bucket => _bucket;
  num? get totalFreeOrder => _totalFreeOrder;
  num? get freeUser => _freeUser;
  String? get checkinLevel => _checkinLevel;
  num? get rechargeUserSum => _rechargeUserSum;

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
