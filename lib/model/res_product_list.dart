class ResProductList {
  ProductData? data;
  bool? success;
  int? statusCode;
  String? message;

  ResProductList({this.data, this.success, this.statusCode, this.message});

  ResProductList.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ProductData.fromJson(json['data']) : null;
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

class ProductData {
  List<Products>? products;

  ProductData({this.products});

  ProductData.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? prodName;
  String? prodImage;
  int? productPriceInr;

  Products({this.id, this.prodName, this.prodImage, this.productPriceInr});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prodName = json['prod_name'];
    prodImage = json['prod_image'];
    productPriceInr = json['product_price_inr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['prod_name'] = prodName;
    data['prod_image'] = prodImage;
    data['product_price_inr'] = productPriceInr;
    return data;
  }
}
