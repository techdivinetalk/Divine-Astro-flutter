/// success : true
/// status_code : 200
/// message : "Schedule meeting added successfully"

class SubmitScheduleTrainingModel {
  SubmitScheduleTrainingModel({
    bool? success,
    num? statusCode,
    String? message,
  }) {
    _success = success;
    _statusCode = statusCode;
    _message = message;
  }

  SubmitScheduleTrainingModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  SubmitScheduleTrainingModel copyWith({
    bool? success,
    num? statusCode,
    String? message,
  }) =>
      SubmitScheduleTrainingModel(
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}
