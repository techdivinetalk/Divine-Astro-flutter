class ResGetKundli {
  KundliDetails? data;
  bool? success;
  int? statusCode;
  String? message;

  ResGetKundli({this.data, this.success, this.statusCode, this.message});

  ResGetKundli.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? KundliDetails.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class KundliDetails {
  int? id;
  int? atrologyApiInputId;
  BirthDetails? birthDetails;
  AstroDetails? astroDetails;
  GeneralNakshatraReport? generalNakshatraReport;
  Manglik? manglik;
  KalsarpaDetails? kalsarpaDetails;
  SadhesatiCurrentStatus? sadhesatiCurrentStatus;
  PitraDoshaReport? pitraDoshaReport;
  // Null? advancedPanchang;
  String? createdAt;
  String? updatedAt;
  String? lagnaSvg;
  String? moonSvg;
  String? sunSvg;
  String? navamanshaSvg;

  KundliDetails(
      {this.id,
      this.atrologyApiInputId,
      this.birthDetails,
      this.astroDetails,
      this.generalNakshatraReport,
      this.manglik,
      this.kalsarpaDetails,
      this.sadhesatiCurrentStatus,
      this.pitraDoshaReport,
      // this.advancedPanchang,
      this.createdAt,
      this.updatedAt,
      this.lagnaSvg,
      this.moonSvg,
      this.sunSvg,
      this.navamanshaSvg});

  KundliDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    atrologyApiInputId = json['atrology_api_input_id'];
    birthDetails = json['birth_details'] != null
        ? BirthDetails.fromJson(json['birth_details'])
        : null;
    astroDetails = json['astro_details'] != null
        ? AstroDetails.fromJson(json['astro_details'])
        : null;
    generalNakshatraReport = json['general_nakshatra_report'] != null
        ? GeneralNakshatraReport.fromJson(json['general_nakshatra_report'])
        : null;
    manglik =
        json['manglik'] != null ? Manglik.fromJson(json['manglik']) : null;
    kalsarpaDetails = json['kalsarpa_details'] != null
        ? KalsarpaDetails.fromJson(json['kalsarpa_details'])
        : null;
    sadhesatiCurrentStatus = json['sadhesati_current_status'] != null
        ? SadhesatiCurrentStatus.fromJson(json['sadhesati_current_status'])
        : null;
    pitraDoshaReport = json['pitra_dosha_report'] != null
        ? PitraDoshaReport.fromJson(json['pitra_dosha_report'])
        : null;
    // advancedPanchang = json['advanced_panchang'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lagnaSvg = json['lagna_svg'];
    moonSvg = json['moon_svg'];
    sunSvg = json['sun_svg'];
    navamanshaSvg = json['navamansha_svg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['atrology_api_input_id'] = atrologyApiInputId;
    if (birthDetails != null) {
      data['birth_details'] = birthDetails!.toJson();
    }
    if (astroDetails != null) {
      data['astro_details'] = astroDetails!.toJson();
    }
    if (generalNakshatraReport != null) {
      data['general_nakshatra_report'] = generalNakshatraReport!.toJson();
    }
    if (manglik != null) {
      data['manglik'] = manglik!.toJson();
    }
    if (kalsarpaDetails != null) {
      data['kalsarpa_details'] = kalsarpaDetails!.toJson();
    }
    if (sadhesatiCurrentStatus != null) {
      data['sadhesati_current_status'] = sadhesatiCurrentStatus!.toJson();
    }
    if (pitraDoshaReport != null) {
      data['pitra_dosha_report'] = pitraDoshaReport!.toJson();
    }
    // data['advanced_panchang'] = advancedPanchang;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['lagna_svg'] = lagnaSvg;
    data['moon_svg'] = moonSvg;
    data['sun_svg'] = sunSvg;
    data['navamansha_svg'] = navamanshaSvg;
    return data;
  }
}

class BirthDetails {
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  double? latitude;
  double? longitude;
  double? timezone;
  int? seconds;
  double? ayanamsha;
  String? sunrise;
  String? sunset;

  BirthDetails(
      {this.year,
      this.month,
      this.day,
      this.hour,
      this.minute,
      this.latitude,
      this.longitude,
      this.timezone,
      this.seconds,
      this.ayanamsha,
      this.sunrise,
      this.sunset});

  BirthDetails.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    day = json['day'];
    hour = json['hour'];
    minute = json['minute'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    timezone = json['timezone'];
    seconds = json['seconds'];
    ayanamsha = json['ayanamsha'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['month'] = month;
    data['day'] = day;
    data['hour'] = hour;
    data['minute'] = minute;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['timezone'] = timezone;
    data['seconds'] = seconds;
    data['ayanamsha'] = ayanamsha;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    return data;
  }
}

class AstroDetails {
  String? ascendant;
  String? ascendantLord;
  String? varna;
  String? vashya;
  String? yoni;
  String? gan;
  String? nadi;
  String? signLord;
  String? sign;
  String? naksahtra;
  String? naksahtraLord;
  int? charan;
  String? yog;
  String? karan;
  String? tithi;
  String? yunja;
  String? tatva;
  String? nameAlphabet;
  String? paya;

  AstroDetails(
      {this.ascendant,
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
      this.paya});

  AstroDetails.fromJson(Map<String, dynamic> json) {
    ascendant = json['ascendant'];
    ascendantLord = json['ascendant_lord'];
    varna = json['Varna'];
    vashya = json['Vashya'];
    yoni = json['Yoni'];
    gan = json['Gan'];
    nadi = json['Nadi'];
    signLord = json['SignLord'];
    sign = json['sign'];
    naksahtra = json['Naksahtra'];
    naksahtraLord = json['NaksahtraLord'];
    charan = json['Charan'];
    yog = json['Yog'];
    karan = json['Karan'];
    tithi = json['Tithi'];
    yunja = json['yunja'];
    tatva = json['tatva'];
    nameAlphabet = json['name_alphabet'];
    paya = json['paya'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ascendant'] = ascendant;
    data['ascendant_lord'] = ascendantLord;
    data['Varna'] = varna;
    data['Vashya'] = vashya;
    data['Yoni'] = yoni;
    data['Gan'] = gan;
    data['Nadi'] = nadi;
    data['SignLord'] = signLord;
    data['sign'] = sign;
    data['Naksahtra'] = naksahtra;
    data['NaksahtraLord'] = naksahtraLord;
    data['Charan'] = charan;
    data['Yog'] = yog;
    data['Karan'] = karan;
    data['Tithi'] = tithi;
    data['yunja'] = yunja;
    data['tatva'] = tatva;
    data['name_alphabet'] = nameAlphabet;
    data['paya'] = paya;
    return data;
  }
}

class GeneralNakshatraReport {
  List<String>? physical;
  List<String>? character;
  List<String>? education;
  List<String>? family;
  List<String>? health;

  GeneralNakshatraReport(
      {this.physical,
      this.character,
      this.education,
      this.family,
      this.health});

  GeneralNakshatraReport.fromJson(Map<String, dynamic> json) {
    physical = json['physical'].cast<String>();
    character = json['character'].cast<String>();
    education = json['education'].cast<String>();
    family = json['family'].cast<String>();
    health = json['health'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['physical'] = physical;
    data['character'] = character;
    data['education'] = education;
    data['family'] = family;
    data['health'] = health;
    return data;
  }
}

class Manglik {
  ManglikPresentRule? manglikPresentRule;
  List<String>? manglikCancelRule;
  bool? isMarsManglikCancelled;
  String? manglikStatus;
  int? percentageManglikPresent;
  double? percentageManglikAfterCancellation;
  String? manglikReport;
  bool? isPresent;

  Manglik(
      {this.manglikPresentRule,
      this.manglikCancelRule,
      this.isMarsManglikCancelled,
      this.manglikStatus,
      this.percentageManglikPresent,
      this.percentageManglikAfterCancellation,
      this.manglikReport,
      this.isPresent});

  Manglik.fromJson(Map<String, dynamic> json) {
    manglikPresentRule = json['manglik_present_rule'] != null
        ? ManglikPresentRule.fromJson(json['manglik_present_rule'])
        : null;
    manglikCancelRule = json['manglik_cancel_rule'].cast<String>();
    isMarsManglikCancelled = json['is_mars_manglik_cancelled'];
    manglikStatus = json['manglik_status'];
    percentageManglikPresent = json['percentage_manglik_present'];
    percentageManglikAfterCancellation =
        json['percentage_manglik_after_cancellation'];
    manglikReport = json['manglik_report'];
    isPresent = json['is_present'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (manglikPresentRule != null) {
      data['manglik_present_rule'] = manglikPresentRule!.toJson();
    }
    data['manglik_cancel_rule'] = manglikCancelRule;
    data['is_mars_manglik_cancelled'] = isMarsManglikCancelled;
    data['manglik_status'] = manglikStatus;
    data['percentage_manglik_present'] = percentageManglikPresent;
    data['percentage_manglik_after_cancellation'] =
        percentageManglikAfterCancellation;
    data['manglik_report'] = manglikReport;
    data['is_present'] = isPresent;
    return data;
  }
}

class ManglikPresentRule {
  List<String>? basedOnAspect;
  List<String>? basedOnHouse;

  ManglikPresentRule({this.basedOnAspect, this.basedOnHouse});

  ManglikPresentRule.fromJson(Map<String, dynamic> json) {
    basedOnAspect = json['based_on_aspect'].cast<String>();
    basedOnHouse = json['based_on_house'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['based_on_aspect'] = basedOnAspect;
    data['based_on_house'] = basedOnHouse;
    return data;
  }
}

class KalsarpaDetails {
  bool? present;
  String? type;
  String? oneLine;
  String? name;
  Report? report;

  KalsarpaDetails(
      {this.present, this.type, this.oneLine, this.name, this.report});

  KalsarpaDetails.fromJson(Map<String, dynamic> json) {
    present = json['present'];
    type = json['type'];
    oneLine = json['one_line'];
    name = json['name'];
    report = json['report'] != null ? Report.fromJson(json['report']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['present'] = present;
    data['type'] = type;
    data['one_line'] = oneLine;
    data['name'] = name;
    if (report != null) {
      data['report'] = report!.toJson();
    }
    return data;
  }
}

class Report {
  int? houseId;
  String? report;

  Report({this.houseId, this.report});

  Report.fromJson(Map<String, dynamic> json) {
    houseId = json['house_id'];
    report = json['report'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['house_id'] = houseId;
    data['report'] = report;
    return data;
  }
}

class SadhesatiCurrentStatus {
  String? considerationDate;
  bool? isSaturnRetrograde;
  String? moonSign;
  String? saturnSign;
  String? isUndergoingSadhesati;
  bool? sadhesatiStatus;
  String? whatIsSadhesati;

  SadhesatiCurrentStatus(
      {this.considerationDate,
      this.isSaturnRetrograde,
      this.moonSign,
      this.saturnSign,
      this.isUndergoingSadhesati,
      this.sadhesatiStatus,
      this.whatIsSadhesati});

  SadhesatiCurrentStatus.fromJson(Map<String, dynamic> json) {
    considerationDate = json['consideration_date'];
    isSaturnRetrograde = json['is_saturn_retrograde'];
    moonSign = json['moon_sign'];
    saturnSign = json['saturn_sign'];
    isUndergoingSadhesati = json['is_undergoing_sadhesati'];
    sadhesatiStatus = json['sadhesati_status'];
    whatIsSadhesati = json['what_is_sadhesati'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['consideration_date'] = considerationDate;
    data['is_saturn_retrograde'] = isSaturnRetrograde;
    data['moon_sign'] = moonSign;
    data['saturn_sign'] = saturnSign;
    data['is_undergoing_sadhesati'] = isUndergoingSadhesati;
    data['sadhesati_status'] = sadhesatiStatus;
    data['what_is_sadhesati'] = whatIsSadhesati;
    return data;
  }
}

class PitraDoshaReport {
  String? whatIsPitriDosha;
  bool? isPitriDoshaPresent;
  // List<Null>? rulesMatched;
  String? conclusion;
  // Null? remedies;
  // Null? effects;

  PitraDoshaReport({
    this.whatIsPitriDosha,
    this.isPitriDoshaPresent,
    // this.rulesMatched,
    this.conclusion,
    // this.remedies,
    // this.effects
  });

  PitraDoshaReport.fromJson(Map<String, dynamic> json) {
    whatIsPitriDosha = json['what_is_pitri_dosha'];
    isPitriDoshaPresent = json['is_pitri_dosha_present'];
    conclusion = json['conclusion'];
    // if (json['rules_matched'] != null) {
    //   rulesMatched = <Null>[];
    //   json['rules_matched'].forEach((v) {
    //     rulesMatched!.add(Null.fromJson(v));
    //   });
    // }

    // remedies = json['remedies'];
    // effects = json['effects'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['what_is_pitri_dosha'] = whatIsPitriDosha;
    data['is_pitri_dosha_present'] = isPitriDoshaPresent;
    data['conclusion'] = conclusion;
    // if (rulesMatched != null) {
    //   data['rules_matched'] = rulesMatched!.map((v) => v.toJson()).toList();
    // }

    // data['remedies'] = remedies;
    // data['effects'] = effects;
    return data;
  }
}
