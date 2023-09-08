class ResCommonChatStatus {
  bool? success;
  int? statusCode;
  String? message;

  ResCommonChatStatus({this.success, this.statusCode, this.message});

  ResCommonChatStatus.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}
