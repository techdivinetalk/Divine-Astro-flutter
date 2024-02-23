class GetPoojaAddOnesResponse {
  List<GetPoojaAddOnesResponseData>? data;
  bool? success;
  int? statusCode;
  String? message;

  GetPoojaAddOnesResponse(
      {this.data, this.success, this.statusCode, this.message});

  GetPoojaAddOnesResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GetPoojaAddOnesResponseData>[];
      json['data'].forEach((v) {
        data!.add(new GetPoojaAddOnesResponseData.fromJson(v));
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

class GetPoojaAddOnesResponseData {
  int? id;
  String? name;
  String? images;
  int? amount;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool isSelected = false;

  GetPoojaAddOnesResponseData(
      {this.id,
      this.name,
      this.images,
      this.amount,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.isSelected = false});

  GetPoojaAddOnesResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    images = json['images'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['images'] = images;
    data['amount'] = amount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
