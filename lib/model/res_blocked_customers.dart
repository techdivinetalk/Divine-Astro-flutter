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
  // Null? getCustomers;

  AstroBlockCustomer({
    this.id,
    this.customerId,
    this.astrologerId,
    this.isBlock,
    this.createdAt,
    this.updatedAt,
    this.roleId,
    // this.getCustomers
  });

  AstroBlockCustomer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    astrologerId = json['astrologer_id'];
    isBlock = json['is_block'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roleId = json['role_id'];
    // getCustomers = json['get_customers'];
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
    // data['get_customers'] = this.getCustomers;
    return data;
  }
}
