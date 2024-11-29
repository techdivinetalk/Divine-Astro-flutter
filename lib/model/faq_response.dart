import 'dart:convert';

FAQsResponse faqsResponseFromJson(String str) =>
    FAQsResponse.fromJson(json.decode(str));

String faqsResponseToJson(FAQsResponse data) => json.encode(data.toJson());

class FAQsResponse {
  List<FAQData>? data;
  bool? success;
  int? statusCode;
  String? message;

  FAQsResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory FAQsResponse.fromJson(Map<String, dynamic> json) => FAQsResponse(
        data: json["data"] == null
            ? []
            : List<FAQData>.from(json["data"].map((x) => FAQData.fromJson(x))),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class FAQData {
  final int id;
  final int sequenceNumber;
  final String question;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;

  FAQData({
    required this.id,
    required this.sequenceNumber,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FAQData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      // Handle the case where json is null (optional)
      throw FormatException('Invalid JSON format');
    }
    return FAQData(
      id: json["id"] as int,
      question: json["question"] as String? ?? '',
      answer: json["answer"] as String? ?? '',
      sequenceNumber: json["sequence_number"] as int? ?? 0,
      createdAt: _parseDateTime(json["created_at"]),
      updatedAt: _parseDateTime(json["updated_at"]),
    );
  }

  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) {
      return DateTime.now(); // Provide a default value
    }
    if (dateTime is DateTime) {
      return dateTime;
    } else {
      return DateTime.tryParse(dateTime.toString()) ?? DateTime.now(); // Provide a default value
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "sequence_number": sequenceNumber,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}


