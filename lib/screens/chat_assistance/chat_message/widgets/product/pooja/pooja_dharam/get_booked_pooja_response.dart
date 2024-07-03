// class GetBookedPoojaResponse {
//   GetBookedPoojaResponseData? data;
//   bool? success;
//   int? statusCode;
//   String? message;

//   GetBookedPoojaResponse(
//       {this.data, this.success, this.statusCode, this.message});

//   GetBookedPoojaResponse.fromJson(Map<String, dynamic> json) {
//     data = json['data'] != null
//         ? new GetBookedPoojaResponseData.fromJson(json['data'])
//         : null;
//     success = json['success'];
//     statusCode = json['status_code'];
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['success'] = this.success;
//     data['status_code'] = this.statusCode;
//     data['message'] = this.message;
//     return data;
//   }
// }

// class GetBookedPoojaResponseData {
//   List<UpcomingPooja>? upcomingPooja;
//   List<UpcomingPooja>? poojaHistory;

//   GetBookedPoojaResponseData({this.upcomingPooja, this.poojaHistory});

//   GetBookedPoojaResponseData.fromJson(Map<String, dynamic> json) {
//     if (json['upcoming_pooja'] != null) {
//       upcomingPooja = <UpcomingPooja>[];
//       json['upcoming_pooja'].forEach((v) {
//         upcomingPooja!.add(new UpcomingPooja.fromJson(v));
//       });
//     }
//     if (json['pooja_history'] != null) {
//       poojaHistory = <UpcomingPooja>[];
//       json['pooja_history'].forEach((v) {
//         poojaHistory!.add(new UpcomingPooja.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.upcomingPooja != null) {
//       data['upcoming_pooja'] =
//           this.upcomingPooja!.map((v) => v.toJson()).toList();
//     }
//     if (this.poojaHistory != null) {
//       data['pooja_history'] =
//           this.poojaHistory!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class UpcomingPooja {
//   int? id;
//   int? productId;
//   int? amount;
//   String? transactionFrom;
//   String? addressTitle;
//   int? phoneNo;
//   int? alternatePhoneNo;
//   String? flatNo;
//   String? locality;
//   String? landmark;
//   String? city;
//   String? state;
//   int? pincode;
//   int? userId;
//   int? transactionId;
//   String? createdAt;
//   int? quantity;
//   int? productType;
//   String? productTypeName;
//   String? productTypeTableName;
//   String? appointmentDate;
//   String? appointmentTime;
//   String? orderId;
//   int? isOfferApply;
//   int? offerCost;
//   String? status;
//   int? offerAmount;
//   int? isFine;
//   int? partnerFineAmount;
//   GetPooja? getPooja;

//   UpcomingPooja(
//       {this.id,
//       this.productId,
//       this.amount,
//       this.transactionFrom,
//       this.addressTitle,
//       this.phoneNo,
//       this.alternatePhoneNo,
//       this.flatNo,
//       this.locality,
//       this.landmark,
//       this.city,
//       this.state,
//       this.pincode,
//       this.userId,
//       this.transactionId,
//       this.createdAt,
//       this.quantity,
//       this.productType,
//       this.productTypeName,
//       this.productTypeTableName,
//       this.appointmentDate,
//       this.appointmentTime,
//       this.orderId,
//       this.isOfferApply,
//       this.offerCost,
//       this.status,
//       this.offerAmount,
//       this.isFine,
//       this.partnerFineAmount,
//       this.getPooja});

//   UpcomingPooja.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productId = json['product_id'];
//     amount = json['amount'];
//     transactionFrom = json['transaction_from'];
//     addressTitle = json['address_title'];
//     phoneNo = json['phone_no'];
//     alternatePhoneNo = json['alternate_phone_no'];
//     flatNo = json['flat_no'];
//     locality = json['locality'];
//     landmark = json['landmark'];
//     city = json['city'];
//     state = json['state'];
//     pincode = json['pincode'];
//     userId = json['user_id'];
//     transactionId = json['transaction_id'];
//     createdAt = json['created_at'];
//     quantity = json['quantity'];
//     productType = json['product_type'];
//     productTypeName = json['product_type_name'];
//     productTypeTableName = json['product_type_table_name'];
//     appointmentDate = json['appointment_date'];
//     appointmentTime = json['appointment_time'];
//     orderId = json['order_id'];
//     isOfferApply = json['is_offer_apply'];
//     offerCost = json['offer_cost'];
//     status = json['status'];
//     offerAmount = json['offer_amount'];
//     isFine = json['is_fine'];
//     partnerFineAmount = json['partner_fine_amount'];
//     getPooja = json['get_pooja'] != null
//         ? new GetPooja.fromJson(json['get_pooja'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_id'] = this.productId;
//     data['amount'] = this.amount;
//     data['transaction_from'] = this.transactionFrom;
//     data['address_title'] = this.addressTitle;
//     data['phone_no'] = this.phoneNo;
//     data['alternate_phone_no'] = this.alternatePhoneNo;
//     data['flat_no'] = this.flatNo;
//     data['locality'] = this.locality;
//     data['landmark'] = this.landmark;
//     data['city'] = this.city;
//     data['state'] = this.state;
//     data['pincode'] = this.pincode;
//     data['user_id'] = this.userId;
//     data['transaction_id'] = this.transactionId;
//     data['created_at'] = this.createdAt;
//     data['quantity'] = this.quantity;
//     data['product_type'] = this.productType;
//     data['product_type_name'] = this.productTypeName;
//     data['product_type_table_name'] = this.productTypeTableName;
//     data['appointment_date'] = this.appointmentDate;
//     data['appointment_time'] = this.appointmentTime;
//     data['order_id'] = this.orderId;
//     data['is_offer_apply'] = this.isOfferApply;
//     data['offer_cost'] = this.offerCost;
//     data['status'] = this.status;
//     data['offer_amount'] = this.offerAmount;
//     data['is_fine'] = this.isFine;
//     data['partner_fine_amount'] = this.partnerFineAmount;
//     if (this.getPooja != null) {
//       data['get_pooja'] = this.getPooja!.toJson();
//     }
//     return data;
//   }
// }

// class GetPooja {
//   int? id;
//   String? poojaName;
//   String? poojaImg;
//   String? poojaDesc;
//   int? poojaStartingPriceInr;
//   int? poojaStartingPriceUsd;
//   String? poojaShortDesc;
//   String? poojaBannerImage;
//   int? referalAmount;
//   int? payoutType;
//   int? payoutValue;
//   int? cashbackType;
//   int? cashbackValue;

//   GetPooja(
//       {this.id,
//       this.poojaName,
//       this.poojaImg,
//       this.poojaDesc,
//       this.poojaStartingPriceInr,
//       this.poojaStartingPriceUsd,
//       this.poojaShortDesc,
//       this.poojaBannerImage,
//       this.referalAmount,
//       this.payoutType,
//       this.payoutValue,
//       this.cashbackType,
//       this.cashbackValue});

//   GetPooja.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     poojaName = json['pooja_name'];
//     poojaImg = json['pooja_img'];
//     poojaDesc = json['pooja_desc'];
//     poojaStartingPriceInr = json['pooja_starting_price_inr'];
//     poojaStartingPriceUsd = json['pooja_starting_price_usd'];
//     poojaShortDesc = json['pooja_short_desc'];
//     poojaBannerImage = json['pooja_banner_image'];
//     referalAmount = json['referal_amount'];
//     payoutType = json['payout_type'];
//     payoutValue = json['payout_value'];
//     cashbackType = json['cashback_type'];
//     cashbackValue = json['cashback_value'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['pooja_name'] = this.poojaName;
//     data['pooja_img'] = this.poojaImg;
//     data['pooja_desc'] = this.poojaDesc;
//     data['pooja_starting_price_inr'] = this.poojaStartingPriceInr;
//     data['pooja_starting_price_usd'] = this.poojaStartingPriceUsd;
//     data['pooja_short_desc'] = this.poojaShortDesc;
//     data['pooja_banner_image'] = this.poojaBannerImage;
//     data['referal_amount'] = this.referalAmount;
//     data['payout_type'] = this.payoutType;
//     data['payout_value'] = this.payoutValue;
//     data['cashback_type'] = this.cashbackType;
//     data['cashback_value'] = this.cashbackValue;
//     return data;
//   }
// }

class GetBookedPoojaResponse {
  GetBookedPoojaResponseDataData? data;
  bool? success;
  int? statusCode;
  String? message;

  GetBookedPoojaResponse(
      {this.data, this.success, this.statusCode, this.message});

  GetBookedPoojaResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? GetBookedPoojaResponseDataData.fromJson(json['data'])
        : null;
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

class GetBookedPoojaResponseDataData {
  List<PoojaHistory>? poojaHistory;

  GetBookedPoojaResponseDataData({this.poojaHistory});

  GetBookedPoojaResponseDataData.fromJson(Map<String, dynamic> json) {
    if (json['pooja_history'] != null) {
      poojaHistory = <PoojaHistory>[];
      json['pooja_history'].forEach((v) {
        poojaHistory!.add(PoojaHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (poojaHistory != null) {
      data['pooja_history'] = poojaHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PoojaHistory {
  int? id;
  int? productId;
  int? amount;
  String? transactionFrom;
  String? addressTitle;
  int? phoneNo;
  int? alternatePhoneNo;
  String? flatNo;
  String? locality;
  String? landmark;
  String? city;
  String? state;
  int? pincode;
  int? userId;
  int? transactionId;
  String? createdAt;
  int? quantity;
  int? productType;
  String? productTypeName;
  String? productTypeTableName;
  String? appointmentDate;
  String? appointmentTime;
  String? orderId;
  int? isOfferApply;
  int? offerCost;
  String? status;
  int? offerAmount;
  int? isFine;
  int? partnerFineAmount;
  GetPooja? getPooja;
  String? type;

  PoojaHistory(
      {this.id,
      this.productId,
      this.amount,
      this.transactionFrom,
      this.addressTitle,
      this.phoneNo,
      this.alternatePhoneNo,
      this.flatNo,
      this.locality,
      this.landmark,
      this.city,
      this.state,
      this.pincode,
      this.userId,
      this.transactionId,
      this.createdAt,
      this.quantity,
      this.productType,
      this.productTypeName,
      this.productTypeTableName,
      this.appointmentDate,
      this.appointmentTime,
      this.orderId,
      this.isOfferApply,
      this.offerCost,
      this.status,
      this.offerAmount,
      this.isFine,
      this.partnerFineAmount,
      this.getPooja,
      this.type});

  PoojaHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    amount = json['amount'];
    transactionFrom = json['transaction_from'];
    addressTitle = json['address_title'];
    phoneNo = json['phone_no'];
    alternatePhoneNo = json['alternate_phone_no'];
    flatNo = json['flat_no'];
    locality = json['locality'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    userId = json['user_id'];
    transactionId = json['transaction_id'];
    createdAt = json['created_at'];
    quantity = json['quantity'];
    productType = json['product_type'];
    productTypeName = json['product_type_name'];
    productTypeTableName = json['product_type_table_name'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    orderId = json['order_id'];
    isOfferApply = json['is_offer_apply'];
    offerCost = json['offer_cost'];
    status = json['status'];
    offerAmount = json['offer_amount'];
    isFine = json['is_fine'];
    partnerFineAmount = json['partner_fine_amount'];
    getPooja =
        json['get_pooja'] != null ? GetPooja.fromJson(json['pooja']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['amount'] = amount;
    data['transaction_from'] = transactionFrom;
    data['address_title'] = addressTitle;
    data['phone_no'] = phoneNo;
    data['alternate_phone_no'] = alternatePhoneNo;
    data['flat_no'] = flatNo;
    data['locality'] = locality;
    data['landmark'] = landmark;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['user_id'] = userId;
    data['transaction_id'] = transactionId;
    data['created_at'] = createdAt;
    data['quantity'] = quantity;
    data['product_type'] = productType;
    data['product_type_name'] = productTypeName;
    data['product_type_table_name'] = productTypeTableName;
    data['appointment_date'] = appointmentDate;
    data['appointment_time'] = appointmentTime;
    data['order_id'] = orderId;
    data['is_offer_apply'] = isOfferApply;
    data['offer_cost'] = offerCost;
    data['status'] = status;
    data['offer_amount'] = offerAmount;
    data['is_fine'] = isFine;
    data['partner_fine_amount'] = partnerFineAmount;
    if (getPooja != null) {
      data['pooja'] = getPooja!.toJson();
    }
    data['type'] = type;
    return data;
  }
}

class GetPooja {
  int? id;
  String? poojaName;
  String? poojaImg;
  String? poojaDesc;
  int? poojaStartingPriceInr;
  Null? poojaStartingPriceUsd;
  String? poojaShortDesc;
  String? poojaBannerImage;
  int? referalAmount;
  int? payoutType;
  int? payoutValue;
  int? cashbackType;
  int? cashbackValue;

  GetPooja(
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

  GetPooja.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pooja_name'] = poojaName;
    data['pooja_img'] = poojaImg;
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
