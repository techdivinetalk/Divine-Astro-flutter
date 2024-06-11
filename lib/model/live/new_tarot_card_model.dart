import 'package:divine_astrologer/model/live/deck_card_model.dart';

class NewTarotCardModel {
  List<DeckCardModel>? data;
  bool? success;
  int? statusCode;
  String? message;

  NewTarotCardModel({this.data, this.success, this.statusCode, this.message});

  NewTarotCardModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DeckCardModel>[];
      json['data'].forEach((v) {
        data!.add(new DeckCardModel.fromJson(v));
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
}
