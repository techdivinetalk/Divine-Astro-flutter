import 'dart:convert';

CustomerLoginModel customerLoginModelFromJson(String str) =>
    CustomerLoginModel.fromJson(json.decode(str));

String customerLoginModelToJson(CustomerLoginModel data) =>
    json.encode(data.toJson());

class CustomerLoginModel {
  Data? data;
  bool? success;
  int? statusCode;
  String? token;

  CustomerLoginModel({
    this.data,
    this.success,
    this.statusCode,
    this.token,
  });

  factory CustomerLoginModel.fromJson(Map<String, dynamic> json) =>
      CustomerLoginModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        success: json["success"],
        statusCode: json["status_code"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "success": success,
    "status_code": statusCode,
    "token": token,
  };
}

class Data {
  int? id;
  int? roleId;
  String? name;
  String? email;
  String? avatar;
  dynamic emailVerifiedAt;
  List<dynamic>? settings;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic mobileNo;
  dynamic lastName;
  dynamic dateOfBirth;
  dynamic timeOfBirth;
  dynamic currentAddress;
  dynamic cityStateCountry;
  dynamic pincode;
  dynamic placeOfBirth;
  int? isEngaged;
  int? customerNo;
  int? isEmail;
  dynamic deletedAt;
  int? freshdeskId;
  String? deviceToken;
  dynamic maritalStatus;
  dynamic topicOfConcern;
  dynamic appVersion;
  dynamic deviceBrand;
  dynamic deviceModel;
  dynamic deviceManufacture;
  dynamic deviceSdkCode;
  dynamic isRegister;
  dynamic city;
  dynamic accessToken;
  int? isBlock;
  dynamic gender;
  dynamic gid;
  dynamic mobileNumber;

  Data({
    this.id,
    this.roleId,
    this.name,
    this.email,
    this.avatar,
    this.emailVerifiedAt,
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
    this.mobileNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    roleId: json["role_id"],
    name: json["name"],
    email: json["email"],
    avatar: json["avatar"],
    emailVerifiedAt: json["email_verified_at"],
    settings: json["settings"] == null
        ? []
        : List<dynamic>.from(json["settings"]!.map((x) => x)),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    mobileNo: "${json["mobile_no"]}",
    lastName: json["last_name"],
    dateOfBirth: json["date_of_birth"],
    timeOfBirth: json["time_of_birth"],
    currentAddress: json["current_address"],
    cityStateCountry: json["city_state_country"],
    pincode: json["pincode"],
    placeOfBirth: json["place_of_birth"],
    isEngaged: json["is_engaged"],
    customerNo: json["customer_no"],
    isEmail: json["is_email"],
    deletedAt: json["deleted_at"],
    freshdeskId: json["freshdesk_id"],
    deviceToken: json["device_token"],
    maritalStatus: json["marital_status"],
    topicOfConcern: json["topic_of_concern"],
    appVersion: json["appVersion"],
    deviceBrand: json["device_brand"],
    deviceModel: json["device_model"],
    deviceManufacture: json["device_manufacture"],
    deviceSdkCode: json["device_sdk_code"],
    isRegister: json["is_register"],
    city: json["city"],
    accessToken: json["access_token"],
    isBlock: json["is_block"],
    gender: json["gender"],
    gid: json["gid"],
    mobileNumber: json["phone_no"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_id": roleId,
    "name": name,
    "email": email,
    "avatar": avatar,
    "email_verified_at": emailVerifiedAt,
    "settings":
    settings == null ? [] : List<dynamic>.from(settings!.map((x) => x)),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "mobile_no": mobileNo,
    "last_name": lastName,
    "date_of_birth": dateOfBirth,
    "time_of_birth": timeOfBirth,
    "current_address": currentAddress,
    "city_state_country": cityStateCountry,
    "pincode": pincode,
    "place_of_birth": placeOfBirth,
    "is_engaged": isEngaged,
    "customer_no": customerNo,
    "is_email": isEmail,
    "deleted_at": deletedAt,
    "freshdesk_id": freshdeskId,
    "device_token": deviceToken,
    "marital_status": maritalStatus,
    "topic_of_concern": topicOfConcern,
    "appVersion": appVersion,
    "device_brand": deviceBrand,
    "device_model": deviceModel,
    "device_manufacture": deviceManufacture,
    "device_sdk_code": deviceSdkCode,
    "is_register": isRegister,
    "city": city,
    "access_token": accessToken,
    "is_block": isBlock,
    "gender": gender,
    "gid": gid,
    "phone_no": mobileNumber,
  };
}
