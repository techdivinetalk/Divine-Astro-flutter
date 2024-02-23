class GetUserAddressResponse {
  GetUserAddressResponseData? data;
  bool? success;
  int? statusCode;
  String? message;

  GetUserAddressResponse(
      {this.data, this.success, this.statusCode, this.message});

  GetUserAddressResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GetUserAddressResponseData.fromJson(json['data']) : null;
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

class GetUserAddressResponseData {
  List<Addresses>? addresses;

  GetUserAddressResponseData({this.addresses});

  GetUserAddressResponseData.fromJson(Map<String, dynamic> json) {
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  int? id;
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

  Addresses(
      {this.id,
      this.addressTitle,
      this.phoneNo,
      this.alternatePhoneNo,
      this.flatNo,
      this.locality,
      this.landmark,
      this.city,
      this.state,
      this.pincode,
      this.userId});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
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
    return data;
  }
}
