class UpdateUserAddressResponse {
  List<UpdateUserAddressResponseData>? data;
  bool? success;
  int? statusCode;
  String? message;

  UpdateUserAddressResponse(
      {this.data, this.success, this.statusCode, this.message});

  UpdateUserAddressResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <UpdateUserAddressResponseData>[];
      json['data'].forEach((v) {
        data!.add(new UpdateUserAddressResponseData.fromJson(v));
      });
    }
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class UpdateUserAddressResponseData {
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

  UpdateUserAddressResponseData(
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

  UpdateUserAddressResponseData.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_title'] = this.addressTitle;
    data['phone_no'] = this.phoneNo;
    data['alternate_phone_no'] = this.alternatePhoneNo;
    data['flat_no'] = this.flatNo;
    data['locality'] = this.locality;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['user_id'] = this.userId;
    return data;
  }
}
