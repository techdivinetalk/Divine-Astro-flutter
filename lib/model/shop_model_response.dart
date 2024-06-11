import 'dart:convert';


ShopModel shopModelFromJson(String str) => ShopModel.fromJson(json.decode(str));

String shopModelToJson(ShopModel data) => json.encode(data.toJson());

class ShopModel {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  ShopModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
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
  List<Shop>? shops;

  Data({
    this.shops,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    shops: json["shops"] == null
        ? []
        : List<Shop>.from(json["shops"]!.map((x) => Shop.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "shops": shops == null
        ? []
        : List<dynamic>.from(shops!.map((x) => x.toJson())),
  };
}

class Shop {
  int? id;
  String? shopName;
  String? shopImage;
  String? shopDesc;
  int? shopRating;
  int? shopStatus;
  int? masterCategorieId;

  Shop({
    this.id,
    this.shopName,
    this.shopImage,
    this.shopDesc,
    this.shopRating,
    this.shopStatus,
    this.masterCategorieId,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    id: json["id"],
    shopName: json["shop_name"],
    shopImage: json["shop_image"],
    shopDesc: json["shop_desc"],
    shopRating: json["shop_rating"],
    shopStatus: json["shop_status"],
    masterCategorieId: json["master_categorie_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "shop_name": shopName,
    "shop_image": shopImage,
    "shop_desc": shopDesc,
    "shop_rating": shopRating,
    "shop_status": shopStatus,
    "master_categorie_id": masterCategorieId,
  };
}
