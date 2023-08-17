import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

import '../../di/shared_preference_service.dart';
import '../../model/res_login.dart';

class EditProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  UserData? userData;
  var tagIndexes = [0].obs;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  RxList<String> tags = <String>[].obs;
  RxInt tag = 0.obs;
  var options = [
    'Tarot',
    'Vedic',
    'Numerology',
    'Prashana',
    'Vastu',
    'Palmistry',
    'Reiki Healing',
    'Counsellor',
    'Face Reading',
    'Counsellor',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    userData = preferenceService.getUserDetail();
    nameController.text = userData?.name ?? "";
    experienceController.text = userData?.experiance.toString() ?? "";
    descriptionController.text =
        parse(userData?.description ?? "").documentElement!.text;
  }
}
