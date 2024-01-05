class BlockedCustomerListRes {
  List<Data>? data;
  bool? success;
  int? statusCode;
  String? message;

  BlockedCustomerListRes(
      {this.data, this.success, this.statusCode, this.message});

  BlockedCustomerListRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {  
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  int? customerId;
  int? isBlock;
  GetCustomers? getCustomers;

  Data({this.id, this.customerId, this.isBlock, this.getCustomers});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    isBlock = json['is_block'];
    getCustomers = json['get_customers'] != null
        ? new GetCustomers.fromJson(json['get_customers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['is_block'] = this.isBlock;
    if (this.getCustomers != null) {
      data['get_customers'] = this.getCustomers!.toJson();
    }
    return data;
  }
}

class GetCustomers {
  int? id;
  String? name;
  String? avatar;

  GetCustomers({this.id, this.name, this.avatar});

  GetCustomers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}
