import 'dart:core';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../di/shared_preference_service.dart';
import '../../../model/chat_assistant/chat_assistant_chats_response.dart';
import '../../../model/chat_offline_model.dart';
import '../../../repository/user_repository.dart';

enum ProductType { call, chat, videoCall }

class ChatSupportController extends GetxController {
  ChatSupportController(this.userRepository);

  final UserRepository userRepository;

  late TextEditingController textEditingController;
  late TextEditingController ratingTextController;
  var isReview = false.obs; // Observable boolean
  var rating = 0.0.obs; // Observable double
  final RxBool loading = false.obs;
  RxList<Map<String, Object>> chatMessageList = [
    {
      "createdAt": DateTime.now().toIso8601String(),
      "message": "How can i help you?",
      "id": DateTime.now().millisecondsSinceEpoch,
      "sendBy": SendBy.customer,
      "msgType": MsgType.text,
      "seenStatus": SeenStatus.notSent,
      "customerId": "84389483984"
    }
  ].obs;
  final SharedPreferenceService pref = Get.put(SharedPreferenceService());
  ProductType engageType = ProductType.chat;
  // final createdAt = DateTime.now().millisecondsSinceEpoch.toString();
  var ratedData;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    textEditingController = TextEditingController();
    ratingTextController = TextEditingController();
  }

  sendMessage() {
    Map<String, Object> chatData = {
      "createdAt": DateTime.now().toIso8601String(),
      "message": textEditingController.text,
      "id": DateTime.now().millisecondsSinceEpoch,
      "sendBy": SendBy.astrologer,
      "msgType": MsgType.text,
      "seenStatus": SeenStatus.notSent,
      "customerId": pref.getUserDetail()!.id.toString()
    };
    chatMessageList.add(chatData);
    update();
  }

  void toggleSwitch() {
    isReview.value = !isReview.value;
    update();
  }

  void updateRating(data) {
    rating.value = data;
    update();
  }

  void submitRating() {
    ratedData = {
      "rating": rating.value,
      "description": ratingTextController.text,
      "username": "Paras shah",
    };
    log(ratedData.toString());
    textEditingController.clear();
    update();
  }
}
