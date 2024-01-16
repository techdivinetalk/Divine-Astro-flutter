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
  int id, sequenceNumber;
  String question, answer;
  DateTime createdAt, updatedAt;

  FAQData({
    required this.id,
    required this.question,
    required this.answer,
    required this.sequenceNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FAQData.fromJson(Map<String, dynamic> json) => FAQData(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        sequenceNumber: json["sequence_number"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "sequence_number": sequenceNumber,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
