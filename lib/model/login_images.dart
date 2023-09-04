import 'dart:convert';

LoginImages loginImagesFromJson(String str) =>
    LoginImages.fromJson(json.decode(str));

String loginImagesToJson(LoginImages data) => json.encode(data.toJson());

class LoginImages {
  Data data;
  bool success;
  int statusCode;
  String message;

  LoginImages({
    required this.data,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory LoginImages.fromJson(Map<String, dynamic> json) => LoginImages(
        data: Data.fromJson(json["data"]),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class Data {
  List<LoginDatum> data;
  String baseurl;

  Data({
    this.data = const [],
    required this.baseurl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] != null
            ? List<LoginDatum>.from(
                json["data"].map((x) => LoginDatum.fromJson(x)))
            : [],
        baseurl: json["baseurl"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "baseurl": baseurl,
      };
}

class LoginDatum {
  int id;
  String? image;
  String? descriptioin;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int type;

  LoginDatum({
    required this.id,
    required this.image,
    required this.descriptioin,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.type,
  });

  factory LoginDatum.fromJson(Map<String, dynamic> json) => LoginDatum(
        id: json["id"],
        image: json["image"],
        descriptioin: json["descriptioin"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "descriptioin": descriptioin,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        "type": type,
      };

  String getImageUrl(String amazon) => amazon + image!;
}
