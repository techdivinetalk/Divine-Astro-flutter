class SendOtpModel {
  final Data? data;
  final bool? success;
  final int? statusCode;
  final String? message;

  SendOtpModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  SendOtpModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as Map<String, dynamic>?) != null ||
                (json['data'] as Map<String, dynamic>?) != {}
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'success': success,
        'status_code': statusCode,
        'message': message
      };
}

class Data {
  final String? sessionId;
  dynamic mobileNo;

  Data({
    this.sessionId,
    this.mobileNo,
  });

  Data.fromJson(Map<String, dynamic> json)
      : sessionId = json['session_id'] as String?,
        mobileNo = json['mobile_no'];

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'mobile_no': mobileNo,
      };
}
