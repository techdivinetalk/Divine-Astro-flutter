/// success : true
/// data : {"astrologer_id":2129,"reason_id":1,"comment":"Personal reasons","status":"pending","updated_at":"2024-06-20T11:32:26.000000Z","created_at":"2024-06-20T11:32:26.000000Z","id":2}
/// status_code : 201
/// message : "Resignation application submitted successfully"

class ResignationSubmitModel {
  ResignationSubmitModel({
    final bool? success,
    final SubmitData? data,
    final int? statusCode,
    final String? message,
  }) {
    _success = success;
    _data = data;
    _statusCode = statusCode;
    _message = message;
  }

  ResignationSubmitModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? SubmitData.fromJson(json['data']) : null;
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  bool? _success;
  SubmitData? _data;
  int? _statusCode;
  String? _message;
  ResignationSubmitModel copyWith({
    bool? success,
    SubmitData? data,
    int? statusCode,
    String? message,
  }) =>
      ResignationSubmitModel(
        success: success ?? _success,
        data: data ?? _data,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  bool? get success => _success;
  SubmitData? get data => _data;
  int? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}

/// astrologer_id : 2129
/// reason_id : 1
/// comment : "Personal reasons"
/// status : "pending"
/// updated_at : "2024-06-20T11:32:26.000000Z"
/// created_at : "2024-06-20T11:32:26.000000Z"
/// id : 2

class SubmitData {
  SubmitData({
    var astrologerId,
    var reasonId,
    final String? comment,
    final String? status,
    final String? updatedAt,
    final String? createdAt,
    var id,
  }) {
    _astrologerId = astrologerId;
    _reasonId = reasonId;
    _comment = comment;
    _status = status;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
  }

  SubmitData.fromJson(dynamic json) {
    _astrologerId = json['astrologer_id'];
    _reasonId = json['reason_id'];
    _comment = json['comment'];
    _status = json['status'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }
  var _astrologerId;
  var _reasonId;
  String? _comment;
  String? _status;
  String? _updatedAt;
  String? _createdAt;
  var _id;
  SubmitData copyWith({
    var astrologerId,
    var reasonId,
    String? comment,
    String? status,
    String? updatedAt,
    String? createdAt,
    var id,
  }) =>
      SubmitData(
        astrologerId: astrologerId ?? _astrologerId,
        reasonId: reasonId ?? _reasonId,
        comment: comment ?? _comment,
        status: status ?? _status,
        updatedAt: updatedAt ?? _updatedAt,
        createdAt: createdAt ?? _createdAt,
        id: id ?? _id,
      );
  get astrologerId => _astrologerId;
  get reasonId => _reasonId;
  String? get comment => _comment;
  String? get status => _status;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['astrologer_id'] = _astrologerId;
    map['reason_id'] = _reasonId;
    map['comment'] = _comment;
    map['status'] = _status;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }
}
