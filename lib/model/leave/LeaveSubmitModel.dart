/// success : true
/// data : {"astrologer_id":2129,"leave_reason_id":1,"comment":"Personal reasons","status":"pending","start_date":"2024-07-01","end_date":"2024-08-01","updated_at":"2024-06-25T05:09:31.000000Z","created_at":"2024-06-25T05:09:31.000000Z","id":1}
/// status_code : 201
/// message : "Leave application submitted successfully"

/// success : true
/// data : {"astrologer_id":2129,"reason_id":"2","comment":"Ab man nhi hai","status":"pending","updated_at":"2024-06-25T09:14:34.000000Z","created_at":"2024-06-25T09:14:34.000000Z","id":31}
/// status_code : 201
/// message : "Resignation application submitted successfully"

class LeaveSubmitModel {
  LeaveSubmitModel({
    bool? success,
    Data? data,
    int? statusCode,
    String? message,
  }) {
    _success = success;
    _data = data;
    _statusCode = statusCode;
    _message = message;
  }

  LeaveSubmitModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  bool? _success;
  Data? _data;
  int? _statusCode;
  String? _message;
  LeaveSubmitModel copyWith({
    bool? success,
    Data? data,
    int? statusCode,
    String? message,
  }) =>
      LeaveSubmitModel(
        success: success ?? _success,
        data: data ?? _data,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  bool? get success => _success;
  Data? get data => _data;
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
/// reason_id : "2"
/// comment : "Ab man nhi hai"
/// status : "pending"
/// updated_at : "2024-06-25T09:14:34.000000Z"
/// created_at : "2024-06-25T09:14:34.000000Z"
/// id : 31

class Data {
  Data({
    var astrologerId,
    String? reasonId,
    String? comment,
    String? status,
    String? updatedAt,
    String? createdAt,
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

  Data.fromJson(dynamic json) {
    _astrologerId = json['astrologer_id'];
    _reasonId = json['reason_id'];
    _comment = json['comment'];
    _status = json['status'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }
  var _astrologerId;
  String? _reasonId;
  String? _comment;
  String? _status;
  String? _updatedAt;
  String? _createdAt;
  var _id;
  Data copyWith({
    int? astrologerId,
    String? reasonId,
    String? comment,
    String? status,
    String? updatedAt,
    String? createdAt,
    int? id,
  }) =>
      Data(
        astrologerId: astrologerId ?? _astrologerId,
        reasonId: reasonId ?? _reasonId,
        comment: comment ?? _comment,
        status: status ?? _status,
        updatedAt: updatedAt ?? _updatedAt,
        createdAt: createdAt ?? _createdAt,
        id: id ?? _id,
      );
  get astrologerId => _astrologerId;
  String? get reasonId => _reasonId;
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

// class LeaveSubmitModel {
//   LeaveSubmitModel({
//     bool? success,
//     Data? data,
//     num? statusCode,
//     String? message,
//   }) {
//     _success = success;
//     _data = data;
//     _statusCode = statusCode;
//     _message = message;
//   }
//
//   LeaveSubmitModel.fromJson(dynamic json) {
//     _success = json['success'];
//     _data = json['data'] != null ? Data.fromJson(json['data']) : null;
//     _statusCode = json['status_code'];
//     _message = json['message'];
//   }
//   bool? _success;
//   Data? _data;
//   num? _statusCode;
//   String? _message;
//   LeaveSubmitModel copyWith({
//     bool? success,
//     Data? data,
//     num? statusCode,
//     String? message,
//   }) =>
//       LeaveSubmitModel(
//         success: success ?? _success,
//         data: data ?? _data,
//         statusCode: statusCode ?? _statusCode,
//         message: message ?? _message,
//       );
//   bool? get success => _success;
//   Data? get data => _data;
//   num? get statusCode => _statusCode;
//   String? get message => _message;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['success'] = _success;
//     if (_data != null) {
//       map['data'] = _data?.toJson();
//     }
//     map['status_code'] = _statusCode;
//     map['message'] = _message;
//     return map;
//   }
// }

/// astrologer_id : 2129
/// leave_reason_id : 1
/// comment : "Personal reasons"
/// status : "pending"
/// start_date : "2024-07-01"
/// end_date : "2024-08-01"
/// updated_at : "2024-06-25T05:09:31.000000Z"
/// created_at : "2024-06-25T05:09:31.000000Z"
/// id : 1

// class Data {
//   Data({
//     num? astrologerId,
//     num? leaveReasonId,
//     String? comment,
//     String? status,
//     String? startDate,
//     String? endDate,
//     String? updatedAt,
//     String? createdAt,
//     num? id,
//   }) {
//     _astrologerId = astrologerId;
//     _leaveReasonId = leaveReasonId;
//     _comment = comment;
//     _status = status;
//     _startDate = startDate;
//     _endDate = endDate;
//     _updatedAt = updatedAt;
//     _createdAt = createdAt;
//     _id = id;
//   }
//
//   Data.fromJson(dynamic json) {
//     _astrologerId = json['astrologer_id'];
//     _leaveReasonId = json['leave_reason_id'];
//     _comment = json['comment'];
//     _status = json['status'];
//     _startDate = json['start_date'];
//     _endDate = json['end_date'];
//     _updatedAt = json['updated_at'];
//     _createdAt = json['created_at'];
//     _id = json['id'];
//   }
//   num? _astrologerId;
//   num? _leaveReasonId;
//   String? _comment;
//   String? _status;
//   String? _startDate;
//   String? _endDate;
//   String? _updatedAt;
//   String? _createdAt;
//   num? _id;
//   Data copyWith({
//     num? astrologerId,
//     num? leaveReasonId,
//     String? comment,
//     String? status,
//     String? startDate,
//     String? endDate,
//     String? updatedAt,
//     String? createdAt,
//     num? id,
//   }) =>
//       Data(
//         astrologerId: astrologerId ?? _astrologerId,
//         leaveReasonId: leaveReasonId ?? _leaveReasonId,
//         comment: comment ?? _comment,
//         status: status ?? _status,
//         startDate: startDate ?? _startDate,
//         endDate: endDate ?? _endDate,
//         updatedAt: updatedAt ?? _updatedAt,
//         createdAt: createdAt ?? _createdAt,
//         id: id ?? _id,
//       );
//   num? get astrologerId => _astrologerId;
//   num? get leaveReasonId => _leaveReasonId;
//   String? get comment => _comment;
//   String? get status => _status;
//   String? get startDate => _startDate;
//   String? get endDate => _endDate;
//   String? get updatedAt => _updatedAt;
//   String? get createdAt => _createdAt;
//   num? get id => _id;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['astrologer_id'] = _astrologerId;
//     map['leave_reason_id'] = _leaveReasonId;
//     map['comment'] = _comment;
//     map['status'] = _status;
//     map['start_date'] = _startDate;
//     map['end_date'] = _endDate;
//     map['updated_at'] = _updatedAt;
//     map['created_at'] = _createdAt;
//     map['id'] = _id;
//     return map;
//   }
// }
