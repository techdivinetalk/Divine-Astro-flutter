import 'dart:convert';

KalsarpaDosh kalsarpaDoshFromJson(String str) => KalsarpaDosh.fromJson(json.decode(str));

String kalsarpaDoshToJson(KalsarpaDosh data) => json.encode(data.toJson());

class KalsarpaDosh {
  bool? present;
  String? type, oneLine, name;
  Report? report;

  KalsarpaDosh({
    this.present,
    this.type,
    this.oneLine,
    this.name,
    this.report,
  });

  factory KalsarpaDosh.fromJson(Map<String, dynamic> json) => KalsarpaDosh(
        present: json["present"],
        type: json["type"],
        oneLine: json["one_line"],
        name: json["name"],
        report: Report.fromJson(json["report"]),
      );

  Map<String, dynamic> toJson() => {
        "present": present,
        "type": type,
        "one_line": oneLine,
        "name": name,
        "report": report!.toJson(),
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
