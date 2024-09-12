/// data : [{"meeting_date":"2024-09-03","detail":[{"id":2,"meeting_time":"09:00:00"},{"id":3,"meeting_time":"09:00:00"}]},{"meeting_date":"2024-09-04","detail":[{"id":4,"meeting_time":"09:00:00"},{"id":5,"meeting_time":"09:00:00"}]}]
/// success : true
/// status_code : 200
/// message : "Schedule meetings retrieved successfully"

class AstroTrainingSessionModel {
  AstroTrainingSessionModel({
    List<Data>? data,
    bool? success,
    num? statusCode,
    String? message,
  }) {
    _data = data;
    _success = success;
    _statusCode = statusCode;
    _message = message;
  }

  AstroTrainingSessionModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  List<Data>? _data;
  bool? _success;
  num? _statusCode;
  String? _message;
  AstroTrainingSessionModel copyWith({
    List<Data>? data,
    bool? success,
    num? statusCode,
    String? message,
  }) =>
      AstroTrainingSessionModel(
        data: data ?? _data,
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  List<Data>? get data => _data;
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}

/// meeting_date : "2024-09-03"
/// detail : [{"id":2,"meeting_time":"09:00:00"},{"id":3,"meeting_time":"09:00:00"}]

class Data {
  Data({
    String? meetingDate,
    List<Detail>? detail,
  }) {
    _meetingDate = meetingDate;
    _detail = detail;
  }

  Data.fromJson(dynamic json) {
    _meetingDate = json['meeting_date'];
    if (json['detail'] != null) {
      _detail = [];
      json['detail'].forEach((v) {
        _detail?.add(Detail.fromJson(v));
      });
    }
  }
  String? _meetingDate;
  List<Detail>? _detail;
  Data copyWith({
    String? meetingDate,
    List<Detail>? detail,
  }) =>
      Data(
        meetingDate: meetingDate ?? _meetingDate,
        detail: detail ?? _detail,
      );
  String? get meetingDate => _meetingDate;
  List<Detail>? get detail => _detail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['meeting_date'] = _meetingDate;
    if (_detail != null) {
      map['detail'] = _detail?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 2
/// meeting_time : "09:00:00"

class Detail {
  Detail({
    num? id,
    String? meetingTime,
  }) {
    _id = id;
    _meetingTime = meetingTime;
  }

  Detail.fromJson(dynamic json) {
    _id = json['id'];
    _meetingTime = json['meeting_time'];
  }
  num? _id;
  String? _meetingTime;
  Detail copyWith({
    num? id,
    String? meetingTime,
  }) =>
      Detail(
        id: id ?? _id,
        meetingTime: meetingTime ?? _meetingTime,
      );
  num? get id => _id;
  String? get meetingTime => _meetingTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['meeting_time'] = _meetingTime;
    return map;
  }
}
