/// data : [{"id":1299,"recharge_amount":20000,"remark":"Paras Sir","created_at":"2023-09-07T17:48:34.000000Z","is_payment_done":0,"razorpay_transaction_id":null,"status":null,"is_gift":0,"wallet_type":0,"reward_grant_date":null},{"id":1298,"recharge_amount":1,"remark":"Test","created_at":"2023-09-07T17:46:16.000000Z","is_payment_done":0,"razorpay_transaction_id":null,"status":null,"is_gift":0,"wallet_type":0,"reward_grant_date":null}]
/// success : true
/// status_code : 200
/// message : "Order history successfully fetched"

class RefundLogsModel {
  RefundLogsModel({
    List<RefundLogsModelList>? data,
    bool? success,
    num? statusCode,
    String? message,
  }) {
    _data = data;
    _success = success;
    _statusCode = statusCode;
    _message = message;
  }

  RefundLogsModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(RefundLogsModelList.fromJson(v));
      });
    }
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  List<RefundLogsModelList>? _data;
  bool? _success;
  num? _statusCode;
  String? _message;
  RefundLogsModel copyWith({
    List<RefundLogsModelList>? data,
    bool? success,
    num? statusCode,
    String? message,
  }) =>
      RefundLogsModel(
        data: data ?? _data,
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  List<RefundLogsModelList>? get data => _data;
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}

/// id : 1299
/// recharge_amount : 20000
/// remark : "Paras Sir"
/// created_at : "2023-09-07T17:48:34.000000Z"
/// is_payment_done : 0
/// razorpay_transaction_id : null
/// status : null
/// is_gift : 0
/// wallet_type : 0
/// reward_grant_date : null

class RefundLogsModelList {
  RefundLogsModelList({
    num? id,
    num? rechargeAmount,
    String? remark,
    String? createdAt,
    num? isPaymentDone,
    dynamic razorpayTransactionId,
    dynamic status,
    num? isGift,
    num? walletType,
    dynamic rewardGrantDate,
  }) {
    _id = id;
    _rechargeAmount = rechargeAmount;
    _remark = remark;
    _createdAt = createdAt;
    _isPaymentDone = isPaymentDone;
    _razorpayTransactionId = razorpayTransactionId;
    _status = status;
    _isGift = isGift;
    _walletType = walletType;
    _rewardGrantDate = rewardGrantDate;
  }

  RefundLogsModelList.fromJson(dynamic json) {
    _id = json['id'];
    _rechargeAmount = json['recharge_amount'];
    _remark = json['remark'];
    _createdAt = json['created_at'];
    _isPaymentDone = json['is_payment_done'];
    _razorpayTransactionId = json['razorpay_transaction_id'];
    _status = json['status'];
    _isGift = json['is_gift'];
    _walletType = json['wallet_type'];
    _rewardGrantDate = json['reward_grant_date'];
  }
  num? _id;
  num? _rechargeAmount;
  String? _remark;
  String? _createdAt;
  num? _isPaymentDone;
  dynamic _razorpayTransactionId;
  dynamic _status;
  num? _isGift;
  num? _walletType;
  dynamic _rewardGrantDate;
  RefundLogsModelList copyWith({
    num? id,
    num? rechargeAmount,
    String? remark,
    String? createdAt,
    num? isPaymentDone,
    dynamic razorpayTransactionId,
    dynamic status,
    num? isGift,
    num? walletType,
    dynamic rewardGrantDate,
  }) =>
      RefundLogsModelList(
        id: id ?? _id,
        rechargeAmount: rechargeAmount ?? _rechargeAmount,
        remark: remark ?? _remark,
        createdAt: createdAt ?? _createdAt,
        isPaymentDone: isPaymentDone ?? _isPaymentDone,
        razorpayTransactionId: razorpayTransactionId ?? _razorpayTransactionId,
        status: status ?? _status,
        isGift: isGift ?? _isGift,
        walletType: walletType ?? _walletType,
        rewardGrantDate: rewardGrantDate ?? _rewardGrantDate,
      );
  num? get id => _id;
  num? get rechargeAmount => _rechargeAmount;
  String? get remark => _remark;
  String? get createdAt => _createdAt;
  num? get isPaymentDone => _isPaymentDone;
  dynamic get razorpayTransactionId => _razorpayTransactionId;
  dynamic get status => _status;
  num? get isGift => _isGift;
  num? get walletType => _walletType;
  dynamic get rewardGrantDate => _rewardGrantDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['recharge_amount'] = _rechargeAmount;
    map['remark'] = _remark;
    map['created_at'] = _createdAt;
    map['is_payment_done'] = _isPaymentDone;
    map['razorpay_transaction_id'] = _razorpayTransactionId;
    map['status'] = _status;
    map['is_gift'] = _isGift;
    map['wallet_type'] = _walletType;
    map['reward_grant_date'] = _rewardGrantDate;
    return map;
  }
}
