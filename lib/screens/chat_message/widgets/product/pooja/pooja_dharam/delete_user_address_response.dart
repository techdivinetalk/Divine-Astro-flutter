class DeleteUserAddressResponse {
  List<DeleteUserAddressResponseData>? data;
  bool? success;
  int? statusCode;
  String? message;

  DeleteUserAddressResponse(
      {this.data, this.success, this.statusCode, this.message});

  DeleteUserAddressResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DeleteUserAddressResponseData>[];
      json['data'].forEach((v) {
        data!.add(new DeleteUserAddressResponseData.fromJson(v));
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
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class DeleteUserAddressResponseData {
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

  DeleteUserAddressResponseData(
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

  DeleteUserAddressResponseData.fromJson(Map<String, dynamic> json) {
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
