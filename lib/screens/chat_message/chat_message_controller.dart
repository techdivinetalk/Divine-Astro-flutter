import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
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
    listenSocket();
    if (Get.arguments != null) {
      args = Get.arguments;
      getAssistantChatList();
      broadcastReceiver.start();
      broadcastReceiver.messages.listen((broadCastEvent) {
        if (broadCastEvent.name == 'chatAssist') {
          var responseMsg = broadCastEvent.data?['msg'];
          print("responseMsg ${args!.id}");
          if (responseMsg["sender_id"].toString() == args!.id.toString()) {
            print("responseMsg id match");
            chatMessageList.add(AssistChatData(
                message: responseMsg["message"],
                astrologerId: args!.id,
                createdAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ")
                    .format(DateTime.now()),
                id: DateTime.now().millisecondsSinceEpoch,
                isSuspicious: 0,
                msgType: responseMsg['msg_type'] != null
                    ? msgTypeValues.map[responseMsg["msg_type"]]
                    : MsgType.text,
                seenStatus: SeenStatus.delivered,
                customerId: int.parse(responseMsg["sender_id"] ?? 0)));

          }
        }
      });
      //to check if the list has enough number of elements to scroll
      // messageScrollController.hasClients ? null : getAssistantChatList();
      //

      messageScrollController.addListener(() {
        final topPosition = messageScrollController.position.minScrollExtent;
        if (messageScrollController.position.pixels == topPosition) {
          //code to fetch old messages
          getAssistantChatList();
        }
      });
      // getAssistantChatList();
      scrollToBottomFunc();
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      scrollToBottomFunc();
    });
  }

  void listenSocket() {
    appSocket.listenForAssistantChatMessage((chatData) {
      print("data from chatAssist message $chatData");
      final newChatData = AssistChatData.fromJson(chatData);
      final updateAtIndex = chatMessageList
          .indexWhere((oldChatData) => oldChatData.id == newChatData.id);
      if (updateAtIndex == -1) {
        chatMessageList.add(newChatData);
      } else {
        chatMessageList[updateAtIndex] = newChatData;
      }
      update();
    });
  }

  scrollToBottomFunc() {
    print("chat Assist Scrolled to bottom");
    messageScrollController.hasClients
        ? messageScrollController.animateTo(
            messageScrollController.position.maxScrollExtent * 2,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut)
        : ();
  }

  reArrangeChatList() {
    //to remove duplicacy of messages
    // chatMessageList(chatMessageList
    //     .groupBy((chat) => chat.createdAt)
    //     .values
    //     .map((group) => group.first)
    //     .toList());

    //
    chatMessageList.sort((a, b) {
      if (a is AssistChatData && b is AssistChatData) {
        return a.createdAt?.compareTo(b.createdAt ?? '0') ?? 1;
      }
      return 0;
    });
    update();
  }

  getAssistantChatList() async {
    try {
      if (processedPages.contains(currentPage.value)) {
        return;
      }
      final response = await chatAssistantRepository.getAstrologerChats(
          {"customer_id": args!.id, "page": currentPage.value});
      if (response.data != null) {
        if (response.data!.chatAssistMsgList?.isNotEmpty == true) {
          chatMessageList.addAll(response.data!.chatAssistMsgList!);
          print("---------------------chatAssistMsgList--------------------");
          print(response.data?.toJson());
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
    reArrangeChatList();
  }

  void sendMsg() {
    if (messageController.text.isNotEmpty) {
      final msgData = AssistChatData(
          message: messageController.text,
          astrologerId: preferenceService.getUserDetail()!.id,
          createdAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ")
              .format(DateTime.now()),
          id: DateTime.now().millisecondsSinceEpoch,
          isSuspicious: 0,
          msgType: MsgType.text,
          sendBy: SendBy.astrologer,
          seenStatus: SeenStatus.notSent,
          // msgStatus: MsgStatus.sent,
          customerId: args?.id);
      appSocket.sendAssistantMessage(
          customerId: args!.id.toString(),
          msgData: msgData,
          message: messageController.text,
          astroId: preferenceService.getUserDetail()!.id.toString());
      // print("socket msg");
      // print(preferenceService.getUserDetail()!.id.toString());
      // print(args!.id.toString());
      chatMessageList.add(msgData);
      scrollToBottomFunc();
      messageController.clear();
    }
  }
}
