class SaveRemediesResponse {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  SaveRemediesResponse(
      {this.data, this.success, this.statusCode, this.message});

  SaveRemediesResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? orderId;
  int? partnerId;
  int? customerId;
  int? shopId;
  int? productId;
  int? isConfirm;
  String? status;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.orderId,
        this.partnerId,
        this.customerId,
        this.shopId,
        this.productId,
        this.isConfirm,
        this.status,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    partnerId = json['partner_id'];
    customerId = json['customer_id'];
    shopId = json['shop_id'];
    productId = json['product_id'];
    isConfirm = json['is_confirm'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['partner_id'] = this.partnerId;
    data['customer_id'] = this.customerId;
    data['shop_id'] = this.shopId;
    data['product_id'] = this.productId;
    data['is_confirm'] = this.isConfirm;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
