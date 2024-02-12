// To parse this JSON data, do
//
//     final remedySuggestedOrderHistoryModelClass = remedySuggestedOrderHistoryModelClassFromJson(jsonString);

import 'dart:convert';

RemedySuggestedOrderHistoryModelClass remedySuggestedOrderHistoryModelClassFromJson(String str) => RemedySuggestedOrderHistoryModelClass.fromJson(json.decode(str));

String remedySuggestedOrderHistoryModelClassToJson(RemedySuggestedOrderHistoryModelClass data) => json.encode(data.toJson());

class RemedySuggestedOrderHistoryModelClass {
  List<RemedySuggestedDataList>? data;
  bool? success;
  int? statusCode;
  String? message;

  RemedySuggestedOrderHistoryModelClass({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory RemedySuggestedOrderHistoryModelClass.fromJson(Map<String, dynamic> json) => RemedySuggestedOrderHistoryModelClass(
    data: json["data"] == null ? [] : List<RemedySuggestedDataList>.from(json["data"]!.map((x) => RemedySuggestedDataList.fromJson(x))),
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}

class RemedySuggestedDataList {
  int? id;
  int? orderId;
  int? partnerId;
  int? customerId;
  int? shopId;
  int? productId;
  int? isConfirm;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  GetCustomers? getCustomers;
  ProductDetails? productDetails;
  GetOrder? getOrder;

  RemedySuggestedDataList({
    this.id,
    this.orderId,
    this.partnerId,
    this.customerId,
    this.shopId,
    this.productId,
    this.isConfirm,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.getCustomers,
    this.productDetails,
  });

  factory RemedySuggestedDataList.fromJson(Map<String, dynamic> json) => RemedySuggestedDataList(
    id: json["id"],
    orderId: json["order_id"],
    partnerId: json["partner_id"],
    customerId: json["customer_id"],
    shopId: json["shop_id"],
    productId: json["product_id"],
    isConfirm: json["is_confirm"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    getCustomers: json["get_customers"] == null ? null : GetCustomers.fromJson(json["get_customers"]),
    productDetails: json["product_details"] == null ? null : ProductDetails.fromJson(json["product_details"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "partner_id": partnerId,
    "customer_id": customerId,
    "shop_id": shopId,
    "product_id": productId,
    "is_confirm": isConfirm,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "get_customers": getCustomers?.toJson(),
    "product_details": productDetails?.toJson(),
  };
}

class GetCustomers {
  int? id;
  String? name;
  String? avatar;
  int? customerNo;

  GetCustomers({
    this.id,
    this.name,
    this.avatar,
    this.customerNo,
  });

  factory GetCustomers.fromJson(Map<String, dynamic> json) => GetCustomers(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
    customerNo: json["customer_no"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "customer_no": customerNo,
  };
}

class ProductDetails {
  int? id;
  String? prodName;
  String? prodImage;

  ProductDetails({
    this.id,
    this.prodName,
    this.prodImage,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
    id: json["id"],
    prodName: json["prod_name"],
    prodImage: json["prod_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "prod_name": prodName,
    "prod_image": prodImage,
  };
}

class GetOrder {
  int? id;
  int? amount;
  String? status;
  String? orderId;
  String? createdAt;

  GetOrder({this.id, this.amount, this.status, this.orderId, this.createdAt});

  factory GetOrder.fromJson(Map<String, dynamic> json) => GetOrder(
    id: json['id'],
    amount: json['amount'],
    status: json['status'],
    orderId: json['order_id'],
    createdAt: json['created_at']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'status':  status,
    'order_id':  orderId,
    'created_at': createdAt,
  };
}


// // To parse this JSON data, do
// //
// //     final remedySuggestedOrderHistoryModelClass = remedySuggestedOrderHistoryModelClassFromJson(jsonString);
//
// import 'dart:convert';
//
// RemedySuggestedOrderHistoryModelClass remedySuggestedOrderHistoryModelClassFromJson(String str) => RemedySuggestedOrderHistoryModelClass.fromJson(json.decode(str));
//
// String remedySuggestedOrderHistoryModelClassToJson(RemedySuggestedOrderHistoryModelClass data) => json.encode(data.toJson());
//
// class RemedySuggestedOrderHistoryModelClass {
//   List<RemedySuggestedDataList>? data;
//   bool? success;
//   int? statusCode;
//   String? message;
//
//   RemedySuggestedOrderHistoryModelClass({
//     this.data,
//     this.success,
//     this.statusCode,
//     this.message,
//   });
//
//   factory RemedySuggestedOrderHistoryModelClass.fromJson(Map<String, dynamic> json) => RemedySuggestedOrderHistoryModelClass(
//     data: json["data"] == null ? [] : List<RemedySuggestedDataList>.from(json["data"]!.map((x) => RemedySuggestedDataList.fromJson(x))),
//     success: json["success"],
//     statusCode: json["status_code"],
//     message: json["message"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//     "success": success,
//     "status_code": statusCode,
//     "message": message,
//   };
// }
//
// class RemedySuggestedDataList {
//   int? id;
//   int? orderId;
//   int? partnerId;
//   int? customerId;
//   int? shopId;
//   int? productId;
//   int? isConfirm;
//   String? status;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   GetCustomers? getCustomers;
//   ProductDetails? productDetails;
//
//   RemedySuggestedDataList({
//     this.id,
//     this.orderId,
//     this.partnerId,
//     this.customerId,
//     this.shopId,
//     this.productId,
//     this.isConfirm,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.getCustomers,
//     this.productDetails,
//   });
//
//   factory RemedySuggestedDataList.fromJson(Map<String, dynamic> json) => RemedySuggestedDataList(
//     id: json["id"],
//     orderId: json["order_id"],
//     partnerId: json["partner_id"],
//     customerId: json["customer_id"],
//     shopId: json["shop_id"],
//     productId: json["product_id"],
//     isConfirm: json["is_confirm"],
//     status: json["status"],
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//     updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//     getCustomers: json["get_customers"] == null ? null : GetCustomers.fromJson(json["get_customers"]),
//     productDetails: json["product_details"] == null ? null : ProductDetails.fromJson(json["product_details"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "order_id": orderId,
//     "partner_id": partnerId,
//     "customer_id": customerId,
//     "shop_id": shopId,
//     "product_id": productId,
//     "is_confirm": isConfirm,
//     "status": status,
//     "created_at": createdAt?.toIso8601String(),
//     "updated_at": updatedAt?.toIso8601String(),
//     "get_customers": getCustomers?.toJson(),
//     "product_details": productDetails?.toJson(),
//   };
// }
//
// class GetCustomers {
//   int? id;
//   String? name;
//   String? avatar;
//   int? customerNo;
//
//   GetCustomers({
//     this.id,
//     this.name,
//     this.avatar,
//     this.customerNo,
//   });
//
//   factory GetCustomers.fromJson(Map<String, dynamic> json) => GetCustomers(
//     id: json["id"],
//     name: json["name"],
//     avatar: json["avatar"],
//     customerNo: json["customer_no"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "avatar": avatar,
//     "customer_no": customerNo,
//   };
// }
//
// class ProductDetails {
//   int? id;
//   String? prodName;
//   String? prodImage;
//
//   ProductDetails({
//     this.id,
//     this.prodName,
//     this.prodImage,
//   });
//
//   factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
//     id: json["id"],
//     prodName: json["prod_name"],
//     prodImage: json["prod_image"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "prod_name": prodName,
//     "prod_image": prodImage,
//   };
// }
