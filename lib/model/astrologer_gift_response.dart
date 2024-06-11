import 'dart:convert';

GiftResponse giftResponseFromJson(String str) =>
    GiftResponse.fromJson(json.decode(str));

String giftResponseToJson(GiftResponse data) => json.encode(data.toJson());

class GiftResponse {
  List<GiftData>? data;
  bool? success;
  int? statusCode;
  String? message;

  GiftResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory GiftResponse.fromJson(Map<String, dynamic> json) {
    return GiftResponse(
      data: json["data"] == null
          ? []
          : List<GiftData>.from(
          (json["data"] as List<dynamic>).map((x) => GiftData.fromJson(x))),
      success: json["success"],
      statusCode: json["status_code"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? null
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}

class GiftData {
  int id;
  String giftName;
  String giftImage;
  int giftPrice;
  int giftStatus;
  DateTime createdAt;
  DateTime updatedAt;
  String fullGiftImage;
  String? animation;

  GiftData({
    required this.id,
    required this.giftName,
    required this.giftImage,
    required this.giftPrice,
    required this.giftStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.fullGiftImage,
    required this.animation,
  });

  factory GiftData.fromJson(Map<String, dynamic> json) => GiftData(
        id: json["id"],
        giftName: json["gift_name"],
        giftImage: json["gift_image"],
        giftPrice: json["gift_price"],
        giftStatus: json["gift_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        fullGiftImage: json["full_gift_image"],
        animation: json["animation"] ??"",
      );
 
  Map<String, dynamic> toJson() => {
        "id": id,
        "gift_name": giftName,
        "gift_image": giftImage,
        "gift_price": giftPrice,
        "gift_status": giftStatus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "full_gift_image": fullGiftImage,
        "animation": animation,
      };
}
