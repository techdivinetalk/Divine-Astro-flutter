
import 'dart:convert';

PerformanceResponse performanceResponseFromJson(String str) =>
    PerformanceResponse.fromJson(json.decode(str));

String performanceResponseToJson(PerformanceResponse data) =>
    json.encode(data.toJson());

class PerformanceResponse {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  PerformanceResponse({this.data, this.success, this.statusCode, this.message});

  PerformanceResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  TodaysAvailiblity? todaysAvailiblity;
  Last30DaysAvailiblity? last30DaysAvailiblity;

  Data({this.todaysAvailiblity, this.last30DaysAvailiblity});

  Data.fromJson(Map<String, dynamic> json) {
    todaysAvailiblity = json['todays_availiblity'] != null
        ? new TodaysAvailiblity.fromJson(json['todays_availiblity'])
        : null;
    last30DaysAvailiblity = json['last_30_days_availiblity'] != null
        ? new Last30DaysAvailiblity.fromJson(json['last_30_days_availiblity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todaysAvailiblity != null) {
      data['todays_availiblity'] = this.todaysAvailiblity!.toJson();
    }
    if (this.last30DaysAvailiblity != null) {
      data['last_30_days_availiblity'] = this.last30DaysAvailiblity!.toJson();
    }
    return data;
  }
}

class TodaysAvailiblity {
  dynamic? availableChat;
  dynamic? availableCall;
  dynamic? availableLive;
  dynamic? busyChat;
  dynamic? busyCall;
  dynamic? busyLive;

  TodaysAvailiblity(
      {this.availableChat,
        this.availableCall,
        this.availableLive,
        this.busyChat,
        this.busyCall,
        this.busyLive});

  TodaysAvailiblity.fromJson(Map<String, dynamic> json) {
    availableChat = json['available_chat'];
    availableCall = json['available_call'];
    availableLive = json['available_live'];
    busyChat = json['busy_chat'];
    busyCall = json['busy_call'];
    busyLive = json['busy_live'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available_chat'] = this.availableChat;
    data['available_call'] = this.availableCall;
    data['available_live'] = this.availableLive;
    data['busy_chat'] = this.busyChat;
    data['busy_call'] = this.busyCall;
    data['busy_live'] = this.busyLive;
    return data;
  }
}

class Last30DaysAvailiblity {
  dynamic? availableChat;
  dynamic? availableCall;
  dynamic? busyChat;
  dynamic? busyCall;
  dynamic? availableLive;

  Last30DaysAvailiblity(
      {this.availableChat,
        this.availableCall,
        this.busyChat,
        this.busyCall,
        this.availableLive});

  Last30DaysAvailiblity.fromJson(Map<String, dynamic> json) {
    availableChat = json['available_chat'];
    availableCall = json['available_call'];
    busyChat = json['busy_chat'];
    busyCall = json['busy_call'];
    availableLive = json['available_live'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available_chat'] = this.availableChat;
    data['available_call'] = this.availableCall;
    data['busy_chat'] = this.busyChat;
    data['busy_call'] = this.busyCall;
    data['available_live'] = this.availableLive;
    return data;
  }
}
