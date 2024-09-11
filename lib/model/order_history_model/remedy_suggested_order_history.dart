// To parse this JSON data, do
//
//     final remedySuggestedOrderHistoryModelClass = remedySuggestedOrderHistoryModelClassFromJson(jsonString);

import 'dart:convert';

RemedySuggestedOrderHistoryModelClass
    remedySuggestedOrderHistoryModelClassFromJson(String str) =>
        RemedySuggestedOrderHistoryModelClass.fromJson(json.decode(str));

String remedySuggestedOrderHistoryModelClassToJson(
        RemedySuggestedOrderHistoryModelClass data) =>
    json.encode(data.toJson());

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

  factory RemedySuggestedOrderHistoryModelClass.fromJson(
          Map<String, dynamic> json) =>
      RemedySuggestedOrderHistoryModelClass(
        data: json["data"] == null
            ? []
            : List<RemedySuggestedDataList>.from(
                json["data"]!.map((x) => RemedySuggestedDataList.fromJson(x))),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
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
  PoojaDetails? poojaDetails;
  GetOrder? getOrder;

  RemedySuggestedDataList(
      {this.id,
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
      this.poojaDetails,
      this.getOrder});

  factory RemedySuggestedDataList.fromJson(Map<String, dynamic> json) =>
      RemedySuggestedDataList(
        id: json["id"],
        orderId: json["order_id"],
        partnerId: json["partner_id"],
        customerId: json["customer_id"],
        shopId: json["shop_id"],
        productId: json["product_id"],
        isConfirm: json["is_confirm"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        getCustomers: json["get_customers"] == null
            ? null
            : GetCustomers.fromJson(json["get_customers"]),
        productDetails: json["product_details"] == null
            ? null
            : ProductDetails.fromJson(json["product_details"]),
        poojaDetails: json["pooja_detail"] == null
            ? null
            : PoojaDetails.fromJson(json["pooja_detail"]),
        getOrder: json["get_order"] == null
            ? null
            : GetOrder.fromJson(json["get_order"]),
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
        "pooja_detail": poojaDetails?.toJson(),
        "get_order": getOrder?.toJson(),
      };
}

class GetCustomers {
  int? id;
  String? name;
  String? avatar;
  int? customerNo;
  dynamic level;

  GetCustomers({
    this.id,
    this.name,
    this.avatar,
    this.customerNo,
    this.level,
  });

  factory GetCustomers.fromJson(Map<String, dynamic> json) => GetCustomers(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        customerNo: json["customer_no"],
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
        "customer_no": customerNo,
        "level": level,
      };
}

class ProductDetails {
  int? id;
  String? prodName;
  String? prodImage;
  int? prod_starting_price_inr;

  int? payoutType;
  int? payoutValue;

  ProductDetails({
    this.id,
    this.prodName,
    this.prodImage,
    this.payoutType,
    this.prod_starting_price_inr,
    this.payoutValue,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json["id"] as int?,
      prodName: json["prod_name"] as String?,
      prodImage: json["prod_image"] as String?,
      prod_starting_price_inr: json["product_price_inr"] as int?,
      payoutType: json["payout_type"] as int?,
      payoutValue: json["payout_value"] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "prod_name": prodName,
        "prod_image": prodImage,
        "payout_type": payoutType,
        "product_price_inr": prod_starting_price_inr,
        "payout_value": payoutValue,
      };
}

class PoojaDetails {
  int? id;
  String? poojaName;
  String? pooja_img;
  int? payoutType;
  int? payoutValue;
  int? pooja_starting_price_inr;
  var gst;

  PoojaDetails({
    this.id,
    this.poojaName,
    this.pooja_img,
    this.payoutType,
    this.payoutValue,
    this.pooja_starting_price_inr,
    this.gst,
  });

  factory PoojaDetails.fromJson(Map<String, dynamic> json) {
    return PoojaDetails(
      id: json["id"] as int?,
      poojaName: json["pooja_name"] as String?,
      pooja_img: json["pooja_img"] as String?,
      payoutType: json["payout_type"] as int?,
      payoutValue: json["payout_value"] as int?,
      pooja_starting_price_inr: json["pooja_starting_price_inr"] as int?,
      gst: json["gst"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "pooja_name": poojaName,
        "pooja_img": pooja_img,
        "payout_type": payoutType,
        "payout_value": payoutValue,
        "pooja_starting_price_inr": pooja_starting_price_inr,
        "gst": gst,
      };
}

class GetOrder {
  int? id;
  int? amount;
  String? status;
  String? orderId;
  String? createdAt;
  // New fields
  String? additionalField1;
  int? additionalField2;

  GetOrder({
    this.id,
    this.amount,
    this.status,
    this.orderId,
    this.createdAt,
    this.additionalField1,
    this.additionalField2,
  });

  factory GetOrder.fromJson(Map<String, dynamic> json) => GetOrder(
        id: json['id'] as int?,
        amount: json['amount'] as int?,
        status: json['status'] as String?,
        orderId: json['order_id'] as String?,
        createdAt: json['created_at'] as String?,
        // Assign values for new fields or use null checks
        additionalField1: json['additional_field1'] as String?,
        additionalField2: json['additional_field2'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'status': status,
        'order_id': orderId,
        'created_at': createdAt,
        // Include new fields in the JSON representation
        'additional_field1': additionalField1,
        'additional_field2': additionalField2,
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
