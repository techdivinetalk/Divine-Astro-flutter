class ResGetShop {
  ShopData? data;
  bool? success;
  int? statusCode;
  String? message;

  ResGetShop({this.data, this.success, this.statusCode, this.message});

  ResGetShop.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ShopData.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class ShopData {
  List<Shops>? shops;
  List<Shops>? remedies;

  ShopData({this.shops, this.remedies});

  ShopData.fromJson(Map<String, dynamic> json) {
    if (json['shops'] != null) {
      shops = <Shops>[];
      json['shops'].forEach((v) {
        shops!.add(Shops.fromJson(v));
      });
    }
    if (json['remedies'] != null) {
      remedies = <Shops>[];
      json['remedies'].forEach((v) {
        remedies!.add(Shops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shops != null) {
      data['shops'] = shops!.map((v) => v.toJson()).toList();
    }
    if (remedies != null) {
      data['remedies'] = remedies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shops {
  int? id;
  String? shopName;
  String? shopImage;

  Shops({this.id, this.shopName, this.shopImage});

  Shops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopName = json['shop_name'];
    shopImage = json['shop_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_name'] = shopName;
    data['shop_image'] = shopImage;
    return data;
  }
}
