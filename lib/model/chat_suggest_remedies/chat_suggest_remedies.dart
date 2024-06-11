class ChatSuggestRemediesListResponse {
  List<Remedy>? remedies;
  bool? success;
  int? statusCode;
  String? message;

  ChatSuggestRemediesListResponse({
    this.remedies,
    this.success,
    this.statusCode,
    this.message,
  });

  ChatSuggestRemediesListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      remedies = List<Remedy>.from(json['data'].map((v) => Remedy.fromJson(v)));
    }
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (remedies != null) {
      data['data'] = remedies!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class Remedy {
  int id;
  String name;
  String content;
  int status;
  String createdAt;

  Remedy({
    required this.id,
    required this.name,
    required this.content,
    required this.status,
    required this.createdAt,
  });

  Remedy.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? '',
        content = json['content'] ?? '',
        status = 1,
        // Default status value, update accordingly
        createdAt = json['created_at'] ?? ' ';


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['content'] = content;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }

  static String extractName(String fullName) {
    // Extract the non-numeric part of the name
    return fullName.replaceAll(RegExp(r'[0-9.]'), '').trim();
  }
}
