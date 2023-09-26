class ResLogin {
  UserData? data;
  bool? success;
  int? statusCode;
  String? token;

  ResLogin({this.data, this.success, this.statusCode, this.token});

  ResLogin.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['token'] = token;
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  String? phoneNo;
  String? email;
  String? image;
  String? category;
  int? status;
  String? language;
  int? rating;
  num? balance;
  String? legalDocuments;
  String? experiance;
  String? description;
  int? isChat;
  int? isCall;
  int? isVideo;
  num? amount;
  int? videoCallAmount;
  int? videoCallMinimumTime;
  int? audioCallAmount;
  int? audioCallMinimumTime;
  int? anonymousCallAmount;
  int? anonymousCallMinimumTime;
  int? chatAmount;
  int? chatMinimumTime;
  num? videoCallPayout;
  num? audioCallPayout;

  // int? anonymousCallPayout;
  // String? chatPayout;
  double? giftPayout;
  String? accountNumber;
  String? ifscCode;
  String? accountHolderName;
  String? accountType;
  num? totalPayout;
  num? totalPayment;

  // Null? razorpayContactId;
  String? employmentType;
  String? bankName;
  int? payoutType;
  int? freshdeskId;
  int? videoDiscountedAmount;
  int? audioDiscountedAmount;
  int? anonymousDiscountedAmount;
  int? chatDiscountedAmount;

  // Null? speciality;
  int? roleId;
  int? uniqueNo;
  int? isBusy;
  String? deviceToken;
  double? appVersion;
  String? deviceBrand;
  String? deviceModel;
  String? deviceManufacture;
  String? deviceSdkCode;
  String? panNo;
  String? paymentMode;
  String? sessionId;
  int? callPreviousStatus;
  int? chatPreviousStatus;
  num? retention;
  String? premium;
  List<AstrologerSpeciality>? astrologerSpeciality;
  String? mobileNumber;

  // Null? astroCat;
  List<AstroCatPivot>? astroCatPivot;

  // List<Null>? astroSpecialityPivot;

  UserData({
    this.id,
    this.name,
    this.phoneNo,
    this.email,
    this.image,
    this.category,
    this.status,
    this.language,
    this.rating,
    this.balance,
    this.legalDocuments,
    this.experiance,
    this.description,
    this.isChat,
    this.isCall,
    this.isVideo,
    this.amount,
    this.videoCallAmount,
    this.videoCallMinimumTime,
    this.audioCallAmount,
    this.audioCallMinimumTime,
    this.anonymousCallAmount,
    this.anonymousCallMinimumTime,
    this.chatAmount,
    this.chatMinimumTime,
    this.videoCallPayout,
    this.audioCallPayout,
    // this.anonymousCallPayout,
    // this.chatPayout,
    this.giftPayout,
    this.accountNumber,
    this.ifscCode,
    this.accountHolderName,
    this.accountType,
    this.totalPayout,
    this.totalPayment,
    // this.razorpayContactId,
    this.employmentType,
    this.bankName,
    this.payoutType,
    this.freshdeskId,
    this.videoDiscountedAmount,
    this.audioDiscountedAmount,
    this.anonymousDiscountedAmount,
    this.chatDiscountedAmount,
    // this.speciality,
    this.roleId,
    this.uniqueNo,
    this.isBusy,
    this.deviceToken,
    this.appVersion,
    this.deviceBrand,
    this.deviceModel,
    this.deviceManufacture,
    this.deviceSdkCode,
    this.panNo,
    this.paymentMode,
    this.sessionId,
    this.callPreviousStatus,
    this.chatPreviousStatus,
    this.retention,
    this.premium,
    // this.astroCat,
    this.astroCatPivot,
    // this.astroSpecialityPivot
    this.astrologerSpeciality,
    this.mobileNumber,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNo = json['phone_no'];
    email = json['email'];
    image = json['image'];
    category = json['category'];
    status = json['status'];
    language = json['language'];
    rating = json['rating'];
    balance = json['balance'];
    legalDocuments = json['legal_documents'];
    experiance = json['experiance'].toString();
    description = json['description'];
    isChat = json['is_chat'];
    isCall = json['is_call'];
    isVideo = json['is_video'];
    amount = json['amount'];
    videoCallAmount = json['video_call_amount'];
    videoCallMinimumTime = json['video_call_minimum_time'];
    audioCallAmount = json['audio_call_amount'];
    audioCallMinimumTime = json['audio_call_minimum_time'];
    anonymousCallAmount = json['anonymous_call_amount'];
    anonymousCallMinimumTime = json['anonymous_call_minimum_time'];
    chatAmount = json['chat_amount'];
    chatMinimumTime = json['chat_minimum_time'];
    videoCallPayout = json['video_call_payout'];
    audioCallPayout = json['audio_call_payout'];
    // anonymousCallPayout = json['anonymous_call_payout'];
    // chatPayout = json['chat_payout'];
    giftPayout = double.parse(json['gift_payout'].toString());
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    accountHolderName = json['account_holder_name'];
    accountType = json['account_type'];
    totalPayout = json['total_payout'];
    totalPayment = json['total_payment'];
    // razorpayContactId = json['razorpay_contact_id'];
    employmentType = json['employment_type'];
    bankName = json['bank_name'];
    payoutType = json['payout_type'];
    freshdeskId = json['freshdesk_id'];
    videoDiscountedAmount = json['video_discounted_amount'];
    audioDiscountedAmount = json['audio_discounted_amount'];
    anonymousDiscountedAmount = json['anonymous_discounted_amount'];
    chatDiscountedAmount = json['chat_discounted_amount'];
    // speciality = json['speciality'];
    roleId = json['role_id'];
    uniqueNo = json['unique_no'];
    isBusy = json['is_busy'];
    deviceToken = json['device_token'];
    appVersion = json['appVersion'];
    deviceBrand = json['device_brand'];
    deviceModel = json['device_model'];
    deviceManufacture = json['device_manufacture'];
    deviceSdkCode = json['device_sdk_code'];
    panNo = json['pan_no'];
    paymentMode = json['payment_mode'];
    sessionId = json['session_id'];
    callPreviousStatus = json['call_previous_status'];
    chatPreviousStatus = json['chat_previous_status'];
    retention = json['retention'];
    premium = json['premium'];
    mobileNumber = json['mobile_no'];
    // astroCat = json['astro_cat'];
    if (json['astro_cat_pivot'] != null) {
      astroCatPivot = <AstroCatPivot>[];
      json['astro_cat_pivot'].forEach((v) {
        astroCatPivot!.add(AstroCatPivot.fromJson(v));
      });
    }
    if (json['astro_speciality_pivot'] != null) {
      astrologerSpeciality = <AstrologerSpeciality>[];
      json['astro_speciality_pivot'].forEach((v) {
        astrologerSpeciality?.add(AstrologerSpeciality.fromJson(v));
      });
    }
    // if (json['astro_speciality_pivot'] != null) {
    //   astroSpecialityPivot = <Null>[];
    //   json['astro_speciality_pivot'].forEach((v) {
    //     astroSpecialityPivot!.add(Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone_no'] = phoneNo;
    data['email'] = email;
    data['image'] = image;
    data['category'] = category;
    data['status'] = status;
    data['language'] = language;
    data['rating'] = rating;
    data['balance'] = balance;
    data['legal_documents'] = legalDocuments;
    data['experiance'] = experiance;
    data['description'] = description;
    data['is_chat'] = isChat;
    data['is_call'] = isCall;
    data['is_video'] = isVideo;
    data['amount'] = amount;
    data['video_call_amount'] = videoCallAmount;
    data['video_call_minimum_time'] = videoCallMinimumTime;
    data['audio_call_amount'] = audioCallAmount;
    data['audio_call_minimum_time'] = audioCallMinimumTime;
    data['anonymous_call_amount'] = anonymousCallAmount;
    data['anonymous_call_minimum_time'] = anonymousCallMinimumTime;
    data['chat_amount'] = chatAmount;
    data['chat_minimum_time'] = chatMinimumTime;
    data['video_call_payout'] = videoCallPayout;
    data['audio_call_payout'] = audioCallPayout;
    // data['anonymous_call_payout'] = anonymousCallPayout;
    // data['chat_payout'] = chatPayout;
    data['gift_payout'] = giftPayout;
    data['account_number'] = accountNumber;
    data['ifsc_code'] = ifscCode;
    data['account_holder_name'] = accountHolderName;
    data['account_type'] = accountType;
    data['total_payout'] = totalPayout;
    data['total_payment'] = totalPayment;
    // data['razorpay_contact_id'] = this.razorpayContactId;
    data['employment_type'] = employmentType;
    data['bank_name'] = bankName;
    data['payout_type'] = payoutType;
    data['freshdesk_id'] = freshdeskId;
    data['video_discounted_amount'] = videoDiscountedAmount;
    data['audio_discounted_amount'] = audioDiscountedAmount;
    data['anonymous_discounted_amount'] = anonymousDiscountedAmount;
    data['chat_discounted_amount'] = chatDiscountedAmount;
    // data['speciality'] = this.speciality;
    data['role_id'] = roleId;
    data['unique_no'] = uniqueNo;
    data['is_busy'] = isBusy;
    data['device_token'] = deviceToken;
    data['appVersion'] = appVersion;
    data['device_brand'] = deviceBrand;
    data['device_model'] = deviceModel;
    data['device_manufacture'] = deviceManufacture;
    data['device_sdk_code'] = deviceSdkCode;
    data['pan_no'] = panNo;
    data['payment_mode'] = paymentMode;
    data['session_id'] = sessionId;
    data['call_previous_status'] = callPreviousStatus;
    data['chat_previous_status'] = chatPreviousStatus;
    data['retention'] = retention;
    data['premium'] = premium;
    data['mobile_no'] = mobileNumber;
    // data['astro_cat'] = astroCat;
    if (astroCatPivot != null) {
      data['astro_cat_pivot'] = astroCatPivot!.map((v) => v.toJson()).toList();
    }
    if (astrologerSpeciality != null) {
      data['astro_speciality_pivot'] =
          astrologerSpeciality!.map((v) => v.toJson()).toList();
    }
    // if (astroSpecialityPivot != null) {
    //   data['astro_speciality_pivot'] =
    //       astroSpecialityPivot!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class AstroCatPivot {
  int? id;
  int? astrologerId;
  int? categoryId;
  CategoryDetails? categoryDetails;

  AstroCatPivot(
      {this.id, this.astrologerId, this.categoryId, this.categoryDetails});

  AstroCatPivot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    astrologerId = json['astrologer_id'];
    categoryId = json['category_id'];
    categoryDetails = json['category_details'] != null
        ? CategoryDetails.fromJson(json['category_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['astrologer_id'] = astrologerId;
    data['category_id'] = categoryId;
    if (categoryDetails != null) {
      data['category_details'] = categoryDetails!.toJson();
    }
    return data;
  }
}

class CategoryDetails {
  int? id;
  String? name;
  String? image;
  int? status;

  CategoryDetails({this.id, this.name, this.image, this.status});

  CategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['status'] = status;
    return data;
  }
}

class AstrologerSpeciality {
  int? id;
  int? astrologerId;
  int? astrologerSpecialityId;
  SpecialityDetails? specialityDetails;

  AstrologerSpeciality({
    this.id,
    this.astrologerId,
    this.astrologerSpecialityId,
    this.specialityDetails,
  });

  factory AstrologerSpeciality.fromJson(Map<String, dynamic> json) =>
      AstrologerSpeciality(
        id: json["id"],
        astrologerId: json["astrologer_id"],
        astrologerSpecialityId: json["astrologer_speciality_id"],
        specialityDetails: json["speciality_details"] == null
            ? null
            : SpecialityDetails.fromJson(json["speciality_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "astrologer_id": astrologerId,
        "astrologer_speciality_id": astrologerSpecialityId,
        "speciality_details": specialityDetails?.toJson(),
      };
}

class SpecialityDetails {
  int? id;
  String? name;
  String? image;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? status;

  SpecialityDetails({
    this.id,
    this.name,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory SpecialityDetails.fromJson(Map<String, dynamic> json) =>
      SpecialityDetails(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status": status,
      };
}
