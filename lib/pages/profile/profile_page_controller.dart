import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/getStorage/get_storage.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_key.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/constant_details_model_class.dart';
import 'package:divine_astrologer/model/res_reply_review.dart';
import 'package:divine_astrologer/pages/profile/profile_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../common/custom_widgets.dart';
import '../../di/shared_preference_service.dart';
import '../../gen/assets.gen.dart';
import '../../model/res_login.dart';
import '../../model/res_review_ratings.dart';
import '../../model/res_user_profile.dart';
import '../../repository/user_repository.dart';
import '../../screens/dashboard/dashboard_controller.dart';
import '../../screens/live_page/constant.dart';
import '../home/home_controller.dart';

class ProfilePageController extends GetxController {
  final UserRepository userRepository;

  ProfilePageController(this.userRepository);

  UserData? userData;
  GetUserProfile? userProfile;
  RxString userProfileImage = "".obs;
  ResReviewRatings? ratingsData;
  ResReviewReply? reviewReply;
  var preference = Get.find<SharedPreferenceService>();

  // var dashboardController = Get.find<DashboardController>();
  RxBool profileDataSync = false.obs;
  RxBool reviewDataSync = false.obs;
  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;
  RxBool isLoading = false.obs;

  List<List<String>> reportReason = <List<String>>[
    ["itSpam", ''],
    ["hateSpeechSymbols", ''],
    ["violenceOrganisations", ''],
    ["falseInformation", ''],
    ["scamFraud", ''],
    ["bullyingHarassment", ''],
  ];

  var languageList = <ChangeLanguageModelClass>[
    ChangeLanguageModelClass(
        'English',
        'Eng',
        appColors.textColor,
        (GetStorages.get(GetStorageKeys.language) ?? "en_US") == "en_US"
            ? true
            : false),
    ChangeLanguageModelClass(
        'Hindi',
        'हिन्दी',
        appColors.teal,
        (GetStorages.get(GetStorageKeys.language) ?? "en_US") == "hi_IN"
            ? true
            : false),
    ChangeLanguageModelClass(
        'Marathi',
        'मराठी',
        appColors.appRedColour,
        (GetStorages.get(GetStorageKeys.language) ?? "en_US") == "mr_IN"
            ? true
            : false),
    ChangeLanguageModelClass(
        'Gujarati',
        'ગુજરાતી',
        appColors.appRedColour,
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
      ProfileOptionModelClass("Remedies",
          Assets.images.remedies.svg(width: 30.h, height: 30.h), ''),
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
    ProfileOptionModelClass(
        "Pooja", Assets.images.pooja.svg(width: 30.h, height: 30.h), ''),
    // ProfileOptionModelClass("Add Remedies",
    //     Assets.images.remedies.svg(width: 30.h, height: 30.h), ''),
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

  String? baseAmazonUrl;

  @override
  void onInit() {
    super.onInit();
    userData = preference.getUserDetail();
    baseAmazonUrl = preference.getBaseImageURL();
    userProfileImage.value = "$baseAmazonUrl/${userData?.image}";
    print(userProfileImage.value);
    print("userProfileImage.value");
    getConstantDetailsData();
    getUserProfileDetails();
    getReviewRating();
  }

  void setUserData(UserData? value) {
    userData = value;
    update();
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
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  getReviewRating() async {
    try {
      Map<String, dynamic> params = {"role_id": userData?.roleId, "page": 1};
      var response = await userRepository.getReviewRatings(params);
      ratingsData = response;
      update();
      log("Data==>${jsonEncode(ratingsData!.data)}");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    reviewDataSync.value = true;
  }

  void reportReviews(
    String reportComment,
    reviewID,
  ) async {
    Map<String, dynamic> param = {
      "review_id": reviewID,
      "comment": reportComment
    };

    final response = await UserRepository().reportUserReviews(param);
    if (response.statusCode == 200) {
      // Get.back();
      showCupertinoModalPopup(
        barrierColor: appColors.darkBlue.withOpacity(0.5),
        context: Get.context!,
        builder: (context) => ThankYouReportUI(
          onPressed: () {
            Get.back();
          },
        ),
      );
    } else {
      Get.back();
      divineSnackBar(data: "${response.message}", color: appColors.redColor);
    }
  }

  Future<void> getReplyOnReview(
      {required String textMsg, required int reviewId}) async {
    try {
      // Set loading state to true
      isLoading.value = true;

      Map<String, dynamic> params = {
        "review_id": reviewId,
        "comment": textMsg,
        "role_id": userData?.roleId ?? 7
      };

      var response = await userRepository.reviewReply(params);
      // reviewReply = response;
      print(jsonEncode(response));
      print("responseresponseresponseresponseresponse");
      getReviewRating();
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    } finally {
      // Set loading state to false regardless of success or failure
      isLoading.value = false;

      // Update the value
      reviewDataSync.value = true;
    }
  }

//Update profile image

  updateProfileImage() {
    showCupertinoModalPopup(
      context: Get.context!,
      barrierColor: appColors.darkBlue.withOpacity(0.5),
      builder: (BuildContext context) {
        return Material(
          color: appColors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: appColors.white, width: 1.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                      color: appColors.white.withOpacity(0.1)),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.r)),
                  color: appColors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    CustomText(
                      'chooseOptions'.tr,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      'shareOptions'.tr,
                      fontSize: 16.sp,
                      fontColor: appColors.grey,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          onTap: () async {
                            Get.back();
                            await getImage(true);
                          },
                          child: Column(
                            children: [
                              Assets.svg.camera.svg(),
                              SizedBox(height: 8.h),
                              CustomText(
                                "camera".tr,
                                fontSize: 16.sp,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 64.w),
                        CustomButton(
                          onTap: () async {
                            Get.back();
                            await getImage(false);
                          },
                          child: Column(
                            children: [
                              Assets.svg.gallery.svg(),
                              SizedBox(height: 8.h),
                              CustomText(
                                "gallery".tr,
                                fontSize: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(bool isCamera) async {
    pickedFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 250,
    );

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
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Update image',
          toolbarColor: appColors.white,
          toolbarWidgetColor: appColors.blackColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
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
        // uploadImageToS3Bucket(File(result.path));
        uploadImage(File(result.path));
      }
    } else {
      debugPrint("Image is not cropped.");
    }
  }

  uploadImageToS3Bucket(File? selectedFile) async {
    var commonConstants = await userRepository.constantDetailsData();
    var dataString = commonConstants.data!.awsCredentails.baseurl?.split(".");
    var extension = p.extension(selectedFile!.path);

    var response = await AwsS3.uploadFile(
      accessKey: commonConstants.data!.awsCredentails.accesskey!,
      secretKey: commonConstants.data!.awsCredentails.secretKey!,
      file: selectedFile,
      bucket: dataString![0].split("//")[1],
      destDir: 'astrologer/${userData?.id}',
      filename: '${DateTime.now().millisecondsSinceEpoch.toString()}$extension',
      region: dataString[2],
    );
    if (response != null) {
      // dashboardController.userProfileImage.value = response;
      userImage(response ?? '');
      userProfileImage.value = response;
      userData?.image = response;
      preference.setUserDetail(userData!);
      update();
      divineSnackBar(data: "Profile image update successfully");
    } else {
      CustomException("Something went wrong");
    }
  }

  Future<void> uploadImage(File imageFile) async {
    var token = preferenceService.getToken();
    // Create a Uri from the URL string
    var uri = Uri.parse(
        "https://wakanda-api.divinetalk.live/api/astro/v7/uploadAstroImage");

    // Create a MultipartRequest
    var request = http.MultipartRequest('POST', uri);

    // Add headers to the request
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'profile_image',
      imageFile.path,
    ));

    var response = await request.send();

    // Listen for the response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value); // Handle the response from the server
      print(
          "valuevaluevaluevaluevaluevaluevalue"); // Handle the response from the server
    });

    if (response.statusCode == 200) {
      print("Image uploaded successfully.");
    } else {
      print("Failed to upload image.");
    }
  }

  ConstantDetailsModelClass? getConstantDetails;

  getConstantDetailsData() async {
    try {
      var data = await userRepository.constantDetailsData();
      getConstantDetails = data;
      preferenceService.setConstantDetails(data);

      profileDataSync.value = true;
      //    getDashboardDetail();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  whatsapp() async {
    var contact = getConstantDetails?.data?.whatsappNo ?? '';
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      divineSnackBar(data: 'WhatsApp is not installed.');
      log('WhatsApp is not installed.');
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
