/// success : true
/// status_code : 200
/// message : "Financial Support ticket successfully created"
/// data : {"astrologer_id":2129,"description":"descriptionController.text","ticket_type":"Issue","status":0,"is_viewed":false,"updated_at":"2024-08-05T07:15:23.000000Z","created_at":"2024-08-05T07:15:23.000000Z","id":5}

class FinancialCreateIssueModel {
  FinancialCreateIssueModel({
    bool? success,
    num? statusCode,
    String? message,
    FinancialCreateIssueModelData? data,
  }) {
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
  }

  FinancialCreateIssueModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
    _data = json['data'] != null
        ? FinancialCreateIssueModelData.fromJson(json['data'])
        : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  FinancialCreateIssueModelData? _data;
  FinancialCreateIssueModel copyWith({
    bool? success,
    num? statusCode,
    String? message,
    FinancialCreateIssueModelData? data,
  }) =>
      FinancialCreateIssueModel(
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
        data: data ?? _data,
      );
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  FinancialCreateIssueModelData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// astrologer_id : 2129
/// description : "descriptionController.text"
/// ticket_type : "Issue"
/// status : 0
/// is_viewed : false
/// updated_at : "2024-08-05T07:15:23.000000Z"
/// created_at : "2024-08-05T07:15:23.000000Z"
/// id : 5

class FinancialCreateIssueModelData {
  FinancialCreateIssueModelData({
    num? astrologerId,
    String? description,
    String? ticketType,
    num? status,
    bool? isViewed,
    String? updatedAt,
    String? createdAt,
    num? id,
  }) {
    _astrologerId = astrologerId;
    _description = description;
    _ticketType = ticketType;
    _status = status;
    _isViewed = isViewed;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
  }

  FinancialCreateIssueModelData.fromJson(dynamic json) {
    _astrologerId = json['astrologer_id'];
    _description = json['description'];
    _ticketType = json['ticket_type'];
    _status = json['status'];
    _isViewed = json['is_viewed'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }
  num? _astrologerId;
  String? _description;
  String? _ticketType;
  num? _status;
  bool? _isViewed;
  String? _updatedAt;
  String? _createdAt;
  num? _id;
  FinancialCreateIssueModelData copyWith({
    num? astrologerId,
    String? description,
    String? ticketType,
    num? status,
    bool? isViewed,
    String? updatedAt,
    String? createdAt,
    num? id,
  }) =>
      FinancialCreateIssueModelData(
        astrologerId: astrologerId ?? _astrologerId,
        description: description ?? _description,
        ticketType: ticketType ?? _ticketType,
        status: status ?? _status,
        isViewed: isViewed ?? _isViewed,
        updatedAt: updatedAt ?? _updatedAt,
        createdAt: createdAt ?? _createdAt,
        id: id ?? _id,
      );
  num? get astrologerId => _astrologerId;
  String? get description => _description;
  String? get ticketType => _ticketType;
  num? get status => _status;
  bool? get isViewed => _isViewed;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['astrologer_id'] = _astrologerId;
    map['description'] = _description;
    map['ticket_type'] = _ticketType;
    map['status'] = _status;
    map['is_viewed'] = _isViewed;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }
}
