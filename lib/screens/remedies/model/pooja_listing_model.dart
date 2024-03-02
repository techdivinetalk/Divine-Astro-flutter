class PujaListingModel {
  final List<PujaListingData>? data;
  final bool? success;
  final int? statusCode;
  final String? message;

  PujaListingModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  PujaListingModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((dynamic e) => PujaListingData.fromJson(e as Map<String,dynamic>)).toList(),
        success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'data' : data?.map((e) => e.toJson()).toList(),
    'success' : success,
    'status_code' : statusCode,
    'message' : message
  };
}

class PujaListingData {
  final int? id;
  final String? poojaName;
  final String? poojaImg;
  final String? poojaDesc;
  final int? poojaStartingPriceInr;
  final int? poojaStartingPriceUsd;
  final String? poojaShortDesc;
  final String? poojaBannerImage;
  final int? referalAmount;
  final int? payoutType;
  final int? payoutValue;
  final int? cashbackType;
  final int? cashbackValue;
  final int? poojaBy;
  final int? poojaById;
  final int? isApprove;

  PujaListingData({
    this.id,
    this.poojaName,
    this.poojaImg,
    this.poojaDesc,
    this.poojaStartingPriceInr,
    this.poojaStartingPriceUsd,
    this.poojaShortDesc,
    this.poojaBannerImage,
    this.referalAmount,
    this.payoutType,
    this.payoutValue,
    this.cashbackType,
    this.cashbackValue,
    this.poojaBy,
    this.poojaById,
    this.isApprove,
  });

  PujaListingData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        poojaName = json['pooja_name'] as String?,
        poojaImg = json['pooja_img'] as String?,
        poojaDesc = json['pooja_desc'] as String?,
        poojaStartingPriceInr = json['pooja_starting_price_inr'] as int?,
        poojaStartingPriceUsd = json['pooja_starting_price_usd'] as int?,
        poojaShortDesc = json['pooja_short_desc'] as String?,
        poojaBannerImage = json['pooja_banner_image'] as String?,
        referalAmount = json['referal_amount'] as int?,
        payoutType = json['payout_type'] as int?,
        payoutValue = json['payout_value'] as int?,
        cashbackType = json['cashback_type'] as int?,
        cashbackValue = json['cashback_value'] as int?,
        poojaBy = json['pooja_by'] as int?,
        poojaById = json['pooja_by_id'] as int?,
        isApprove = json['is_approve'] as int?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'pooja_name' : poojaName,
    'pooja_img' : poojaImg,
    'pooja_desc' : poojaDesc,
    'pooja_starting_price_inr' : poojaStartingPriceInr,
    'pooja_starting_price_usd' : poojaStartingPriceUsd,
    'pooja_short_desc' : poojaShortDesc,
    'pooja_banner_image' : poojaBannerImage,
    'referal_amount' : referalAmount,
    'payout_type' : payoutType,
    'payout_value' : payoutValue,
    'cashback_type' : cashbackType,
    'cashback_value' : cashbackValue,
    'pooja_by' : poojaBy,
    'pooja_by_id' : poojaById,
    'is_approve' : isApprove
  };
}