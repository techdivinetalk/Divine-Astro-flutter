/// data : [{"id":127978,"astrologer_id":2129,"amount":"20.00","order_id":9862181,"fine_type":1,"created_at":"2024-09-26T14:59:25.000000Z","is_payment_done":0,"status":null,"is_ignore":0,"get_order":{"id":9862181,"amount":0,"status":"busy","order_id":"FAUDIO1727362716305395","created_at":"2024-09-26 20:28:36","product_type":7,"product_type_name":"exotel_audio_call"}},{"id":127971,"astrologer_id":2129,"amount":"20.00","order_id":9861982,"fine_type":1,"created_at":"2024-09-26T14:45:46.000000Z","is_payment_done":0,"status":null,"is_ignore":0,"get_order":{"id":9861982,"amount":0,"status":"busy","order_id":"FAUDIO1727361908802005","created_at":"2024-09-26 20:15:08","product_type":7,"product_type_name":"exotel_audio_call"}},{"id":127891,"astrologer_id":2129,"amount":"20.00","order_id":9859689,"fine_type":1,"created_at":"2024-09-26T11:37:37.000000Z","is_payment_done":0,"status":null,"is_ignore":0,"get_order":{"id":9859689,"amount":0,"status":"busy","order_id":"FAUDIO1727350585616874","created_at":"2024-09-26 17:06:25","product_type":7,"product_type_name":"exotel_audio_call"}},{"id":127889,"astrologer_id":2129,"amount":"20.00","order_id":9859635,"fine_type":1,"created_at":"2024-09-26T11:36:12.000000Z","is_payment_done":0,"status":null,"is_ignore":0,"get_order":{"id":9859635,"amount":0,"status":"busy","order_id":"FAUDIO1727350427212846","created_at":"2024-09-26 17:03:47","product_type":7,"product_type_name":"exotel_audio_call"}},{"id":127856,"astrologer_id":2129,"amount":"20.00","order_id":9859057,"fine_type":1,"created_at":"2024-09-26T10:53:23.000000Z","is_payment_done":0,"status":null,"is_ignore":0,"get_order":{"id":9859057,"amount":0,"status":"busy","order_id":"FAUDIO1727347957861822","created_at":"2024-09-26 16:22:37","product_type":7,"product_type_name":"exotel_audio_call"}},{"id":127853,"astrologer_id":2129,"amount":"20.00","order_id":9858884,"fine_type":1,"created_at":"2024-09-26T10:39:12.000000Z","is_payment_done":0,"status":null,"is_ignore":0,"get_order":{"id":9858884,"amount":0,"status":"busy","order_id":"FAUDIO1727347078522381","created_at":"2024-09-26 16:07:58","product_type":7,"product_type_name":"exotel_audio_call"}},{"id":127851,"astrologer_id":2129,"amount":"20.00","order_id":9858826,"fine_type":1,"created_at":"2024-09-26T10:36:04.000000Z","is_payment_done":0,"status":null,"is_ignore":0,"get_order":{"id":9858826,"amount":0,"status":"busy","order_id":"FAUDIO1727346831526315","created_at":"2024-09-26 16:03:51","product_type":7,"product_type_name":"exotel_audio_call"}},{"id":127813,"astrologer_id":2129,"amount":"20.00","order_id":9857866,"fine_type":1,"created_at":"2024-09-26T09:31:01.000000Z","is_payment_done":0,"status":null,"is_ignore":0,"get_order":{"id":9857866,"amount":0,"status":"busy","order_id":"FAUDIO1727342988629431","created_at":"2024-09-26 14:59:48","product_type":7,"product_type_name":"exotel_audio_call"}},{"id":127809,"astrologer_id":2129,"amount":"20.00","order_id":9857746,"fine_type":1,"created_at":"2024-09-26T09:23:38.000000Z","is_payment_done":0,"status":null,"is_ignore":0,"get_order":{"id":9857746,"amount":0,"status":"busy","order_id":"FAUDIO1727342545296922","created_at":"2024-09-26 14:52:25","product_type":7,"product_type_name":"exotel_audio_call"}},{"id":127807,"astrologer_id":2129,"amount":"20.00","order_id":9857721,"fine_type":1,"created_at":"2024-09-26T09:21:43.000000Z","is_payment_done":0,"status":null,"is_ignore":0,"get_order":{"id":9857721,"amount":0,"status":"busy","order_id":"FAUDIO1727342459343627","created_at":"2024-09-26 14:50:59","product_type":7,"product_type_name":"exotel_audio_call"}}]
/// success : true
/// status_code : 200
/// message : "Order history successfully fetched"

class FineOrderHistroyModel {
  FineOrderHistroyModel({
    List<FineData>? data,
    bool? success,
    num? statusCode,
    String? message,
  }) {
    _data = data;
    _success = success;
    _statusCode = statusCode;
    _message = message;
  }

  FineOrderHistroyModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(FineData.fromJson(v));
      });
    }
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  List<FineData>? _data;
  bool? _success;
  num? _statusCode;
  String? _message;
  FineOrderHistroyModel copyWith({
    List<FineData>? data,
    bool? success,
    num? statusCode,
    String? message,
  }) =>
      FineOrderHistroyModel(
        data: data ?? _data,
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  List<FineData>? get data => _data;
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

/// id : 127978
/// astrologer_id : 2129
/// amount : "20.00"
/// order_id : 9862181
/// fine_type : 1
/// created_at : "2024-09-26T14:59:25.000000Z"
/// is_payment_done : 0
/// status : null
/// is_ignore : 0
/// get_order : {"id":9862181,"amount":0,"status":"busy","order_id":"FAUDIO1727362716305395","created_at":"2024-09-26 20:28:36","product_type":7,"product_type_name":"exotel_audio_call"}

class FineData {
  FineData({
    num? id,
    num? astrologerId,
    String? amount,
    num? orderId,
    num? fineType,
    String? createdAt,
    num? isPaymentDone,
    dynamic status,
    num? isIgnore,
    GetOrder? getOrder,
  }) {
    _id = id;
    _astrologerId = astrologerId;
    _amount = amount;
    _orderId = orderId;
    _fineType = fineType;
    _createdAt = createdAt;
    _isPaymentDone = isPaymentDone;
    _status = status;
    _isIgnore = isIgnore;
    _getOrder = getOrder;
  }

  FineData.fromJson(dynamic json) {
    _id = json['id'];
    _astrologerId = json['astrologer_id'];
    _amount = json['amount'];
    _orderId = json['order_id'];
    _fineType = json['fine_type'];
    _createdAt = json['created_at'];
    _isPaymentDone = json['is_payment_done'];
    _status = json['status'];
    _isIgnore = json['is_ignore'];
    _getOrder =
        json['get_order'] != null ? GetOrder.fromJson(json['get_order']) : null;
  }
  num? _id;
  num? _astrologerId;
  String? _amount;
  num? _orderId;
  num? _fineType;
  String? _createdAt;
  num? _isPaymentDone;
  dynamic _status;
  num? _isIgnore;
  GetOrder? _getOrder;
  FineData copyWith({
    num? id,
    num? astrologerId,
    String? amount,
    num? orderId,
    num? fineType,
    String? createdAt,
    num? isPaymentDone,
    dynamic status,
    num? isIgnore,
    GetOrder? getOrder,
  }) =>
      FineData(
        id: id ?? _id,
        astrologerId: astrologerId ?? _astrologerId,
        amount: amount ?? _amount,
        orderId: orderId ?? _orderId,
        fineType: fineType ?? _fineType,
        createdAt: createdAt ?? _createdAt,
        isPaymentDone: isPaymentDone ?? _isPaymentDone,
        status: status ?? _status,
        isIgnore: isIgnore ?? _isIgnore,
        getOrder: getOrder ?? _getOrder,
      );
  num? get id => _id;
  num? get astrologerId => _astrologerId;
  String? get amount => _amount;
  num? get orderId => _orderId;
  num? get fineType => _fineType;
  String? get createdAt => _createdAt;
  num? get isPaymentDone => _isPaymentDone;
  dynamic get status => _status;
  num? get isIgnore => _isIgnore;
  GetOrder? get getOrder => _getOrder;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['astrologer_id'] = _astrologerId;
    map['amount'] = _amount;
    map['order_id'] = _orderId;
    map['fine_type'] = _fineType;
    map['created_at'] = _createdAt;
    map['is_payment_done'] = _isPaymentDone;
    map['status'] = _status;
    map['is_ignore'] = _isIgnore;
    if (_getOrder != null) {
      map['get_order'] = _getOrder?.toJson();
    }
    return map;
  }
}

/// id : 9862181
/// amount : 0
/// status : "busy"
/// order_id : "FAUDIO1727362716305395"
/// created_at : "2024-09-26 20:28:36"
/// product_type : 7
/// product_type_name : "exotel_audio_call"

class GetOrder {
  GetOrder({
    num? id,
    num? amount,
    String? status,
    String? orderId,
    String? createdAt,
    num? productType,
    String? productTypeName,
  }) {
    _id = id;
    _amount = amount;
    _status = status;
    _orderId = orderId;
    _createdAt = createdAt;
    _productType = productType;
    _productTypeName = productTypeName;
  }

  GetOrder.fromJson(dynamic json) {
    _id = json['id'];
    _amount = json['amount'];
    _status = json['status'];
    _orderId = json['order_id'];
    _createdAt = json['created_at'];
    _productType = json['product_type'];
    _productTypeName = json['product_type_name'];
  }
  num? _id;
  num? _amount;
  String? _status;
  String? _orderId;
  String? _createdAt;
  num? _productType;
  String? _productTypeName;
  GetOrder copyWith({
    num? id,
    num? amount,
    String? status,
    String? orderId,
    String? createdAt,
    num? productType,
    String? productTypeName,
  }) =>
      GetOrder(
        id: id ?? _id,
        amount: amount ?? _amount,
        status: status ?? _status,
        orderId: orderId ?? _orderId,
        createdAt: createdAt ?? _createdAt,
        productType: productType ?? _productType,
        productTypeName: productTypeName ?? _productTypeName,
      );
  num? get id => _id;
  num? get amount => _amount;
  String? get status => _status;
  String? get orderId => _orderId;
  String? get createdAt => _createdAt;
  num? get productType => _productType;
  String? get productTypeName => _productTypeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['amount'] = _amount;
    map['status'] = _status;
    map['order_id'] = _orderId;
    map['created_at'] = _createdAt;
    map['product_type'] = _productType;
    map['product_type_name'] = _productTypeName;
    return map;
  }
}
