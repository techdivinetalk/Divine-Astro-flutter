import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../common/custom_widgets.dart';
import '../../common/routes.dart';
import '../../di/api_provider.dart';
import '../../firebase_service/firebase_service.dart';
import '../../gen/assets.gen.dart';
import '../../model/TechnicalIssuesData.dart';
import '../../model/TechnicalSupport.dart';
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

class TechnicalIssueController extends GetxController {
  TechnicalIssueController(this.userRepository);

  final UserRepository userRepository;
  TextEditingController descriptionController = TextEditingController();
  List<String> dropDownItems = ["Issue", "Suggestion"];
  var isLoading = false.obs;
  var isTechnicalLoading = false.obs;
  var showMimimum = false.obs;
  TechnicalSupport? technicalSupport;
  TechnicalIssuesData? technicalIssuesList;

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
                              SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Assets.svg.camera.svg()),
                              SizedBox(height: 8.h),
                              CustomText(
                                "Camera".tr,
                                fontSize: 16.sp,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        CustomButton(
                          onTap: () async {
                            Get.back();
                            await getImage(false);
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Assets.svg.gallery.svg()),
                              SizedBox(height: 8.h),
                              CustomText(
                                "Gallery".tr,
                                fontSize: 16.sp,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        CustomButton(
                          onTap: () async {
                            Get.back();
                            await getMedia();
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: Icon(
                                  Icons.video_collection,
                                  color: Color(0xff84909a),
                                  size: 80,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              CustomText(
                                "Media".tr,
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
    if (await PermissionHelper().askMediaPermission()) {
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

          int imageSize = await File(pickedFile.path)
              .length(); // Get the image size in bytes
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
        for (var pickedFile in pickedFiles) {
          int imageSize = await File(pickedFile.path)
              .length(); // Get the image size in bytes
          await compressImages(XFile(pickedFile.path));

          // selectedImages.add(pickedFile.path);
          // selectedFiles.add(File(pickedFile.path));

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
  }

  /*compressImages(croppedFile) async {
    int oversizedCount = 0;

    uploadFile = File(croppedFile.path);
    final filePath = uploadFile!.absolute.path;
    final lastIndex = filePath
        .lastIndexOf(RegExp(r'\.(png|jpg|jpeg|heic)', caseSensitive: false));

    debugPrint("File path: $filePath");
    debugPrint("Last index of extension: $lastIndex");

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

        if (!FileUtils.isFileSizeValid(bytes: imageSize)) {
          oversizedCount++;
          Fluttertoast.showToast(msg: "Image Size is more than 2 MB");
        } else {
          selectedImages.add(result.path);
          selectedFiles.add(File(result.path));
        }

        if (oversizedCount > 0) {
          Fluttertoast.showToast(
              msg: "$oversizedCount images exceed 2 MB and cannot be uploaded");
        }
      } else {
        debugPrint("Failed to compress the image.");
      }
    } else {
      Fluttertoast.showToast(
          msg: "The file path does not contain a valid extension.");
    }
  }*/
  compressImages(croppedFile) async {
    int oversizedCount = 0;

    uploadFile = File(croppedFile.path);
    final filePath = uploadFile!.absolute.path;
    final lastIndex = filePath
        .lastIndexOf(RegExp(r'\.(png|jpg|jpeg|heic)', caseSensitive: false));

    debugPrint("File path: $filePath");
    debugPrint("Last index of extension: $lastIndex");

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
          selectedImages.add(result.path);
          selectedFiles.add(File(result.path));
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
  }

  cropImage(i) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: i.path,
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

        selectedImages.add(result.path);
        selectedFiles.add(File(result.path));

        // uploadImage(File(result.path));
      }
    } else {
      debugPrint("Image is not cropped.");
    }
  }

  var currentUploadedFile;
  var currentUploadedVideo;

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
    request.fields.addAll({"module_name": "technicalSupport"});

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
      for (var videoFile in selectedMedias) {
        print("111");

        await uploadVideo(videoFile);
        print("111");

        update();
      }
      Future.delayed(Duration(seconds: 2)).then((c) {
        if ((selectedFiles.isEmpty &&
                selectedMedias.isNotEmpty &&
                selectedMedias.length == mediaUrls.length &&
                mediaUrls.contains(currentUploadedVideo)) ||
            (selectedMedias.isEmpty &&
                selectedFiles.isNotEmpty &&
                selectedFiles.length == uploadedImagesList.length &&
                uploadedImagesList.contains(currentUploadedFile)) ||
            (selectedFiles.length == uploadedImagesList.length &&
                uploadedImagesList.contains(currentUploadedFile) &&
                selectedMedias.length == mediaUrls.length &&
                mediaUrls.contains(currentUploadedVideo))) {
          print("222");
          submitIssues();
        } else {
          Fluttertoast.showToast(msg: "Add any Media");
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
      "images": uploadedImagesList,
      "media": mediaUrls,
    };

    print("paramssss${param.toString()}");
    isLoading(true);

    try {
      print(222.toString());

      final response = await userRepository.submitTechnicalIssues(param);
      if (response.success == true) {
        technicalSupport = response;
        divineSnackBar(
            data: response.message.toString(), color: appColors.green);
        descriptionController.clear();
        uploadedImagesList.clear();
        selectedImages.clear();
        selectedFiles.clear();
        selectedMedias.value.clear();
        selectedMedias.clear();
        selectedFiles.clear();
        mediaUrls.value.clear();
        mediaUrls.clear();

        selected = null;
        Get.toNamed(RouteName.allTechnicalIssues);

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

  RxList mediaUrls = [].obs;
  RxList selectedMedias = [].obs;
  RxBool pickingFileLoading = false.obs;
  bool isStoryMoreThan2MB = false;

  getMedia() async {
    pickingFileLoading.value = true;
    if (await PermissionHelper().askStoragePermission(Permission.videos)) {
      pickingFileLoading.value = true;

      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.video,
          allowCompression: true,
          allowMultiple: false,
        );
        int fileSizeInBytes =
            await File(result!.files.single.path ?? "").length();
        double sizeInKB = fileSizeInBytes / 1024;
        print("pick video size : ${sizeInKB}");
        print("maximumStorySize : ${maximumStorySize.value}");
        if (sizeInKB < double.parse(maximumStorySize.value.toString())) {
          if (sizeInKB > 2048) {
            isStoryMoreThan2MB = true;
          }
          // Fluttertoast.showToast(msg: "${'uploadStory'.tr}..");
          selectedMedias.value.add(result.files.single.path!);
          print("object-------------${selectedMedias.value.toString()}");
          // await uploadImage(File(result.files.single.path!));
        } else {
          isLoading.value = false;

          Fluttertoast.showToast(
              msg:
                  "Story video size should be maximum ${convertKBtoMB(double.parse(maximumStorySize.value.toString()))} MB",
              backgroundColor: appColors.red);
        }
      } catch (e) {}
    }
    update();
  }

  String convertKBtoMB(double sizeInKB) {
    return (sizeInKB / 1024).toStringAsFixed(0);
  }

  uploadVideo(imageFile) async {
    var uploadedStory;
    isLoading(true);
    var token = await preferenceService.getToken();
    print("image length - ${imageFile}");

    var uri = Uri.parse("${ApiProvider.imageBaseUrl}uploadImage");
    print("api apia----->${"${ApiProvider.imageBaseUrl}uploadImage"}");

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile,
    ));
    request.fields.addAll({"module_name": "support"});
    if (isStoryMoreThan2MB) {
      request.fields.addAll({"is_large_file": "1"});
    }

    print("request : ${request.toString()}");
    print("request : ${request.headers.toString()}");
    print("request : ${request.fields.toString()}");
    var response = await request.send();

    // Listen for the response
    print(response.toString());
    // Listen for the response
    response.stream.transform(utf8.decoder).listen((value) {
      print("value ----> $value");
      // if (value.isEmpty) {
      //   isLoading(false);
      // }
      if (jsonDecode(value)["data"]["path"] == null) {
        // Convert the string to JSON
        Map<String, dynamic> jsonResponse = jsonDecode(value.toString());
        isLoading.value = false;

        Fluttertoast.showToast(
          msg: jsonResponse['data']['image'][0].toString(),
        );
        isLoading(false);
        Get.back();
      } else {
        print(value); // Handle the response from the server
        uploadedStory = jsonDecode(value)["data"]["path"];
        update();
        print(
            "Image uploaded successfully. --  - ${jsonDecode(value)["data"]["full_path"].toString()}");
        mediaUrls.value.add(jsonDecode(value)["data"]["path"]);
        currentUploadedVideo = jsonDecode(value)["data"]["path"];

        update();
        print(
            "valuevaluevaluevaluevaluevaluevalue"); // Handle the response from the server
      }
    });

    if (response.statusCode == 200) {
      print("Image uploaded successfully.");
      // uploadStory(uploadedStory.toString());
    } else {
      isLoading(false);

      print("Failed to upload image.");
    }
  }
}
