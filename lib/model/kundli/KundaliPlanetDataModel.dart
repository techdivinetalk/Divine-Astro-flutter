import 'dart:convert';

/// data : {"type":"planetry_positions","title":"Planetry Positions","data":[{"id":0,"name":"Sun","fullDegree":256.77638446907287,"normDegree":16.776384469072866,"speed":1.0194568056955187,"isRetro":"false","sign":"Sagittarius","signLord":"Jupiter","nakshatra":"Purva Shadha","nakshatraLord":"Venus","nakshatra_pad":2,"house":11,"is_planet_set":false,"planet_awastha":"Yuva"},{"id":1,"name":"Moon","fullDegree":305.365844825837,"normDegree":5.365844825836973,"speed":13.408521350555338,"isRetro":"false","sign":"Aquarius","signLord":"Saturn","nakshatra":"Dhanishtha","nakshatraLord":"Mars","nakshatra_pad":4,"house":1,"is_planet_set":false,"planet_awastha":"Bala"},{"id":2,"name":"Mars","fullDegree":226.06046167671573,"normDegree":16.060461676715732,"speed":0.7035522397805455,"isRetro":"false","sign":"Scorpio","signLord":"Mars","nakshatra":"Anuradha","nakshatraLord":"Saturn","nakshatra_pad":4,"house":10,"is_planet_set":false,"planet_awastha":"Yuva"},{"id":3,"name":"Mercury","fullDegree":272.0342070306552,"normDegree":2.034207030655182,"speed":-0.23321054566929464,"isRetro":"true","sign":"Capricorn","signLord":"Saturn","nakshatra":"Uttra Shadha","nakshatraLord":"Sun","nakshatra_pad":2,"house":12,"is_planet_set":false,"planet_awastha":"Mrit"},{"id":4,"name":"Jupiter","fullDegree":71.46995518184286,"normDegree":11.469955181842863,"speed":-0.1346811232647673,"isRetro":"true","sign":"Gemini","signLord":"Mercury","nakshatra":"Ardra","nakshatraLord":"Rahu","nakshatra_pad":2,"house":5,"is_planet_set":false,"planet_awastha":"Kumara"},{"id":5,"name":"Venus","fullDegree":282.5397551038818,"normDegree":12.539755103881816,"speed":-0.11723901191303196,"isRetro":"true","sign":"Capricorn","signLord":"Saturn","nakshatra":"Shravan","nakshatraLord":"Moon","nakshatra_pad":1,"house":12,"is_planet_set":false,"planet_awastha":"Yuva"},{"id":6,"name":"Saturn","fullDegree":261.90000405901696,"normDegree":21.900004059016965,"speed":0.1182059530607968,"isRetro":"false","sign":"Sagittarius","signLord":"Jupiter","nakshatra":"Purva Shadha","nakshatraLord":"Venus","nakshatra_pad":3,"house":11,"is_planet_set":true,"planet_awastha":"Vridha"},{"id":7,"name":"Rahu","fullDegree":294.73075623998596,"normDegree":24.730756239985965,"speed":-0.05299202244914132,"isRetro":"true","sign":"Capricorn","signLord":"Saturn","nakshatra":"Dhanishtha","nakshatraLord":"Mars","nakshatra_pad":1,"house":12,"is_planet_set":false,"planet_awastha":"Bala"},{"id":8,"name":"Ketu","fullDegree":114.73075623998596,"normDegree":24.730756239985965,"speed":-0.05299202244914132,"isRetro":"true","sign":"Cancer","signLord":"Moon","nakshatra":"Ashlesha","nakshatraLord":"Mercury","nakshatra_pad":3,"house":6,"is_planet_set":false,"planet_awastha":"Bala"},{"id":9,"name":"Ascendant","fullDegree":307.86487593600486,"normDegree":7.864875936004864,"speed":0,"isRetro":false,"sign":"Aquarius","signLord":"Saturn","nakshatra":"Shatbhisha","nakshatraLord":"Rahu","nakshatra_pad":1,"house":1,"is_planet_set":false,"planet_awastha":"--"}],"color":{"Sun":"#860111","Moon":"#E0FFFF","Mars":"#FF0000","Mercury":"#00FF00","Jupiter":"#FFFF00","Venus":"#FFC0CB","Saturn":"#000000","Rahu":"#0000FF","Ketu":"#605B73","Ascendant":"#000000"}}
/// success : true
/// status_code : 200
/// message : "Data fetched successfully"

KundaliPlanetDataModel kundaliPlanetsModelFromJson(String str) =>
    KundaliPlanetDataModel.fromJson(json.decode(str));

String kundaliPlanetsModelToJson(KundaliPlanetDataModel data) =>
    json.encode(data.toJson());

class KundaliPlanetDataModel {
  KundaliPlanetDataModel({
    Data? data,
    bool? success,
    num? statusCode,
    String? message,
  }) {
    _data = data;
    _success = success;
    _statusCode = statusCode;
    _message = message;
  }

  KundaliPlanetDataModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _statusCode = json['status_code'];
    _message = json['message'];
  }
  Data? _data;
  bool? _success;
  num? _statusCode;
  String? _message;
  KundaliPlanetDataModel copyWith({
    Data? data,
    bool? success,
    num? statusCode,
    String? message,
  }) =>
      KundaliPlanetDataModel(
        data: data ?? _data,
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        message: message ?? _message,
      );
  Data? get data => _data;
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['message'] = _message;
    return map;
  }
}

/// type : "planetry_positions"
/// title : "Planetry Positions"
/// data : [{"id":0,"name":"Sun","fullDegree":256.77638446907287,"normDegree":16.776384469072866,"speed":1.0194568056955187,"isRetro":"false","sign":"Sagittarius","signLord":"Jupiter","nakshatra":"Purva Shadha","nakshatraLord":"Venus","nakshatra_pad":2,"house":11,"is_planet_set":false,"planet_awastha":"Yuva"},{"id":1,"name":"Moon","fullDegree":305.365844825837,"normDegree":5.365844825836973,"speed":13.408521350555338,"isRetro":"false","sign":"Aquarius","signLord":"Saturn","nakshatra":"Dhanishtha","nakshatraLord":"Mars","nakshatra_pad":4,"house":1,"is_planet_set":false,"planet_awastha":"Bala"},{"id":2,"name":"Mars","fullDegree":226.06046167671573,"normDegree":16.060461676715732,"speed":0.7035522397805455,"isRetro":"false","sign":"Scorpio","signLord":"Mars","nakshatra":"Anuradha","nakshatraLord":"Saturn","nakshatra_pad":4,"house":10,"is_planet_set":false,"planet_awastha":"Yuva"},{"id":3,"name":"Mercury","fullDegree":272.0342070306552,"normDegree":2.034207030655182,"speed":-0.23321054566929464,"isRetro":"true","sign":"Capricorn","signLord":"Saturn","nakshatra":"Uttra Shadha","nakshatraLord":"Sun","nakshatra_pad":2,"house":12,"is_planet_set":false,"planet_awastha":"Mrit"},{"id":4,"name":"Jupiter","fullDegree":71.46995518184286,"normDegree":11.469955181842863,"speed":-0.1346811232647673,"isRetro":"true","sign":"Gemini","signLord":"Mercury","nakshatra":"Ardra","nakshatraLord":"Rahu","nakshatra_pad":2,"house":5,"is_planet_set":false,"planet_awastha":"Kumara"},{"id":5,"name":"Venus","fullDegree":282.5397551038818,"normDegree":12.539755103881816,"speed":-0.11723901191303196,"isRetro":"true","sign":"Capricorn","signLord":"Saturn","nakshatra":"Shravan","nakshatraLord":"Moon","nakshatra_pad":1,"house":12,"is_planet_set":false,"planet_awastha":"Yuva"},{"id":6,"name":"Saturn","fullDegree":261.90000405901696,"normDegree":21.900004059016965,"speed":0.1182059530607968,"isRetro":"false","sign":"Sagittarius","signLord":"Jupiter","nakshatra":"Purva Shadha","nakshatraLord":"Venus","nakshatra_pad":3,"house":11,"is_planet_set":true,"planet_awastha":"Vridha"},{"id":7,"name":"Rahu","fullDegree":294.73075623998596,"normDegree":24.730756239985965,"speed":-0.05299202244914132,"isRetro":"true","sign":"Capricorn","signLord":"Saturn","nakshatra":"Dhanishtha","nakshatraLord":"Mars","nakshatra_pad":1,"house":12,"is_planet_set":false,"planet_awastha":"Bala"},{"id":8,"name":"Ketu","fullDegree":114.73075623998596,"normDegree":24.730756239985965,"speed":-0.05299202244914132,"isRetro":"true","sign":"Cancer","signLord":"Moon","nakshatra":"Ashlesha","nakshatraLord":"Mercury","nakshatra_pad":3,"house":6,"is_planet_set":false,"planet_awastha":"Bala"},{"id":9,"name":"Ascendant","fullDegree":307.86487593600486,"normDegree":7.864875936004864,"speed":0,"isRetro":false,"sign":"Aquarius","signLord":"Saturn","nakshatra":"Shatbhisha","nakshatraLord":"Rahu","nakshatra_pad":1,"house":1,"is_planet_set":false,"planet_awastha":"--"}]
/// color : {"Sun":"#860111","Moon":"#E0FFFF","Mars":"#FF0000","Mercury":"#00FF00","Jupiter":"#FFFF00","Venus":"#FFC0CB","Saturn":"#000000","Rahu":"#0000FF","Ketu":"#605B73","Ascendant":"#000000"}

class Data {
  Data({
    String? type,
    String? title,
    List<Planet>? data,
    Color? color,
  }) {
    _type = type;
    _title = title;
    _data = data;
    _color = color;
  }

  Data.fromJson(dynamic json) {
    _type = json['type'];
    _title = json['title'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Planet.fromJson(v));
      });
    }
    _color = json['color'] != null ? Color.fromJson(json['color']) : null;
  }
  String? _type;
  String? _title;
  List<Planet>? _data;
  Color? _color;
  Data copyWith({
    String? type,
    String? title,
    List<Planet>? data,
    Color? color,
  }) =>
      Data(
        type: type ?? _type,
        title: title ?? _title,
        data: data ?? _data,
        color: color ?? _color,
      );
  String? get type => _type;
  String? get title => _title;
  List<Planet>? get data => _data;
  Color? get color => _color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['title'] = _title;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_color != null) {
      map['color'] = _color?.toJson();
    }
    return map;
  }
}

/// Sun : "#860111"
/// Moon : "#E0FFFF"
/// Mars : "#FF0000"
/// Mercury : "#00FF00"
/// Jupiter : "#FFFF00"
/// Venus : "#FFC0CB"
/// Saturn : "#000000"
/// Rahu : "#0000FF"
/// Ketu : "#605B73"
/// Ascendant : "#000000"

class Color {
  Color({
    String? sun,
    String? moon,
    String? mars,
    String? mercury,
    String? jupiter,
    String? venus,
    String? saturn,
    String? rahu,
    String? ketu,
    String? ascendant,
  }) {
    _sun = sun;
    _moon = moon;
    _mars = mars;
    _mercury = mercury;
    _jupiter = jupiter;
    _venus = venus;
    _saturn = saturn;
    _rahu = rahu;
    _ketu = ketu;
    _ascendant = ascendant;
  }

  Color.fromJson(dynamic json) {
    _sun = json['Sun'];
    _moon = json['Moon'];
    _mars = json['Mars'];
    _mercury = json['Mercury'];
    _jupiter = json['Jupiter'];
    _venus = json['Venus'];
    _saturn = json['Saturn'];
    _rahu = json['Rahu'];
    _ketu = json['Ketu'];
    _ascendant = json['Ascendant'];
  }
  String? _sun;
  String? _moon;
  String? _mars;
  String? _mercury;
  String? _jupiter;
  String? _venus;
  String? _saturn;
  String? _rahu;
  String? _ketu;
  String? _ascendant;
  Color copyWith({
    String? sun,
    String? moon,
    String? mars,
    String? mercury,
    String? jupiter,
    String? venus,
    String? saturn,
    String? rahu,
    String? ketu,
    String? ascendant,
  }) =>
      Color(
        sun: sun ?? _sun,
        moon: moon ?? _moon,
        mars: mars ?? _mars,
        mercury: mercury ?? _mercury,
        jupiter: jupiter ?? _jupiter,
        venus: venus ?? _venus,
        saturn: saturn ?? _saturn,
        rahu: rahu ?? _rahu,
        ketu: ketu ?? _ketu,
        ascendant: ascendant ?? _ascendant,
      );
  String? get sun => _sun;
  String? get moon => _moon;
  String? get mars => _mars;
  String? get mercury => _mercury;
  String? get jupiter => _jupiter;
  String? get venus => _venus;
  String? get saturn => _saturn;
  String? get rahu => _rahu;
  String? get ketu => _ketu;
  String? get ascendant => _ascendant;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Sun'] = _sun;
    map['Moon'] = _moon;
    map['Mars'] = _mars;
    map['Mercury'] = _mercury;
    map['Jupiter'] = _jupiter;
    map['Venus'] = _venus;
    map['Saturn'] = _saturn;
    map['Rahu'] = _rahu;
    map['Ketu'] = _ketu;
    map['Ascendant'] = _ascendant;
    return map;
  }
}

/// id : 0
/// name : "Sun"
/// fullDegree : 256.77638446907287
/// normDegree : 16.776384469072866
/// speed : 1.0194568056955187
/// isRetro : "false"
/// sign : "Sagittarius"
/// signLord : "Jupiter"
/// nakshatra : "Purva Shadha"
/// nakshatraLord : "Venus"
/// nakshatra_pad : 2
/// house : 11
/// is_planet_set : false
/// planet_awastha : "Yuva"

class Planet {
  Planet({
    num? id,
    String? name,
    num? fullDegree,
    num? normDegree,
    num? speed,
    var isRetro,
    String? sign,
    String? signLord,
    String? nakshatra,
    String? nakshatraLord,
    num? nakshatraPad,
    num? house,
    bool? isPlanetSet,
    String? planetAwastha,
  }) {
    _id = id;
    _name = name;
    _fullDegree = fullDegree;
    _normDegree = normDegree;
    _speed = speed;
    _isRetro = isRetro;
    _sign = sign;
    _signLord = signLord;
    _nakshatra = nakshatra;
    _nakshatraLord = nakshatraLord;
    _nakshatraPad = nakshatraPad;
    _house = house;
    _isPlanetSet = isPlanetSet;
    _planetAwastha = planetAwastha;
  }

  Planet.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _fullDegree = json['fullDegree'];
    _normDegree = json['normDegree'];
    _speed = json['speed'];
    _isRetro = json['isRetro'];
    _sign = json['sign'];
    _signLord = json['signLord'];
    _nakshatra = json['nakshatra'];
    _nakshatraLord = json['nakshatraLord'];
    _nakshatraPad = json['nakshatra_pad'];
    _house = json['house'];
    _isPlanetSet = json['is_planet_set'];
    _planetAwastha = json['planet_awastha'];
  }
  num? _id;
  String? _name;
  num? _fullDegree;
  num? _normDegree;
  num? _speed;
  var _isRetro;
  String? _sign;
  String? _signLord;
  String? _nakshatra;
  String? _nakshatraLord;
  num? _nakshatraPad;
  num? _house;
  bool? _isPlanetSet;
  String? _planetAwastha;
  Planet copyWith({
    num? id,
    String? name,
    num? fullDegree,
    num? normDegree,
    num? speed,
    var isRetro,
    String? sign,
    String? signLord,
    String? nakshatra,
    String? nakshatraLord,
    num? nakshatraPad,
    num? house,
    bool? isPlanetSet,
    String? planetAwastha,
  }) =>
      Planet(
        id: id ?? _id,
        name: name ?? _name,
        fullDegree: fullDegree ?? _fullDegree,
        normDegree: normDegree ?? _normDegree,
        speed: speed ?? _speed,
        isRetro: isRetro ?? _isRetro,
        sign: sign ?? _sign,
        signLord: signLord ?? _signLord,
        nakshatra: nakshatra ?? _nakshatra,
        nakshatraLord: nakshatraLord ?? _nakshatraLord,
        nakshatraPad: nakshatraPad ?? _nakshatraPad,
        house: house ?? _house,
        isPlanetSet: isPlanetSet ?? _isPlanetSet,
        planetAwastha: planetAwastha ?? _planetAwastha,
      );
  num? get id => _id;
  String? get name => _name;
  num? get fullDegree => _fullDegree;
  num? get normDegree => _normDegree;
  num? get speed => _speed;
  get isRetro => _isRetro;
  String? get sign => _sign;
  String? get signLord => _signLord;
  String? get nakshatra => _nakshatra;
  String? get nakshatraLord => _nakshatraLord;
  num? get nakshatraPad => _nakshatraPad;
  num? get house => _house;
  bool? get isPlanetSet => _isPlanetSet;
  String? get planetAwastha => _planetAwastha;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['fullDegree'] = _fullDegree;
    map['normDegree'] = _normDegree;
    map['speed'] = _speed;
    map['isRetro'] = _isRetro;
    map['sign'] = _sign;
    map['signLord'] = _signLord;
    map['nakshatra'] = _nakshatra;
    map['nakshatraLord'] = _nakshatraLord;
    map['nakshatra_pad'] = _nakshatraPad;
    map['house'] = _house;
    map['is_planet_set'] = _isPlanetSet;
    map['planet_awastha'] = _planetAwastha;
    return map;
  }
}
