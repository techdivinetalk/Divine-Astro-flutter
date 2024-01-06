class BlockedCustomerRes {
  bool? success;
  int? statusCode;
  String? message;

  BlockedCustomerRes({this.success, this.statusCode, this.message});

  BlockedCustomerRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}
