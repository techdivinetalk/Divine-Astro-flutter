import 'dart:developer';

import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class AppSocket {
  static final AppSocket _singleton = AppSocket._internal();
  Socket? socket;

  factory AppSocket() {
    return _singleton;
  }

  AppSocket._internal();

  void socketConnect() {
    debugPrint('socketConnect ');
    socket = io(
        ApiProvider.socketUrl,
        OptionBuilder()
            .enableAutoConnect()
            .setTransports(['websocket']).build());
    socket!.connect();
    if (socket!.disconnected) {
      socket
        ?..disconnect()
        ..connect();
    }
    socket?.onConnect((_) {
      Get.put(HomeController());
      //Get.find<HomeController>();
      socket?.emit(ApiProvider().joinRoomSocket, {
        "userId": preferenceService.getUserDetail()!.id.toString(),
        "userType": 'astrologer',
        "chat": Get.find<HomeController>().chatSwitch.value ? "1" : "0",
        "call": Get.find<HomeController>().callSwitch.value ? "1" : "0",
        "video": Get.find<HomeController>().videoSwitch.value ? "1" : "0"
      });
      log('Socket connected successfully');
    });
  }

  void updateChatCallSocketEvent(
      {required String chat, required String call, required String video}) {
    debugPrint(
        'data ${preferenceService.getUserDetail()!.id.toString()} chat: $chat "call": $call,"video": $video');
    debugPrint('enter updateChatCallSocketEvent');
    socket?.emit(ApiProvider().joinRoomSocket, {
      "userId": preferenceService.getUserDetail()!.id.toString(),
      "userType": 'astrologer',
      "chat": chat,
      "call": call,
      "video": video
    });
  }

  void startAstroCustumerSocketEvent(
      {required String orderId, required userId}) {
    debugPrint('enter startAstroCustPrivateChat');
    socket?.emit(ApiProvider().startAstroCustPrivateChat, {
      "userId": userId,
      "astroId": preferenceService.getUserDetail()!.id.toString(),
      "userType": 'astrologer',
      "orderId": orderId
    });
  }

  void isAstroJoinedChat(void Function(dynamic) callback) {
    socket?.on(ApiProvider().astrologerJoinedPrivateChat, callback);
  }

  void socketDisconnect() {
    socket?.disconnect();
  }

  void isCustomerJoinedChat(void Function(dynamic) callback) {
    socket?.on(ApiProvider().userJoinedPrivateChat, callback);
  }

  void typingSocket({required String orderId, required userId}) {
    socket?.emit(ApiProvider().userTyping, {
      "typist": preferenceService.getUserDetail()!.id.toString(),
      "listener": userId,
      "orderId": orderId
    });
  }

  void typingListenerSocket(void Function(dynamic) callback) {
    socket?.on(ApiProvider().userTyping, callback);
  }

  void sendMessageSocket(ChatMessage newMessage) {
    debugPrint('newMessage.toOfflineJson() ${newMessage.toOfflineJson()}');
    socket?.emit(ApiProvider().sendMessage, newMessage.toOfflineJson());
  }

  void sendMessageSocketListenerSocket(void Function(dynamic) callback) {
    socket?.on(ApiProvider().sendMessage, callback);
  }

  void sendMessageListenerSocket(void Function(dynamic) callback) {
    socket?.on(ApiProvider().messageSent, callback);
  }

  void listenerMessageStatusSocket(void Function(dynamic) callback) {
    socket?.on(ApiProvider().msgStatusChanged, callback);
  }

  void messageReceivedStatusUpdate(
      {required String receiverId,
      required String chatMessageId,
      required String chatStatus,
      required String time,
      required String orderId}) {
    debugPrint('messageReceivedStatusUpdate socket called');
    socket?.emit(ApiProvider().changeMsgStatus, {
      'receiverId': receiverId,
      'chatMessageId': chatMessageId,
      'chatStatus': chatStatus,
      'time': time,
      'orderId': orderId
    });
  }

  void userLeavePrivateChat(void Function(dynamic) callback) {
    socket?.on(ApiProvider().leavePrivateChat, callback);
  }

  void customerLeavedPrivateChatListenerSocket(
      void Function(dynamic) callback) {
    socket?.on(ApiProvider().userDisconnected, callback);
  }

  void sendConnectRequest({required String astroId, required String custId}) {
    socket?.emit(ApiProvider().sendConnectRequest,
        {'astroId': astroId, 'custId': custId, 'userType': 'astrologer'});
  }

  void listenForAssistantChatMessage(void Function(dynamic) callback) {
    socket?.on(
      ApiProvider().listenChatAssistMessage,
      (data) {
        callback(data);
      },
    );
    print("socket finished");
  }

  void sendAssistantMessage(
      {required String message,
      required String astroId,
      required AssistChatData msgData,
      required String customerId}) {
    socket?.emit(ApiProvider().sendChatAssistMessage, {
      'userType': 'astrologer',
      'msgData': msgData.toJson(),
      'custId': customerId,
      'astroId': astroId,
      'message': message
    });
  }

  // Added By: divine-dharam
  void joinLive({
    required String userType,
    required int userId,
  }) {
    socket?.emit(
      ApiProvider().joinLive,
      {
        'userType': userType,
        'userId': userId,
      },
    );
    return;
  }
  //
}
