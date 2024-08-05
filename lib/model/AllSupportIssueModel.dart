/// success : true
/// status_code : 200
/// message : " Support tickets retrieved successfully"
/// data : [{"id":2,"astrologer_id":2129,"description":"ndhdjjjs","suggestion":null,"ticket_type":"Issue","status":"0","is_viewed":0,"assigned_to":null,"created_at":"2024-08-05T07:13:04.000000Z","updated_at":"2024-08-05T07:13:04.000000Z","ticket_number":"TICKET0002","status_text":"Pending","support_images":[{"id":3,"support_id":2,"image":"images/supportIssue/August2024/pYOBTe4SNatYAssZ4JD8r8IPXTSR8fthH3IIG4fn.jpg","created_at":null,"updated_at":null}]}]

class AllSupportIssueModel {
  AllSupportIssueModel({
    bool? success,
    num? statusCode,
    String? message,
    List<Data>? data,
  }) {
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
  }

  AllSupportIssueModel.fromJson(dynamic json) {
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
  AllSupportIssueModel copyWith({
    bool? success,
    num? statusCode,
    String? message,
    List<Data>? data,
  }) =>
      AllSupportIssueModel(
        success: success ?? _success,
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

/// id : 2
/// astrologer_id : 2129
/// description : "ndhdjjjs"
/// suggestion : null
/// ticket_type : "Issue"
/// status : "0"
/// is_viewed : 0
/// assigned_to : null
/// created_at : "2024-08-05T07:13:04.000000Z"
/// updated_at : "2024-08-05T07:13:04.000000Z"
/// ticket_number : "TICKET0002"
/// status_text : "Pending"
/// support_images : [{"id":3,"support_id":2,"image":"images/supportIssue/August2024/pYOBTe4SNatYAssZ4JD8r8IPXTSR8fthH3IIG4fn.jpg","created_at":null,"updated_at":null}]

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
    List<SupportImages>? supportImages,
  }) {
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
    _supportImages = supportImages;
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
    if (json['support_images'] != null) {
      _supportImages = [];
      json['support_images'].forEach((v) {
        _supportImages?.add(SupportImages.fromJson(v));
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
  List<SupportImages>? _supportImages;
  Data copyWith({
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
    List<SupportImages>? supportImages,
  }) =>
      Data(
        id: id ?? _id,
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
        supportImages: supportImages ?? _supportImages,
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
  List<SupportImages>? get supportImages => _supportImages;

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
    if (_supportImages != null) {
      map['support_images'] = _supportImages?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 3
/// support_id : 2
/// image : "images/supportIssue/August2024/pYOBTe4SNatYAssZ4JD8r8IPXTSR8fthH3IIG4fn.jpg"
/// created_at : null
/// updated_at : null

class SupportImages {
  SupportImages({
    num? id,
    num? supportId,
    String? image,
    dynamic createdAt,
    dynamic updatedAt,
  }) {
    _id = id;
    _supportId = supportId;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  SupportImages.fromJson(dynamic json) {
    _id = json['id'];
    _supportId = json['support_id'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _supportId;
  String? _image;
  dynamic _createdAt;
  dynamic _updatedAt;
  SupportImages copyWith({
    num? id,
    num? supportId,
    String? image,
    dynamic createdAt,
    dynamic updatedAt,
  }) =>
      SupportImages(
        id: id ?? _id,
        supportId: supportId ?? _supportId,
        image: image ?? _image,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  num? get supportId => _supportId;
  String? get image => _image;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['support_id'] = _supportId;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
