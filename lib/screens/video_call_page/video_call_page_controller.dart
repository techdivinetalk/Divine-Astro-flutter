import 'package:divine_astrologer/model/chat/req_common_chat_model.dart';
import 'package:divine_astrologer/model/chat/res_astro_chat_listener.dart';
import 'package:divine_astrologer/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/routes.dart';

class VideoCallPageController extends GetxController {
  RxBool muteValue = false.obs, videoValue = false.obs;
  String name = 'Vimal Gosain';
  String gender = "Male";
  String dob = "16-April-1998";
  String pob = "New Delhi, New Delhi, Delhi, India";
  String tob = "9:30 PM";
  String maritalStatus = "Single";
  String problemArea = "Love and Relationship";
  String featureText = "wants to do video call with you!";
  bool isForChat = false;
  ResAstroChatListener? data;
  RxString btnTitle = "Accept".obs;
  RxBool isWaiting = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ResAstroChatListener) {
      isForChat = true;
      data = Get.arguments;
      name = data!.customeName ?? "";
      gender = data!.astroName ?? "";
      dob = data!.astroName ?? "";
      pob = data!.astroName ?? "";
      tob = data!.astroName ?? "";
      maritalStatus = data!.astroName ?? "";
      problemArea = data!.astroName ?? "";
      isWaiting.value = data!.status == 1 ? true : false;
      btnTitle.value =
          data!.status == 1 ? "Waiting for user to connect ..." : "Accept";
      featureText = "wants to chat with you!";
    }
  }

  onAccept() async {
    if (isForChat) {
// *accept_or_reject: 1 = accept, 3 = chat reject by timeout
// * is_timeout: should be 1 when reject by timeout
      var response = await ChatRepository().chatAccept(ReqCommonChatParams(
        acceptOrReject: 1,
        isTimeout: 0,
        orderId: data!.orderId,
        queueId: data!.queueId,
      ).toJson());
      if (response.statusCode == 200) {
        isWaiting.value = true;
        btnTitle.value = "Waiting for user to connect ...";
      } else {
        Get.back();
      }

      // Get.back();
    } else {
      Get.toNamed(RouteName.videoCall);
    }
  }
}
