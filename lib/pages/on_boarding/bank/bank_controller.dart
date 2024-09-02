import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../common/custom_widgets.dart';
import '../../../di/api_provider.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/update_bank_response.dart';
import '../../../repository/user_repository.dart';
import '../../../screens/financial_support/financial_support_controller.dart';

class BankController extends GetxController {
  // Repositories
  UserRepository userRepository = UserRepository();

  // TextEditingControllers for bank details
  late TextEditingController bankNameController;
  late TextEditingController bankHolderController;
  late TextEditingController bankAccountController;
  late TextEditingController bankIFSCController;

  // FocusNodes for handling form focus
  FocusNode bankNameNode = FocusNode();
  FocusNode bankHolderNode = FocusNode();
  FocusNode bankAccountNode = FocusNode();
  FocusNode bankIFSCNode = FocusNode();

  // Variables for storing images
  var passBookImage;
  var blankChequeImage;

  // Variables for uploading images
  var uploadImagePan;
  var uploadImageCheque;

  // Variables for managing image compression and uploading
  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;

  // Variables for tracking status
  String status = "";
  late UpdateBankResponse updateBankResponse;
  RxBool submittingBankDetails = false.obs;

  // Initialization method
  @override
  void onInit() {
    super.onInit();
    // Initialize TextEditingControllers
    bankNameController = TextEditingController();
    bankHolderController = TextEditingController();
    bankAccountController = TextEditingController();
    bankIFSCController = TextEditingController();
  }

  // Method to upload all images and submit bank details
  Future<void> uploadAll() async {
    await [];
  }

  // Method to update the profile image
  void updateProfileImage(String from) {
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
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: appColors.white, width: 1.5),
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    color: appColors.white.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
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
                    CustomText(
                      'Only photos can be shared'.tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontColor: appColors.grey,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          onTap: () async {
                            Get.back();
                            await getImage(true, from);
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
                            await getImage(false, from);
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

  // Method to pick an image from the camera or gallery
  Future<void> getImage(bool isCamera, String from) async {
    pickedFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 250,
    );

    if (pickedFile != null) {
      image = File(pickedFile!.path);
      await compressImages(image!, from);
    }
  }

  // Method to compress the image
  Future<void> compressImages(File croppedFile, String from) async {
    int oversizedCount = 0;
    uploadFile = File(croppedFile.path);
    final filePath = uploadFile!.absolute.path;
    final lastIndex = filePath
        .lastIndexOf(RegExp(r'\.(png|jpg|jpeg|heic)', caseSensitive: false));

    if (lastIndex != -1) {
      final splitted = filePath.substring(0, lastIndex);
      final extension = filePath.substring(lastIndex).toLowerCase();
      String outPath;

      // Ensure the output path ends with .jpg or .jpeg for compression
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
          Fluttertoast.showToast(msg: "Image Size should be less than 5 MB");
        } else {
          if (from == "passBook") {
            passBookImage = result.path;
            uploadPan(File(result.path));
          } else {
            blankChequeImage = result.path;
            uploadCheque(File(result.path));
            Fluttertoast.showToast(msg: "Image Uploaded");
          }
          update();
        }
      } else {
        debugPrint("Failed to compress the image.");
      }
    } else {
      Fluttertoast.showToast(
          msg: "The file path does not contain a valid extension.");
    }
    update();
  }

  // Method to upload the PAN image
  Future<void> uploadPan(imageFile) async {
    var token = await preferenceService.getToken();

    var uri = Uri.parse("${ApiProvider.imageBaseUrl}uploadImage");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    // Attach the image file to the request
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.fields.addAll({"module_name": "user_bank_passbook"});

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      if (response.statusCode == 200) {
        print("Image uploaded successfully.");
        var imageUrl = jsonDecode(value)["data"]["full_path"];

        if (jsonDecode(value)["data"]["full_path"] == null) {
          Fluttertoast.showToast(msg: "Not able to upload");
        } else {
          uploadImagePan = imageUrl;
        }
      } else {
        print("Failed to upload image.");
      }
    });
  }

  // Method to upload the cheque image
  Future<void> uploadCheque(imageFile) async {
    var token = await preferenceService.getToken();
    print("Image length - ${imageFile.path}");

    var uri = Uri.parse("${ApiProvider.imageBaseUrl}uploadImage");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    // Attach the image file to the request
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.fields.addAll({"module_name": "user_bank_cheque"});

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      if (response.statusCode == 200) {
        print("Image uploaded successfully.");
        var imageUrl = jsonDecode(value)["data"]["full_path"];

        if (jsonDecode(value)["data"]["full_path"] == null) {
          Fluttertoast.showToast(msg: "Not able to upload");
        } else {
          uploadImageCheque = imageUrl;
        }
      } else {
        print("Failed to upload image.");
      }
    });
  }

  // Method to submit bank details
  Future<void> submitBankDetails() async {
    submittingBankDetails.value = true;
    var body = {
      "bank_name": bankNameController.text,
      "account_number": bankAccountController.text,
      "ifsc_code": bankIFSCController.text,
      "account_holder_name": bankIFSCController.text,
      "legal_documents": {
        "0": uploadImagePan,
        "1": uploadImageCheque,
      },
      "in_onboarding": 1
    };
    final response = await userRepository.updateBankDetailsApi(body);
    if (response.success == true) {
      updateBankResponse = response;
      submittingBankDetails.value = false;
      status = response.data.status!;

      divineSnackBar(data: response.message);
    } else {
      submittingBankDetails.value = false;
    }
  }
}
