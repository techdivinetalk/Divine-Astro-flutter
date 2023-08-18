import 'dart:convert';

HoroChart horoChartFromJson(String str) => HoroChart.fromJson(json.decode(str));

String horoChartToJson(HoroChart data) => json.encode(data.toJson());

class HoroChart {
  String? svg;

  HoroChart({this.svg});

  factory HoroChart.fromJson(Map<String, dynamic> json) => HoroChart(svg: json["svg"]);

  Map<String, dynamic> toJson() => {"svg": svg};
}
