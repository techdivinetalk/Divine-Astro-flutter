/// data : {"type":"good","message":"test"}
/// success : true
/// status_code : 200
/// message : "Retention data successfully sent"

class RitentionPopupModel {
  RitentionPopupModel({
    Data? data,
    bool? success,
    num? statusCode,
    String? message,
  }) {
    _data = data;
    _success = success;
    _statusCode = statusCode;
    _message = message;
  }

  RitentionPopupModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  Data? _data;
  bool? _success;
  num? _statusCode;
  String? _message;
  RitentionPopupModel copyWith({
    Data? data,
    bool? success,
    num? statusCode,
    String? message,
  }) =>
      RitentionPopupModel(
        data: data ?? _data,
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  Data? get data => _data;
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}

/// type : "good"
/// message : "test"

class Data {
  Data({
    String? type,
    String? message,
  }) {
    _type = type;
    _message = message;
  }

  Data.fromJson(dynamic json) {
    _type = json['type'];
    _message = json['message'];
  }
  String? _type;
  String? _message;
  Data copyWith({
    String? type,
    String? message,
  }) =>
      Data(
        type: type ?? _type,
        message: message ?? _message,
      );
  String? get type => _type;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['message'] = _message;
    return map;
  }
}
