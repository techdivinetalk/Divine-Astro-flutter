/// title : "Initiate Voice Call?"
/// description : "<p>You are about to initiate a 2-minute voice call with the user. Please note:</p>\r\n                            <ul>\r\n                                <li>You can use this call once per day.</li>\r\n                                <li>Sharing personal contact details is not allowed.</li>\r\n                                <li>The call will automatically end after 2 minutes.</li>\r\n                                <li>You can only call 2 users per day on chat assistance.</li>\r\n                                <li>Do not show this message again.</li>\r\n                            </ul>"
/// success : true
/// status_code : 200
/// message : "Voice call initiation message returned successfully"

class CheckingAssistantCallModel {
  CheckingAssistantCallModel({
    String? title,
    String? description,
    bool? success,
    num? statusCode,
    String? message,
  }) {
    _title = title;
    _description = description;
    _success = success;
    _statusCode = statusCode;
    _message = message;
  }

  CheckingAssistantCallModel.fromJson(dynamic json) {
    _title = json['title'];
    _description = json['description'];
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  String? _title;
  String? _description;
  bool? _success;
  num? _statusCode;
  String? _message;
  CheckingAssistantCallModel copyWith({
    String? title,
    String? description,
    bool? success,
    num? statusCode,
    String? message,
  }) =>
      CheckingAssistantCallModel(
        title: title ?? _title,
        description: description ?? _description,
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  String? get title => _title;
  String? get description => _description;
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['description'] = _description;
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}
