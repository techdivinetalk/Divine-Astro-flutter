class ResSaveKundli {
  SaveKundliData? data;
  bool? success;
  int? statusCode;
  String? message;

  ResSaveKundli({this.data, this.success, this.statusCode, this.message});

  ResSaveKundli.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? SaveKundliData.fromJson(json['data']) : null;
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

class SaveKundliData {
  int? userId;
  String? name;
  String? gender;
  String? dateOfBirth;
  String? timeOfBirth;
  String? placeOfBirth;
  double? latitude;
  double? longitude;
  int? atrologyApiInputId;
  String? updatedAt;
  String? createdAt;
  int? id;
  GetAtrologyApi? getAtrologyApi;

  SaveKundliData(
      {this.userId,
        this.name,
        this.gender,
        this.dateOfBirth,
        this.timeOfBirth,
        this.placeOfBirth,
        this.latitude,
        this.longitude,
        this.atrologyApiInputId,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.getAtrologyApi});

  SaveKundliData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    timeOfBirth = json['time_of_birth'];
    placeOfBirth = json['place_of_birth'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    atrologyApiInputId = json['atrology_api_input_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    getAtrologyApi = json['get_atrology_api'] != null
        ? GetAtrologyApi.fromJson(json['get_atrology_api'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['time_of_birth'] = timeOfBirth;
    data['place_of_birth'] = placeOfBirth;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['atrology_api_input_id'] = atrologyApiInputId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    if (getAtrologyApi != null) {
      data['get_atrology_api'] = getAtrologyApi!.toJson();
    }
    return data;
  }
}

class GetAtrologyApi {
  int? id;
  int? day;
  int? month;
  int? year;
  int? hour;
  int? min;
  String? lat;
  String? long;
  num? timeZone;
  String? lagnaSvg;
  String? moonSvg;
  String? sunSvg;
  String? navamanshaSvg;
  String? createdAt;
  String? updatedAt;

  GetAtrologyApi(
      {this.id,
        this.day,
        this.month,
        this.year,
        this.hour,
        this.min,
        this.lat,
        this.long,
        this.timeZone,
        this.lagnaSvg,
        this.moonSvg,
        this.sunSvg,
        this.navamanshaSvg,
        this.createdAt,
        this.updatedAt});

  GetAtrologyApi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    month = json['month'];
    year = json['year'];
    hour = json['hour'];
    min = json['min'];
    lat = json['lat'];
    long = json['long'];
    timeZone = json['time_zone'];
    lagnaSvg = json['lagna_svg'];
    moonSvg = json['moon_svg'];
    sunSvg = json['sun_svg'];
    navamanshaSvg = json['navamansha_svg'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['day'] = day;
    data['month'] = month;
    data['year'] = year;
    data['hour'] = hour;
    data['min'] = min;
    data['lat'] = lat;
    data['long'] = long;
    data['time_zone'] = timeZone;
    data['lagna_svg'] = lagnaSvg;
    data['moon_svg'] = moonSvg;
    data['sun_svg'] = sunSvg;
    data['navamansha_svg'] = navamanshaSvg;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}