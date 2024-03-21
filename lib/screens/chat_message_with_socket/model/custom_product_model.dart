class CustomProductModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final CustomProductData? data;

  CustomProductModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  CustomProductModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String,dynamic>?) != null ? CustomProductData.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'success' : success,
    'status_code' : statusCode,
    'message' : message,
    'data' : data?.toJson()
  };
}

class CustomProductData {
  final String? name;
  final String? image;
  final String? desc;
  final int? amount;
  final int? astrologerId;
  final int? id;
  final int? gst;
  final int? gstAmount;
  final int? totalAmountWithGst;

  CustomProductData({
    this.name,
    this.image,
    this.desc,
    this.amount,
    this.astrologerId,
    this.id,
    this.gst,
    this.gstAmount,
    this.totalAmountWithGst,
  });

  CustomProductData.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        image = json['image'] as String?,
        desc = json['desc'] as String?,
        amount = json['amount'] as int?,
        astrologerId = json['astrologer_id'] as int?,
        id = json['id'] as int?,
        gst = json['gst'] as int?,
        gstAmount = json['gst_amount'] as int?,
        totalAmountWithGst = json['total_amount_with_gst'] as int?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'image' : image,
    'desc' : desc,
    'amount' : amount,
    'astrologer_id' : astrologerId,
    'id' : id,
    'gst' : gst,
    'gst_amount' : gstAmount,
    'total_amount_with_gst' : totalAmountWithGst
  };
}