class AddProductModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final ProductData? data;

  AddProductModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  AddProductModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? ProductData.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'success': success,
        'status_code': statusCode,
        'message': message,
        'data': data?.toJson()
      };
}

class ProductData {
  final int? prodShopId;
  final int? prodCatId;
  final String? prodName;
  final String? prodImage;
  final String? prodDesc;
  final double? productPriceInr;
  final int? offerPriceInr;
  final int? productPriceUsd;
  final int? productStatus;
  final String? productLongDesc;
  final String? productBannerImage;
  final bool? isApprove;
  final int? productBy;
  final int? productById;
  final int? id;

  ProductData({
    this.prodShopId,
    this.prodCatId,
    this.prodName,
    this.prodImage,
    this.prodDesc,
    this.productPriceInr,
    this.offerPriceInr,
    this.productPriceUsd,
    this.productStatus,
    this.productLongDesc,
    this.productBannerImage,
    this.isApprove,
    this.productBy,
    this.productById,
    this.id,
  });

  ProductData.fromJson(Map<String, dynamic> json)
      : prodShopId = json['prod_shop_id'] as int?,
        prodCatId = json['prod_cat_id'] as int?,
        prodName = json['prod_name'] as String?,
        prodImage = json['prod_image'] as String?,
        prodDesc = json['prod_desc'] as String?,
        productPriceInr = json['product_price_inr'] as double?,
        offerPriceInr = json['offer_price_inr'] as int?,
        productPriceUsd = json['product_price_usd'] as int?,
        productStatus = json['product_status'] as int?,
        productLongDesc = json['product_long_desc'] as String?,
        productBannerImage = json['product_banner_image'] as String?,
        isApprove = json['is_approve'] as bool?,
        productBy = json['product_by'] as int?,
        productById = json['product_by_id'] as int?,
        id = json['id'] as int?;

  Map<String, dynamic> toJson() => {
        'prod_shop_id': prodShopId,
        'prod_cat_id': prodCatId,
        'prod_name': prodName,
        'prod_image': prodImage,
        'prod_desc': prodDesc,
        'product_price_inr': productPriceInr,
        'offer_price_inr': offerPriceInr,
        'product_price_usd': productPriceUsd,
        'product_status': productStatus,
        'product_long_desc': productLongDesc,
        'product_banner_image': productBannerImage,
        'is_approve': isApprove,
        'product_by': productBy,
        'product_by_id': productById,
        'id': id
      };
}
