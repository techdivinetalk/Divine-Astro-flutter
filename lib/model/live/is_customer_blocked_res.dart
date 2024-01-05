class IsCustomerBlockedRes {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  IsCustomerBlockedRes(
      {this.success, this.statusCode, this.message, this.data});

  IsCustomerBlockedRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? isCustomerBlocked;

  Data({this.isCustomerBlocked});

  Data.fromJson(Map<String, dynamic> json) {
    isCustomerBlocked = json['is_customer_blocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_customer_blocked'] = isCustomerBlocked;
    return data;
  }
}
