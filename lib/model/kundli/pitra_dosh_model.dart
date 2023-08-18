import 'dart:convert';

PitraDosh pitraDoshFromJson(String str) => PitraDosh.fromJson(json.decode(str));

String pitraDoshToJson(PitraDosh data) => json.encode(data.toJson());

class PitraDosh {
  String? whatIsPitriDosha, conclusion;
  bool? isPitriDoshaPresent;
  List<String>? rulesMatched, remedies, effects;

  PitraDosh({
    this.whatIsPitriDosha,
    this.isPitriDoshaPresent,
    this.rulesMatched,
    this.conclusion,
    this.remedies,
    this.effects,
  });

  factory PitraDosh.fromJson(Map<String, dynamic> json) => PitraDosh(
        whatIsPitriDosha: json["what_is_pitri_dosha"],
        isPitriDoshaPresent: json["is_pitri_dosha_present"],
        rulesMatched: json["rules_matched"] != null
            ? List<String>.from(json["rules_matched"].map((x) => x))
            : [],
        conclusion: json["conclusion"],
        remedies: json["remedies"] != null ? List<String>.from(json["remedies"].map((x) => x)) : [],
        effects: json["effects"] != null ? List<String>.from(json["effects"].map((x) => x)) : [],
      );

  Map<String, dynamic> toJson() => {
        "what_is_pitri_dosha": whatIsPitriDosha,
        "is_pitri_dosha_present": isPitriDoshaPresent,
        "rules_matched": List<dynamic>.from(rulesMatched!.map((x) => x)),
        "conclusion": conclusion,
        "remedies": List<dynamic>.from(remedies!.map((x) => x)),
        "effects": List<dynamic>.from(effects!.map((x) => x)),
      };
}
