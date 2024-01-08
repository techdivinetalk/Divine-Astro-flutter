class UpdateMessageTemplateResponse {
  bool? success;
  int? statusCode;
  String? message;

  UpdateMessageTemplateResponse({this.success, this.statusCode, this.message});

  UpdateMessageTemplateResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}
