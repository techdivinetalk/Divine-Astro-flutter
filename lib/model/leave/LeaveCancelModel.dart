/// success : true
/// status_code : 200
/// message : "Leave application has been canceled"

class LeaveCancelModel {
  LeaveCancelModel({
    bool? success,
    int? statusCode,
    String? message,
  }) {
    _success = success;
    _statusCode = statusCode;
    _message = message;
  }

  LeaveCancelModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  bool? _success;
  int? _statusCode;
  String? _message;
  LeaveCancelModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
  }) =>
      LeaveCancelModel(
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  bool? get success => _success;
  int? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}
