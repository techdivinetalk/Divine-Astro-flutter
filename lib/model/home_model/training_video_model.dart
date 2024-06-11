class TrainingVideoModel {
  final List<TrainingVideoData>? data;
  final bool? success;
  final int? statusCode;
  final String? message;

  TrainingVideoModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  TrainingVideoModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((dynamic e) => TrainingVideoData.fromJson(e as Map<String,dynamic>)).toList(),
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

class TrainingVideoData {
  final int? id;
  final String? title;
  final String? description;
  final String? url;
  final int? days;
  final int? isViwe;

  TrainingVideoData({
    this.id,
    this.title,
    this.description,
    this.url,
    this.days,
    this.isViwe,
  });

  TrainingVideoData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        description = json['description'] as String?,
        url = json['url'] as String?,
        days = json['days'] as int?,
        isViwe = json['is_viwe'] as int?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'description' : description,
    'url' : url,
    'days' : days,
    'is_viwe' : isViwe
  };
}