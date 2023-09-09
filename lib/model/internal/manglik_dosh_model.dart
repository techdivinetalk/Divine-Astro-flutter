// To parse this JSON data, do
//
//     final manglikDoshModel = manglikDoshModelFromJson(jsonString);

import 'dart:convert';

ManglikDoshModel manglikDoshModelFromJson(String str) => ManglikDoshModel.fromJson(json.decode(str));

String manglikDoshModelToJson(ManglikDoshModel data) => json.encode(data.toJson());

class ManglikDoshModel {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  ManglikDoshModel({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory ManglikDoshModel.fromJson(Map<String, dynamic> json) => ManglikDoshModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}

class Data {
  Manglik? manglik;
  KalsarpaDetails? kalsarpaDetails;
  PitraDoshaReport? pitraDoshaReport;
  SadhesatiCurrentStatus? sadhesatiCurrentStatus;

  Data({
    this.manglik,
    this.kalsarpaDetails,
    this.pitraDoshaReport,
    this.sadhesatiCurrentStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    manglik: json["manglik"] == null ? null : Manglik.fromJson(json["manglik"]),
    kalsarpaDetails: json["kalsarpa_details"] == null ? null : KalsarpaDetails.fromJson(json["kalsarpa_details"]),
    pitraDoshaReport: json["pitra_dosha_report"] == null ? null : PitraDoshaReport.fromJson(json["pitra_dosha_report"]),
    sadhesatiCurrentStatus: json["sadhesati_current_status"] == null ? null : SadhesatiCurrentStatus.fromJson(json["sadhesati_current_status"]),
  );

  Map<String, dynamic> toJson() => {
    "manglik": manglik?.toJson(),
    "kalsarpa_details": kalsarpaDetails?.toJson(),
    "pitra_dosha_report": pitraDoshaReport?.toJson(),
    "sadhesati_current_status": sadhesatiCurrentStatus?.toJson(),
  };
}

class KalsarpaDetails {
  bool? present;
  String? type;
  String? oneLine;
  String? name;
  Report? report;

  KalsarpaDetails({
    this.present,
    this.type,
    this.oneLine,
    this.name,
    this.report,
  });

  factory KalsarpaDetails.fromJson(Map<String, dynamic> json) => KalsarpaDetails(
    present: json["present"],
    type: json["type"],
    oneLine: json["one_line"],
    name: json["name"],
    report: json["report"] == null ? null : Report.fromJson(json["report"]),
  );

  Map<String, dynamic> toJson() => {
    "present": present,
    "type": type,
    "one_line": oneLine,
    "name": name,
    "report": report?.toJson(),
  };
}

class Report {
  int? houseId;
  String? report;

  Report({
    this.houseId,
    this.report,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    houseId: json["house_id"],
    report: json["report"],
  );

  Map<String, dynamic> toJson() => {
    "house_id": houseId,
    "report": report,
  };
}

class Manglik {
  ManglikPresentRule? manglikPresentRule;
  List<String>? manglikCancelRule;
  bool? isMarsManglikCancelled;
  String? manglikStatus;
  String? percentageManglikPresent;
  String? percentageManglikAfterCancellation;
  String? manglikReport;
  bool? isPresent;

  Manglik({
    this.manglikPresentRule,
    this.manglikCancelRule,
    this.isMarsManglikCancelled,
    this.manglikStatus,
    this.percentageManglikPresent,
    this.percentageManglikAfterCancellation,
    this.manglikReport,
    this.isPresent,
  });

  factory Manglik.fromJson(Map<String, dynamic> json) => Manglik(
    manglikPresentRule: json["manglik_present_rule"] == null ? null : ManglikPresentRule.fromJson(json["manglik_present_rule"]),
    manglikCancelRule: json["manglik_cancel_rule"] == null ? [] : List<String>.from(json["manglik_cancel_rule"]!.map((x) => x)),
    isMarsManglikCancelled: json["is_mars_manglik_cancelled"],
    manglikStatus: json["manglik_status"],
    percentageManglikPresent: json["percentage_manglik_present"].toString(),
    percentageManglikAfterCancellation: json["percentage_manglik_after_cancellation"].toString(),
    manglikReport: json["manglik_report"],
    isPresent: json["is_present"],
  );

  Map<String, dynamic> toJson() => {
    "manglik_present_rule": manglikPresentRule?.toJson(),
    "manglik_cancel_rule": manglikCancelRule == null ? [] : List<dynamic>.from(manglikCancelRule!.map((x) => x)),
    "is_mars_manglik_cancelled": isMarsManglikCancelled,
    "manglik_status": manglikStatus,
    "percentage_manglik_present": percentageManglikPresent,
    "percentage_manglik_after_cancellation": percentageManglikAfterCancellation,
    "manglik_report": manglikReport,
    "is_present": isPresent,
  };
}

class ManglikPresentRule {
  List<String>? basedOnAspect;
  List<String>? basedOnHouse;

  ManglikPresentRule({
    this.basedOnAspect,
    this.basedOnHouse,
  });

  factory ManglikPresentRule.fromJson(Map<String, dynamic> json) => ManglikPresentRule(
    basedOnAspect: json["based_on_aspect"] == null ? [] : List<String>.from(json["based_on_aspect"]!.map((x) => x)),
    basedOnHouse: json["based_on_house"] == null ? [] : List<String>.from(json["based_on_house"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "based_on_aspect": basedOnAspect == null ? [] : List<dynamic>.from(basedOnAspect!.map((x) => x)),
    "based_on_house": basedOnHouse == null ? [] : List<dynamic>.from(basedOnHouse!.map((x) => x)),
  };
}

class PitraDoshaReport {
  String? whatIsPitriDosha;
  bool? isPitriDoshaPresent;
  List<String>? rulesMatched;
  String? conclusion;
  List<String>? remedies;
  List<String>? effects;

  PitraDoshaReport({
    this.whatIsPitriDosha,
    this.isPitriDoshaPresent,
    this.rulesMatched,
    this.conclusion,
    this.remedies,
    this.effects,
  });

  factory PitraDoshaReport.fromJson(Map<String, dynamic> json) => PitraDoshaReport(
    whatIsPitriDosha: json["what_is_pitri_dosha"],
    isPitriDoshaPresent: json["is_pitri_dosha_present"],
    rulesMatched: json["rules_matched"] == null ? [] : List<String>.from(json["rules_matched"]!.map((x) => x)),
    conclusion: json["conclusion"],
    remedies: json["remedies"] == null ? [] : List<String>.from(json["remedies"]!.map((x) => x)),
    effects: json["effects"] == null ? [] : List<String>.from(json["effects"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "what_is_pitri_dosha": whatIsPitriDosha,
    "is_pitri_dosha_present": isPitriDoshaPresent,
    "rules_matched": rulesMatched == null ? [] : List<dynamic>.from(rulesMatched!.map((x) => x)),
    "conclusion": conclusion,
    "remedies": remedies == null ? [] : List<dynamic>.from(remedies!.map((x) => x)),
    "effects": effects == null ? [] : List<dynamic>.from(effects!.map((x) => x)),
  };
}

class SadhesatiCurrentStatus {
  String? considerationDate;
  bool? isSaturnRetrograde;
  String? moonSign;
  String? saturnSign;
  String? isUndergoingSadhesati;
  String? sadhesatiPhase;
  bool? sadhesatiStatus;
  String? startDate;
  String? endDate;
  String? whatIsSadhesati;

  SadhesatiCurrentStatus({
    this.considerationDate,
    this.isSaturnRetrograde,
    this.moonSign,
    this.saturnSign,
    this.isUndergoingSadhesati,
    this.sadhesatiPhase,
    this.sadhesatiStatus,
    this.startDate,
    this.endDate,
    this.whatIsSadhesati,
  });

  factory SadhesatiCurrentStatus.fromJson(Map<String, dynamic> json) => SadhesatiCurrentStatus(
    considerationDate: json["consideration_date"],
    isSaturnRetrograde: json["is_saturn_retrograde"],
    moonSign: json["moon_sign"],
    saturnSign: json["saturn_sign"],
    isUndergoingSadhesati: json["is_undergoing_sadhesati"],
    sadhesatiPhase: json["sadhesati_phase"],
    sadhesatiStatus: json["sadhesati_status"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    whatIsSadhesati: json["what_is_sadhesati"],
  );

  Map<String, dynamic> toJson() => {
    "consideration_date": considerationDate,
    "is_saturn_retrograde": isSaturnRetrograde,
    "moon_sign": moonSign,
    "saturn_sign": saturnSign,
    "is_undergoing_sadhesati": isUndergoingSadhesati,
    "sadhesati_phase": sadhesatiPhase,
    "sadhesati_status": sadhesatiStatus,
    "start_date": startDate,
    "end_date": endDate,
    "what_is_sadhesati": whatIsSadhesati,
  };
}
