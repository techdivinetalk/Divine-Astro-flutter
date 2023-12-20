import "package:divine_astrologer/di/shared_preference_service.dart";
import 'package:divine_astrologer/model/refer_astrologer/refer_astrologer_request.dart';
import 'package:divine_astrologer/model/refer_astrologer/refer_astrologer_response.dart';
import 'package:divine_astrologer/repository/refer_astrologer_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

enum WorkingForPlatform { yes, no }

class ReferAstrologerController extends GetxController {
  final ReferAstrologerRepository repository;
  final ReferAstrologerState state = ReferAstrologerState();

  ReferAstrologerController(this.repository);

  bool get isYes => state.isYes;

  bool get isNo => state.isNo;

  GlobalKey<FormState> get formState => state.formKey;
  RxBool formValidateVal = true.obs;

  void workingForPlatForm({required WorkingForPlatform value}) {
    state.platform = value;
    update();
  }

  void submitForm() async {
    if (formState.currentState!.validate()) {
      formValidateVal.value = true;
      formState.currentState!.save();
      ReferAstrologerResponse response = await repository
          .referAstrologer(state.referAstrologerRequestString());
      if (response.status!.code == 200) {
        Get.back();
      }
      if (response.status!.code == 400) {
        Fluttertoast.showToast(msg: response.status!.message.toString());
      }
    } else {
      formValidateVal.value = false;
    }
  }

  checkFormValidation() {
    if (formState.currentState!.validate()) {
      formValidateVal.value = true;
    } else {
      formValidateVal.value = false;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    state.init();
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}

class ReferAstrologerState {
  WorkingForPlatform platform = WorkingForPlatform.no;
  late final GlobalKey<FormState> formKey;

  SharedPreferenceService pref = SharedPreferenceService();

  bool get isYes => platform == WorkingForPlatform.yes;

  bool get isNo => platform == WorkingForPlatform.no;

  late final TextEditingController astrologerName;
  late final TextEditingController mobileNumber;
  late final TextEditingController astrologySkills;
  late final TextEditingController astrologerExperience;
  late final TextEditingController otherPlatform;

  void init() {
    formKey = GlobalKey<FormState>();
    astrologerName = TextEditingController();
    mobileNumber = TextEditingController();
    astrologySkills = TextEditingController();
    astrologerExperience = TextEditingController();
    otherPlatform = TextEditingController();
  }

  void dispose() {
    astrologerName.dispose();
    mobileNumber.dispose();
    astrologySkills.dispose();
    astrologerExperience.dispose();
    otherPlatform.dispose();
  }

  ReferAstrologerRequest referAstrologerRequest() {
    return ReferAstrologerRequest(
      firstName: astrologerName.text.trim(),
      email: "",
      contactNumber: mobileNumber.text.trim(),
      segment: astrologySkills.text.trim(),
      notes: "came from ${otherPlatform.text.trim()}",
      experience: astrologerExperience.text.trim(),
      referBy: pref.getUserDetail()?.id,
    );
  }

  String referAstrologerRequestString() {
    return referAstrologerRequest().toPrettyJson();
  }
}
