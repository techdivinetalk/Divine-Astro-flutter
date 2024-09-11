class WaitingListQueueModel {
  final List<WaitingListQueueData>? data;
  final bool? success;
  final int? statusCode;
  final String? message;

  WaitingListQueueModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  WaitingListQueueModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((dynamic e) => WaitingListQueueData.fromJson(e as Map<String,dynamic>)).toList(),
        success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'data' : data?.map((e) => e.toJson()).toList(),
    'success' : success,
    'status_code' : statusCode,
    'message' : message
  };
}

class WaitingListQueueData {
  final int? id;
  final int? customerId;
  final int? sequence;
  final int? talkMinute;
  final String? status;
  final int? waitTime;
  final int? isCall;
  final int? orderId;
  final GetCustomers? getCustomers;

  WaitingListQueueData({
    this.id,
    this.customerId,
    this.sequence,
    this.talkMinute,
    this.status,
    this.waitTime,
    this.isCall,
    this.orderId,
    this.getCustomers,
  });

  WaitingListQueueData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        customerId = json['customer_id'] as int?,
        sequence = json['sequence'] as int?,
        talkMinute = json['talk_minute'] as int?,
        status = json['status'] as String?,
        waitTime = json['wait_time'] as int?,
        isCall = json['is_call'] as int?,
        orderId = json['order_id'] as int?,
        getCustomers = (json['get_customers'] as Map<String,dynamic>?) != null ? GetCustomers.fromJson(json['get_customers'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'customer_id' : customerId,
    'sequence' : sequence,
    'talk_minute' : talkMinute,
    'status' : status,
    'wait_time' : waitTime,
    'is_call' : isCall,
    'order_id' : orderId,
    'get_customers' : getCustomers?.toJson()
  };
}

class GetCustomers {
  final int? id;
  final String? name;
  final String? avatar;
  final int? mobileNo;
  final int? gender;
  final dynamic level;

  GetCustomers({
    this.id,
    this.name,
    this.avatar,
    this.mobileNo,
    this.gender,
    this.level,
  });

  GetCustomers.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        avatar = json['avatar'] as String?,
        mobileNo = json['mobile_no'] as int?,
        gender = json['gender'] as int?,
        level = json['level'] as dynamic;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'avatar' : avatar,
    'mobile_no' : mobileNo,
    'gender' : gender,
    'level' : level,
  };
}