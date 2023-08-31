class ResBlockedCustomers {
  List<Data>? data;
  bool? success;
  int? statusCode;
  String? message;

  ResBlockedCustomers({this.data, this.success, this.statusCode, this.message});

  ResBlockedCustomers.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? phoneNo;
  String? email;
  String? image;
  List<AstroBlockCustomer>? astroBlockCustomer;

  Data(
      {this.id,
        this.name,
        this.phoneNo,
        this.email,
        this.image,
        this.astroBlockCustomer});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNo = json['phone_no'];
    email = json['email'];
    image = json['image'];
    if (json['astro_block_customer'] != null) {
      astroBlockCustomer = <AstroBlockCustomer>[];
      json['astro_block_customer'].forEach((v) {
        astroBlockCustomer!.add(AstroBlockCustomer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone_no'] = phoneNo;
    data['email'] = email;
    data['image'] = image;
    if (astroBlockCustomer != null) {
      data['astro_block_customer'] =
          astroBlockCustomer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AstroBlockCustomer {
  int? id;
  int? customerId;
  int? astrologerId;
  int? isBlock;
  String? createdAt;
  String? updatedAt;
  int? roleId;
  GetCustomers? getCustomers;

  AstroBlockCustomer(
      {this.id,
        this.customerId,
        this.astrologerId,
        this.isBlock,
        this.createdAt,
        this.updatedAt,
        this.roleId,
        this.getCustomers});

  AstroBlockCustomer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    astrologerId = json['astrologer_id'];
    isBlock = json['is_block'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roleId = json['role_id'];
    getCustomers = json['get_customers'] != null
        ? GetCustomers.fromJson(json['get_customers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['astrologer_id'] = astrologerId;
    data['is_block'] = isBlock;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['role_id'] = roleId;
    if (getCustomers != null) {
      data['get_customers'] = getCustomers!.toJson();
    }
    return data;
  }
}

class GetCustomers {
  int? id;
  int? roleId;
  String? name;
  String? email;
  String? avatar;
  String? emailVerifiedAt;
  String? password;
  String? rememberToken;
  String? settings;
  String? createdAt;
  String? updatedAt;
  int? mobileNo;
  String? lastName;
  String? dateOfBirth;
  String? timeOfBirth;
  String? currentAddress;
  String? cityStateCountry;
  String? pincode;
  String? placeOfBirth;
  int? isEngaged;
  int? customerNo;
  int? isEmail;
  String? deletedAt;
  int? freshdeskId;
  String? deviceToken;
  String? maritalStatus;
  String? topicOfConcern;
  String? appVersion;
  String? deviceBrand;
  String? deviceModel;
  String? deviceManufacture;
  String? deviceSdkCode;
  String? isRegister;
  String? city;
  String? accessToken;
  int? isBlock;
  String? gender;
  String? gid;
  String? phonePayUserid;

  GetCustomers(
      {this.id,
        this.roleId,
        this.name,
        this.email,
        this.avatar,
        this.emailVerifiedAt,
        this.password,
        this.rememberToken,
        this.settings,
        this.createdAt,
        this.updatedAt,
        this.mobileNo,
        this.lastName,
        this.dateOfBirth,
        this.timeOfBirth,
        this.currentAddress,
        this.cityStateCountry,
        this.pincode,
        this.placeOfBirth,
        this.isEngaged,
        this.customerNo,
        this.isEmail,
        this.deletedAt,
        this.freshdeskId,
        this.deviceToken,
        this.maritalStatus,
        this.topicOfConcern,
        this.appVersion,
        this.deviceBrand,
        this.deviceModel,
        this.deviceManufacture,
        this.deviceSdkCode,
        this.isRegister,
        this.city,
        this.accessToken,
        this.isBlock,
        this.gender,
        this.gid,
        this.phonePayUserid});

  GetCustomers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    rememberToken = json['remember_token'];
    settings = json['settings'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    mobileNo = json['mobile_no'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    timeOfBirth = json['time_of_birth'];
    currentAddress = json['current_address'];
    cityStateCountry = json['city_state_country'];
    pincode = json['pincode'];
    placeOfBirth = json['place_of_birth'];
    isEngaged = json['is_engaged'];
    customerNo = json['customer_no'];
    isEmail = json['is_email'];
    deletedAt = json['deleted_at'];
    freshdeskId = json['freshdesk_id'];
    deviceToken = json['device_token'];
    maritalStatus = json['marital_status'];
    topicOfConcern = json['topic_of_concern'];
    appVersion = json['appVersion'];
    deviceBrand = json['device_brand'];
    deviceModel = json['device_model'];
    deviceManufacture = json['device_manufacture'];
    deviceSdkCode = json['device_sdk_code'];
    isRegister = json['is_register'];
    city = json['city'];
    accessToken = json['access_token'];
    isBlock = json['is_block'];
    gender = json['gender'];
    gid = json['gid'];
    phonePayUserid = json['phone_pay_userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_id'] = roleId;
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    data['email_verified_at'] = emailVerifiedAt;
    data['password'] = password;
    data['remember_token'] = rememberToken;
    data['settings'] = settings;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['mobile_no'] = mobileNo;
    data['last_name'] = lastName;
    data['date_of_birth'] = dateOfBirth;
    data['time_of_birth'] = timeOfBirth;
    data['current_address'] = currentAddress;
    data['city_state_country'] = cityStateCountry;
    data['pincode'] = pincode;
    data['place_of_birth'] = placeOfBirth;
    data['is_engaged'] = isEngaged;
    data['customer_no'] = customerNo;
    data['is_email'] = isEmail;
    data['deleted_at'] = deletedAt;
    data['freshdesk_id'] = freshdeskId;
    data['device_token'] = deviceToken;
    data['marital_status'] = maritalStatus;
    data['topic_of_concern'] = topicOfConcern;
    data['appVersion'] = appVersion;
    data['device_brand'] = deviceBrand;
    data['device_model'] = deviceModel;
    data['device_manufacture'] = deviceManufacture;
    data['device_sdk_code'] = deviceSdkCode;
    data['is_register'] = isRegister;
    data['city'] = city;
    data['access_token'] = accessToken;
    data['is_block'] = isBlock;
    data['gender'] = gender;
    data['gid'] = gid;
    data['phone_pay_userid'] = phonePayUserid;
    return data;
  }
}
