class ResOrderHistory {
  List<OrderData>? data;
  bool? success;
  int? statusCode;
  String? message;

  ResOrderHistory({this.data, this.success, this.statusCode, this.message});

  ResOrderHistory.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(OrderData.fromJson(v));
      });
    }
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class OrderData {
  int? orderId;
  int? customerId;
  String? customerName;
  String? customerImage;
  int? customerNo;
  String? customOrderId;
  String? dateTime;
  int? amount;
  String? discount;
  String? callType;
  int? productType;
  String? productName;
  num? gst;
  num? paymentGateway;
  num? totalEarning;
  String? status;
  String? duration;

  OrderData(
      {this.orderId,
      this.customerId,
      this.customerName,
      this.customerImage,
      this.customerNo,
      this.customOrderId,
      this.dateTime,
      this.amount,
      this.discount,
      this.callType,
      this.productType,
      this.productName,
      this.gst,
      this.paymentGateway,
      this.totalEarning,
      this.status,
      this.duration});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerImage = json['customer_image'];
    customerNo = json['customer_no'];
    customOrderId = json['custom_order_id'];
    dateTime = json['date_time'];
    amount = json['amount'];
    discount = json['discount'];
    callType = json['call_type'];
    productType = json['product_type'];
    productName = json['product_name'];
    gst = json['gst'];
    paymentGateway = json['payment_gateway'];
    totalEarning = json['total_earning'];
    status = json['status'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['customer_image'] = customerImage;
    data['customer_no'] = customerNo;
    data['custom_order_id'] = customOrderId;
    data['date_time'] = dateTime;
    data['amount'] = amount;
    data['discount'] = discount;
    data['call_type'] = callType;
    data['product_type'] = productType;
    data['product_name'] = productName;
    data['gst'] = gst;
    data['payment_gateway'] = paymentGateway;
    data['total_earning'] = totalEarning;
    data['status'] = status;
    data['duration'] = duration;
    return data;
  }
}
