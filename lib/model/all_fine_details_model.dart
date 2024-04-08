import 'dart:convert';

FeedbackFineResponse feedbackFineResponseFromJson(String str) =>
    FeedbackFineResponse.fromJson(json.decode(str));

String feedbackFineResponseToJson(FeedbackFineResponse data) =>
    json.encode(data.toJson());

class FeedbackFineResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<FeedbackItem>? data;

  FeedbackFineResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory FeedbackFineResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List?;
    List<FeedbackItem>? feedbackItems = dataList?.map((item) => FeedbackItem.fromJson(item)).toList();

    return FeedbackFineResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: feedbackItems,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data != null ? List<dynamic>.from(data!.map((x) => x.toJson())) : null,
  };
}

class FeedbackItem {
  final int? id;
  final String? name;
  final int? status;
  final FeedbackFine? fine;
  final FeedbackSolution? solution;

  FeedbackItem({
    this.id,
    this.name,
    this.status,
    this.fine,
    this.solution,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      fine: json['fine'] != null ? FeedbackFine.fromJson(json['fine']) : null,
      solution: FeedbackSolution.fromJson(json['solution']),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "fine": fine?.toJson(),
    "solution": solution?.toJson(),
  };
}

class FeedbackFine {
  final int id;
  final String label;
  final String amount;
  final int type;
  final int problemId;

  FeedbackFine({
    required this.id,
    required this.label,
    required this.amount,
    required this.type,
    required this.problemId,
  });

  factory FeedbackFine.fromJson(Map<String, dynamic> json) {
    return FeedbackFine(
      id: json['id'],
      label: json['label'],
      amount: json['amount'],
      type: json['type'],
      problemId: json['problem_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "amount": amount,
    "type": type,
    "problem_id": problemId,
  };
}

class FeedbackSolution {
  final int id;
  final String name;
  final int status;
  final int problemId;

  FeedbackSolution({
    required this.id,
    required this.name,
    required this.status,
    required this.problemId,
  });

  factory FeedbackSolution.fromJson(Map<String, dynamic> json) {
    return FeedbackSolution(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      problemId: json['problem_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "problem_id": problemId,
  };
}
