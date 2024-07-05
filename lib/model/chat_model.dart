import 'package:divine_astrologer/model/chat_offline_model.dart';

class ChatHistoryResponse {
  List<ChatMessage>? chatMessages;
  bool? success;
  int? statusCode;
  String? message;

  ChatHistoryResponse({this.chatMessages, this.success, this.statusCode, this.message});

  ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      chatMessages = List<ChatMessage>.from(json['data'].map((message) => ChatMessage.fromOfflineJson(message)));
    }
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chatMessages != null) {
      data['data'] = chatMessages!.map((message) => message.toJson()).toList();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}