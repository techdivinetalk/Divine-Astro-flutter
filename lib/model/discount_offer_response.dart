import 'dart:convert';

import 'package:divine_astrologer/model/home_page_model_class.dart';

DiscountOfferData discountOfferDataFromJson(String str) => DiscountOfferData.fromJson(json.decode(str));

String discountOfferDataToJson(DiscountOfferData data) => json.encode(data.toJson());

class DiscountOfferData {
  List<DiscountOffer>? discountOffers;
  bool? success;
  int? statusCode;
  String? message;

  DiscountOfferData({
    this.discountOffers,
    this.success,
    this.statusCode,
    this.message,
  });

  factory DiscountOfferData.fromJson(Map<String, dynamic> json) => DiscountOfferData(
    discountOffers: json["data"] == null ? [] : List<DiscountOffer>.from(json["data"]!.map((x) => DiscountOffer.fromJson(x))),
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": discountOffers == null ? [] : List<dynamic>.from(discountOffers!.map((x) => x.toJson())),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}