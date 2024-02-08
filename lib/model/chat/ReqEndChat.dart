class ReqEndChat {
  bool? success;
  String? error;
  int? statusCode;
  String? message;

  ReqEndChat({this.success, this.error, this.statusCode, this.message});

  ReqEndChat.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}
