
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
  ConversionRate? conversionRate;
  RepurchaseRate? repurchaseRate;
  OnlineHours? onlineHours;
  LiveHours? liveHours;
  Ecom? ecom;
  BusyHours? busyHours;
  Overall? overall;

  Data({
    this.todaysAvailiblity,
    this.last30DaysAvailiblity,
    this.conversionRate,
    this.repurchaseRate,
    this.onlineHours,
    this.liveHours,
    this.ecom,
    this.busyHours,
    this.overall,
  });

  Data.fromJson(Map<String, dynamic> json) {
    todaysAvailiblity = json['todays_availiblity'] != null
        ? TodaysAvailiblity.fromJson(json['todays_availiblity'])
        : null;
    last30DaysAvailiblity = json['last_30_days_availiblity'] != null
        ? Last30DaysAvailiblity.fromJson(json['last_30_days_availiblity'])
        : null;
    conversionRate = json['conversion_rate'] != null
        ? ConversionRate.fromJson(json['conversion_rate'])
        : null;
    repurchaseRate = json['repurchase_rate'] != null
        ? RepurchaseRate.fromJson(json['repurchase_rate'])
        : null;
    onlineHours = json['online_hours'] != null
        ? OnlineHours.fromJson(json['online_hours'])
        : null;
    liveHours = json['live_hrs'] != null
        ? LiveHours.fromJson(json['live_hrs'])
        : null;
    ecom = json['ecom'] != null ? Ecom.fromJson(json['ecom']) : null;
    busyHours = json['busy_hrs'] != null
        ? BusyHours.fromJson(json['busy_hrs'])
        : null;
    overall =
    json['overall'] != null ? Overall.fromJson(json['overall']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todaysAvailiblity != null) {
      data['todays_availiblity'] = this.todaysAvailiblity!.toJson();
    }
    if (this.last30DaysAvailiblity != null) {
      data['last_30_days_availiblity'] = this.last30DaysAvailiblity!.toJson();
    }
    if (this.conversionRate != null) {
      data['conversion_rate'] = this.conversionRate!.toJson();
    }
    if (this.repurchaseRate != null) {
      data['repurchase_rate'] = this.repurchaseRate!.toJson();
    }
    if (this.onlineHours != null) {
      data['online_hours'] = this.onlineHours!.toJson();
    }
    if (this.liveHours != null) {
      data['live_hrs'] = this.liveHours!.toJson();
    }
    if (this.ecom != null) {
      data['ecom'] = this.ecom!.toJson();
    }
    if (this.busyHours != null) {
      data['busy_hrs'] = this.busyHours!.toJson();
    }
    if (this.overall != null) {
      data['overall'] = this.overall!.toJson();
    }
    return data;
  }
}

class ConversionRate {
  String? label;
  List<RankDetail>? rankDetail;
  Performance? performance;

  ConversionRate({this.label, this.rankDetail, this.performance});

  ConversionRate.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['rank_detail'] != null) {
      rankDetail = [];
      json['rank_detail'].forEach((v) {
        rankDetail!.add(RankDetail.fromJson(v));
      });
    }
    performance = json['performance'] != null
        ? Performance.fromJson(json['performance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.rankDetail != null) {
      data['rank_detail'] = this.rankDetail!.map((v) => v.toJson()).toList();
    }
    if (this.performance != null) {
      data['performance'] = this.performance!.toJson();
    }
    return data;
  }
}

class RepurchaseRate {
  String? label;
  List<RankDetail>? rankDetail;
  Performance? performance;

  RepurchaseRate({this.label, this.rankDetail, this.performance});

  RepurchaseRate.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['rank_detail'] != null) {
      rankDetail = [];
      json['rank_detail'].forEach((v) {
        rankDetail!.add(RankDetail.fromJson(v));
      });
    }
    performance = json['performance'] != null
        ? Performance.fromJson(json['performance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.rankDetail != null) {
      data['rank_detail'] = this.rankDetail!.map((v) => v.toJson()).toList();
    }
    if (this.performance != null) {
      data['performance'] = this.performance!.toJson();
    }
    return data;
  }
}

class OnlineHours {
  String? label;
  List<RankDetail>? rankDetail;
  Performance? performance;

  OnlineHours({this.label, this.rankDetail, this.performance});

  OnlineHours.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['rank_detail'] != null) {
      rankDetail = [];
      json['rank_detail'].forEach((v) {
        rankDetail!.add(RankDetail.fromJson(v));
      });
    }
    performance = json['performance'] != null
        ? Performance.fromJson(json['performance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.rankDetail != null) {
      data['rank_detail'] = this.rankDetail!.map((v) => v.toJson()).toList();
    }
    if (this.performance != null) {
      data['performance'] = this.performance!.toJson();
    }
    return data;
  }
}

class LiveHours {
  String? label;
  List<RankDetail>? rankDetail;
  Performance? performance;

  LiveHours({this.label, this.rankDetail, this.performance});

  LiveHours.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['rank_detail'] != null) {
      rankDetail = [];
      json['rank_detail'].forEach((v) {
        rankDetail!.add(RankDetail.fromJson(v));
      });
    }
    performance = json['performance'] != null
        ? Performance.fromJson(json['performance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.rankDetail != null) {
      data['rank_detail'] = this.rankDetail!.map((v) => v.toJson()).toList();
    }
    if (this.performance != null) {
      data['performance'] = this.performance!.toJson();
    }
    return data;
  }
}

class Ecom {
  String? label;
  List<RankDetail>? rankDetail;
  Performance? performance;

  Ecom({this.label, this.rankDetail, this.performance});

  Ecom.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['rank_detail'] != null) {
      rankDetail = [];
      json['rank_detail'].forEach((v) {
        rankDetail!.add(RankDetail.fromJson(v));
      });
    }
    performance = json['performance'] != null
        ? Performance.fromJson(json['performance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.rankDetail != null) {
      data['rank_detail'] = this.rankDetail!.map((v) => v.toJson()).toList();
    }
    if (this.performance != null) {
      data['performance'] = this.performance!.toJson();
    }
    return data;
  }
}

class BusyHours {
  String? label;
  List<RankDetail>? rankDetail;
  Performance? performance;

  BusyHours({this.label, this.rankDetail, this.performance});

  BusyHours.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['rank_detail'] != null) {
      rankDetail = [];
      json['rank_detail'].forEach((v) {
        rankDetail!.add(RankDetail.fromJson(v));
      });
    }
    performance = json['performance'] != null
        ? Performance.fromJson(json['performance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.rankDetail != null) {
      data['rank_detail'] = this.rankDetail!.map((v) => v.toJson()).toList();
    }
    if (this.performance != null) {
      data['performance'] = this.performance!.toJson();
    }
    return data;
  }
}

class Overall {
  int? totalMarks;
  int? outOff;
  int? percent;
  List<RankSystem>? rankSystem;
  String? rank;
  String? image;

  Overall({
    this.totalMarks,
    this.outOff,
    this.percent,
    this.rankSystem,
    this.rank,
    this.image,
  });

  Overall.fromJson(Map<String, dynamic> json) {
    totalMarks = json['total_marks'];
    outOff = json['out_off'];
    percent = json['percent'];
    if (json['rank_system'] != null) {
      rankSystem = [];
      json['rank_system'].forEach((v) {
        rankSystem!.add(RankSystem.fromJson(v));
      });
    }
    rank = json['rank'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total_marks'] = totalMarks;
    data['out_off'] = outOff;
    data['percent'] = percent;
    if (rankSystem != null) {
      data['rank_system'] = rankSystem!.map((v) => v.toJson()).toList();
    }
    data['rank'] = rank;
    data['image'] = image;
    return data;
  }
}

class RankDetail {
  String? text;
  String? min;
  String? max;
  String? value;

  RankDetail({this.text, this.min, this.max, this.value});

  RankDetail.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    min = json['min'];
    max = json['max'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['min'] = this.min;
    data['max'] = this.max;
    data['value'] = this.value;
    return data;
  }
}

class Performance {
  dynamic marksObtains;
  dynamic totalMarks;
  dynamic result;
  List<Marks>? marks;

  Performance({this.marksObtains, this.totalMarks, this.marks, this.result});

  Performance.fromJson(Map<String, dynamic> json) {
    marksObtains = json['marks_obtains'];
    totalMarks = json['total_marks'];
    result = json['result'];
    if (json['marks'] != null) {
      marks = <Marks>[];
      json['marks'].forEach((v) {
        marks!.add(new Marks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['marks_obtains'] = this.marksObtains;
    data['total_marks'] = this.totalMarks;
    data['result'] = this.result;
    if (this.marks != null) {
      data['marks'] = this.marks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Marks {
  String? min;
  String? max;
  String? value;

  Marks({this.min, this.max, this.value});

  Marks.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min'] = this.min;
    data['max'] = this.max;
    data['value'] = this.value;
    return data;
  }
}

class RankSystem {
  String? text;
  String? min;
  String? max;
  String? value;
  String? image;

  RankSystem({this.text, this.min, this.max, this.value, this.image});

  RankSystem.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    min = json['min'];
    max = json['max'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['min'] = this.min;
    data['max'] = this.max;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

class TodaysAvailiblity {
  dynamic availableChat;
  dynamic availableCall;
  dynamic availableLive;
  dynamic busyChat;
  dynamic busyCall;
  dynamic busyLive;

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
  String? data;
  dynamic availableChat;
  dynamic availableCall;
  dynamic busyChat;
  dynamic busyCall;
  dynamic availableLive;

  Last30DaysAvailiblity(
      { this.data,this.availableChat,
        this.availableCall,
        this.busyChat,
        this.busyCall,
        this.availableLive});

  Last30DaysAvailiblity.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    availableChat = json['available_chat'];
    availableCall = json['available_call'];
    busyChat = json['busy_chat'];
    busyCall = json['busy_call'];
    availableLive = json['available_live'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['available_chat'] = this.availableChat;
    data['available_call'] = this.availableCall;
    data['busy_chat'] = this.busyChat;
    data['busy_call'] = this.busyCall;
    data['available_live'] = this.availableLive;
    return data;
  }
}
