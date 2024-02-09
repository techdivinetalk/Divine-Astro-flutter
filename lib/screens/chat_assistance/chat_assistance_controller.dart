
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_socket/app_socket.dart';
import '../../model/chat_assistant/CustomerDetailsResponse.dart';
import '../../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../../repository/chat_assistant_repository.dart';
import '../../utils/enum.dart';

class ChatAssistanceController extends GetxController {
  final chatAssistantRepository = ChatAssistantRepository();
  ChatAssistantAstrologerListResponse? chatAssistantAstrologerListResponse;
  CustomerDetailsResponse? customerDetailsResponse;
  Loading loading = Loading.initial;
  final appSocket = AppSocket();

  RxBool isSearchEnable = RxBool(false);

  RxBool keyboardActive = false.obs;
  final searchController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();

    getAssistantAstrologerList();
    listenSocket();
  }

  void listenSocket() {
    appSocket.listenForAssistantChatMessage((chatData) {
      print('socket called');
      print("data from chatAssist message $chatData");
    });
  }

  Future<void> getAssistantAstrologerList() async {
    try {
      loading = Loading.loading;
      chatAssistantAstrologerListResponse = await chatAssistantRepository.getChatAssistantAstrologerList();
      loading = Loading.loaded;
    } catch (err) {
      loading = Loading.error;
    }
    update();
  }
Future<void> getConsulation() async {
    try {
      loading = Loading.loading;
      customerDetailsResponse = await chatAssistantRepository.getConsulation();
      loading = Loading.loaded;
    } catch (err) {
      loading = Loading.error;
    }
    update();
  }
}
