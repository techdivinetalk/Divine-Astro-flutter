import 'dart:convert';

SadesathiDosh sadesathiDoshFromJson(String str) => SadesathiDosh.fromJson(json.decode(str));

String sadesathiDoshToJson(SadesathiDosh data) => json.encode(data.toJson());

class SadesathiDosh {
  bool? isSaturnRetrograde, sadhesatiStatus;
  String? considerationDate,
      moonSign,
      saturnSign,
      isUndergoingSadhesati,
      sadhesatiPhase,
      startDate,
      endDate,
      whatIsSadhesati;

  SadesathiDosh({
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

  factory SadesathiDosh.fromJson(Map<String, dynamic> json) => SadesathiDosh(
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
