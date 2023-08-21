import 'dart:convert';

BirthDetails birthDetailsFromJson(String str) => BirthDetails.fromJson(json.decode(str));

String birthDetailsToJson(BirthDetails data) => json.encode(data.toJson());

class BirthDetails {
  int? year, month, day, hour, minute, seconds;
  double? latitude, longitude, timezone, ayanamsha;
  String? sunrise, sunset;

  BirthDetails({
    this.year,
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
    this.sunset,
  });

  factory BirthDetails.fromJson(Map<String, dynamic> json) => BirthDetails(
        year: json["year"],
        month: json["month"],
        day: json["day"],
        hour: json["hour"],
        minute: json["minute"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        timezone: json["timezone"]?.toDouble(),
        seconds: json["seconds"],
        ayanamsha: json["ayanamsha"]?.toDouble(),
        sunrise: json["sunrise"],
        sunset: json["sunset"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "month": month,
        "day": day,
        "hour": hour,
        "minute": minute,
        "latitude": latitude,
        "longitude": longitude,
        "timezone": timezone,
        "seconds": seconds,
        "ayanamsha": ayanamsha,
        "sunrise": sunrise,
        "sunset": sunset,
      };
}
