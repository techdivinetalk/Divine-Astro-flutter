/// data : {"id":31,"astrologer_id":2129,"stage_no":3,"data":"{\"page\": 3, \"astro_images\": [\"https://divineprod.blob.core.windows.net/divineprod/images/onBoarding/September2024/2lowxgvm8IhM6d90cDSezrCbZfm0W4AYIYA99Uob.jpg\", \"https://divineprod.blob.core.windows.net/divineprod/images/onBoarding/September2024/k2SSwl0wKGOmxdbRbR1PjUC72fSrLHRjT8kH3ypc.jpg\"]}","created_at":"2024-09-04 11:24:05","updated_at":"2024-09-04 11:24:05","is_approved":3}
/// success : true
/// status_code : 200
/// message : "Astrologer data retrieved successfully"

class GetAstroOnboarding {
  GetAstroOnboarding({
    Data? data,
    List? images,
    bool? success,
    int? statusCode,
    String? message,
  }) {
    _data = data;
    _images = images;
    _success = success;
    _statusCode = statusCode;
    _message = message;
  }

  GetAstroOnboarding.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _images = json['image'];
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  Data? _data;
  List? _images;
  bool? _success;
  int? _statusCode;
  String? _message;
  GetAstroOnboarding copyWith({
    Data? data,
    List? images,
    bool? success,
    int? statusCode,
    String? message,
  }) =>
      GetAstroOnboarding(
        data: data ?? _data,
        images: images ?? _images,
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  Data? get data => _data;
  List? get images => _images;
  bool? get success => _success;
  int? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['image'] = _images;
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}

/// id : 31
/// astrologer_id : 2129
/// stage_no : 3
/// data : "{\"page\": 3, \"astro_images\": [\"https://divineprod.blob.core.windows.net/divineprod/images/onBoarding/September2024/2lowxgvm8IhM6d90cDSezrCbZfm0W4AYIYA99Uob.jpg\", \"https://divineprod.blob.core.windows.net/divineprod/images/onBoarding/September2024/k2SSwl0wKGOmxdbRbR1PjUC72fSrLHRjT8kH3ypc.jpg\"]}"
/// created_at : "2024-09-04 11:24:05"
/// updated_at : "2024-09-04 11:24:05"
/// is_approved : 3

class Data {
  Data({
    int? id,
    int? astrologerId,
    int? stageNo,
    var data,
    String? createdAt,
    String? updatedAt,
    int? isApproved,
  }) {
    _id = id;
    _astrologerId = astrologerId;
    _stageNo = stageNo;
    _data = data;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _isApproved = isApproved;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _astrologerId = json['astrologer_id'];
    _stageNo = json['stage_no'];
    _data = json['data'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isApproved = json['is_approved'];
  }
  int? _id;
  int? _astrologerId;
  int? _stageNo;
  var _data;
  String? _createdAt;
  String? _updatedAt;
  int? _isApproved;
  Data copyWith({
    int? id,
    int? astrologerId,
    int? stageNo,
    var data,
    String? createdAt,
    String? updatedAt,
    int? isApproved,
  }) =>
      Data(
        id: id ?? _id,
        astrologerId: astrologerId ?? _astrologerId,
        stageNo: stageNo ?? _stageNo,
        data: data ?? _data,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        isApproved: isApproved ?? _isApproved,
      );
  int? get id => _id;
  int? get astrologerId => _astrologerId;
  int? get stageNo => _stageNo;
  get data => _data;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get isApproved => _isApproved;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['astrologer_id'] = _astrologerId;
    map['stage_no'] = _stageNo;
    map['data'] = _data;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['is_approved'] = _isApproved;
    return map;
  }
}
