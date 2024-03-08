import 'dart:convert';

PayoutDetails payoutDetailsModelClassFromJson(String str) =>
    PayoutDetails.fromJson(json.decode(str));

String payoutDetailsModelClassToJson(PayoutDetails data) =>
    json.encode(data.toJson());

class PayoutDetails {
  Data? data;
  final bool? success;
  final int? statusCode;
  final String? message;

  PayoutDetails({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory PayoutDetails.fromJson(Map<String, dynamic> json) {
    return PayoutDetails(
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data?.toJson(),
      'success': success,
      'status_code': statusCode,
      'message': message,
    };
  }
}

class Data {
  final TotalAmountEarned totalAmountEarned;
  final double payoutPending;
  final ProductRevenue productRevenue;
  final WeeklyOrder weeklyOrder;
  final ProductSold productSold;
  final CallPickup callPickup;
  final Ratings ratings;
  final List<PaymentLog> paymentLog;
  final double tds;
  final double totalPaymentGatewayCharges;

  Data({
    required this.totalAmountEarned,
    required this.payoutPending,
    required this.productRevenue,
    required this.weeklyOrder,
    required this.productSold,
    required this.callPickup,
    required this.ratings,
    required this.paymentLog,
    required this.tds,
    required this.totalPaymentGatewayCharges,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      totalAmountEarned: TotalAmountEarned.fromJson(json['total_amount_earned']),
      payoutPending: json['payout_pending'],
      productRevenue: ProductRevenue.fromJson(json['product_revenue']),
      weeklyOrder: WeeklyOrder.fromJson(json['weekly_order']),
      productSold: ProductSold.fromJson(json['product_sold']),
      callPickup: CallPickup.fromJson(json['call_pickup']),
      ratings: Ratings.fromJson(json['ratings']),
      paymentLog: List<PaymentLog>.from(json['payment_log'].map((log) => PaymentLog.fromJson(log))),
      tds: json['tds'],
      totalPaymentGatewayCharges: json['total_payment_gateway_charges'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_amount_earned': totalAmountEarned.toJson(),
      'payout_pending': payoutPending,
      'product_revenue': productRevenue.toJson(),
      'weekly_order': weeklyOrder.toJson(),
      'product_sold': productSold.toJson(),
      'call_pickup': callPickup.toJson(),
      'ratings': ratings.toJson(),
      'payment_log': List<dynamic>.from(paymentLog.map((log) => log.toJson())),
      'tds': tds,
      'total_payment_gateway_charges': totalPaymentGatewayCharges,
    };
  }
}

class TotalAmountEarned {
  final double amountEarned;
  final int percentage;
  final String increaseDecrease;

  TotalAmountEarned({
    required this.amountEarned,
    required this.percentage,
    required this.increaseDecrease,
  });

  factory TotalAmountEarned.fromJson(Map<String, dynamic> json) {
    return TotalAmountEarned(
      amountEarned: json['amount_earned'],
      percentage: json['percentage'],
      increaseDecrease: json['increase/decrease'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount_earned': amountEarned,
      'percentage': percentage,
      'increase/decrease': increaseDecrease,
    };
  }
}

class ProductRevenue {
  final double amount;
  final int percentage;
  final String increaseDecrease;

  ProductRevenue({
    required this.amount,
    required this.percentage,
    required this.increaseDecrease,
  });

  factory ProductRevenue.fromJson(Map<String, dynamic> json) {
    return ProductRevenue(
      amount: json['amount'],
      percentage: json['percentage'],
      increaseDecrease: json['increase/decrease'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'percentage': percentage,
      'increase/decrease': increaseDecrease,
    };
  }
}

class WeeklyOrder {
  final int count;
  final int percentage;
  final String increaseDecrease;

  WeeklyOrder({
    required this.count,
    required this.percentage,
    required this.increaseDecrease,
  });

  factory WeeklyOrder.fromJson(Map<String, dynamic> json) {
    return WeeklyOrder(
      count: json['count'],
      percentage: json['percentage'],
      increaseDecrease: json['increase/decrease'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'percentage': percentage,
      'increase/decrease': increaseDecrease,
    };
  }
}

class ProductSold {
  final int count;
  final int percentage;
  final String increaseDecrease;

  ProductSold({
    required this.count,
    required this.percentage,
    required this.increaseDecrease,
  });

  factory ProductSold.fromJson(Map<String, dynamic> json) {
    return ProductSold(
      count: json['count'],
      percentage: json['percentage'],
      increaseDecrease: json['increase/decrease'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'percentage': percentage,
      'increase/decrease': increaseDecrease,
    };
  }
}

class CallPickup {
  final int count;
  final int percentage;
  final String increaseDecrease;

  CallPickup({
    required this.count,
    required this.percentage,
    required this.increaseDecrease,
  });

  factory CallPickup.fromJson(Map<String, dynamic> json) {
    return CallPickup(
      count: json['count'],
      percentage: json['percentage'],
      increaseDecrease: json['increase/decrease'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'percentage': percentage,
      'increase/decrease': increaseDecrease,
    };
  }
}

class Ratings {
  final int? count;
  final int percentage;
  final String increaseDecrease;

  Ratings({
    required this.count,
    required this.percentage,
    required this.increaseDecrease,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      count: json['count'],
      percentage: json['percentage'],
      increaseDecrease: json['increase/decrease'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'percentage': percentage,
      'increase/decrease': increaseDecrease,
    };
  }
}

class PaymentLog {
  final int id;
  final String payoutFor;
  final double tax;
  final double paymentGateway;
  final double totalAmount;
  final String status;
  final String date;
  final double actualPayments;
  final String discount;
  final String orderId;
  final String callDuration;
  final String callStatus;
  final CustomerDetails customerDetails;

  PaymentLog({
    required this.id,
    required this.payoutFor,
    required this.tax,
    required this.paymentGateway,
    required this.totalAmount,
    required this.status,
    required this.date,
    required this.actualPayments,
    required this.discount,
    required this.orderId,
    required this.callDuration,
    required this.callStatus,
    required this.customerDetails,
  });

  factory PaymentLog.fromJson(Map<String, dynamic> json) {
    return PaymentLog(
      id: json['id'],
      payoutFor: json['payout_for'],
      tax: json['tax'],
      paymentGateway: json['paymet_gateway'],
      totalAmount: json['total_amount'],
      status: json['status'],
      date: json['date'],
      actualPayments: json['actual_payments'],
      discount: json['discount'],
      orderId: json['order_id'],
      callDuration: json['call_duration'],
      callStatus: json['call_status'],
      customerDetails: CustomerDetails.fromJson(json['customer_details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payout_for': payoutFor,
      'tax': tax,
      'paymet_gateway': paymentGateway,
      'total_amount': totalAmount,
      'status': status,
      'date': date,
      'actual_payments': actualPayments,
      'discount': discount,
      'order_id': orderId,
      'call_duration': callDuration,
      'call_status': callStatus,
      'customer_details': customerDetails.toJson(),
    };
  }
}

class CustomerDetails {
  final int id;
  final String name;
  final String avatar;

  CustomerDetails({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }
}
