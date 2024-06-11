
import "dart:convert";

BlockedCustomersResponse blockedCustomersResponseFromJson(String str) =>
    BlockedCustomersResponse.fromJson(json.decode(str));

String blockedCustomersResponseToJson(BlockedCustomersResponse data) =>
    json.encode(data.toJson());

class BlockedCustomersResponse {
  List<BlockedUserList>? data;
  bool? success;
  int? statusCode;
  String? message;

  BlockedCustomersResponse(
      {this.data, this.success, this.statusCode, this.message});

  BlockedCustomersResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BlockedUserList>[];
      json['data'].forEach((v) {
        data!.add(new BlockedUserList.fromJson(v));
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

class BlockedUserList {
  int? id;
  int? customerId;
  int? isBlock;
  GetCustomers? getCustomers;

  BlockedUserList({this.id, this.customerId, this.isBlock, this.getCustomers});

  BlockedUserList.fromJson(Map<String, dynamic> json) {
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
