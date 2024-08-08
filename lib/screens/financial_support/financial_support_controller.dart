import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import '../../model/FinancialCreateIssueModel.dart';
import '../../repository/user_repository.dart';

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

class FinancialSupportController extends GetxController {
  FinancialSupportController(this.userRepository);

  final UserRepository userRepository;
  TextEditingController descriptionController = TextEditingController();
  List<String> dropDownItems = ["Issue", "Suggestion"];
  var isLoading = false.obs;
  var isTechnicalLoading = false.obs;
  var selectingImages = false.obs;
  FinancialCreateIssueModel? technicalSupport;
  FinancialCreateIssueModelData? technicalIssuesList;

  var selected;
  String poojaImageUrl = "";
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
        // imageQuality: 90,
        // maxWidth: 250,
      );
      if (pickedFile != null) {
        // selectedImages.add(pickedFile.path);
        // selectedFiles.add(File(pickedFile.path));
        final imageTemp = File(pickedFile.path);

        int imageSize =
            await File(pickedFile.path).length(); // Get the image size in bytes
        await compressImages(XFile(pickedFile.path));

        // if (!FileUtils.isFileSizeValid(bytes: imageSize)) {
        //   Fluttertoast.showToast(
        //       msg:
        //           "Image Size is more then 2 MB"); // Optionally, you can show an alert to the user or handle it accordingly
        // } else {
        //   selectedImages.add(pickedFile.path);
        //   selectedFiles.add(File(pickedFile.path));
        // }
      }
    } else {
      // Pick multiple images from the gallery
      pickedFiles = await picker.pickMultiImage(
          // imageQuality: 90,
          // maxWidth: 250,
          );
      // if (pickedFiles != null && pickedFiles.isNotEmpty) {
      //   selectedImages.addAll(pickedFiles.map((pickedFile) => pickedFile.path));
      //   selectedFiles.addAll(
      //       pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
      // }

      int oversizedCount = 0;

      final imageTemp = File(pickedFiles[0].path);
      selectingImages(true);
      for (var pickedFile in pickedFiles) {
        int imageSize =
            await File(pickedFile.path).length(); // Get the image size in bytes
        await compressImages(XFile(pickedFile.path));
        // if (!FileUtils.isFileSizeValid(bytes: imageSize)) {
        //   oversizedCount++;
        // } else {
        //   selectedImages.add(pickedFile.path);
        //   selectedFiles.add(File(pickedFile.path));
        // }
      }
      if (oversizedCount > 0) {
        Fluttertoast.showToast(
            msg: "$oversizedCount images exceed 2 MB and cannot be uploaded");
      }
      // if (selectedImages.isNotEmpty) {
      //   Fluttertoast.showToast(
      //       msg:
      //           "Images selected successfully: ${selectedImages.length} images");
      // }
    }
    print("selectedImages - $selectedImages");
    print("selectedImages - $selectedFiles");
    update();
  }

  compressImages(croppedFile) async {
    int oversizedCount = 0;
    uploadFile = File(croppedFile.path);
    final filePath = uploadFile!.absolute.path;
    final lastIndex = filePath
        .lastIndexOf(RegExp(r'\.(png|jpg|jpeg|heic)', caseSensitive: false));

    debugPrint("File path: $filePath");
    debugPrint("Last index of extension: $lastIndex");
    final splitted = filePath.substring(0, (lastIndex));
    if (lastIndex != -1) {
      final splitted = filePath.substring(0, lastIndex);
      final extension = filePath.substring(lastIndex);
      final outPath = extension.toLowerCase() == '.heic'
          ? "${splitted}_out.jpg"
          : "${splitted}_out$extension";
      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 500,
      );
      if (result != null) {
        int imageSize =
            await File(result.path).length(); // Get the image size in bytes

        if (!FileUtils.isFileSizeValid(bytes: imageSize)) {
          oversizedCount++;

          Fluttertoast.showToast(
              msg:
                  "Image Size is more then 2 MB"); // Optionally, you can show an alert to the user or handle it accordingly
        } else {
          selectedImages.add(result.path);
          selectedFiles.add(File(result.path));
        }
        if (oversizedCount > 0) {
          Fluttertoast.showToast(
              msg: "$oversizedCount images exceed 2 MB and cannot be uploaded");
        }
        // selectedImages.add(result.path);
        // selectedFiles.add(File(result.path));
      } else {
        debugPrint("The file path does not contain .png, .jpg, or .jpeg.");
      }
      // uploadImage(File(result.path));
    }
  }

  var currentUploadedFile;
  Future<void> uploadImage(imageFile) async {
    var token = await preferenceService.getToken();
    isLoading(true);

    print("image length - ${imageFile.path}");

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
    request.fields.addAll({"module_name": "financialSupport"});

    var response = await request.send();

    // Listen for the response

    print("responseresponseresponse");
    response.stream.transform(utf8.decoder).listen((value) {
      print(jsonDecode(value)["data"]);
      uploadedImagesList.add(jsonDecode(value)["data"]["path"]);
      update();
      currentUploadedFile = jsonDecode(value)["data"]["path"];
      print("img-- ${uploadedImagesList.toString()}");
      print("valuevaluevaluevaluevaluevaluevalue");
    });
    print("uploadedImages -- ${uploadedImagesList.toString()}");

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
      print("111");
      for (var imageFile in selectedFiles) {
        print("111");

        await uploadImage(imageFile);
        print("111");

        update();
      }
      Future.delayed(Duration(seconds: 2)).then((c) {
        if (selectedFiles.length == uploadedImagesList.length &&
            uploadedImagesList.contains(currentUploadedFile)) {
          print("222");
          submitIssues();
        }
      });
      print("111");
    }
    print("uploadedImages -- ${uploadedImagesList.toString()}");
  }

  submitIssues() async {
    isLoading(true);
    print("uploadedImages -- ${uploadedImagesList.toString()}");
    isLoading(true);
    print("uploadedImages -- ${uploadedImagesList.toString()}");

    Map<String, dynamic> param = {
      "description": descriptionController.text,
      "ticket_type": selected,
      "images": uploadedImagesList
    };

    print("paramssss${param.toString()}");
    isLoading(true);

    try {
      print(222.toString());

      final response = await userRepository.submitFinancialIssues(param);
      if (response.success == true) {
        technicalSupport = response;
        divineSnackBar(
            data: response.message.toString(), color: appColors.green);
        descriptionController.clear();
        uploadedImagesList.clear();
        selectedImages.clear();
        selectedFiles.clear();
        selected = null;
        Get.toNamed(RouteName.allFinancialSupportIssues);

        isLoading(false);
      } else {
        print(3.toString());

        isLoading(false);
      }
      print("Data Of submit ==> ${jsonEncode(response.data)}");
    } catch (error) {
      print(33.toString());

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
