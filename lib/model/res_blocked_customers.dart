import 'dart:convert';

ResBlockedCustomers resBlockedCustomersFromJson(String str) =>
    ResBlockedCustomers.fromJson(json.decode(str));

String resBlockedCustomersToJson(ResBlockedCustomers data) =>
    json.encode(data.toJson());

class ResBlockedCustomers {
  List<Datum> data;
  bool? success;
  int? statusCode;
  String? message;

  ResBlockedCustomers({
    this.data = const [],
    this.success,
    this.statusCode,
    this.message,
  });

  factory ResBlockedCustomers.fromJson(Map<String, dynamic> json) =>
      ResBlockedCustomers(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class Datum {
  int? id;
  String? name;
  String? phoneNo;
  String? email;
  String? image;
  List<AstroBlockCustomer> astroBlockCustomer;

  Datum({
    this.id,
    this.name,
    this.phoneNo,
    this.email,
    this.image,
    this.astroBlockCustomer = const [],
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        phoneNo: json["phone_no"],
        email: json["email"],
        image: json["image"],
        astroBlockCustomer: json["astro_block_customer"] == null
            ? []
            : List<AstroBlockCustomer>.from(
                json["astro_block_customer"]
                    .map((x) => AstroBlockCustomer.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_no": phoneNo,
        "email": email,
        "image": image,
        "astro_block_customer": List<dynamic>.from(
          astroBlockCustomer.map((x) => x.toJson()),
        ),
      };
}

class AstroBlockCustomer {
  int? id;
  int? customerId;
  int? astrologerId;
  int? isBlock;
  String? createdAt;
  String? updatedAt;
  dynamic roleId;
  String? image;
  String? name;

  AstroBlockCustomer({
    this.id,
    this.customerId,
    this.astrologerId,
    this.isBlock,
    this.createdAt,
    this.updatedAt,
    this.roleId,
    this.image,
    this.name,
  });

  factory AstroBlockCustomer.fromJson(Map<String, dynamic> json) =>
      AstroBlockCustomer(
        id: json["id"],
        customerId: json["customer_id"],
        astrologerId: json["astrologer_id"],
        isBlock: json["is_block"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        roleId: json["role_id"],
        image: json["image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "astrologer_id": astrologerId,
        "is_block": isBlock,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "role_id": roleId,
        "image": image,
        "name": name,
      };
}
