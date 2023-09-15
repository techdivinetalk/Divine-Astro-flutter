import 'dart:convert';

UpdateSessionTypeResponse updateSessionTypeResponseFromJson(String str) => UpdateSessionTypeResponse.fromJson(json.decode(str));

String updateSessionTypeResponseToJson(UpdateSessionTypeResponse data) => json.encode(data.toJson());

class UpdateSessionTypeResponse {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  UpdateSessionTypeResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory UpdateSessionTypeResponse.fromJson(Map<String, dynamic> json) => UpdateSessionTypeResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}

class Data {
  String? isChat;
  String? isCall;
  String? isVideo;

  Data({
    this.isChat,
    this.isCall,
    this.isVideo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isChat: json["is_chat"],
    isCall: json["is_call"],
    isVideo: json["is_video"],
  );

  Map<String, dynamic> toJson() => {
    "is_chat": isChat,
    "is_call": isCall,
    "is_video": isVideo,
  };
}
