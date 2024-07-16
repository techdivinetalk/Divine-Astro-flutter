

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/add_custom_product/add_custom_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/common_image_view.dart';
import '../../gen/assets.gen.dart';
import '../../screens/add_puja/add_puja_controller.dart';
import '../../screens/puja/widget/remedy_text_filed.dart';

class AddCustomProductView extends GetView<AddCustomProductController> {
  AddCustomProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddCustomProductController>(
      assignId: true,
      init: AddCustomProductController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 30,
            backgroundColor: appColors.white,
            surfaceTintColor: appColors.white,
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            title: CustomText('Add Custom Product'.tr),
          ),
          body: ListView(
            children: [
              InkWell(
                  onTap: () async {
                    if (await PermissionHelper().askMediaPermission()) {
                      updateProfileImage();
                    }
                  },
                  child: CommonImageView(
                    imagePath: controller.productImageUrl.isEmpty
                        ? Assets.images.icUploadStory.path
                        : controller.productImageUrl,
                    fit: BoxFit.cover,
                    height: 90.h,
                    width: 90.h,
                    placeHolder: Assets.images.defaultProfile.path,
                    radius: BorderRadius.circular(100.h),
                  )),
              SizedBox(height: 10.h),
              CustomText(
                'Upload Product Image',
                fontColor: appColors.textColor,
              ),
              SizedBox(height: 20.h),
              PoojaRemedyTextFiled(
                title: "Product Name",
                maxLength: 20,
                controller: controller.productName,
                textInputFormatter: [CustomSpaceInputFormatter()],
                onChanged: (value) {
                  controller.update();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              PoojaRemedyTextFiled(
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(10),
                  CustomSpaceInputFormatter(),
                  FilteringTextInputFormatter.digitsOnly
                ],
                isSuffix: false,
                title: 'Product Price ( In INR )',
                controller: controller.productPrice,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product Price is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  if (controller.productApiPath.isEmpty) {
                    Fluttertoast.showToast(msg: "Please select product image");
                  } else if (controller.productName.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter product name");
                  } else if (controller.productPrice.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter product price");
                  } else {
                    controller.addCustomProduct();
                  }
                  // if (formKey.currentState?.validate() ?? false) {}
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: appColors.guideColor,
                  ),
                  child: CustomText(
                    'Save',
                    fontColor: appColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
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
                            // Get.back();
                            await getImage(true, controller: controller);
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
                            // Get.back();
                            await getImage(false, controller: controller);
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
  Future getImage(bool isCamera,
      {AddCustomProductController? controller}) async {
    controller!.pickedFile = await controller.picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 250,
    );

    if (controller.pickedFile != null) {
      controller.image = controller!.pickedFile;

      await cropImage();
    }
  }

  cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: controller.image!.path,
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

      controller.uploadFile = File(croppedFile.path);
      final filePath = controller.uploadFile!.absolute.path;
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
        controller.update();
        print("imageimageimageimage");
      }
    } else {
      debugPrint("Image is not cropped.");
    }
  }

  Future<void> uploadImage(File imageFile,{AddCustomProductController? controller}) async {
    log("uploading images 1");
    var uri = Uri.parse("${ApiProvider.imageBaseUrl}uploadImage");

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    log("uploading images 2");

    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));
    request.fields.addAll({"module_name": "pooja"});

    var response = await request.send();
    log("uploading images 3");

    // Listen for the response

    response.stream.transform(utf8.decoder).listen((value) {
      print(jsonDecode(value)["data"]);
      controller!.productApiPath = jsonDecode(value)["data"]["path"];
      controller.productImageUrl = jsonDecode(value)["data"]["full_path"];
      log("uploading images 4");
      log("uploading images 5 - ${controller.productApiPath}");

      controller.update();
      print("valuevaluevaluevaluevaluevaluevalue");
    });

    if (response.statusCode == 200) {
      print("Image uploaded successfully.");
      log("uploading images 6 - ${controller!.productApiPath}");

      // Get.bottomSheet(
      //     CreateCustomProductSheet(
      //       controller: widget.controller,
      //       chatMessageController: widget.chatMessageController,
      //     ),
      //     isScrollControlled: true);
      // if (image.isNotEmpty) {
      //   poojaImageUrl = image;
      // }
    } else {
      print("Failed to upload image.");
    }
  }
}
