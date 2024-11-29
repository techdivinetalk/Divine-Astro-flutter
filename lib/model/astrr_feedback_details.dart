import 'dart:convert';

AstroFeedbackDetailResponse astroFeedbackDetailResponseFromJson(String str) =>
    AstroFeedbackDetailResponse.fromJson(json.decode(str));

String astroFeedbackDetailResponseToJson(AstroFeedbackDetailResponse data) =>
    json.encode(data.toJson());

class AstroFeedbackDetailResponse {
  AstroFeedbackDetailData? data;
  bool? success;
  int? statusCode;
  String? message;

  AstroFeedbackDetailResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory AstroFeedbackDetailResponse.fromJson(Map<String, dynamic> json) =>
      AstroFeedbackDetailResponse(
        data: json['data'] != null
            ? AstroFeedbackDetailData.fromJson(json['data'])
            : AstroFeedbackDetailData(),
        success: json['success'],
        statusCode: json['status_code'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
    'data': data?.toJson(),
    'success': success,
    'status_code': statusCode,
    'message': message,
  };
}

class AstroFeedbackDetailData {
  dynamic totalProblem;
  dynamic fineAmounts;
  List<FeedbackProblem>? problems;

  AstroFeedbackDetailData({
    this.totalProblem,
    this.fineAmounts,
    this.problems,
  });

  factory AstroFeedbackDetailData.fromJson(Map<String, dynamic> json) =>
      AstroFeedbackDetailData(
        totalProblem: json['total_problem'],
        fineAmounts: json['fine_amounts'],
        problems: json['problems'] != null
            ? List<FeedbackProblem>.from(
          json['problems'].map((x) => FeedbackProblem.fromJson(x)),
        )
            : null,
      );

  Map<String, dynamic> toJson() => {
    'total_problem': totalProblem,
    'fine_amounts': fineAmounts,
    'problems': problems != null
        ? List<dynamic>.from(problems!.map((x) => x.toJson()))
        : null,
  };
}

class FeedbackProblem {
  int? id;
  String? problem;
  String? solution;
  int? totalProblem; // New field

  FeedbackProblem({
    this.id,
    this.problem,
    this.solution,
    this.totalProblem,
  });

  factory FeedbackProblem.fromJson(Map<String, dynamic> json) =>
      FeedbackProblem(
        id: json['id'],
        problem: json['problem'],
        solution: json['solution'],
        totalProblem: json['total_problem'], // Extract the new field
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'problem': problem,
    'solution': solution,
    'total_problem': totalProblem, // Include the new field in the JSON
  };
}

