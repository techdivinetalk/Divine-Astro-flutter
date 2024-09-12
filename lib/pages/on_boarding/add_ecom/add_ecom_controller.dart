import 'dart:io';
import 'dart:math';

import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/app_exception.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../common/common_image_view.dart';
import '../../../common/routes.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../model/categories_list.dart';
import '../../../repository/user_repository.dart';
import '../../../screens/add_puja/model/puja_product_categories_model.dart';
import '../../../screens/puja/model/pooja_listing_model.dart';

class FileUtils {
  static String getfilesizestring({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 bytes";
    const suffixes = [" bytes", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  static bool isFileSizeValid({required int bytes, int maxSizeInMB = 2}) {
    double sizeInMB = bytes / (1024 * 1024);
    print("image size ------ ${sizeInMB.toString()}");

    return sizeInMB <= maxSizeInMB;
  }
}

class AddEcomController extends GetxController {
  UserRepository userRepository = UserRepository();
  var dropDownItems = ['Puja', "Product"].obs;

  TextEditingController nameC = TextEditingController();
  TextEditingController detailC = TextEditingController();
  TextEditingController pricC = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<PujaProductCategoriesData> tagType = [];
  List<PujaProductCategoriesData> selectedTag = [];
  List<PujaProductCategoriesData> categoriesType = [];
  List<PujaProductCategoriesData> pujaNamesList = [];
  PujaProductCategoriesData? selectedPujaName;
  PujaProductCategoriesData? selectedCategory;

  PujaListingData? pujaListingData;

  var isEdit = false.obs;
  var id = 0.obs;
  RxString selectedValue = "Puja".obs;

  var selected;
  selectedDropDown(value) {
    selected = value;
    selectedImage = null;
    update();
  }

  @override
  void onInit() {
    getCategoriesData();
    getPujaNamesData();
    getTag();

    super.onInit();
  }

  var selectedImage;
  RxList<CategoriesData> tags = <CategoriesData>[].obs;
  List<CategoriesData> options = <CategoriesData>[].obs;

  RxList<int> tagIndexes = <int>[].obs;
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

  /// Get Image Picker method
  Future getImage(bool isCamera) async {
    pickedFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 250,
    );

    if (pickedFile != null) {
      image = File(pickedFile!.path);

      await compressImages(image);
    }
  }

  /// Crop aimge method
  String productImageUrl = "";
  String productApiPath = "";

  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;

  compressImages(croppedFile) async {
    int oversizedCount = 0;

    uploadFile = File(croppedFile.path);
    final filePath = uploadFile!.absolute.path;
    final lastIndex = filePath
        .lastIndexOf(RegExp(r'\.(png|jpg|jpeg|heic)', caseSensitive: false));

    if (lastIndex != -1) {
      final splitted = filePath.substring(0, lastIndex);
      final extension = filePath.substring(lastIndex).toLowerCase();

      // Ensure the output path ends with .jpg or .jpeg for compression
      String outPath;
      if (extension == '.heic' || extension == '.png') {
        outPath = "${splitted}_out.jpg";
      } else if (extension == '.jpg' || extension == '.jpeg') {
        outPath = "${splitted}_out$extension";
      } else {
        Fluttertoast.showToast(msg: "Unsupported file format.");
        return;
      }

      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 500,
      );

      if (result != null) {
        int imageSize =
            await File(result.path).length(); // Get the image size in bytes

        if (!FileUtils.isFileSizeValid(bytes: imageSize, maxSizeInMB: 5)) {
          oversizedCount++;
          // Fluttertoast.showToast(msg: "Image Size is more than 2 MB");
          Fluttertoast.showToast(msg: "Image Size should be less then 5 MB");
        } else {
          selectedImage = result.path;
          update();
        }

        // if (oversizedCount > 0) {
        //   Fluttertoast.showToast(
        //       msg: "$oversizedCount images exceed 2 MB and cannot be uploaded");
        // }
      } else {
        debugPrint("Failed to compress the image.");
      }
    } else {
      Fluttertoast.showToast(
          msg: "The file path does not contain a valid extension.");
    }
    update();
  }

  // https://uat-divine-partner.divinetalk.live/api/astro/v7/addProductByAstrologer
  // [log] body: {"prod_cat_id":9,"prod_name":"dfdfd","prod_image":"images/pooja/September2024/mPv2AeKQGTdIQ6hCOIefwLAtIcGHe8m8bOLY9u7L.jpg","prod_desc":"fdf","product_price_inr":"232323","product_long_desc":"fdf"}

  getTag() async {
    Map<String, dynamic> param = {};
    try {
      final response = await userRepository.getTagProductAndPooja(param);
      if (response.data != null) {
        tagType = response.data!;
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  getCategoriesData({String? type}) async {
    categoriesType.clear();
    for (int i = 0; i < tagType.length; i++) {
      tagType[i].isSelected = false;
    }
    selectedTag.clear();

    selectedCategory = null;

    update();

    Map<String, dynamic> param = {
      "type": type ?? "pooja",
    };

    try {
      final response = await userRepository.getCategoriesProductAndPooja(param);
      if (response.data != null) {
        categoriesType = response.data!;

        print(categoriesType);
        print("categoriesTypecategoriesTypecategoriesType");
      }
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  bool validation() {
    // if (poojaDes.text.length < 100) {
    //   Fluttertoast.showToast(
    //       msg: "Puja description must be more than 100 character.");
    //   return false;
    // }

    if (selectedCategory == null || selectedCategory?.id == null) {
      Fluttertoast.showToast(msg: "Please select category");
      return false;
    } else if (selectedTag.isEmpty) {
      Fluttertoast.showToast(msg: "Please select tag");
      return false;
    }

    return true;
  }

  getPujaNamesData() async {
    try {
      final response = await userRepository.getPoojaNamesApi({});
      if (response.data != null) {
        pujaNamesList = response.data!;
        print(pujaNamesList.length);
        print("pujaNamesList.length");
      }
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  bool loading = false;

  /// add puja or edit api function
  bool isPujaLoading = false;

  void addEditPoojaApi() async {
    isPujaLoading = true;
    update();
    List tagList = [];
    for (int i = 0; i < selectedTag.length; i++) {
      tagList.add(selectedTag[i].id.toString());
    }
    Map<String, dynamic> param = {
      "pooja_name": nameC.text,
      "pooja_img": productImageUrl,
      "pooja_desc": detailC.text,
      "pooja_name_id": selectedPujaName != null && selectedPujaName!.id != null
          ? selectedPujaName!.id
          : "",
      "pooja_starting_price_inr": pricC.text,
      "pooja_short_desc": detailC.text,
      "pooja_category_id": selectedCategory?.id,
      "tag": tagList,
      "pooja_banner_image": "https://example.com/pooja_banner_image.jpg",
      "in_onboarding": 1,
    };
    param.addIf(id.value != 0, "pooja_id", id.value);
    try {
      final response = await userRepository.addEditPujaApi(param);
      if (response.data != null) {
        isPujaLoading = false;
        update();
        submitStage6("2", param);

        // Get.toNamed(
        //   RouteName.scheduleTraining1,
        // );
        uploadeddddd("Puja");
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  void addEditProduct() async {
    isPujaLoading = false;
    // update();
    Map<String, dynamic> param = {
      "prod_cat_id": selectedCategory?.id,
      "prod_name": nameC.text,
      "prod_image": productImageUrl,
      "prod_desc": detailC.text,
      "product_price_inr": pricC.text,
      //"offer_price_inr": poojaPrice.text,
      //"product_price_usd": 10.0,
      "product_long_desc": detailC.text,
      // "product_banner_image": "https://example.com/banner_image.jpg",
      "in_onboarding": 1,
    };
    param.addIf(id.value != 0, "product_id", id.value);
    try {
      final response = await userRepository.addEditProductApi(param);
      if (response.data != null) {
        isPujaLoading = false;
        update();
        print("-------------------${param}");
        submitStage6("1", param);
        uploadeddddd("Product");
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  submitStage6(from, param) async {
    update();
    var body = param;
    body.addAll({
      "page": 6,
    });
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        Get.toNamed(
          RouteName.scheduleTraining1,
        );
        update();
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  submitStage62() async {
    update();
    var body = {
      "prod_cat_id": "",
      "prod_name": "",
      "prod_image": "",
      "prod_desc": "",
      "product_price_inr": "",
      "product_long_desc": "",
      "in_onboarding": 1,
      "page": 6,
    };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        Get.offNamed(
          RouteName.scheduleTraining1,
        );
        update();
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  void showExitAppDialog() {
    Get.defaultDialog(
      title: 'Close App?',
      titleStyle: TextStyle(
        fontSize: 20,
        fontFamily: FontFamily.metropolis,
        fontWeight: FontWeight.w600,
        color: appColors.appRedColour,
      ),
      titlePadding: EdgeInsets.only(top: 20, bottom: 5),
      middleText:
          'You\'re just a few steps away from getting started with divinetalk.',
      middleTextStyle: TextStyle(
        fontSize: 14,
        fontFamily: FontFamily.poppins,
        fontWeight: FontWeight.w400,
        color: appColors.black.withOpacity(0.8),
      ),
      backgroundColor: appColors.white,
      radius: 10,
      barrierDismissible: true, // Can tap outside to close the dialog
      actions: [
        TextButton(
          onPressed: () {
            // Handle exit action
            exit(0);
          },
          child: Text(
            'Exit App',
            style: TextStyle(
              fontSize: 16,
              fontFamily: FontFamily.metropolis,
              fontWeight: FontWeight.w600,
              color: appColors.darkBlue,
            ),
          ),
          style: TextButton.styleFrom(
            side: BorderSide(color: appColors.darkBlue),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle continue action
            Get.back(); // Close dialog
            // Add any other functionality you need
          },
          child: Text(
            'Continue',
            style: TextStyle(
              fontSize: 16,
              fontFamily: FontFamily.metropolis,
              fontWeight: FontWeight.w600,
              color: appColors.white,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: appColors.appRedColour,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  uploadeddddd(selected) {
    showCupertinoModalPopup(
      context: Get.context!,
      barrierColor: appColors.darkBlue.withOpacity(0.5),
      builder: (BuildContext context) {
        return Material(
          color: appColors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                    SizedBox(height: 10.h),
                    CommonImageView(
                      imagePath: "assets/images/done.png",
                      height: 50,
                      width: 50,
                      placeHolder: Assets.images.defaultProfile.path,
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      '$selected Submitted'.tr,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      'We will review your product details to begin showcasing on your profile for purchase.'
                          .tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontColor: appColors.grey,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: appColors.red,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Okay",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                              color: AppColors().white,
                            ),
                          ),
                        ),
                      ),
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
}
