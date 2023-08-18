import 'dart:convert';

KundliPrediction kundliPredictionFromJson(String str) => KundliPrediction.fromJson(json.decode(str));

String kundliPredictionToJson(KundliPrediction data) => json.encode(data.toJson());

class KundliPrediction {
  List<String>? physical, character, education, family, health;

  KundliPrediction({
    this.physical,
    this.character,
    this.education,
    this.family,
    this.health,
  });

  factory KundliPrediction.fromJson(Map<String, dynamic> json) => KundliPrediction(
    physical: List<String>.from(json["physical"].map((x) => x)),
    character: List<String>.from(json["character"].map((x) => x)),
    education: List<String>.from(json["education"].map((x) => x)),
    family: List<String>.from(json["family"].map((x) => x)),
    health: List<String>.from(json["health"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "physical": List<dynamic>.from(physical!.map((x) => x)),
    "character": List<dynamic>.from(character!.map((x) => x)),
    "education": List<dynamic>.from(education!.map((x) => x)),
    "family": List<dynamic>.from(family!.map((x) => x)),
    "health": List<dynamic>.from(health!.map((x) => x)),
  };
}
