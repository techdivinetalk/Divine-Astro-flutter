class GetSinglePoojaResponse {
  GetSinglePoojaResponseData? data;
  bool? success;
  int? statusCode;
  String? message;

  GetSinglePoojaResponse(
      {this.data, this.success, this.statusCode, this.message});

  GetSinglePoojaResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GetSinglePoojaResponseData.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class GetSinglePoojaResponseData {
  List<Pooja>? pooja;

  GetSinglePoojaResponseData({this.pooja});

  GetSinglePoojaResponseData.fromJson(Map<String, dynamic> json) {
    if (json['pooja'] != null) {
      pooja = <Pooja>[];
      json['pooja'].forEach((v) {
        pooja!.add(new Pooja.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (pooja != null) {
      data['pooja'] = pooja!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pooja {
  int? id;
  String? poojaName;
  String? poojaImg;
  String? poojaDesc;
  int? poojaStartingPriceInr;
  int? poojaStartingPriceUsd;
  String? poojaShortDesc;
  String? poojaBannerImage;
  String? gst;
  int? referalAmount;
  int? payoutType;
  int? payoutValue;
  int? cashbackType;
  int? cashbackValue;

  Pooja(
      {this.id,
      this.poojaName,
      this.poojaImg,
      this.poojaDesc,
      this.poojaStartingPriceInr,
      this.poojaStartingPriceUsd,
      this.poojaShortDesc,
      this.poojaBannerImage,
      this.gst,
      this.referalAmount,
      this.payoutType,
      this.payoutValue,
      this.cashbackType,
      this.cashbackValue});

  Pooja.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    poojaName = json['pooja_name'];
    poojaImg = json['pooja_img'];
    poojaDesc = json['pooja_desc'];
    poojaStartingPriceInr = json['pooja_starting_price_inr'];
    poojaStartingPriceUsd = json['pooja_starting_price_usd'];
    gst = json['gst'];
    poojaShortDesc = json['pooja_short_desc'];
    poojaBannerImage = json['pooja_banner_image'];
    referalAmount = json['referal_amount'];
    payoutType = json['payout_type'];
    payoutValue = json['payout_value'];
    cashbackType = json['cashback_type'];
    cashbackValue = json['cashback_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['pooja_name'] = poojaName;
    data['pooja_img'] = poojaImg;
    data['gst'] = gst;
    data['pooja_desc'] = poojaDesc;
    data['pooja_starting_price_inr'] = poojaStartingPriceInr;
    data['pooja_starting_price_usd'] = poojaStartingPriceUsd;
    data['pooja_short_desc'] = poojaShortDesc;
    data['pooja_banner_image'] = poojaBannerImage;
    data['referal_amount'] = referalAmount;
    data['payout_type'] = payoutType;
    data['payout_value'] = payoutValue;
    data['cashback_type'] = cashbackType;
    data['cashback_value'] = cashbackValue;
    return data;
  }
}
