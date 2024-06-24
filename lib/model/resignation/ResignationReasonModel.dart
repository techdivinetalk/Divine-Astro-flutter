/// success : true
/// data : [{"id":1,"reason":"other","have_comment":true,"created_at":null,"updated_at":null},{"id":2,"reason":"Ab man nhi hai","have_comment":false,"created_at":null,"updated_at":null},{"id":3,"reason":"Dil bhar gya","have_comment":false,"created_at":null,"updated_at":null}]
/// status_code : 200
/// message : "Resignation Resons Fetch successfully"

class ResignationReasonModel {
  ResignationReasonModel({
    bool? success,
    List<Data>? data,
    num? statusCode,
    String? message,
  }) {
    _success = success;
    _data = data;
    _statusCode = statusCode;
    _message = message;
  }

  ResignationReasonModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  bool? _success;
  List<Data>? _data;
  num? _statusCode;
  String? _message;
  ResignationReasonModel copyWith({
    bool? success,
    List<Data>? data,
    num? statusCode,
    String? message,
  }) =>
      ResignationReasonModel(
        success: success ?? _success,
        data: data ?? _data,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  bool? get success => _success;
  List<Data>? get data => _data;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}

/// id : 1
/// reason : "other"
/// have_comment : true
/// created_at : null
/// updated_at : null

class Data {
  Data({
    num? id,
    String? reason,
    bool? haveComment,
    dynamic createdAt,
    dynamic updatedAt,
  }) {
    _id = id;
    _reason = reason;
    _haveComment = haveComment;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _reason = json['reason'];
    _haveComment = json['have_comment'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _reason;
  bool? _haveComment;
  dynamic _createdAt;
  dynamic _updatedAt;
  Data copyWith({
    num? id,
    String? reason,
    bool? haveComment,
    dynamic createdAt,
    dynamic updatedAt,
  }) =>
      Data(
        id: id ?? _id,
        reason: reason ?? _reason,
        haveComment: haveComment ?? _haveComment,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  String? get reason => _reason;
  bool? get haveComment => _haveComment;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['reason'] = _reason;
    map['have_comment'] = _haveComment;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
