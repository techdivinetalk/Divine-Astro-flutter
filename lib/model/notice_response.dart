import 'dart:convert';

import 'package:intl/intl.dart';

NoticeResponse noticeResponseFromJson(String str) =>
    NoticeResponse.fromJson(json.decode(str));

String noticeResponseToJson(NoticeResponse data) => json.encode(data.toJson());

class NoticeResponse {
  List<NoticeDatum> data;
  bool? success;
  int? statusCode;
  String? message;

  NoticeResponse({
    this.data = const [],
    this.success,
    this.statusCode,
    this.message,
  });

  NoticeResponse copyWith({
    List<NoticeDatum>? data,
    bool? success,
    int? statusCode,
    String? message,
  }) =>
      NoticeResponse(
        data: data ?? this.data,
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory NoticeResponse.fromJson(Map<String, dynamic> json) => NoticeResponse(
        data: List<NoticeDatum>.from(
            json["data"].map((x) => NoticeDatum.fromJson(x))),
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}

class NoticeDatum {
  int? id;
  String? title;
  String? description;
  DateTime? scheduleDate;
  String? scheduleTime;
  int? status;

  NoticeDatum({
    this.id,
    this.title,
    this.description,
    this.scheduleDate,
    this.scheduleTime,
    this.status,
  });

  NoticeDatum copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? scheduleDate,
    String? scheduleTime,
    int? status,
  }) =>
      NoticeDatum(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        scheduleDate: scheduleDate ?? this.scheduleDate,
        scheduleTime: scheduleTime ?? this.scheduleTime,
        status: status ?? this.status,
      );

  factory NoticeDatum.fromJson(Map<String, dynamic> json) => NoticeDatum(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        scheduleDate: DateTime.parse(json["schedule_date"]),
        scheduleTime: json["schedule_time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "schedule_date":
            "${scheduleDate?.year.toString().padLeft(4, '0')}-${scheduleDate?.month.toString().padLeft(2, '0')}-${scheduleDate?.day.toString().padLeft(2, '0')}",
        "schedule_time": scheduleTime,
        "status": status,
      };

  String getTimeAndDate() =>
      "${formatTime(scheduleTime!)} ${formatDateTime(scheduleDate!)}";
}

String formatDateTime(DateTime dateTime, {String format = "dd/MM/yyyy"}) {
  final dateFormat = DateFormat(format);
  String date = dateFormat.format(dateTime);
  return date;
}

String formatTime(String dateTime) {
  final inputFormat = DateFormat('HH:mm:ss');
  final outputFormat = DateFormat('hh:mm a');

  DateTime time = inputFormat.parse(dateTime);
  String formattedTime = outputFormat.format(time);

  return formattedTime;
}
