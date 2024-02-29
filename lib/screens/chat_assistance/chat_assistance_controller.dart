
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_socket/app_socket.dart';
import '../../di/shared_preference_service.dart';
import '../../model/chat_assistant/CustomerDetailsResponse.dart';
import '../../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../../repository/chat_assistant_repository.dart';
import '../../utils/enum.dart';

class ChatAssistanceController extends GetxController {
  final chatAssistantRepository = ChatAssistantRepository();
  ChatAssistantAstrologerListResponse? chatAssistantAstrologerListResponse;
  CustomerDetailsResponse? customerDetailsResponse;
  Loading loading = Loading.initial;
  RxList <AssistChatData> unreadMessageList = <AssistChatData>[].obs;
  RxList searchData = [].obs;
  RxList filteredUserData = [].obs;
  final appSocket = AppSocket();

  RxBool isSearchEnable = RxBool(false);

  RxBool keyboardActive = false.obs;
  final searchController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();

    getAssistantAstrologerList();
    getUnreadMessage();
    // listenSocket();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getUnreadMessage();
  }



  // void listenSocket() {
  //   appSocket.listenForAssistantChatMessage((chatData) {
  //     print('socket called');
  //     print("data from chatAssist message $chatData");
  //   });
  // }

 /* void getUnreadMessage() async {
    final localDataList =
    await SharedPreferenceService().getChatAssistUnreadMessage();
    if (localDataList.isEmpty) {
      return;
    }
    print("data present: ");
    unreadMessageList.value = localDataList;
    update();
  }*/

  void getUnreadMessage() async {
    final localDataList =
    await SharedPreferenceService().getChatAssistUnreadMessage();
    /// Check if localDataList is null before accessing isEmpty
    if (localDataList == null || localDataList.isEmpty) {
      return;
    }
    print("data present: ");
    unreadMessageList.value = localDataList;
    update();
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
  void searchCall(String value) {
    searchData.clear();
    filteredUserData.clear();

    if (value.isEmpty) {
      return;
    }
    if (chatAssistantAstrologerListResponse != null ||
        chatAssistantAstrologerListResponse!.data != null ||
        chatAssistantAstrologerListResponse!.data!.data!.isNotEmpty) {
      for (var userDetail in chatAssistantAstrologerListResponse!.data!.data!) {

        if (userDetail.name!.toLowerCase().contains(value.toLowerCase())) {
          searchData.add(userDetail);
        }
      }
      for (var userDetail in customerDetailsResponse?.data??<ConsultationData>[]) {
        if (userDetail.customerName.toLowerCase().contains(value.toLowerCase())) {
          filteredUserData.add(userDetail);
        }
      }
    }
    update();
  }

}
