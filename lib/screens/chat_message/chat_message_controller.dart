import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:divine_astrologer/model/chat/req_common_chat_model.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:divine_astrologer/screens/dashboard/dashboard_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../app_socket/app_socket.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../di/api_provider.dart';
import '../../di/hive_services.dart';
import '../../di/shared_preference_service.dart';
import '../../model/chat/res_astro_chat_listener.dart';
import '../../model/chat/res_common_chat_success.dart';
import '../../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../../model/chat_assistant/chat_assistant_chats_response.dart';
import '../../model/chat_offline_model.dart';
import '../../repository/chat_assistant_repository.dart';
import '../../repository/chat_repository.dart';
import '../../repository/kundli_repository.dart';
import '../../repository/user_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../live_page/constant.dart';

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

  ChatMessageController(KundliRepository put, ChatRepository put2);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      args = Get.arguments;
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
          customerId: preferenceService.getUserDetail()!.id.toString(),
          message: messageController.text,
          astroId: args!.id.toString());

      chatMessageList.add(data(
          message: messageController.text,
          astrologerId: args!.id,
          createdAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ").format(DateTime.now()),
          id: DateTime.now().millisecondsSinceEpoch,
          isSuspicious: 0,
          msgType: 0,
          seenStatus: 0,
          customerId: preferenceService.getUserDetail()!.id));
      messageController.clear();
    }
  }
}