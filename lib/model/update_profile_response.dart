import 'dart:convert';

import 'package:divine_astrologer/model/res_login.dart';

UpdateProfileResponse updateProfileResponseFromJson(String str) =>
    UpdateProfileResponse.fromJson(json.decode(str));

String updateProfileResponseToJson(UpdateProfileResponse data) =>
    json.encode(data.toJson());

class UpdateProfileResponse {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  UpdateProfileResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  UpdateProfileResponse copyWith({
    Data? data,
    bool? success,
    int? statusCode,
    String? message,
  }) =>
      UpdateProfileResponse(
        data: data ?? this.data,
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResponse(
        data: Data.fromJson(json["data"]),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class Data {
  int? id;
  String? name;
  String? phoneNo;
  String? email;
  String? image;
  dynamic category;
  int? status;
  String? language;
  int? rating;
  dynamic balance;
  String? legalDocuments;
  dynamic experiance;
  String? description;
  int? isChat;
  int? isCall;
  int? isVideo;
  dynamic amount;
  int? videoCallAmount;
  int? videoCallMinimumTime;
  int? audioCallAmount;
  int? audioCallMinimumTime;
  int? anonymousCallAmount;
  int? anonymousCallMinimumTime;
  int? chatAmount;
  int? chatMinimumTime;
  int? videoCallPayout;
  int? audioCallPayout;
  int? anonymousCallPayout;
  int? chatPayout;
  int? giftPayout;
  String? accountNumber;
  String? ifscCode;
  String? accountHolderName;
  String? accountType;
  double? totalPayout;
  double? totalPayment;
  dynamic razorpayContactId;
  String? employmentType;
  String? bankName;
  int? payoutType;
  int? freshdeskId;
  int? videoDiscountedAmount;
  int? audioDiscountedAmount;
  int? anonymousDiscountedAmount;
  int? chatDiscountedAmount;
  dynamic speciality;
  int? roleId;
  int? uniqueNo;
  int? isBusy;
  String? deviceToken;
  num? appVersion;
  String? deviceBrand;
  String? deviceModel;
  String? deviceManufacture;
  String? deviceSdkCode;
  String? panNo;
  String? paymentMode;
  String? sessionId;
  int? callPreviousStatus;
  int? chatPreviousStatus;
  double? retention;
  String? premium;
  int? freeOrderCount;
  dynamic astroCat;
  List<AstroCatPivot> astroCatPivot;
  List<AstrologerSpeciality> astroSpecialityPivot;

  Data({
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
    this.anonymousCallPayout,
    this.chatPayout,
    this.giftPayout,
    this.accountNumber,
    this.ifscCode,
    this.accountHolderName,
    this.accountType,
    this.totalPayout,
    this.totalPayment,
    this.razorpayContactId,
    this.employmentType,
    this.bankName,
    this.payoutType,
    this.freshdeskId,
    this.videoDiscountedAmount,
    this.audioDiscountedAmount,
    this.anonymousDiscountedAmount,
    this.chatDiscountedAmount,
    this.speciality,
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
    this.freeOrderCount,
    this.astroCat,
    this.astroCatPivot = const [],
    this.astroSpecialityPivot = const [],
  });

  Data copyWith({
    int? id,
    String? name,
    String? phoneNo,
    String? email,
    String? image,
    dynamic category,
    int? status,
    String? language,
    int? rating,
    dynamic balance,
    String? legalDocuments,
    dynamic experiance,
    String? description,
    int? isChat,
    int? isCall,
    int? isVideo,
    dynamic amount,
    int? videoCallAmount,
    int? videoCallMinimumTime,
    int? audioCallAmount,
    int? audioCallMinimumTime,
    int? anonymousCallAmount,
    int? anonymousCallMinimumTime,
    int? chatAmount,
    int? chatMinimumTime,
    int? videoCallPayout,
    int? audioCallPayout,
    int? anonymousCallPayout,
    int? chatPayout,
    int? giftPayout,
    String? accountNumber,
    String? ifscCode,
    String? accountHolderName,
    String? accountType,
    double? totalPayout,
    double? totalPayment,
    dynamic razorpayContactId,
    String? employmentType,
    String? bankName,
    int? payoutType,
    int? freshdeskId,
    int? videoDiscountedAmount,
    int? audioDiscountedAmount,
    int? anonymousDiscountedAmount,
    int? chatDiscountedAmount,
    dynamic speciality,
    int? roleId,
    int? uniqueNo,
    int? isBusy,
    String? deviceToken,
    double? appVersion,
    String? deviceBrand,
    String? deviceModel,
    String? deviceManufacture,
    String? deviceSdkCode,
    String? panNo,
    String? paymentMode,
    String? sessionId,
    int? callPreviousStatus,
    int? chatPreviousStatus,
    double? retention,
    String? premium,
    int? freeOrderCount,
    dynamic astroCat,
    List<AstroCatPivot>? astroCatPivot,
    List<AstrologerSpeciality>? astroSpecialityPivot,
  }) =>
      Data(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNo: phoneNo ?? this.phoneNo,
        email: email ?? this.email,
        image: image ?? this.image,
        category: category ?? this.category,
        status: status ?? this.status,
        language: language ?? this.language,
        rating: rating ?? this.rating,
        balance: balance ?? this.balance,
        legalDocuments: legalDocuments ?? this.legalDocuments,
        experiance: experiance ?? this.experiance,
        description: description ?? this.description,
        isChat: isChat ?? this.isChat,
        isCall: isCall ?? this.isCall,
        isVideo: isVideo ?? this.isVideo,
        amount: amount ?? this.amount,
        videoCallAmount: videoCallAmount ?? this.videoCallAmount,
        videoCallMinimumTime: videoCallMinimumTime ?? this.videoCallMinimumTime,
        audioCallAmount: audioCallAmount ?? this.audioCallAmount,
        audioCallMinimumTime: audioCallMinimumTime ?? this.audioCallMinimumTime,
        anonymousCallAmount: anonymousCallAmount ?? this.anonymousCallAmount,
        anonymousCallMinimumTime:
            anonymousCallMinimumTime ?? this.anonymousCallMinimumTime,
        chatAmount: chatAmount ?? this.chatAmount,
        chatMinimumTime: chatMinimumTime ?? this.chatMinimumTime,
        videoCallPayout: videoCallPayout ?? this.videoCallPayout,
        audioCallPayout: audioCallPayout ?? this.audioCallPayout,
        anonymousCallPayout: anonymousCallPayout ?? this.anonymousCallPayout,
        chatPayout: chatPayout ?? this.chatPayout,
        giftPayout: giftPayout ?? this.giftPayout,
        accountNumber: accountNumber ?? this.accountNumber,
        ifscCode: ifscCode ?? this.ifscCode,
        accountHolderName: accountHolderName ?? this.accountHolderName,
        accountType: accountType ?? this.accountType,
        totalPayout: totalPayout ?? this.totalPayout,
        totalPayment: totalPayment ?? this.totalPayment,
        razorpayContactId: razorpayContactId ?? this.razorpayContactId,
        employmentType: employmentType ?? this.employmentType,
        bankName: bankName ?? this.bankName,
        payoutType: payoutType ?? this.payoutType,
        freshdeskId: freshdeskId ?? this.freshdeskId,
        videoDiscountedAmount:
            videoDiscountedAmount ?? this.videoDiscountedAmount,
        audioDiscountedAmount:
            audioDiscountedAmount ?? this.audioDiscountedAmount,
        anonymousDiscountedAmount:
            anonymousDiscountedAmount ?? this.anonymousDiscountedAmount,
        chatDiscountedAmount: chatDiscountedAmount ?? this.chatDiscountedAmount,
        speciality: speciality ?? this.speciality,
        roleId: roleId ?? this.roleId,
        uniqueNo: uniqueNo ?? this.uniqueNo,
        isBusy: isBusy ?? this.isBusy,
        deviceToken: deviceToken ?? this.deviceToken,
        appVersion: appVersion ?? this.appVersion,
        deviceBrand: deviceBrand ?? this.deviceBrand,
        deviceModel: deviceModel ?? this.deviceModel,
        deviceManufacture: deviceManufacture ?? this.deviceManufacture,
        deviceSdkCode: deviceSdkCode ?? this.deviceSdkCode,
        panNo: panNo ?? this.panNo,
        paymentMode: paymentMode ?? this.paymentMode,
        sessionId: sessionId ?? this.sessionId,
        callPreviousStatus: callPreviousStatus ?? this.callPreviousStatus,
        chatPreviousStatus: chatPreviousStatus ?? this.chatPreviousStatus,
        retention: retention ?? this.retention,
        premium: premium ?? this.premium,
        freeOrderCount: freeOrderCount ?? this.freeOrderCount,
        astroCat: astroCat ?? this.astroCat,
        astroCatPivot: astroCatPivot ?? this.astroCatPivot,
        astroSpecialityPivot: astroSpecialityPivot ?? this.astroSpecialityPivot,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        phoneNo: json["phone_no"],
        email: json["email"],
        image: json["image"],
        category: json["category"],
        status: json["status"],
        language: json["language"],
        rating: json["rating"],
        balance: json["balance"],
        legalDocuments: json["legal_documents"],
        experiance: json["experiance"],
        description: json["description"],
        isChat: json["is_chat"],
        isCall: json["is_call"],
        isVideo: json["is_video"],
        amount: json["amount"],
        videoCallAmount: json["video_call_amount"],
        videoCallMinimumTime: json["video_call_minimum_time"],
        audioCallAmount: json["audio_call_amount"],
        audioCallMinimumTime: json["audio_call_minimum_time"],
        anonymousCallAmount: json["anonymous_call_amount"],
        anonymousCallMinimumTime: json["anonymous_call_minimum_time"],
        chatAmount: json["chat_amount"],
        chatMinimumTime: json["chat_minimum_time"],
        videoCallPayout: json["video_call_payout"],
        audioCallPayout: json["audio_call_payout"],
        anonymousCallPayout: json["anonymous_call_payout"],
        chatPayout: json["chat_payout"],
        giftPayout: json["gift_payout"],
        accountNumber: json["account_number"],
        ifscCode: json["ifsc_code"],
        accountHolderName: json["account_holder_name"],
        accountType: json["account_type"],
        totalPayout: json["total_payout"].toDouble(),
        totalPayment: json["total_payment"].toDouble(),
        razorpayContactId: json["razorpay_contact_id"],
        employmentType: json["employment_type"],
        bankName: json["bank_name"],
        payoutType: json["payout_type"],
        freshdeskId: json["freshdesk_id"],
        videoDiscountedAmount: json["video_discounted_amount"],
        audioDiscountedAmount: json["audio_discounted_amount"],
        anonymousDiscountedAmount: json["anonymous_discounted_amount"],
        chatDiscountedAmount: json["chat_discounted_amount"],
        speciality: json["speciality"],
        roleId: json["role_id"],
        uniqueNo: json["unique_no"],
        isBusy: json["is_busy"],
        deviceToken: json["device_token"],
        appVersion: json["appVersion"],
        deviceBrand: json["device_brand"],
        deviceModel: json["device_model"],
        deviceManufacture: json["device_manufacture"],
        deviceSdkCode: json["device_sdk_code"],
        panNo: json["pan_no"],
        paymentMode: json["payment_mode"],
        sessionId: json["session_id"],
        callPreviousStatus: json["call_previous_status"],
        chatPreviousStatus: json["chat_previous_status"],
        retention: json["retention"].toDouble(),
        premium: json["premium"],
        freeOrderCount: json["free_order_count"],
        astroCat: json["astro_cat"],
        astroCatPivot: json["astro_cat_pivot"] != null
            ? List<AstroCatPivot>.from(
                json["astro_cat_pivot"].map((x) => AstroCatPivot.fromJson(x)))
            : [],
        astroSpecialityPivot: json["astro_speciality_pivot"] != null
            ? List<AstrologerSpeciality>.from(json["astro_speciality_pivot"]
                .map((x) => AstrologerSpeciality.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_no": phoneNo,
        "email": email,
        "image": image,
        "category": category,
        "status": status,
        "language": language,
        "rating": rating,
        "balance": balance,
        "legal_documents": legalDocuments,
        "experiance": experiance,
        "description": description,
        "is_chat": isChat,
        "is_call": isCall,
        "is_video": isVideo,
        "amount": amount,
        "video_call_amount": videoCallAmount,
        "video_call_minimum_time": videoCallMinimumTime,
        "audio_call_amount": audioCallAmount,
        "audio_call_minimum_time": audioCallMinimumTime,
        "anonymous_call_amount": anonymousCallAmount,
        "anonymous_call_minimum_time": anonymousCallMinimumTime,
        "chat_amount": chatAmount,
        "chat_minimum_time": chatMinimumTime,
        "video_call_payout": videoCallPayout,
        "audio_call_payout": audioCallPayout,
        "anonymous_call_payout": anonymousCallPayout,
        "chat_payout": chatPayout,
        "gift_payout": giftPayout,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "account_holder_name": accountHolderName,
        "account_type": accountType,
        "total_payout": totalPayout,
        "total_payment": totalPayment,
        "razorpay_contact_id": razorpayContactId,
        "employment_type": employmentType,
        "bank_name": bankName,
        "payout_type": payoutType,
        "freshdesk_id": freshdeskId,
        "video_discounted_amount": videoDiscountedAmount,
        "audio_discounted_amount": audioDiscountedAmount,
        "anonymous_discounted_amount": anonymousDiscountedAmount,
        "chat_discounted_amount": chatDiscountedAmount,
        "speciality": speciality,
        "role_id": roleId,
        "unique_no": uniqueNo,
        "is_busy": isBusy,
        "device_token": deviceToken,
        "appVersion": appVersion,
        "device_brand": deviceBrand,
        "device_model": deviceModel,
        "device_manufacture": deviceManufacture,
        "device_sdk_code": deviceSdkCode,
        "pan_no": panNo,
        "payment_mode": paymentMode,
        "session_id": sessionId,
        "call_previous_status": callPreviousStatus,
        "chat_previous_status": chatPreviousStatus,
        "retention": retention,
        "premium": premium,
        "free_order_count": freeOrderCount,
        "astro_cat": astroCat,
        "astro_cat_pivot":
            List<dynamic>.from(astroCatPivot.map((x) => x.toJson())),
        "astro_speciality_pivot":
            List<dynamic>.from(astroSpecialityPivot.map((x) => x.toJson())),
      };
}

class AstroCatPivot {
  int? id;
  int? astrologerId;
  int? categoryId;
  CategoryDetails? categoryDetails;

  AstroCatPivot({
    this.id,
    this.astrologerId,
    this.categoryId,
    this.categoryDetails,
  });

  AstroCatPivot copyWith({
    int? id,
    int? astrologerId,
    int? categoryId,
    CategoryDetails? categoryDetails,
  }) =>
      AstroCatPivot(
        id: id ?? this.id,
        astrologerId: astrologerId ?? this.astrologerId,
        categoryId: categoryId ?? this.categoryId,
        categoryDetails: categoryDetails ?? this.categoryDetails,
      );

  factory AstroCatPivot.fromJson(Map<String, dynamic> json) => AstroCatPivot(
        id: json["id"],
        astrologerId: json["astrologer_id"],
        categoryId: json["category_id"],
        categoryDetails: CategoryDetails.fromJson(json["category_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "astrologer_id": astrologerId,
        "category_id": categoryId,
        "category_details": categoryDetails?.toJson(),
      };
}

class CategoryDetails {
  int? id;
  String? name;
  String? image;
  int? status;

  CategoryDetails({
    this.id,
    this.name,
    this.image,
    this.status,
  });

  CategoryDetails copyWith({
    int? id,
    String? name,
    String? image,
    int? status,
  }) =>
      CategoryDetails(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        status: status ?? this.status,
      );

  factory CategoryDetails.fromJson(Map<String, dynamic> json) =>
      CategoryDetails(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "status": status,
      };
}
