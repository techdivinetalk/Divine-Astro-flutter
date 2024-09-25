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

  //ScrollController scrollController = ScrollController();
  // RxList<DataList> chatDataList = <DataList>[].obs;
  Loading loading = Loading.initial;
  int page = 1;
  int pageUsersData = 1;
  RxList searchData = [].obs;
  RxList filteredUserData = [].obs;
  final appSocket = AppSocket();

  // RxBool isLoadingMore = false.obs;
  // int _currentPage = 1;
  // bool _hasMoreData = true;

  RxBool isSearchEnable = RxBool(false);
  RxBool keyboardActive = false.obs;
  final searchController = TextEditingController();

  bool isInit = false;

  @override
  void onReady() {
    isInit = false;
    super.onReady();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    debugPrint("test_onInit: call");
    isInit = true;

    getAssistantAstrologerList();
    /* scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (_hasMoreData && !isLoadingMore.value) {
          loadMoreData();
        }
      }
    });*/

    update();
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
  //
  // void getUnreadMessage() async {
  //   final localDataList =
  //   // await SharedPreferenceService().getChatAssistUnreadMessage();
  //   /// Check if localDataList is null before accessing isEmpty
  //   if (localDataList == null || localDataList.isEmpty) {
  //     return;
  //   }
  //   print("data present: ");
  //   unreadMessageList.value = localDataList;
  //   update();
  // }

  Future<void> getAssistantAstrologerList() async {
    try {
      if (loading == Loading.loading) return;

      loading = Loading.loading;
      ChatAssistantAstrologerListResponse? response =
          await chatAssistantRepository.getChatAssistantAstrologerList(page);
      if (response.data != null && response.data!.data!.isNotEmpty) {
        if (page != 1 &&
            chatAssistantAstrologerListResponse != null &&
            chatAssistantAstrologerListResponse!.data!.data!.isNotEmpty) {
          chatAssistantAstrologerListResponse!.data!.data!
              .addAll(response.data!.data!);
        } else {
          chatAssistantAstrologerListResponse = response;
        }
        page++;
      }
      loading = Loading.loaded;
    } catch (err) {
      loading = Loading.error;
    }
    update();
  }

  /*Future<void> getAssistantAstrologerList() async {
    try {
      if (_currentPage == 1) {
        loading = Loading.loading;
        update();
      }
      chatAssistantAstrologerListResponse = await chatAssistantRepository.getChatAssistantAstrologerList();
      loading = Loading.loaded;
      if (chatAssistantAstrologerListResponse != null &&
          chatAssistantAstrologerListResponse!.data != null) {
        if (_currentPage == 1) {
          chatDataList.assignAll(chatAssistantAstrologerListResponse!.data!.data!);
          loading = Loading.loaded;
        } else {
          chatDataList.addAll(chatAssistantAstrologerListResponse!.data!.data!);
        }

        _hasMoreData =
            chatAssistantAstrologerListResponse!.data!.data!.isNotEmpty;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
            loadMoreData();
          }
        });
      } else {
        loading = Loading.error;
      }
    } catch (err) {
      loading = Loading.error;
    }
    update();
  }*/

  // Future<void> getConsulation() async {
  //   try {
  //     if (loading == Loading.loading) return;
  //     loading = Loading.loading;
  //     CustomerDetailsResponse response =
  //         await chatAssistantRepository.getConsulation(pageUsersData);
  //     if (response.data.isNotEmpty) {
  //       if (pageUsersData != 1 &&
  //           customerDetailsResponse != null &&
  //           customerDetailsResponse!.data.isNotEmpty) {
  //         customerDetailsResponse!.data.addAll(response.data);
  //       } else {
  //         customerDetailsResponse = response;
  //       }
  //       pageUsersData++;
  //     }
  //     loading = Loading.loaded;
  //   } catch (err) {
  //     loading = Loading.error;
  //   }
  //   update();
  // }
  var checkin = false.obs;
  var emptyRes = false.obs;
  RxBool isLoadMoreData = false.obs;
  RxBool userDataLoading = false.obs;
  ScrollController scrollCon = ScrollController();
  Future<void> getConsulation() async {
    if (pageUsersData == 1) {
      userDataLoading.value = true;
    }
    CustomerDetailsResponse response =
        await chatAssistantRepository.getConsulation(pageUsersData);

    if (emptyRes.value == false) {
      if (response.data.isNotEmpty) {
        if (pageUsersData != 1 &&
            customerDetailsResponse != null &&
            customerDetailsResponse!.data.isNotEmpty) {
          customerDetailsResponse!.data.addAll(response.data);
          checkin(false);
        } else {
          customerDetailsResponse = response;
          if (pageUsersData == 1) {
            userDataLoading.value = false;
          }
        }
        pageUsersData++;
      } else {
        // Fluttertoast.showToast(msg: "No more data");
        print("data ---- ${response.data.toString()}");
        emptyRes(true);
      }
      isLoadMoreData.value = false;
    } else {
      isLoadMoreData.value = false;
      print("There is no more data in user data");
    }
    update();
  }

  /* Future<void> loadMoreData() async {
    try {
      isLoadingMore.value = true;
      _currentPage++;
      await getAssistantAstrologerList();
    } catch (error) {
      // Handle error
    } finally {
      isLoadingMore.value = false;
    }
  }*/
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
      for (var userDetail
          in customerDetailsResponse?.data ?? <ConsultationData>[]) {
        if (userDetail.customerName
            .toLowerCase()
            .contains(value.toLowerCase())) {
          filteredUserData.add(userDetail);
        }
      }
    }
    update();
  }
}
