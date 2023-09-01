// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:divine_astrologer/common/zego_services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:divine_astrologer/common/getStorage/get_storage.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_key.dart';
import 'package:divine_astrologer/model/res_reply_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../di/shared_preference_service.dart';
import '../../gen/assets.gen.dart';
import '../../model/res_login.dart';
import '../../model/res_review_ratings.dart';
import '../../model/res_user_profile.dart';
import '../../repository/user_repository.dart';
import '../../screens/dashboard/dashboard_controller.dart';

class ProfilePageController extends GetxController {
  final UserRepository userRepository;
  ProfilePageController(this.userRepository);
  UserData? userData;
  GetUserProfile? userProfile;
  RxString userProfileImage = "".obs;
  ResReviewRatings? ratingsData;
  ResReviewReply? reviewReply;
  var preference = Get.find<SharedPreferenceService>();
  var dashboardController = Get.find<DashboardController>();
  RxBool profileDataSync = false.obs;
  RxBool reviewDataSync = false.obs;
  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;

  List<List<String>> reportReason = <List<String>>[
    ["itSpam"],
    ["hateSpeechSymbols"],
    ["violenceOrganisations"],
    ["falseInformation"],
    ["scamFraud"],
    ["bullyingHarassment"],
  ];

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
    ProfileOptionModelClass(
        "uploadStory".tr,
        Assets.images.icUploadStory.svg(width: 30.h, height: 30.h),
        '/uploadStoryUi'),
    ProfileOptionModelClass(
        "uploadYourPhoto".tr,
        Assets.images.icUploadPhoto.svg(width: 30.h, height: 30.h),
        '/uploadYourPhotosUi'),
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
    userProfileImage.value = "${userData?.image}";
    getUserProfileDetails();
    getReviewRating();
  }

//getPercentage
  double getReviewPercentage(
      {required int ratingNumbers, required double totalReviews}) {
    return ((ratingNumbers) / totalReviews);
  }

//API Calls
  getUserProfileDetails() async {
    Map<String, dynamic> params = {"role_id": userData?.roleId};
    try {
      var data = await userRepository.getProfileDetail(params);
      userProfile = data;

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
      Map<String, dynamic> params = {"role_id": userData?.roleId, "page": 1};
      var response = await userRepository.getReviewRatings(params);
      ratingsData = response;

      log("Data==>${jsonEncode(ratingsData!.data)}");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    reviewDataSync.value = true;
  }

  getReplyOnReview({required String textMsg, required int reviewId}) async {
    try {
      Map<String, dynamic> params = {
        "review_id": reviewId,
        "comment": textMsg,
        "role_id": userData?.roleId ?? 7
      };
      var response = await userRepository.reviewReply(params);
      reviewReply = response;

      getReviewRating();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    reviewDataSync.value = true;
  }

//Update profile image
  updateProfileImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Divine Astrologer"),
          content: const Text("Select media option"),
          actions: [
            TextButton(
              child: const Text("Camera"),
              onPressed: () async {
                Get.back();
                await getImage(true);
              },
            ),
            TextButton(
              child: const Text("Gallery"),
              onPressed: () async {
                Get.back();
                await getImage(false);
              },
            ),
          ],
        );
      },
    );
  }

  Future getImage(bool isCamera) async {
    pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 250);

    if (pickedFile != null) {
      image = File(pickedFile!.path);

      await cropImage();
    }
  }

  cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Update image',
            toolbarColor: AppColors.white,
            toolbarWidgetColor: AppColors.blackColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Update image',
        ),
      ],
    );
    if (croppedFile != null) {
      // final file = File(croppedFile.path);

      uploadFile = File(croppedFile.path);
      final filePath = uploadFile!.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 500,
      );
      if (result != null) {
        uploadImageToS3Bucket(File(result.path));
      }
    } else {
      debugPrint("Image is not cropped.");
    }
  }

  uploadImageToS3Bucket(File? selectedFile) async {
    var commonConstants = await userRepository.constantDetailsData();
    var dataString = commonConstants.data.awsCredentails.baseurl?.split(".");
    var extension = p.extension(selectedFile!.path);

    var response = await AwsS3.uploadFile(
      accessKey: commonConstants.data.awsCredentails.accesskey!,
      secretKey: commonConstants.data.awsCredentails.secretKey!,
      file: selectedFile,
      bucket: dataString![0].split("//")[1],
      destDir: 'astrologer/${userData?.id}',
      filename: '${DateTime.now().millisecondsSinceEpoch.toString()}$extension',
      region: dataString[2],
    );
    if (response != null) {
      dashboardController.userProfileImage.value = response;
      userProfileImage.value = response;
      userData?.image = response;
      preference.setUserDetail(userData!);
      await ZegoServices().initZegoInvitationServices("${userData?.id}", "${userData?.name}");
      Get.snackbar("Profile image update successfully", "",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.white,
          colorText: AppColors.blackColor,
          duration: const Duration(seconds: 3));
      debugPrint("Uploaded Url : $response");
    } else {
      CustomException("Something went wrong");
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
