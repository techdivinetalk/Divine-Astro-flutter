class AddUserAddressResponse {
  AddUserAddressResponseData? data;
  bool? success;
  int? statusCode;
  String? message;

  AddUserAddressResponse(
      {this.data, this.success, this.statusCode, this.message});

  AddUserAddressResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new AddUserAddressResponseData.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class AddUserAddressResponseData {
  String? addressTitle;
  String? flatNo;
  String? locality;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  int? userId;
  int? id;

  AddUserAddressResponseData(
      {this.addressTitle,
      this.flatNo,
      this.locality,
      this.landmark,
      this.city,
      this.state,
      this.pincode,
      this.userId,
      this.id});

  AddUserAddressResponseData.fromJson(Map<String, dynamic> json) {
    addressTitle = json['address_title'];
    flatNo = json['flat_no'];
    locality = json['locality'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    userId = json['user_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_title'] = addressTitle;
    data['flat_no'] = flatNo;
    data['locality'] = locality;
    data['landmark'] = landmark;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['user_id'] = userId;
    data['id'] = id;
    return data;
  }
}
