import 'package:dio/dio.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/constants.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/model/master_data_response.dart';
import 'package:divine_astrologer/pages/home/home_controller.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../firebase_service/firebase_service.dart';

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
    print("socket is successfully connected");
    // if (socket!.disconnected) {
    //   socket
    //     ?..disconnect()
    //     ..connect();
    // }
    socket?.onConnect(
      (_) async {
        await socketAPI();
      },
    );
    socket?.onReconnect(
      (_) async {
        await socketAPI();
      },
    );
    // // call socket master-Data
    // debugPrint("test_socket: call master-Data");
    //
    // socket?.emit(ApiProvider().masterDataSocket, {});
    // debugPrint("test_socket: called emit");
    //
    // socket?.on(
    //   ApiProvider().masterDataSocket,
    //   (data) {
    //     if (data != null) {
    //       // if(!kDebugMode){
    //       String jsonResponse = data.toString();
    //       debugPrint("test_socket: $jsonResponse");
    //
    //       MasterDataResponse response = MasterDataResponse.fromJson(data);
    //
    //       if (response.data != null) {
    //         saveMasterData(response.data!);
    //       }
    //       // }
    //     }
    //   },
    // );
    // debugPrint("test_socket: called on");
  }

  saveMasterData(MasterData masterData) {
    isCall(int.parse(masterData.call.toString()));
    isCamera(int.parse(masterData.camera.toString()));
    isChat(int.parse(masterData.chat.toString()));
    isChatAssistance(int.parse(masterData.chatAssistance.toString()));
    isGifts(int.parse(masterData.gifts.toString()));
    isRemidies(int.parse(masterData.remidies.toString()));
    isEcom(int.parse(masterData.ecom.toString()));
    isLiveCall(int.parse(masterData.isLiveCall.toString()));
    isKundli(int.parse(masterData.kundli.toString()));
    isLive(int.parse(masterData.live.toString()));
    isQueue(int.parse(masterData.queue.toString()));
    // isRemidies(int.parse(masterData.tarrotCard.toString()));
    isTemplates(int.parse(masterData.templates.toString()));
    // isTruecaller(int.parse(masterData.truecaller.toString()));
    isVOIP(int.parse(masterData.voip.toString()));

    debugPrint("test_masterData.voip: ${masterData.voip}");
  }

  void emitForAstrologerEnterChatAssist(String? customerId, String? userId) {
    socket?.emit(ApiProvider().enterChatAssist,
        {"receiver_id": customerId, "sender_id": userId});
  }

  void listenForAstrologerEnterChatAssist(void Function(dynamic) callback) {
    print("called inside socket");
    socket?.on(ApiProvider().enterChatAssist, callback);
    print("called outside socket");
  }

  void emitForStartAstroCustChatAssist(
      String? astroId, String? userId, int userType) {
    socket?.emit(ApiProvider().startAstroCustChatAssist,
        {"astroId": astroId, "userId": userId, "userType": userType});
  }

  void userLeftCustChatAssist(String? astroId, String? userId) {
    socket?.emit(ApiProvider().astrologerLeftChatAssist,
        {"astroId": astroId, "userId": userId});
  }

  void userLeftListenChatAssist(void Function(dynamic) callback) {
    socket?.on(ApiProvider().astrologerLeftChatAssist, callback);
  }

  void leavePrivateChatEmit(String? astroId, String? userId, String userType) {
    print("leavePrivateChat");
    socket?.emit(ApiProvider().leavePrivateChat, {
      "astroId": astroId,
      "userId": userId,
      "userType": userType,
      "orderId": AppFirebaseService().orderData.value["orderId"].toString()
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

  Future<void> socketAPI() async {
    try {
      final SharedPreferenceService pref = Get.put(SharedPreferenceService());
      await pref.getUserDetail();
      print({
        "astroId": pref.getUserDetail()?.id ?? 0,
        "clientId": socket?.id ?? "",
      });
      print("objectobjectobjectobject");
      if (pref.getUserDetail() != null) {
        debugPrint("test_socket_id: ${socket?.id}");

        final response = await Dio().post(
          "http://4.240.97.131:8081/api/v3/removeLiveData",
          data: {
            "astroId": pref.getUserDetail()?.id ?? 0,
            "clientId": socket?.id ?? "",
          },
        );
        print("socketAPI(): ${response.data}");
      }
    } on Exception catch (error, stack) {
      debugPrint("socketAPI(): Exception caught: error: $error");
      debugPrint("socketAPI(): Exception caught: stack: $stack");
    }
    return Future<void>.value();
  }

  // void isAstroJoinedChat(void Function(dynamic) callback) {
  //   socket?.on(ApiProvider().astrologerJoinedPrivateChat, callback);
  // }

  void socketDisconnect() {
    socket?.disconnect();
  }

  void listenUserJoinedSocket(void Function(dynamic) callback) {
    socket?.on(ApiProvider().startAstroCustChatAssist, callback);
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
    debugPrint('newMessage.toOfflineJson() ${newMessage.toJson()}');
    socket?.emit(ApiProvider().sendMessage, newMessage.toJson());
  }

  void sendMessageSocketListenerSocket(void Function(dynamic) callback) {
    socket?.on(ApiProvider().sendMessage, callback);
  }

  void sendMessageListenerSocket(void Function(dynamic) callback) {
    socket?.on(ApiProvider().messageSent, callback);
  }

  void astrologerJoinedPrivateChat(void Function(dynamic) callback) {
    socket?.on(ApiProvider().astrologerJoinedPrivateChat, callback);
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

  void leavePrivateChat(void Function(dynamic) callback) {
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
      ApiProvider().chatAssistMessageSent,
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
