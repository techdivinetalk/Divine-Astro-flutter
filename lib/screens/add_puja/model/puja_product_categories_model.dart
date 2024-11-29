class PujaProductCategoriesModel {
  final List<PujaProductCategoriesData>? data;
  final bool? success;
  final int? statusCode;
  final String? message;

  PujaProductCategoriesModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  PujaProductCategoriesModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((dynamic e) => PujaProductCategoriesData.fromJson(e as Map<String,dynamic>)).toList(),
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

class PujaProductCategoriesData {
  final int? id;
  final String? name;
  bool? isSelected;

  PujaProductCategoriesData({
    this.id,
    this.name,
    this.isSelected,
  });

  PujaProductCategoriesData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,isSelected = json['isSelected'] ?? false;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'isSelected' : isSelected,
  };
}