class InsufficientBalModel {
  List<Data>? data;
  bool? success;
  String? error;
  int? statusCode;
  String? message;

  InsufficientBalModel(
      {this.data, this.success, this.error, this.statusCode, this.message});

  InsufficientBalModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? rechargeAmount;
  int? offerAmount;
  int? extraAmount;
  int? percentage;

  Data(
      {this.rechargeAmount,
        this.offerAmount,
        this.extraAmount,
        this.percentage});

  Data.fromJson(Map<String, dynamic> json) {
    rechargeAmount = json['recharge_amount'];
    offerAmount = json['offer_amount'];
    extraAmount = json['extra_amount'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recharge_amount'] = this.rechargeAmount;
    data['offer_amount'] = this.offerAmount;
    data['extra_amount'] = this.extraAmount;
    data['percentage'] = this.percentage;
    return data;
  }
}
