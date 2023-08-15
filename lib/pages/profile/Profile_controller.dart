// ignore_for_file: file_names

import 'package:divine_astrologer/common/getStorage/get_storage.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../di/shared_preference_service.dart';
import '../../gen/assets.gen.dart';
import '../../model/res_login.dart';
import '../../model/res_review_ratings.dart';
import '../../model/res_user_profile.dart';
import '../../repository/user_repository.dart';

class ProfilePageController extends GetxController {
  // ProfilePageController(this.userRepository);
  final UserRepository userRepository = Get.put(UserRepository());
  UserData? userData;
  GetUserProfile? userProfile;
  var preference = Get.find<SharedPreferenceService>();
  RxBool profileDataSync = false.obs;

  var languageList = <ChangeLanguageModelClass>[
    ChangeLanguageModelClass(
        'English',
        'Eng',
        AppColors.appYellowColour,
        (GetStorages.get(GetStorageKeys.language) ?? "en_US") == "en_US"
            ? true
            : false),
    ChangeLanguageModelClass(
        'Hindi',
        'हिन्दी',
        AppColors.teal,
        (GetStorages.get(GetStorageKeys.language) ?? "en_US") == "hi_IN"
            ? true
            : false),
    ChangeLanguageModelClass(
        'Marathi',
        'मराठी',
        AppColors.pink,
        (GetStorages.get(GetStorageKeys.language) ?? "en_US") == "mr_IN"
            ? true
            : false),
    ChangeLanguageModelClass(
        'Gujarati',
        'ગુજરાતી',
        AppColors.pink,
        (GetStorages.get(GetStorageKeys.language) ?? "en_US") == "gu_IN"
            ? true
            : false),
  ].obs;

  init() {
    profileList = <ProfileOptionModelClass>[
      ProfileOptionModelClass(
          "bankDetails".tr,
          Assets.images.icBankDetailNew.svg(width: 30.h, height: 30.h),
          '/bankDetailsUI'),
      ProfileOptionModelClass("uploadStory".tr,
          Assets.images.icUploadStory.svg(width: 30.h, height: 30.h), ''),
      ProfileOptionModelClass("uploadYourPhoto".tr,
          Assets.images.icUploadPhoto.svg(width: 30.h, height: 30.h), ''),
      ProfileOptionModelClass("customerSupport".tr,
          Assets.images.icSupportTeam.svg(width: 30.h, height: 30.h), ''),
      ProfileOptionModelClass(
          "chooseLanguage".tr,
          Assets.images.icLanguages.svg(width: 30.h, height: 30.h),
          '/languagePopup'),
      ProfileOptionModelClass(
          "F&Q", Assets.images.icFaqImg.svg(width: 30.h, height: 30.h), ''),
      ProfileOptionModelClass(
          "priceChange".tr,
          Assets.images.icPriceChangeNew.svg(width: 30.h, height: 30.h),
          '/priceHistoryUI'),
      ProfileOptionModelClass(
          "numberChange".tr,
          Assets.images.icNumChanges.svg(width: 30.h, height: 30.h),
          '/numberChangeReqUI'),
      ProfileOptionModelClass(
          "blockedUsers".tr,
          Assets.images.icBlockUserNew.svg(width: 30.h, height: 30.h),
          '/blockedUser'),
    ].obs;
  }

  ChangeLanguageModelClass? selectedLanguage;
  var profileList = <ProfileOptionModelClass>[
    ProfileOptionModelClass(
        "bankDetails".tr,
        Assets.images.icBankDetailNew.svg(width: 30.h, height: 30.h),
        '/bankDetailsUI'),
    ProfileOptionModelClass("uploadStory".tr,
        Assets.images.icUploadStory.svg(width: 30.h, height: 30.h), ''),
    ProfileOptionModelClass("uploadYourPhoto".tr,
        Assets.images.icUploadPhoto.svg(width: 30.h, height: 30.h), ''),
    ProfileOptionModelClass("customerSupport".tr,
        Assets.images.icSupportTeam.svg(width: 30.h, height: 30.h), ''),
    ProfileOptionModelClass(
        "chooseLanguage".tr,
        Assets.images.icLanguages.svg(width: 30.h, height: 30.h),
        '/languagePopup'),
    ProfileOptionModelClass(
        "F&Q", Assets.images.icFaqImg.svg(width: 30.h, height: 30.h), ''),
    ProfileOptionModelClass(
        "priceChange".tr,
        Assets.images.icPriceChangeNew.svg(width: 30.h, height: 30.h),
        '/priceHistoryUI'),
    ProfileOptionModelClass(
        "numberChange".tr,
        Assets.images.icNumChanges.svg(width: 30.h, height: 30.h),
        '/numberChangeReqUI'),
    ProfileOptionModelClass(
        "blockedUsers".tr,
        Assets.images.icBlockUserNew.svg(width: 30.h, height: 30.h),
        '/blockedUser'),
  ].obs;

  selectedLanguageData(ChangeLanguageModelClass item) {
    List.generate(
        languageList.length, (index) => languageList[index].isSelected = false);

    item.isSelected = true;
    selectedLanguage = item;

    update(['set_language']);
  }

  getSelectedLanguage() {
    if (selectedLanguage != null) {
      if (selectedLanguage!.languagesMain == "English") {
        Get.updateLocale(const Locale('en', 'US'));
        GetStorages.set(GetStorageKeys.language, 'en_US');
        init();
      } else if (selectedLanguage!.languagesMain == "Hindi") {
        Get.updateLocale(const Locale('hi', 'IN'));
        GetStorages.set(GetStorageKeys.language, "hi_IN");
        init();
      } else if (selectedLanguage!.languagesMain == "Marathi") {
        Get.updateLocale(const Locale('mr', 'IN'));
        GetStorages.set(GetStorageKeys.language, "mr_IN");
        init();
      } else if (selectedLanguage!.languagesMain == "Gujarati") {
        Get.updateLocale(const Locale('gu', 'IN'));
        // AppTranslations.locale = const Locale('gu', 'IN');
        GetStorages.set(GetStorageKeys.language, "gu_IN");
        init();
      }
    } else {
      Get.back();
    }
    update(['set_lang', 'profile_option']);
  }

  @override
  void onInit() {
    super.onInit();
    userData = preference.getUserDetail();
    // getUserProfileDetails();
    // getReviewRating();
  }

  getUserProfileDetails() async {
    Map<String, dynamic> params = {"role_id": userData?.roleId};
    try {
      var data = await userRepository.getProfileDetail(params);
      userProfile = data;
      debugPrint("Data $data");
      profileDataSync.value = true;
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

  getReviewRating() async {
    try {
      Map<String, dynamic> params = {"role_id": 7, "page": 1};
      ResReviewRatings data = await userRepository.getReviewRatings(params);
      debugPrint("Data $data");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }
}

class ProfileOptionModelClass {
  String? name;
  Widget? widget;
  String? nav;

  ProfileOptionModelClass(this.name, this.widget, this.nav);
}

class ChangeLanguageModelClass {
  String? languagesMain, languages;
  Color? colors;
  bool isSelected;

  ChangeLanguageModelClass(
      this.languagesMain, this.languages, this.colors, this.isSelected);
}
