/// success : true
/// status : "No resignation application found"
/// data : null
/// is_resign : false
/// status_code : 200
/// message : "No resignation application found"

class ResignationStatus {
  ResignationStatus({
    bool? success,
    String? status,
    dynamic data,
    bool? isResign,
    num? statusCode,
    String? message,
  }) {
    _success = success;
    _status = status;
    _data = data;
    _isResign = isResign;
    _statusCode = statusCode;
    _message = message;
  }

  ResignationStatus.fromJson(dynamic json) {
    _success = json['success'];
    _status = json['status'];
    _data = json['data'];
    _isResign = json['is_resign'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  bool? _success;
  String? _status;
  dynamic _data;
  bool? _isResign;
  num? _statusCode;
  String? _message;
  ResignationStatus copyWith({
    bool? success,
    String? status,
    dynamic data,
    bool? isResign,
    num? statusCode,
    String? message,
  }) =>
      ResignationStatus(
        success: success ?? _success,
        status: status ?? _status,
        data: data ?? _data,
        isResign: isResign ?? _isResign,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  bool? get success => _success;
  String? get status => _status;
  dynamic get data => _data;
  bool? get isResign => _isResign;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['status'] = _status;
    map['data'] = _data;
    map['is_resign'] = _isResign;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}
