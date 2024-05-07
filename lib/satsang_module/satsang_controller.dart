import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';

class SatSangController extends GetxController{

  SharedPreferenceService pref = SharedPreferenceService();

  @override
  void onInit() {
    if(Get.arguments !=null){

    }
    initData();
    super.onInit();
  }

  RxString  userId = "".obs;
  RxString  userName = "".obs;
  String  avatar = "";
  String  liveId = "";

  RxBool  isMod = false.obs;
  RxBool  isHostAvailable = false.obs;
  RxBool  isHost = false.obs;
  String  hostSpeciality = "";


  RxString awsURL = "".obs;



   initData() async {
    await pref.init();
    userId.value = (pref.getUserDetail()?.id ?? "").toString();
    userName.value = pref.getUserDetail()?.name ?? "";
    // avatar = _pref.getUserDetail()?.avatar ?? "";
    print(userId.value);
    print(userName.value);
    print("userName.value");
      awsURL.value = pref.getAmazonUrl() ?? "";
    final String image = pref.getUserDetail()?.image ?? "";
    avatar = isValidImageURL(imageURL: "$awsURL/$image");
    isMod.value = false;
    liveId = (Get.arguments ?? "").toString();
    isHost.value = true;
    isHostAvailable.value = true;
update();
  }


  String isValidImageURL({required String imageURL}) {
    if (GetUtils.isURL(imageURL)) {
      return imageURL;
    } else {
      imageURL = "${pref.getAmazonUrl()}$imageURL";
      if (GetUtils.isURL(imageURL)) {
        return imageURL;
      } else {
        return "";
      }
    }
  }
}