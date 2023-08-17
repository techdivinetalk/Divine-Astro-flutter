class ResReviewReply {
  ReplyData? data;
  bool? success;
  int? statusCode;
  String? message;

  ResReviewReply({this.data, this.success, this.statusCode, this.message});

  ResReviewReply.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ReplyData.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class ReplyData {
  int? customerId;
  int? astrologerId;
  int? parentId;
  String? type;
  String? comment;
  int? isAnonymous;
  num? rating;
  int? orderId;
  String? updatedAt;
  String? createdAt;
  int? id;

  ReplyData(
      {this.customerId,
      this.astrologerId,
      this.parentId,
      this.type,
      this.comment,
      this.isAnonymous,
      this.rating,
      this.orderId,
      this.updatedAt,
      this.createdAt,
      this.id});

  ReplyData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    astrologerId = json['astrologer_id'];
    parentId = json['parent_id'];
    type = json['type'];
    comment = json['comment'];
    isAnonymous = json['is_anonymous'];
    rating = json['rating'];
    orderId = json['order_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['astrologer_id'] = astrologerId;
    data['parent_id'] = parentId;
    data['type'] = type;
    data['comment'] = comment;
    data['is_anonymous'] = isAnonymous;
    data['rating'] = rating;
    data['order_id'] = orderId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
