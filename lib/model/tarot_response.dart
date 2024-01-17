import 'dart:convert';

TarotResponse tarotResponseFromJson(String str) =>
    TarotResponse.fromJson(json.decode(str));

String tarotResponseToJson(TarotResponse data) =>
    json.encode(data.toJson());

class TarotResponse {
  List<TarotCard>? data;

  TarotResponse({this.data});

  TarotResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TarotCard>[];
      json['data'].forEach((v) {
        data!.add(new TarotCard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TarotCard {
  int? id;
  String? name;
  int? status;
  String? image;

  TarotCard({this.id, this.name, this.status, this.image});

  TarotCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['image'] = this.image;
    return data;
  }
}
