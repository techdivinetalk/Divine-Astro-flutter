import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../common/custom_widgets.dart';
import '../../common/routes.dart';
import '../../di/api_provider.dart';
import '../../gen/assets.gen.dart';
import '../../model/TechnicalIssuesData.dart';
import '../../model/TechnicalSupport.dart';
import '../../repository/user_repository.dart';

class TechnicalIssueController extends GetxController {
  TechnicalIssueController(this.userRepository);

  final UserRepository userRepository;
  TextEditingController descriptionController = TextEditingController();
  List<String> dropDownItems = ["Issue", "Suggestion"];
  var isLoading = false.obs;
  var isTechnicalLoading = false.obs;
  TechnicalSupport? technicalSupport;
  TechnicalIssuesData? technicalIssuesList;

  var selected;
  String poojaImageUrl = "";
  String htmlCode = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Display Image</title>
    <style>
        /* Optional: CSS to style the image */
        .center {
            display: block;
            margin-left: auto;
            margin-right: auto;
            width: 50%;
        }
    </style>
</head>
<body>
    <h1 style="text-align: center;">My Image</h1>
    <img src="https://img.freepik.com/free-photo/colorful-design-with-spiral-design_188544-9588.jpg" alt="My Image" class="center">
</body>
</html>''';
  selectedDropDown(value) {
    selected = value;
    update();
  }

  var isEdit = false.obs;

  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;
  List<String> selectedImages = [];
  List<File> selectedFiles = [];
  List<String> uploadedImagesList = [];

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
                      'Choose Options'.tr,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
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
    List<XFile>? pickedFiles;

    if (isCamera) {
      // Pick a single image from the camera
      XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        maxWidth: 250,
      );
      if (pickedFile != null) {
        selectedImages.add(pickedFile.path);
        selectedFiles.add(File(pickedFile.path));
      }
    } else {
      // Pick multiple images from the gallery
      pickedFiles = await picker.pickMultiImage(
        imageQuality: 90,
        maxWidth: 250,
      );
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        selectedImages.addAll(pickedFiles.map((pickedFile) => pickedFile.path));
        selectedFiles.addAll(
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
      }
    }
    log("selectedImages - $selectedImages");
    log("selectedImages - $selectedFiles");
    update();
  }

  var currentUploadedFile;
  Future<void> uploadImage(imageFile) async {
    var token = await preferenceService.getToken();
    isLoading(true);

    log("image length - ${imageFile.path}");

    var uri = Uri.parse("${ApiProvider.imageBaseUrl}uploadImage");

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
    request.fields.addAll({"module_name": "technicalSupport"});

    var response = await request.send();

    // Listen for the response

    print("responseresponseresponse");
    response.stream.transform(utf8.decoder).listen((value) {
      print(jsonDecode(value)["data"]);
      uploadedImagesList.add(jsonDecode(value)["data"]["path"]);
      update();
      currentUploadedFile = jsonDecode(value)["data"]["path"];
      log("img-- ${uploadedImagesList.toString()}");
      print("valuevaluevaluevaluevaluevaluevalue");
    });
    log("uploadedImages -- ${uploadedImagesList.toString()}");

    if (response.statusCode == 200) {
      print("Image uploaded successfully.");

      // if (image.isNotEmpty) {
      //   poojaImageUrl = image;
      // }
    } else {
      isLoading(false);

      print("Failed to upload image.");
    }
  }

// Function to upload a list of images one by one
  Future<void> uploadImagesListsFun() async {
    if (selected == null) {
      divineSnackBar(data: "Please select type", color: appColors.redColor);
    } else if (descriptionController.text.isEmpty) {
      divineSnackBar(data: "Description is empty", color: appColors.redColor);
    } else {
      log("111");
      for (var imageFile in selectedFiles) {
        log("111");

        await uploadImage(imageFile);
        log("111");

        update();
      }
      Future.delayed(Duration(seconds: 2)).then((c) {
        if (selectedFiles.length == uploadedImagesList.length &&
            uploadedImagesList.contains(currentUploadedFile)) {
          log("222");
          submitIssues();
        }
      });
      log("111");
    }
    log("uploadedImages -- ${uploadedImagesList.toString()}");
  }

  submitIssues() async {
    isLoading(true);
    log("uploadedImages -- ${uploadedImagesList.toString()}");
    isLoading(true);
    log("uploadedImages -- ${uploadedImagesList.toString()}");

    Map<String, dynamic> param = {
      "description": descriptionController.text,
      "ticket_type": selected,
      "images": uploadedImagesList
    };

    log("paramssss${param.toString()}");
    isLoading(true);

    try {
      log(222.toString());

      final response = await userRepository.submitTechnicalIssues(param);
      if (response.success == true) {
        technicalSupport = response;
        divineSnackBar(
            data: response.message.toString(), color: appColors.green);
        descriptionController.clear();
        uploadedImagesList.clear();
        selectedImages.clear();
        selectedFiles.clear();
        selected = null;
        Get.toNamed(RouteName.allTechnicalIssues);

        isLoading(false);
      } else {
        log(3.toString());

        isLoading(false);
      }
      log("Data Of submit ==> ${jsonEncode(response.data)}");
    } catch (error) {
      log(33.toString());

      isLoading(false);
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    update();
  }
}
