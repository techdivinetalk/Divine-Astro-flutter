class GetPoojaResponse {
  GetPoojaResponseData? data;
  bool? success;
  int? statusCode;
  String? message;

  GetPoojaResponse({this.data, this.success, this.statusCode, this.message});

  GetPoojaResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new GetPoojaResponseData.fromJson(json['data'])
        : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class GetPoojaResponseData {
  List<Pooja>? pooja;
  List<PoojaBanner>? banner;

  GetPoojaResponseData({this.pooja, this.banner});

  GetPoojaResponseData.fromJson(Map<String, dynamic> json) {
    if (json['pooja'] != null) {
      pooja = <Pooja>[];
      json['pooja'].forEach((v) {
        pooja!.add(new Pooja.fromJson(v));
      });
    }
    if (json['banner'] != null) {
      banner = <PoojaBanner>[];
      json['banner'].forEach((v) {
        banner!.add(new PoojaBanner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pooja != null) {
      data['pooja'] = this.pooja!.map((v) => v.toJson()).toList();
    }
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
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
    data['id'] = this.id;
    data['pooja_name'] = this.poojaName;
    data['pooja_img'] = this.poojaImg;
    data['pooja_desc'] = this.poojaDesc;
    data['pooja_starting_price_inr'] = this.poojaStartingPriceInr;
    data['pooja_starting_price_usd'] = this.poojaStartingPriceUsd;
    data['pooja_short_desc'] = this.poojaShortDesc;
    data['pooja_banner_image'] = this.poojaBannerImage;
    data['referal_amount'] = this.referalAmount;
    data['payout_type'] = this.payoutType;
    data['payout_value'] = this.payoutValue;
    data['cashback_type'] = this.cashbackType;
    data['cashback_value'] = this.cashbackValue;
    return data;
  }
}

class PoojaBanner {
  int? id;
  String? bannerImage;
  int? bannerType;
  String? deeplink;
  String? category;
  String? subCategory;
  Null? param;

  PoojaBanner(
      {this.id,
      this.bannerImage,
      this.bannerType,
      this.deeplink,
      this.category,
      this.subCategory,
      this.param});

  PoojaBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerImage = json['banner_image'];
    bannerType = json['banner_type'];
    deeplink = json['deeplink'];
    category = json['category'];
    subCategory = json['sub_category'];
    param = json['param'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['banner_image'] = this.bannerImage;
    data['banner_type'] = this.bannerType;
    data['deeplink'] = this.deeplink;
    data['category'] = this.category;
    data['sub_category'] = this.subCategory;
    data['param'] = this.param;
    return data;
  }
}
