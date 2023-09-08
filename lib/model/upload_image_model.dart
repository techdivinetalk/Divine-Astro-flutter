import 'dart:convert';

UploadImageRequest uploadImageRequestFromJson(String str) =>
    UploadImageRequest.fromJson(json.decode(str));

String uploadImageRequestToJson(UploadImageRequest data) =>
    json.encode(data.toJson());

class UploadImageRequest {
  String? astroId;
  List<String> images;

  UploadImageRequest({
    this.astroId,
    this.images = const [],
  });

  factory UploadImageRequest.fromJson(Map<String, dynamic> json) =>
      UploadImageRequest(
        astroId: json["astro_id"],
        images: List<String>.from(
          json["images"].map((x) => x),
        ),
      );

  Map<String, dynamic> toJson() => {
        "astro_id": astroId,
        "images": List<dynamic>.from(
          images.map((x) => x),
        ),
      };
}


UploadImageResponse uploadImageResponseFromJson(String str) => UploadImageResponse.fromJson(json.decode(str));

String uploadImageResponseToJson(UploadImageResponse data) => json.encode(data.toJson());

class UploadImageResponse {
  bool success;
  int statusCode;
  String message;

  UploadImageResponse({
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) => UploadImageResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}
