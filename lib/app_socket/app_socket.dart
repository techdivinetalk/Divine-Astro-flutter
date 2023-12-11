import 'dart:developer';

import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class AppSocket {
  static final AppSocket _singleton = AppSocket._internal();
  Socket? _socket;

  factory AppSocket() {
    return _singleton;
  }

  AppSocket._internal();

  void socketConnect() {
    debugPrint('socketConnect ');
    _socket =
        io(ApiProvider.socketUrl, OptionBuilder().enableAutoConnect().setTransports(['websocket']).build());
    _socket!.connect();
    if(_socket!.disconnected){
      _socket?..disconnect()..connect();
    }
    _socket?.onConnect((_) {
      log('Socket connected successfully');
    });
  }

  void updateChatCallSocketEvent({required String chat, required String call, required String video}) {
    debugPrint(
        'data ${preferenceService.getUserDetail()!.id.toString()} chat: $chat "call": $call,"video": $video');
    debugPrint('enter updateChatCallSocketEvent');
    _socket?.emit(ApiProvider().joinRoomSocket, {
      "userId": preferenceService.getUserDetail()!.id.toString(),
      "userType": 'astrologer',
      "chat": chat,
      "call": call,
      "video": video
    });
  }

  void startAstroCustumerSocketEvent({required String orderId, required userId}) {
    debugPrint('enter startAstroCustPrivateChat');
    _socket?.emit(ApiProvider().startAstroCustPrivateChat, {
      "userId": userId,
      "astroId": preferenceService.getUserDetail()!.id.toString(),
      "userType": 'astrologer',
      "orderId": orderId
    });
  }

  void isAstroJoinedChat(void Function(dynamic) callback) {
    _socket?.on(ApiProvider().astrologerJoinedPrivateChat, callback);
  }

  void socketDisconnect() {
    _socket?.disconnect();
  }

  void isCustomerJoinedChat(void Function(dynamic) callback) {
    _socket?.on(ApiProvider().userJoinedPrivateChat, callback);
  }

  void typingSocket({required String orderId, required userId}) {
    _socket?.emit(ApiProvider().userTyping,
        {"typist": preferenceService.getUserDetail()!.id.toString(), "listener": userId, "orderId": orderId});
  }

  void typingListenerSocket(void Function(dynamic) callback) {
    _socket?.on(ApiProvider().userTyping, callback);
  }

  void sendMessageSocket(ChatMessage newMessage) {
    debugPrint('newMessage.toOfflineJson() ${newMessage.toOfflineJson()}');
    _socket?.emit(ApiProvider().sendMessage, newMessage.toOfflineJson());
  }

  void sendMessageSocketListenerSocket(void Function(dynamic) callback) {
    _socket?.on(ApiProvider().sendMessage, callback);
  }

  void sendMessageListenerSocket(void Function(dynamic) callback) {
    _socket?.on(ApiProvider().messageSent, callback);
  }
}
