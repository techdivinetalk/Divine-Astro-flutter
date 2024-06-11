class RemediesModel {
  final List<Remedy>? data;
  final bool? success;
  final int? statusCode;
  final String? message;

  RemediesModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  RemediesModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((dynamic e) => Remedy.fromJson(e as Map<String,dynamic>)).toList(),
        success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'data' : data?.map((e) => e.toJson()).toList(),
    'success' : success,
    'status_code' : statusCode,
    'message' : message
  };
}





class Remedy {
  final int? id;
  final String? name;
  final String? image;
  final String? content;
  final int? masterRemedyId;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final String? remedyBy;
  final int? remedyById;
  final int? customerId;

  Remedy({
    this.id,
    this.name,
    this.image,
    this.content,
    this.masterRemedyId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.remedyBy,
    this.remedyById,
    this.customerId,
  });

  Remedy.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        content = json['content'] as String?,
        image = json['image'] as String?,
        masterRemedyId = json['master_remedy_id'] as int?,
        status = json['status'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        remedyBy = json['remedy_by'] as String?,
        remedyById = json['remedy_by_id'] as int?,
        customerId = json['customer_id'] as int?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'content' : content,
    'image' : image,
    'master_remedy_id' : masterRemedyId,
    'status' : status,
    'created_at' : createdAt,
    'updated_at' : updatedAt,
    'deleted_at' : deletedAt,
    'remedy_by' : remedyBy,
    'remedy_by_id' : remedyById,
    'customer_id' : customerId
  };
}