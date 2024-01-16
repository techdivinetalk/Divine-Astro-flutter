import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app_socket/app_socket.dart';
import '../../common/common_functions.dart';
import '../../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../../model/chat_assistant/chat_assistant_chats_response.dart';
import '../../repository/chat_assistant_repository.dart';
import '../../repository/chat_repository.dart';
import '../../repository/kundli_repository.dart';
class ChatMessageController extends GetxController {
  final chatAssistantRepository = ChatAssistantRepository();
  final messageScrollController = ScrollController();
  ChatAssistChatResponse? chatAssistChatResponse;
  RxList chatMessageList = [].obs;
  RxInt currentPage = 1.obs;
  Set<int> processedPages = {};
  final messageController = TextEditingController();
  RxBool isEmojiShowing = false.obs;
  DataList? args;
  final appSocket = AppSocket();
  BroadcastReceiver broadcastReceiver =
  BroadcastReceiver(names: <String>["chatAssist"]);
  ChatMessageController(KundliRepository put, ChatRepository put2);
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      args = Get.arguments;
      broadcastReceiver.start();
      broadcastReceiver.messages.listen((broadCastEvent) {
        if (broadCastEvent.name == 'chatAssist'){
          var responseMsg = broadCastEvent.data?['msg'];
          print("responseMsg ${args!.id}");
          if(responseMsg["sender_id"].toString() ==  args!.id.toString()) {
            print("responseMsg id match");
            chatMessageList.add(data(
                message: responseMsg["message"],
                astrologerId: args!.id,
                createdAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ").format(DateTime.now()),
                id: DateTime.now().millisecondsSinceEpoch,
                isSuspicious: 0,
                msgType: 1,
                seenStatus: 0,
                customerId: int.parse(responseMsg["sender_id"] ?? 0)));
          }
        }
      });
      getAssistantChatList();
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      scrollToBottomFunc();
    });
  }

  scrollToBottomFunc() {
    messageScrollController.hasClients
        ? messageScrollController.animateTo(messageScrollController.position.maxScrollExtent * 2,
        duration: const Duration(milliseconds: 600), curve: Curves.easeOut)
        : ();
  }

  getAssistantChatList() async {
    try {
      if (processedPages.contains(currentPage.value)) {
        return;
      }
      final response =
      await chatAssistantRepository.getAstrologerChats({"customer_id": args!.id, "page": currentPage.value});
      if (response.data != null) {
        if (response.data!.chatDataList?.isNotEmpty == true) {
          chatMessageList.addAll(response.data!.chatDataList!);
          if (response.data!.nextPageUrl != null) {
            currentPage++;
          } else {
            processedPages.add(currentPage.value);
          }
        } else {
          processedPages.add(currentPage.value);
        }
      }
    } catch (e, s) {
      debugPrint("Error fetching chat messages: $e $s");
    }
  }

  void sendMsg() {
    if (messageController.text.isNotEmpty) {
      appSocket.sendAssistantMessage(
          customerId: args!.id.toString() ,
          message: messageController.text,
          astroId: preferenceService.getUserDetail()!.id.toString());
      print("socket msg");
      print(preferenceService.getUserDetail()!.id.toString());
      print(args!.id.toString());
      chatMessageList.add(data(
          message: messageController.text,
          astrologerId: args!.id,
          createdAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ").format(DateTime.now()),
          id: DateTime.now().millisecondsSinceEpoch,
          isSuspicious: 0,
          msgType: 1,
          seenStatus: 0,
          customerId: preferenceService.getUserDetail()!.id));
      messageController.clear();
    }
  }
}