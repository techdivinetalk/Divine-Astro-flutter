import 'dart:convert';

AstroDetails astroDetailsFromJson(String str) => AstroDetails.fromJson(json.decode(str));

String astroDetailsToJson(AstroDetails data) => json.encode(data.toJson());

class AstroDetails {
  String? ascendant, ascendantLord, varna, vashya, yoni, gan, nadi, signLord, sign, naksahtra, naksahtraLord;
  String? yog, karan, tithi, yunja, tatva, nameAlphabet, paya;
  int? charan;

  AstroDetails({
    this.ascendant,
    this.ascendantLord,
    this.varna,
    this.vashya,
    this.yoni,
    this.gan,
    this.nadi,
    this.signLord,
    this.sign,
    this.naksahtra,
    this.naksahtraLord,
    this.charan,
    this.yog,
    this.karan,
    this.tithi,
    this.yunja,
    this.tatva,
    this.nameAlphabet,
    this.paya,
  });

  factory AstroDetails.fromJson(Map<String, dynamic> json) => AstroDetails(
    ascendant: json["ascendant"],
    ascendantLord: json["ascendant_lord"],
    varna: json["Varna"],
    vashya: json["Vashya"],
    yoni: json["Yoni"],
    gan: json["Gan"],
    nadi: json["Nadi"],
    signLord: json["SignLord"],
    sign: json["sign"],
    naksahtra: json["Naksahtra"],
    naksahtraLord: json["NaksahtraLord"],
    charan: json["Charan"],
    yog: json["Yog"],
    karan: json["Karan"],
    tithi: json["Tithi"],
    yunja: json["yunja"],
    tatva: json["tatva"],
    nameAlphabet: json["name_alphabet"],
    paya: json["paya"],
  );

  Map<String, dynamic> toJson() => {
    "ascendant": ascendant,
    "ascendant_lord": ascendantLord,
    "Varna": varna,
    "Vashya": vashya,
    "Yoni": yoni,
    "Gan": gan,
    "Nadi": nadi,
    "SignLord": signLord,
    "sign": sign,
    "Naksahtra": naksahtra,
    "NaksahtraLord": naksahtraLord,
    "Charan": charan,
    "Yog": yog,
    "Karan": karan,
    "Tithi": tithi,
    "yunja": yunja,
    "tatva": tatva,
    "name_alphabet": nameAlphabet,
    "paya": paya,
  };
}
