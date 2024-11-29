import 'dart:convert';

class ChatOrderResponse {
  final ChatOrderData? data;
  final bool? success;
  final int? statusCode;
  final String? message;

  ChatOrderResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  ChatOrderResponse.fromJson(Map<String, dynamic> json)
      : data =  (json['data'] as Map<String,dynamic>?) != null ? ChatOrderData.fromJson(json['data'] as Map<String,dynamic>) : null,
        success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
        'data':  data?.toJson(),
        'success': success,
        'status_code': statusCode,
        'message': message
      };
}

class ChatOrderData {
  int id;
  int customerId;
  int sequence;
  int talkMinute;
  int waitTime;
  int isCall;
  int orderId;
  String status;
  Customer getCustomers;

  ChatOrderData({
    required this.id,
    required this.customerId,
    required this.sequence,
    required this.talkMinute,
    required this.waitTime,
    required this.isCall,
    required this.orderId,
    required this.status,
    required this.getCustomers,
  });

  factory ChatOrderData.fromJson(Map<String, dynamic> json) {
    return ChatOrderData(
      id: json['id'],
      customerId: json['customer_id'],
      sequence: json['sequence'],
      talkMinute: json['talk_minute'],
      waitTime: json['wait_time'],
      isCall: json['is_call'],
      orderId: json['order_id'],
      status: json['status'],
      getCustomers: Customer.fromJson(json['get_customers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'sequence': sequence,
      'talk_minute': talkMinute,
      'wait_time': waitTime,
      'is_call': isCall,
      'order_id': orderId,
      'status': status,
      'get_customers': getCustomers.toJson(),
    };
  }
}

class Customer {
  int id;
  String name;
  String avatar;
  int mobileNo;
  int gender;

  Customer({
    required this.id,
    required this.name,
    required this.avatar,
    required this.mobileNo,
    required this.gender,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      mobileNo: json['mobile_no'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'mobile_no': mobileNo,
      'gender': gender,
    };
  }
}
