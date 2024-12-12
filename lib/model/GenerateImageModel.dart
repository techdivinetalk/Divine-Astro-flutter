/// data : {"image":"generated-images/generated_image_1733461204.png"}
/// success : true
/// status_code : 200
/// message : "Schedule meeting added successfully"

class GenerateImageModel {
  GenerateImageModel({
      Data? data, 
      bool? success, 
      num? statusCode, 
      String? message,}){
    _data = data;
    _success = success;
    _statusCode = statusCode;
    _message = message;
}

  GenerateImageModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  Data? _data;
  bool? _success;
  num? _statusCode;
  String? _message;
GenerateImageModel copyWith({  Data? data,
  bool? success,
  num? statusCode,
  String? message,
}) => GenerateImageModel(  data: data ?? _data,
  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
);
  Data? get data => _data;
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }

}

/// image : "generated-images/generated_image_1733461204.png"

class Data {
  Data({
      String? image,}){
    _image = image;
}

  Data.fromJson(dynamic json) {
    _image = json['image'];
  }
  String? _image;
Data copyWith({  String? image,
}) => Data(  image: image ?? _image,
);
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    return map;
  }

}