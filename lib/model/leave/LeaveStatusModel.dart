/// status : "pending"
/// is_on_leave : true
/// success : true
/// data : {"id":2,"astrologer_id":2129,"leave_reason_id":1,"comment":"Personal reasons","status":"pending","start_date":"2024-07-01","end_date":"2024-08-01","approve_by":null,"approval_date":null,"approval_comment":null,"created_at":"2024-06-25T10:54:57.000000Z","updated_at":"2024-06-25T10:54:57.000000Z"}
/// status_code : 200
/// message : "Leave application Data"

class LeaveStatusModel {
  LeaveStatusModel({
    String? status,
    bool? isOnLeave,
    bool? success,
    dynamic data,
    num? statusCode,
    String? message,
  }) {
    _status = status;
    _isOnLeave = isOnLeave;
    _success = success;
    _data = data;
    _statusCode = statusCode;
    _message = message;
  }

  LeaveStatusModel.fromJson(dynamic json) {
    _status = json['status'];
    _isOnLeave = json['is_on_leave'];
    _success = json['success'];
    _data = json['data'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  String? _status;
  bool? _isOnLeave;
  bool? _success;
  dynamic _data;
  num? _statusCode;
  String? _message;
  LeaveStatusModel copyWith({
    String? status,
    bool? isOnLeave,
    bool? success,
    dynamic data,
    num? statusCode,
    String? message,
  }) =>
      LeaveStatusModel(
        status: status ?? _status,
        isOnLeave: isOnLeave ?? _isOnLeave,
        success: success ?? _success,
        data: data ?? _data,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  String? get status => _status;
  bool? get isOnLeave => _isOnLeave;
  bool? get success => _success;
  dynamic get data => _data;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['is_on_leave'] = _isOnLeave;
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}

/// id : 2
/// astrologer_id : 2129
/// leave_reason_id : 1
/// comment : "Personal reasons"
/// status : "pending"
/// start_date : "2024-07-01"
/// end_date : "2024-08-01"
/// approve_by : null
/// approval_date : null
/// approval_comment : null
/// created_at : "2024-06-25T10:54:57.000000Z"
/// updated_at : "2024-06-25T10:54:57.000000Z"

// class Data {
//   Data({
//     num? id,
//     num? astrologerId,
//     num? leaveReasonId,
//     String? comment,
//     String? status,
//     String? startDate,
//     String? endDate,
//     dynamic approveBy,
//     dynamic approvalDate,
//     dynamic approvalComment,
//     String? createdAt,
//     String? updatedAt,}){
//     _id = id;
//     _astrologerId = astrologerId;
//     _leaveReasonId = leaveReasonId;
//     _comment = comment;
//     _status = status;
//     _startDate = startDate;
//     _endDate = endDate;
//     _approveBy = approveBy;
//     _approvalDate = approvalDate;
//     _approvalComment = approvalComment;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }
//
//   Data.fromJson(dynamic json) {
//     _id = json['id'];
//     _astrologerId = json['astrologer_id'];
//     _leaveReasonId = json['leave_reason_id'];
//     _comment = json['comment'];
//     _status = json['status'];
//     _startDate = json['start_date'];
//     _endDate = json['end_date'];
//     _approveBy = json['approve_by'];
//     _approvalDate = json['approval_date'];
//     _approvalComment = json['approval_comment'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }
//   num? _id;
//   num? _astrologerId;
//   num? _leaveReasonId;
//   String? _comment;
//   String? _status;
//   String? _startDate;
//   String? _endDate;
//   dynamic _approveBy;
//   dynamic _approvalDate;
//   dynamic _approvalComment;
//   String? _createdAt;
//   String? _updatedAt;
//   Data copyWith({  num? id,
//     num? astrologerId,
//     num? leaveReasonId,
//     String? comment,
//     String? status,
//     String? startDate,
//     String? endDate,
//     dynamic approveBy,
//     dynamic approvalDate,
//     dynamic approvalComment,
//     String? createdAt,
//     String? updatedAt,
//   }) => Data(  id: id ?? _id,
//     astrologerId: astrologerId ?? _astrologerId,
//     leaveReasonId: leaveReasonId ?? _leaveReasonId,
//     comment: comment ?? _comment,
//     status: status ?? _status,
//     startDate: startDate ?? _startDate,
//     endDate: endDate ?? _endDate,
//     approveBy: approveBy ?? _approveBy,
//     approvalDate: approvalDate ?? _approvalDate,
//     approvalComment: approvalComment ?? _approvalComment,
//     createdAt: createdAt ?? _createdAt,
//     updatedAt: updatedAt ?? _updatedAt,
//   );
//   num? get id => _id;
//   num? get astrologerId => _astrologerId;
//   num? get leaveReasonId => _leaveReasonId;
//   String? get comment => _comment;
//   String? get status => _status;
//   String? get startDate => _startDate;
//   String? get endDate => _endDate;
//   dynamic get approveBy => _approveBy;
//   dynamic get approvalDate => _approvalDate;
//   dynamic get approvalComment => _approvalComment;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['astrologer_id'] = _astrologerId;
//     map['leave_reason_id'] = _leaveReasonId;
//     map['comment'] = _comment;
//     map['status'] = _status;
//     map['start_date'] = _startDate;
//     map['end_date'] = _endDate;
//     map['approve_by'] = _approveBy;
//     map['approval_date'] = _approvalDate;
//     map['approval_comment'] = _approvalComment;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     return map;
//   }
//
// }
