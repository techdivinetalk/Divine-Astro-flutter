class ResProductDetail {
  ProductDetailData? data;
  bool? success;
  int? statusCode;
  String? message;

  ResProductDetail({this.data, this.success, this.statusCode, this.message});

  ResProductDetail.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ProductDetailData.fromJson(json['data']) : null;
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

class ProductDetailData {
  List<Products>? products;

  ProductDetailData({this.products});

  ProductDetailData.fromJson(Map<String, dynamic> json) {
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
  int? prodShopId;
  int? prodCatId;
  String? prodName;
  String? prodImage;
  String? prodDesc;
  int? productPriceInr;
  int? productPriceUsd;
  int? productStatus;
  String? productLongDesc;
  String? productBannerImage;
  ProductShop? productShop;

  List<ProductFaq>? productFaq;
  // Null? productCat;

  Products({
    this.id,
    this.prodShopId,
    this.prodCatId,
    this.prodName,
    this.prodImage,
    this.prodDesc,
    this.productPriceInr,
    this.productPriceUsd,
    this.productStatus,
    this.productLongDesc,
    this.productBannerImage,
    this.productShop,
    this.productFaq,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prodShopId = json['prod_shop_id'];
    prodCatId = json['prod_cat_id'];
    prodName = json['prod_name'];
    prodImage = json['prod_image'];
    prodDesc = json['prod_desc'];
    productPriceInr = json['product_price_inr'];
    productPriceUsd = json['product_price_usd'];
    productStatus = json['product_status'];
    productLongDesc = json['product_long_desc'];
    productBannerImage = json['product_banner_image'];
    productShop = json['product_shop'] != null ? ProductShop.fromJson(json['product_shop']) : null;
    productFaq = List<ProductFaq>.from(json["product_faq"].map((x) => ProductFaq.fromJson(x)));

    // productCat = json['product_cat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['prod_shop_id'] = prodShopId;
    data['prod_cat_id'] = prodCatId;
    data['prod_name'] = prodName;
    data['prod_image'] = prodImage;
    data['prod_desc'] = prodDesc;
    data['product_price_inr'] = productPriceInr;
    data['product_price_usd'] = productPriceUsd;
    data['product_status'] = productStatus;
    data['product_long_desc'] = productLongDesc;
    data['product_banner_image'] = productBannerImage;
    data["product_faq"] = List<ProductFaq>.from(productFaq!.map((x) => x.toJson()));
    if (productShop != null) {
      data['product_shop'] = productShop!.toJson();
    }
    // data['product_cat'] = productCat;
    return data;
  }
}

class ProductShop {
  int? id;
  String? shopName;
  String? shopImage;
  String? shopDesc;
  int? shopRating;
  int? shopStatus;
  int? masterCategorieId;

  ProductShop({this.id, this.shopName, this.shopImage, this.shopDesc, this.shopRating, this.shopStatus, this.masterCategorieId});

  ProductShop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopName = json['shop_name'];
    shopImage = json['shop_image'];
    shopDesc = json['shop_desc'];
    shopRating = json['shop_rating'];
    shopStatus = json['shop_status'];
    masterCategorieId = json['master_categorie_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_name'] = shopName;
    data['shop_image'] = shopImage;
    data['shop_desc'] = shopDesc;
    data['shop_rating'] = shopRating;
    data['shop_status'] = shopStatus;
    data['master_categorie_id'] = masterCategorieId;
    return data;
  }
}

class ProductFaq {
  int? productId;
  String? title;
  String? description;
  bool? isExpand;

  ProductFaq({
    this.productId,
    this.title,
    this.description,
    this.isExpand,
  });

  factory ProductFaq.fromJson(Map<String, dynamic> json) => ProductFaq(
        productId: json["product_id"],
        title: json["title"],
        description: json["description"],
        isExpand: json["isExpand"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "title": title,
        "description": description,
        "isExpand": isExpand,
      };
}
