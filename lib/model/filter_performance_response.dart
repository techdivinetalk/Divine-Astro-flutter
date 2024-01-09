import 'dart:convert';

PerformanceFilterResponse performanceFilterResponseFromJson(String str) =>
    PerformanceFilterResponse.fromJson(json.decode(str));

String performanceFilterResponseToJson(PerformanceFilterResponse data) =>
    json.encode(data.toJson());

class PerformanceFilterResponse {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  PerformanceFilterResponse(
      {this.data, this.success, this.statusCode, this.message});

  PerformanceFilterResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Response? response;
  dynamic? score;
  dynamic? totalScore;
  dynamic? scorePrecentage;
  List<RankSystem>? rankSystem;
  String? rank;
  String? image;

  Data(
      {this.response,
        this.score,
        this.totalScore,
        this.scorePrecentage,
        this.rankSystem,
        this.rank,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    score = json['score'];
    totalScore = json['total_score'];
    scorePrecentage = json['score_precentage'];
    if (json['rank_system'] != null) {
      rankSystem = <RankSystem>[];
      json['rank_system'].forEach((v) {
        rankSystem!.add(new RankSystem.fromJson(v));
      });
    }
    rank = json['rank'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['score'] = this.score;
    data['total_score'] = this.totalScore;
    data['score_precentage'] = this.scorePrecentage;
    if (this.rankSystem != null) {
      data['rank_system'] = this.rankSystem!.map((v) => v.toJson()).toList();
    }
    data['rank'] = this.rank;
    data['image'] = this.image;
    return data;
  }
}

class Response {
  Conversion? conversion;
  Conversion? repurchaseRate;
  Conversion? onlineHours;
  Conversion? liveOnline;
  Conversion? averageServiceTime;
  Conversion? customerSatisfactionRatings;

  Response(
      {this.conversion,
        this.repurchaseRate,
        this.onlineHours,
        this.liveOnline,
        this.averageServiceTime,
        this.customerSatisfactionRatings});

  Response.fromJson(Map<String, dynamic> json) {
    conversion = json['conversion'] != null
        ? new Conversion.fromJson(json['conversion'])
        : null;
    repurchaseRate = json['repurchase_rate'] != null
        ? new Conversion.fromJson(json['repurchase_rate'])
        : null;
    onlineHours = json['online_hours'] != null
        ? new Conversion.fromJson(json['online_hours'])
        : null;
    liveOnline = json['live_online'] != null
        ? new Conversion.fromJson(json['live_online'])
        : null;
    averageServiceTime = json['average_service_time'] != null
        ? new Conversion.fromJson(json['average_service_time'])
        : null;
    customerSatisfactionRatings = json['customer_satisfaction_ratings'] != null
        ? new Conversion.fromJson(json['customer_satisfaction_ratings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.conversion != null) {
      data['conversion'] = this.conversion!.toJson();
    }
    if (this.repurchaseRate != null) {
      data['repurchase_rate'] = this.repurchaseRate!.toJson();
    }
    if (this.onlineHours != null) {
      data['online_hours'] = this.onlineHours!.toJson();
    }
    if (this.liveOnline != null) {
      data['live_online'] = this.liveOnline!.toJson();
    }
    if (this.averageServiceTime != null) {
      data['average_service_time'] = this.averageServiceTime!.toJson();
    }
    if (this.customerSatisfactionRatings != null) {
      data['customer_satisfaction_ratings'] =
          this.customerSatisfactionRatings!.toJson();
    }
    return data;
  }
}

class Conversion {
  String? label;
  List<RankDetail>? rankDetail;
  Performance? performance;

  Conversion({this.label, this.rankDetail, this.performance});

  Conversion.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['rank_detail'] != null) {
      rankDetail = <RankDetail>[];
      json['rank_detail'].forEach((v) {
        rankDetail!.add(new RankDetail.fromJson(v));
      });
    }
    performance = json['performance'] != null
        ? new Performance.fromJson(json['performance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.rankDetail != null) {
      data['rank_detail'] = this.rankDetail!.map((v) => v.toJson()).toList();
    }
    if (this.performance != null) {
      data['performance'] = this.performance!.toJson();
    }
    return data;
  }
}

class RankDetail {
  String? text;
  String? min;
  String? max;
  String? value;

  RankDetail({this.text, this.min, this.max, this.value});

  RankDetail.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    min = json['min'];
    max = json['max'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['min'] = this.min;
    data['max'] = this.max;
    data['value'] = this.value;
    return data;
  }
}

class Performance {
  dynamic? marksObtains;
  dynamic? totalMarks;
  List<Marks>? marks;

  Performance({this.marksObtains, this.totalMarks, this.marks});

  Performance.fromJson(Map<String, dynamic> json) {
    marksObtains = json['marks_obtains'];
    totalMarks = json['total_marks'];
    if (json['marks'] != null) {
      marks = <Marks>[];
      json['marks'].forEach((v) {
        marks!.add(new Marks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['marks_obtains'] = this.marksObtains;
    data['total_marks'] = this.totalMarks;
    if (this.marks != null) {
      data['marks'] = this.marks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Marks {
  String? min;
  String? max;
  String? value;

  Marks({this.min, this.max, this.value});

  Marks.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min'] = this.min;
    data['max'] = this.max;
    data['value'] = this.value;
    return data;
  }
}

class RankSystem {
  String? text;
  String? min;
  String? max;
  String? value;
  String? image;

  RankSystem({this.text, this.min, this.max, this.value, this.image});

  RankSystem.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    min = json['min'];
    max = json['max'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['min'] = this.min;
    data['max'] = this.max;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

