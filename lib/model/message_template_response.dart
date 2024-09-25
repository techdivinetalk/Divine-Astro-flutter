import 'dart:convert';

/*MessageTemplateResponse messageTemplateResponseFromJson(String str) =>
    MessageTemplateResponse.fromJson(json.decode(str));

String messageTemplateResponseToJson(MessageTemplateResponse data) =>
    json.encode(data.toJson());*/

class MessageTemplateResponse {
  List<MessageTemplates>? data;
  bool? success;
  int? statusCode;
  String? message;

  MessageTemplateResponse(
      {this.data, this.success, this.statusCode, this.message});

  MessageTemplateResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MessageTemplates>[];
      json['data'].forEach((v) {
        data!.add(new MessageTemplates.fromJson(v));
      });
    }
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }

  String toPrettyString() => JsonEncoder.withIndent(" " * 4).convert(toJson());
}

class MessageTemplates {
  int? id;
  String? message;
  String? title;
  String? description;
  // dynamic createdAt;
  int? astrologerId;
  int? type;
  bool? isOn;

  MessageTemplates(
      {this.id,
      this.message,
      this.title,
      this.description,
      // this.createdAt,
      this.astrologerId,
      this.type,
       });

  MessageTemplates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    title = json['title'];
    description = json['description'];
    // createdAt = DateTime.parse(json["created_at"]);
    astrologerId = json['astrologer_id'];
    type = json['type'];
     isOn = json['isOn'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['title'] = this.title;
    data['description'] = this.description;
    data['isOn'] = this.isOn;
    // data['created_at'] = this.createdAt;
    //data['astrologer_id'] = this.astrologerId;
    data['type'] = this.type;
     return data;
  }
}
