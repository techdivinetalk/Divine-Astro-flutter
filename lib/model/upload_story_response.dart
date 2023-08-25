import 'dart:convert';

UploadStoryResponse uploadStoryResponseFromJson(String str) =>
    UploadStoryResponse.fromJson(json.decode(str));

String uploadStoryResponseToJson(UploadStoryResponse data) =>
    json.encode(data.toJson());

class UploadStoryResponse {
  StoryUploadData? data;
  bool? success;
  int? statusCode;
  String? message;

  UploadStoryResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  UploadStoryResponse copyWith({
    StoryUploadData? data,
    bool? success,
    int? statusCode,
    String? message,
  }) =>
      UploadStoryResponse(
        data: data ?? this.data,
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory UploadStoryResponse.fromJson(Map<String, dynamic> json) =>
      UploadStoryResponse(
        data: uploadStory(json),
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

  static StoryUploadData? uploadStory(Map<String, dynamic> json) {
    if (json["data"] != null) {
      return StoryUploadData.fromJson(json["data"]);
    }
    return null;
  }
}

class StoryUploadData {
  int? astrologerId;
  String? mediaUrl;
  String? updatedAt;
  String? createdAt;
  int? id;

  StoryUploadData({
    this.astrologerId,
    this.mediaUrl,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  StoryUploadData copyWith({
    int? astrologerId,
    String? mediaUrl,
    String? updatedAt,
    String? createdAt,
    int? id,
  }) =>
      StoryUploadData(
        astrologerId: astrologerId ?? this.astrologerId,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
      );

  factory StoryUploadData.fromJson(Map<String, dynamic> json) =>
      StoryUploadData(
        astrologerId: json["astrologer_id"],
        mediaUrl: json["media_url"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "astrologer_id": astrologerId,
        "media_url": mediaUrl,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "id": id,
      };
}
