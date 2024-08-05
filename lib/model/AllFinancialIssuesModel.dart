/// success : true
/// status_code : 200
/// message : "Financial Support tickets retrieved successfully"
/// data : [{"id":6,"astrologer_id":2129,"description":"uuuu","suggestion":null,"ticket_type":"Issue","status":"0","is_viewed":0,"assigned_to":null,"created_at":"2024-08-05T07:19:02.000000Z","updated_at":"2024-08-05T07:19:02.000000Z","ticket_number":"TICKET0006","status_text":"Pending","images":[{"id":5,"financial_support_id":6,"image":"images/financialSupport/August2024/xp1hjWVOiOSPn49uhDndZIEVHpnYoYknPwqwDAUf.jpg","created_at":null,"updated_at":null}]},{"id":5,"astrologer_id":2129,"description":"descriptionController.text","suggestion":null,"ticket_type":"Issue","status":"0","is_viewed":0,"assigned_to":null,"created_at":"2024-08-05T07:15:23.000000Z","updated_at":"2024-08-05T07:15:23.000000Z","ticket_number":"TICKET0005","status_text":"Pending","images":[]},{"id":4,"astrologer_id":2129,"description":"hshshshsu","suggestion":null,"ticket_type":"Suggestion","status":"0","is_viewed":0,"assigned_to":null,"created_at":"2024-08-05T07:12:11.000000Z","updated_at":"2024-08-05T07:12:11.000000Z","ticket_number":"TICKET0004","status_text":"Pending","images":[{"id":4,"financial_support_id":4,"image":"images/financialSupport/August2024/8k9klylTGTN4Uo6Xz0FLe0zjtFyqIL2DOtaqYiov.jpg","created_at":null,"updated_at":null}]},{"id":3,"astrologer_id":2129,"description":"descriptionController.text","suggestion":null,"ticket_type":"Issue","status":"0","is_viewed":0,"assigned_to":null,"created_at":"2024-08-05T07:11:41.000000Z","updated_at":"2024-08-05T07:11:41.000000Z","ticket_number":"TICKET0003","status_text":"Pending","images":[]}]

class AllFinancialIssuesModel {
  AllFinancialIssuesModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  AllFinancialIssuesModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  List<Data>? _data;
AllFinancialIssuesModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  List<Data>? data,
}) => AllFinancialIssuesModel(  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 6
/// astrologer_id : 2129
/// description : "uuuu"
/// suggestion : null
/// ticket_type : "Issue"
/// status : "0"
/// is_viewed : 0
/// assigned_to : null
/// created_at : "2024-08-05T07:19:02.000000Z"
/// updated_at : "2024-08-05T07:19:02.000000Z"
/// ticket_number : "TICKET0006"
/// status_text : "Pending"
/// images : [{"id":5,"financial_support_id":6,"image":"images/financialSupport/August2024/xp1hjWVOiOSPn49uhDndZIEVHpnYoYknPwqwDAUf.jpg","created_at":null,"updated_at":null}]

class Data {
  Data({
      num? id, 
      num? astrologerId, 
      String? description, 
      dynamic suggestion, 
      String? ticketType, 
      String? status, 
      num? isViewed, 
      dynamic assignedTo, 
      String? createdAt, 
      String? updatedAt, 
      String? ticketNumber, 
      String? statusText, 
      List<Images>? images,}){
    _id = id;
    _astrologerId = astrologerId;
    _description = description;
    _suggestion = suggestion;
    _ticketType = ticketType;
    _status = status;
    _isViewed = isViewed;
    _assignedTo = assignedTo;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _ticketNumber = ticketNumber;
    _statusText = statusText;
    _images = images;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _astrologerId = json['astrologer_id'];
    _description = json['description'];
    _suggestion = json['suggestion'];
    _ticketType = json['ticket_type'];
    _status = json['status'];
    _isViewed = json['is_viewed'];
    _assignedTo = json['assigned_to'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _ticketNumber = json['ticket_number'];
    _statusText = json['status_text'];
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images?.add(Images.fromJson(v));
      });
    }
  }
  num? _id;
  num? _astrologerId;
  String? _description;
  dynamic _suggestion;
  String? _ticketType;
  String? _status;
  num? _isViewed;
  dynamic _assignedTo;
  String? _createdAt;
  String? _updatedAt;
  String? _ticketNumber;
  String? _statusText;
  List<Images>? _images;
Data copyWith({  num? id,
  num? astrologerId,
  String? description,
  dynamic suggestion,
  String? ticketType,
  String? status,
  num? isViewed,
  dynamic assignedTo,
  String? createdAt,
  String? updatedAt,
  String? ticketNumber,
  String? statusText,
  List<Images>? images,
}) => Data(  id: id ?? _id,
  astrologerId: astrologerId ?? _astrologerId,
  description: description ?? _description,
  suggestion: suggestion ?? _suggestion,
  ticketType: ticketType ?? _ticketType,
  status: status ?? _status,
  isViewed: isViewed ?? _isViewed,
  assignedTo: assignedTo ?? _assignedTo,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  ticketNumber: ticketNumber ?? _ticketNumber,
  statusText: statusText ?? _statusText,
  images: images ?? _images,
);
  num? get id => _id;
  num? get astrologerId => _astrologerId;
  String? get description => _description;
  dynamic get suggestion => _suggestion;
  String? get ticketType => _ticketType;
  String? get status => _status;
  num? get isViewed => _isViewed;
  dynamic get assignedTo => _assignedTo;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get ticketNumber => _ticketNumber;
  String? get statusText => _statusText;
  List<Images>? get images => _images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['astrologer_id'] = _astrologerId;
    map['description'] = _description;
    map['suggestion'] = _suggestion;
    map['ticket_type'] = _ticketType;
    map['status'] = _status;
    map['is_viewed'] = _isViewed;
    map['assigned_to'] = _assignedTo;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['ticket_number'] = _ticketNumber;
    map['status_text'] = _statusText;
    if (_images != null) {
      map['images'] = _images?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 5
/// financial_support_id : 6
/// image : "images/financialSupport/August2024/xp1hjWVOiOSPn49uhDndZIEVHpnYoYknPwqwDAUf.jpg"
/// created_at : null
/// updated_at : null

class Images {
  Images({
      num? id, 
      num? financialSupportId, 
      String? image, 
      dynamic createdAt, 
      dynamic updatedAt,}){
    _id = id;
    _financialSupportId = financialSupportId;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Images.fromJson(dynamic json) {
    _id = json['id'];
    _financialSupportId = json['financial_support_id'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _financialSupportId;
  String? _image;
  dynamic _createdAt;
  dynamic _updatedAt;
Images copyWith({  num? id,
  num? financialSupportId,
  String? image,
  dynamic createdAt,
  dynamic updatedAt,
}) => Images(  id: id ?? _id,
  financialSupportId: financialSupportId ?? _financialSupportId,
  image: image ?? _image,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get financialSupportId => _financialSupportId;
  String? get image => _image;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['financial_support_id'] = _financialSupportId;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}