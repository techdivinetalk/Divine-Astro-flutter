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
        data = (json['data'] as Map<String, dynamic>?) != null
            ? CustomProductData.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'success': success,
        'status_code': statusCode,
        'message': message,
        'data': data?.toJson()
      };
}

class CustomProductData {
  final String? name;
  final String? image;
  final String? desc;
  final dynamic amount;
  final dynamic astrologerId;
  final dynamic id;
  final dynamic gst;
  final dynamic gstAmount;
  final dynamic totalAmountWithGst;

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
        amount = json['amount'],
        astrologerId = json['astrologer_id'],
        id = json['id'],
        gst = json['gst'],
        gstAmount = json['gst_amount'],
        totalAmountWithGst = json['total_amount_with_gst'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'desc': desc,
        'amount': amount,
        'astrologer_id': astrologerId,
        'id': id,
        'gst': gst,
        'gst_amount': gstAmount,
        'total_amount_with_gst': totalAmountWithGst
      };
}
