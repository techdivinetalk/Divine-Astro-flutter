class CityStateModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final LinkData? data;

  CityStateModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  CityStateModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? LinkData.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'success': success,
        'status_code': statusCode,
        'message': message,
        'data': data?.toJson()
      };
}

class LinkData {
  final String? list;

  LinkData({
    this.list,
  });

  LinkData.fromJson(Map<String, dynamic> json) : list = json['list'] as String?;

  Map<String, dynamic> toJson() => {'list': list};
}

class CityStateData {
  final String? id;
  final String? name;
  final String? cityName;
  final String? stateId;
  final String? countryCode;
  final String? latitude;
  final String? countryName;
  final String? stateCode;
  final String? timeZoneId;
  final String? longitude;
  final String? newCountryCode;

  CityStateData({
    this.id,
    this.name,
    this.stateId,
    this.countryCode,
    this.countryName,
    this.latitude,
    this.stateCode,
    this.longitude,
    this.cityName,
    this.timeZoneId,
    this.newCountryCode,
  });

  CityStateData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        cityName = json['place'] as String?,
        timeZoneId = json['timezone_id'] as String?,
        countryName = json['country_name'] as String?,
        countryCode = json['countryCode'] as String?,
        newCountryCode = json['country_code'] as String?,
        stateCode = json['stateCode'] as String?,
        latitude = json['latitude'] as String?,
        longitude = json['longitude'] as String?,
        stateId = json['state_id'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'place': cityName,
        'timezone_id': timeZoneId,
        'countryCode': countryCode,
        'country_code': newCountryCode,
        'state_id': stateId,
        'stateCode': stateCode,
        'latitude': latitude,
        'longitude': longitude,
      };
}

class NewCityStateModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<CityStateData>? data;

  NewCityStateModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  NewCityStateModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) =>
                CityStateData.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'success': success,
        'status_code': statusCode,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList()
      };
}
