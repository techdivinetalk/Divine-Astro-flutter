class AstrologerNordModel {
  final Status? status;
  final Data? data;

  AstrologerNordModel({
    this.status,
    this.data,
  });

  AstrologerNordModel.fromJson(Map<String, dynamic> json)
      : status = (json['status'] as Map<String,dynamic>?) != null ? Status.fromJson(json['status'] as Map<String,dynamic>) : null,
        data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'status' : status?.toJson(),
    'data' : data?.toJson()
  };
}

class Status {
  final int? code;
  final String? message;

  Status({
    this.code,
    this.message,
  });

  Status.fromJson(Map<String, dynamic> json)
      : code = json['code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'code' : code,
    'message' : message
  };
}

class Data {
  final String? index;
  final String? id;
  final int? score;
  final Source? source;
  final String? chatMsg;
  final String? callMsg;
  final String? chatColor;
  final String? callColor;

  Data({
    this.index,
    this.id,
    this.score,
    this.source,
    this.chatMsg,
    this.callMsg,
    this.chatColor,
    this.callColor,
  });

  Data.fromJson(Map<String, dynamic> json)
      : index = json['_index'] as String?,
        id = json['_id'] as String?,
        score = json['_score'] as int?,
        source = (json['_source'] as Map<String,dynamic>?) != null ? Source.fromJson(json['_source'] as Map<String,dynamic>) : null,
        chatMsg = json['chat_msg'] as String?,
        callMsg = json['call_msg'] as String?,
        chatColor = json['chat_color'] as String?,
        callColor = json['call_color'] as String?;

  Map<String, dynamic> toJson() => {
    '_index' : index,
    '_id' : id,
    '_score' : score,
    '_source' : source?.toJson(),
    'chat_msg' : chatMsg,
    'call_msg' : callMsg,
    'chat_color' : chatColor,
    'call_color' : callColor
  };
}

class Source {
  final String? chatStatus;
  final dynamic uniqueNo;
  final dynamic repurchaseRate;
  final dynamic rating;
  final dynamic isManual;
  final String? videoStatus;
  final String? language;
  final dynamic experiance;
  final dynamic videoCallAmount;
  final dynamic audioCallAmount;
  final dynamic anonymousCallAmount;
  final dynamic retention2;
  final String? offer;
  final String? callStatus;
  final int? customerAssignmentLevel;
  final dynamic roleId;
  final dynamic freeOrderTaken;
  final dynamic rank;
  final dynamic id;
  final List<Categories>? categories;
  final dynamic retention;
  final List<Specialities>? specialities;
  final String? image;
  final List<dynamic>? assignedCustomerList;
  final String? waitTime;
  final String? breathingTime;
  final String? freeOrderCount;
  final String? premiumText;
  final dynamic isTestAccount;
  final dynamic retentionTotalFreeOrder;
  final String? backgroundColor;
  final String? deviceToken;
  final dynamic freeOfferAvilable;
  final String? name;
  final dynamic chatAmount;
  final dynamic retentionPercentage;
  final dynamic retentionPriority;
  final dynamic status;
  final dynamic retentionBucket;

  Source({
    this.chatStatus,
    this.uniqueNo,
    this.repurchaseRate,
    this.rating,
    this.isManual,
    this.videoStatus,
    this.language,
    this.experiance,
    this.videoCallAmount,
    this.audioCallAmount,
    this.anonymousCallAmount,
    this.retention2,
    this.offer,
    this.callStatus,
    this.customerAssignmentLevel,
    this.roleId,
    this.freeOrderTaken,
    this.rank,
    this.id,
    this.categories,
    this.retention,
    this.specialities,
    this.image,
    this.assignedCustomerList,
    this.waitTime,
    this.breathingTime,
    this.freeOrderCount,
    this.premiumText,
    this.isTestAccount,
    this.retentionTotalFreeOrder,
    this.backgroundColor,
    this.deviceToken,
    this.freeOfferAvilable,
    this.name,
    this.chatAmount,
    this.retentionPercentage,
    this.retentionPriority,
    this.status,
    this.retentionBucket,
  });

  Source.fromJson(Map<String, dynamic> json)
      : chatStatus = json['chat_status'] as String?,
        uniqueNo = json['unique_no'],
        repurchaseRate = json['repurchase_rate'],
        rating = json['rating'],
        isManual = json['is_manual'],
        videoStatus = json['video_status'] as String?,
        language = json['language'] as String?,
        experiance = json['experiance'] ,
        videoCallAmount = json['video_call_amount'] ,
        audioCallAmount = json['audio_call_amount'] ,
        anonymousCallAmount = json['anonymous_call_amount'] ,
        retention2 = json['retention2'] ,
        offer = json['offer'] as String?,
        callStatus = json['call_status'] as String?,
        customerAssignmentLevel = json['customerAssignmentLevel'] ,
        roleId = json['role_id'] ,
        freeOrderTaken = json['free_order_taken'] ,
        rank = json['rank'] ,
        id = json['id'] ,
        categories = (json['categories'] as List?)?.map((dynamic e) => Categories.fromJson(e as Map<String,dynamic>)).toList(),
        retention = json['retention'] ,
        specialities = (json['specialities'] as List?)?.map((dynamic e) => Specialities.fromJson(e as Map<String,dynamic>)).toList(),
        image = json['image'] as String?,
        assignedCustomerList = json['assignedCustomerList'] as List?,
        waitTime = json['wait_time'] as String?,
        breathingTime = json['breathing_time'] as String?,
        freeOrderCount = json['free_order_count'] as String?,
        premiumText = json['premium_text'] as String?,
        isTestAccount = json['is_test_account'] ,
        retentionTotalFreeOrder = json['retentionTotalFreeOrder'] ,
        backgroundColor = json['background_color'] as String?,
        deviceToken = json['device_token'] as String?,
        freeOfferAvilable = json['freeOfferAvilable'] ,
        name = json['name'] as String?,
        chatAmount = json['chat_amount'],
        retentionPercentage = json['retentionPercentage'] ,
        retentionPriority = json['retentionPriority'] ,
        status = json['status'] ,
        retentionBucket = json['retentionBucket'] ;

  Map<String, dynamic> toJson() => {
    'chat_status' : chatStatus,
    'unique_no' : uniqueNo,
    'repurchase_rate' : repurchaseRate,
    'rating' : rating,
    'is_manual' : isManual,
    'video_status' : videoStatus,
    'language' : language,
    'experiance' : experiance,
    'video_call_amount' : videoCallAmount,
    'audio_call_amount' : audioCallAmount,
    'anonymous_call_amount' : anonymousCallAmount,
    'retention2' : retention2,
    'offer' : offer,
    'call_status' : callStatus,
    'customerAssignmentLevel' : customerAssignmentLevel,
    'role_id' : roleId,
    'free_order_taken' : freeOrderTaken,
    'rank' : rank,
    'id' : id,
    'categories' : categories?.map((e) => e.toJson()).toList(),
    'retention' : retention,
    'specialities' : specialities?.map((e) => e.toJson()).toList(),
    'image' : image,
    'assignedCustomerList' : assignedCustomerList,
    'wait_time' : waitTime,
    'breathing_time' : breathingTime,
    'free_order_count' : freeOrderCount,
    'premium_text' : premiumText,
    'is_test_account' : isTestAccount,
    'retentionTotalFreeOrder' : retentionTotalFreeOrder,
    'background_color' : backgroundColor,
    'device_token' : deviceToken,
    'freeOfferAvilable' : freeOfferAvilable,
    'name' : name,
    'chat_amount' : chatAmount,
    'retentionPercentage' : retentionPercentage,
    'retentionPriority' : retentionPriority,
    'status' : status,
    'retentionBucket' : retentionBucket
  };
}

class Categories {
  final String? name;
  final int? id;

  Categories({
    this.name,
    this.id,
  });

  Categories.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        id = json['id'] as int?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'id' : id
  };
}

class Specialities {
  final String? name;
  final int? id;

  Specialities({
    this.name,
    this.id,
  });

  Specialities.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        id = json['id'] as int?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'id' : id
  };
}