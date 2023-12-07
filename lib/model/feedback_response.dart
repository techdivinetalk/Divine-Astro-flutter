import 'dart:convert';

FeedbackResponse feedbackResponseFromJson(String str) =>
    FeedbackResponse.fromJson(json.decode(str));

String feedbackResponseToJson(FeedbackResponse data) =>
    json.encode(data.toJson());

class FeedbackResponse {
  List<FeedbackData>? data;
  bool? success;
  int? statusCode;
  String? message;

  FeedbackResponse({this.data, this.success, this.statusCode, this.message});

  FeedbackResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FeedbackData>[];
      json['data'].forEach((v) {
        data!.add(new FeedbackData.fromJson(v));
      });
    }
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class FeedbackData {
  int? id;
  int? orderId;
  String? remark;
  String? createdAt;

  FeedbackData({this.id, this.orderId, this.remark, this.createdAt});

  FeedbackData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    remark = json['remark'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['remark'] = this.remark;
    data['created_at'] = this.createdAt;
    return data;
  }
}

