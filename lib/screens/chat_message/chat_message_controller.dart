import 'dart:async';
import 'package:divine_astrologer/di/shared_preference_service.dart';
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
  RxList<AssistChatData> unreadMessageList = <AssistChatData>[].obs;
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
          print("data 1 ${chatMessageList.length}");
          if (responseMsg["sender_id"].toString() == args?.id.toString()) {
            chatMessageList.add(AssistChatData(
                message: responseMsg['message'],
                astrologerId: args!.id,
                createdAt: DateTime.parse(responseMsg['created_at'])
                    .millisecondsSinceEpoch
                    .toString(),
                id: DateTime.now().millisecondsSinceEpoch,
                isSuspicious: 0,
                sendBy: SendBy.customer,
                msgType: responseMsg['msg_type'] != null
                    ? msgTypeValues.map[responseMsg['msg_type']]
                    : MsgType.text,
                seenStatus: SeenStatus.received,
                customerId: int.parse(responseMsg['sender_id'] ?? 0)));
            update();
            print(
                'added msg in datast######################## ${chatMessageList.length}');
          }
          scrollToBottomFunc();
          reArrangeChatList();
        }
      });
      //to check if the list has enough number of elements to scroll
      // messageScrollController.hasClients ? null : getAssistantChatList();
      //
      getUnreadMessage();
      messageScrollController.addListener(() {
        final topPosition = messageScrollController.position.minScrollExtent;
        if (messageScrollController.position.pixels == topPosition) {
          //code to fetch old messages
          getAssistantChatList();
        }
      });

      messageScrollController.addListener(() {
        final bottomPosition = messageScrollController.position.maxScrollExtent;
        if (messageScrollController.position.pixels == bottomPosition) {
          //code to fetch old messages
          updateUnreadMessageList();
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
    getUnreadMessage();
  }

  void getUnreadMessage() async {
    final localDataList =
        await SharedPreferenceService().getChatAssistUnreadMessage();
    print("data present: ");
    unreadMessageList.value = localDataList;
    update();
  }

  removeMyUnreadMessages() {
    for (int index = 0; index < unreadMessageList.length; index++) {
      if (unreadMessageList[index].customerId == args?.id) {
        unreadMessageList.removeAt(index);
      }
    }
    update();
  }

  updateUnreadMessageList() async {
    removeMyUnreadMessages();

    await SharedPreferenceService()
        .updateChatAssistUnreadMessage(unreadMessageList);
    update();
  }

  void listenSocket() {
    appSocket.listenForAssistantChatMessage((chatData) {
      print("data from chatAssist message $chatData");
      final newChatData = AssistChatData.fromJson(chatData['msgData']);
      print(
          "new message update in chatassist listen scoket ${newChatData.toJson()}");
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
          createdAt: DateTime.now().toIso8601String(),
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
      print("adding data ${msgData.toJson()}");
      chatMessageList.add(msgData
        ..createdAt = DateTime.parse(msgData.createdAt??'')
            .millisecondsSinceEpoch
            .toString());
      scrollToBottomFunc();
      messageController.clear();
    }
  }
}
