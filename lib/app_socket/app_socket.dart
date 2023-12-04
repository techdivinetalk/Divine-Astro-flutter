import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/api_provider.dart';
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

  void socketDisconnect() {
    _socket?.disconnect();
  }
}
