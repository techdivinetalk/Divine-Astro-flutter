import 'dart:convert';

ManglikDosh manglikDoshFromJson(String str) => ManglikDosh.fromJson(json.decode(str));

String manglikDoshToJson(ManglikDosh data) => json.encode(data.toJson());

class ManglikDosh {
  ManglikPresentRule? manglikPresentRule;
  List<dynamic>? manglikCancelRule;
  bool? isMarsManglikCancelled, isPresent;
  String? manglikStatus, manglikReport;
  double? percentageManglikPresent, percentageManglikAfterCancellation;

  ManglikDosh({
    this.manglikPresentRule,
    this.manglikCancelRule,
    this.isMarsManglikCancelled,
    this.manglikStatus,
    this.percentageManglikPresent,
    this.percentageManglikAfterCancellation,
    this.manglikReport,
    this.isPresent,
  });

  factory ManglikDosh.fromJson(Map<String, dynamic> json) => ManglikDosh(
        manglikPresentRule: ManglikPresentRule.fromJson(json["manglik_present_rule"]),
        manglikCancelRule: List<dynamic>.from(json["manglik_cancel_rule"].map((x) => x)),
        isMarsManglikCancelled: json["is_mars_manglik_cancelled"],
        manglikStatus: json["manglik_status"],
        percentageManglikPresent: json["percentage_manglik_present"]?.toDouble(),
        percentageManglikAfterCancellation:
            json["percentage_manglik_after_cancellation"]?.toDouble(),
        manglikReport: json["manglik_report"],
        isPresent: json["is_present"],
      );

  Map<String, dynamic> toJson() => {
        "manglik_present_rule": manglikPresentRule!.toJson(),
        "manglik_cancel_rule": List<dynamic>.from(manglikCancelRule!.map((x) => x)),
        "is_mars_manglik_cancelled": isMarsManglikCancelled,
        "manglik_status": manglikStatus,
        "percentage_manglik_present": percentageManglikPresent,
        "percentage_manglik_after_cancellation": percentageManglikAfterCancellation,
        "manglik_report": manglikReport,
        "is_present": isPresent,
      };
}

class ManglikPresentRule {
  List<String>? basedOnAspect, basedOnHouse;

  ManglikPresentRule({
    this.basedOnAspect,
    this.basedOnHouse,
  });

  factory ManglikPresentRule.fromJson(Map<String, dynamic> json) => ManglikPresentRule(
        basedOnAspect: List<String>.from(json["based_on_aspect"].map((x) => x)),
        basedOnHouse: List<String>.from(json["based_on_house"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "based_on_aspect": List<dynamic>.from(basedOnAspect!.map((x) => x)),
        "based_on_house": List<dynamic>.from(basedOnHouse!.map((x) => x)),
      };
}
