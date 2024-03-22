import 'dart:convert';
import 'dart:io';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/add_puja/model/puja_product_categories_model.dart';
import 'package:divine_astrologer/screens/puja/model/pooja_listing_model.dart';
import 'package:divine_astrologer/screens/puja/widget/pooja_submited_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddPujaController extends GetxController {
  TextEditingController poojaName = TextEditingController();
  TextEditingController poojaDes = TextEditingController();
  TextEditingController poojaPrice = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var durationOptions = ['Puja', "Product"].obs;
  RxString selectedValue = "Puja".obs;
  List<PujaProductCategoriesData> selectedTag = [];
  PujaProductCategoriesData? selectedPujaName;
  PujaProductCategoriesData? selectedCategory;
  List<PujaProductCategoriesData> categoriesType = [];
  List<PujaProductCategoriesData> pujaNamesList = [];
  List<PujaProductCategoriesData> tagType = [];

  PujaListingData? pujaListingData;

  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;

  var isEdit = false.obs;
  var id = 0.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      isEdit(Get.arguments?['edit'] ?? false);
      if (isEdit.value) {
        pujaListingData = Get.arguments?['pujaData'];
        poojaName.text = pujaListingData!.poojaName ?? "";
        poojaDes.text = pujaListingData!.poojaDesc ?? "";
        poojaImageUrl = pujaListingData!.poojaImg ?? "";
        poojaPrice.text = "${pujaListingData!.poojaStartingPriceInr ?? 0}";
      }

      update();
      getCategoriesData();
      getPujaNamesData();
      getTag();
    }

    super.onInit();
  }

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

      await cropImage();
    }
  }

  /// Crop aimge method
  String poojaImageUrl = "";
  String poojaApiPath = "";

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
        uploadImage(File(result.path));
        // String image = await uploadImageToS3Bucket(
        //     File(result.path), result.path.split("/").last);
        print(image);
        // if (image.isNotEmpty) {
        //   poojaImageUrl = image;
        // }
        update();
        print("imageimageimageimage");
      }
    } else {
      debugPrint("Image is not cropped.");
    }
  }

  /// add puja or edit api function

  void addEditPoojaApi() async {
    List tagList = [];
    for (int i = 0; i < selectedTag.length; i++) {
      tagList.add(selectedTag[i].id.toString());
    }
    Map<String, dynamic> param = {
      "pooja_name": poojaName.text,
      "pooja_img": poojaApiPath,
      "pooja_desc": poojaDes.text,
      "pooja_starting_price_inr": poojaPrice.text,
      "pooja_short_desc": poojaDes.text,
      "pooja_category_id": selectedCategory?.id,
      "tag": tagList,
      "pooja_banner_image": "https://example.com/pooja_banner_image.jpg",
    };
    param.addIf(id.value != 0, "pooja_id", id.value);
    try {
      final response = await userRepository.addEditPujaApi(param);
      if (response.data != null) {
        Get.back();
        Get.bottomSheet(const PujaSubmitedBottomSheet());
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
    Map<String, dynamic> param = {

      "prod_cat_id": selectedCategory?.id,
      "prod_name": poojaName.text,
      "prod_image": poojaApiPath,
      "prod_desc": poojaDes.text,
      "product_price_inr": poojaPrice.text,
      //"offer_price_inr": poojaPrice.text,
      //"product_price_usd": 10.0,
      "product_long_desc": poojaDes.text,
      // "product_banner_image": "https://example.com/banner_image.jpg",
    };
    param.addIf(id.value != 0, "product_id", id.value);
    try {
      final response = await userRepository.addEditProductApi(param);
      if (response.data != null) {
        Get.back();
        Get.bottomSheet(const PujaSubmitedBottomSheet());
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

  bool validation() {
    if (poojaDes.text.length < 100) {
      Fluttertoast.showToast(
          msg: "Puja description must be more than 100 character.");
      return false;
    }
    return true;
  }

  Future<void> uploadImage(File imageFile) async {
    var token = await preferenceService.getToken();

    var uri = Uri.parse(
        "https://wakanda-api.divinetalk.live/api/astro/v7/uploadImage");

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));
    request.fields.addAll({"module_name": "pooja"});

    var response = await request.send();

    // Listen for the response

    print("responseresponseresponse");
    response.stream.transform(utf8.decoder).listen((value) {
      print(jsonDecode(value)["data"]);
      poojaApiPath = jsonDecode(value)["data"]["path"];
      poojaImageUrl = jsonDecode(value)["data"]["full_path"];
      update();
      print("valuevaluevaluevaluevaluevaluevalue");
    });

    if (response.statusCode == 200) {
      print("Image uploaded successfully.");
      // if (image.isNotEmpty) {
      //   poojaImageUrl = image;
      // }
    } else {
      print("Failed to upload image.");
    }
  }
}

class CustomSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length <= 1) {
      final newText = newValue.text.replaceAll(' ', '');
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    return newValue;
  }
}
