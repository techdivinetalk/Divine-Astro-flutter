/// success : true
/// status_code : 200
/// message : "AstroScreenshot successfully created"
/// data : {"astrologer_id":2129,"screenshot_url":"images/technicalSupport/July2024/gr4D4LBCJ5wOCAoHoSKeLK7dwptd7JsG1ZgYXtFi.png","updated_at":"2024-08-30T08:43:17.000000Z","created_at":"2024-08-30T08:43:17.000000Z","id":1}

class ScreenshotUploadModel {
  ScreenshotUploadModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  ScreenshotUploadModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
ScreenshotUploadModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => ScreenshotUploadModel(  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// astrologer_id : 2129
/// screenshot_url : "images/technicalSupport/July2024/gr4D4LBCJ5wOCAoHoSKeLK7dwptd7JsG1ZgYXtFi.png"
/// updated_at : "2024-08-30T08:43:17.000000Z"
/// created_at : "2024-08-30T08:43:17.000000Z"
/// id : 1

class Data {
  Data({
      num? astrologerId, 
      String? screenshotUrl, 
      String? updatedAt, 
      String? createdAt, 
      num? id,}){
    _astrologerId = astrologerId;
    _screenshotUrl = screenshotUrl;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
}

  Data.fromJson(dynamic json) {
    _astrologerId = json['astrologer_id'];
    _screenshotUrl = json['screenshot_url'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }
  num? _astrologerId;
  String? _screenshotUrl;
  String? _updatedAt;
  String? _createdAt;
  num? _id;
Data copyWith({  num? astrologerId,
  String? screenshotUrl,
  String? updatedAt,
  String? createdAt,
  num? id,
}) => Data(  astrologerId: astrologerId ?? _astrologerId,
  screenshotUrl: screenshotUrl ?? _screenshotUrl,
  updatedAt: updatedAt ?? _updatedAt,
  createdAt: createdAt ?? _createdAt,
  id: id ?? _id,
);
  num? get astrologerId => _astrologerId;
  String? get screenshotUrl => _screenshotUrl;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['astrologer_id'] = _astrologerId;
    map['screenshot_url'] = _screenshotUrl;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }

}