import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../di/api_provider.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/update_bank_request.dart';
import '../../../model/update_bank_response.dart';

class BankController extends GetxController {
  String status = "";

  bool isImagesUploaded = false;
  String passBookUrl = "";
  String cancelledChequeUrl = "";

  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  File? passBook;
  File? cancelledCheque;
  late int userId;
  late SharedPreferenceService service;
  TextEditingController bankName = TextEditingController();
  TextEditingController holderName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController ifscCode = TextEditingController();

  @override
  void onInit() {
    service = Get.find<SharedPreferenceService>();
    final userData = service.getUserDetail();
    userId = userData!.id!;
    // setUserData();
    super.onInit();
  }

  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) {
      divineSnackBar(data: "Please Pick File");
      return null;
    }

    return File(result.files.first.path.toString());
  }

  void addPassBook(File file) {
    passBook = file;
    uploadToBucket("p", file);
    update();
  }

  void addCancelledCheque(File file) {
    cancelledCheque = file;
    uploadToBucket("c", file);
    update();
  }

  void submit() {
    if (formState.currentState!.validate()) {
      updateDetails();
    } else {
      divineSnackBar(data: "Please Fill All Data", color: appColors.redColor);
    }
  }

  void uploadToBucket(fileType, file) {
    if (passBook != null) {
      uploadImagesToS3Bucket(
        file: file!,
        uploadDone: () => divineSnackBar(
            data: "Uploading Done", duration: const Duration(seconds: 1)),
        fileType: fileType,
      );
      divineSnackBar(
          data: "Uploading Images", duration: const Duration(seconds: 1));
    }
  }

  void updateDetails() async {
    print(passBookUrl.toString());
    print(cancelledChequeUrl.toString());
    print("state.cancelledChequeUrl");
    if (passBookUrl.isEmpty && cancelledChequeUrl.isEmpty) {
      divineSnackBar(
          data: "Please pick your documents",
          duration: const Duration(seconds: 1));
      return;
    }
    if (!isImagesUploaded) {
      divineSnackBar(
          data: "Images Not uploaded yet",
          duration: const Duration(seconds: 1));
      return;
    }
    UpdateBankRequest request = getFormData().copyWith(
      legalDocuments: LegalDocuments(
        the0: passBookUrl.toString(),
        the1: cancelledChequeUrl.toString(),
      ),
    );
    print("-----${request.toJson()}");

    var body = {
      "bank_name": bankName.text.trim(),
      "account_number": accountNumber.text.trim(),
      "ifsc_code": ifscCode.text.trim(),
      "account_holder_name": holderName.text.trim(),
      "legal_documents": {
        "0": passBookUrl.toString(),
        "1": cancelledChequeUrl.toString(),
      },
      "in_onboarding": 1
    };
    final response = await userRepository.updateBankDetailsApi(body);
    status = response.data.status!;
    update();
    await saveUpdatedBankDetails(response.toPrettyString());
    divineSnackBar(data: response.message);
  }

  UpdateBankRequest getFormData() {
    return UpdateBankRequest(
      bankName: bankName.text.trim(),
      accountNumber: accountNumber.text.trim(),
      ifscCode: ifscCode.text.trim(),
      accountHolderName: holderName.text.trim(),
    );
  }

  Future<void> saveUpdatedBankDetails(String json) async {
    await service.saveUpdatedBankDetails(json);
  }

  void uploadImagesToS3Bucket({
    required File file,
    required void Function() uploadDone,
    fileType,
  }) async {
    isImagesUploaded = false;
    // List<Future> futures = <Future>[];
    // futures.add(uploadImageToS3Bucket(passBook, "${userId}_PASSBOOK"));
    // futures.add(
    //     uploadImageToS3Bucket(cancelledCheque, "${userId}_CANCELLED_CHEQUE"));
    // List<dynamic> data = await Future.wait(futures);
    // passBookUrl = data.first;
    // cancelledChequeUrl = data.last;
    if (fileType == "p") {
      uploadPassBook(passBook);
    } else {
      uploadCheque(cancelledCheque);
    }
    isImagesUploaded = true;

    uploadDone();
  }

  var pasbok;
  var cheque;
  var isLoading = false.obs;

  Future<void> uploadPassBook(imageFile) async {
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
    request.fields.addAll({"module_name": "user_bank_passbook"});

    var response = await request.send();

    // Listen for the response

    print("responseresponseresponse");
    response.stream.transform(utf8.decoder).listen((value) {
      print(jsonDecode(value)["data"]);
      update();
      pasbok = jsonDecode(value)["data"]["full_path"];
      passBookUrl = jsonDecode(value)["data"]["full_path"];
      print("img-- ${passBookUrl.toString()}");
      print("valuevaluevaluevaluevaluevaluevalue");
    });
    print("uploadedImages -- ${passBookUrl.toString()}");

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

  Future<void> uploadCheque(imageFile) async {
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
    request.fields.addAll({"module_name": "user_bank_cheque"});

    var response = await request.send();

    // Listen for the response

    print("responseresponseresponse");
    response.stream.transform(utf8.decoder).listen((value) {
      print(jsonDecode(value)["data"]);
      update();
      cheque = jsonDecode(value)["data"]["full_path"];
      cancelledChequeUrl = jsonDecode(value)["data"]["full_path"];
      print("img-- ${cancelledChequeUrl.toString()}");
      print("valuevaluevaluevaluevaluevaluevalue");
    });
    print("uploadedImages -- ${cancelledChequeUrl.toString()}");

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

  void setUserData() {
    final details =
        service.prefs!.getString(SharedPreferenceService.updatedBankDetails);
    if (details != null) {
      UpdateBankResponse data = updateBankResponseFromJson(details);
      bankName.text = data.data.bankName ?? "";
      holderName.text = data.data.accountHolderName ?? "";
      accountNumber.text = data.data.accountNumber ?? "";
      ifscCode.text = data.data.ifscCode ?? "";
      status = data.data.status ?? "";
      if (data.data.legalDocuments!.isNotEmpty) {
        print("images getting");
        passBookUrl = jsonDecode(data.data.legalDocuments!)[0] ?? "";
        cancelledChequeUrl = jsonDecode(data.data.legalDocuments!)[1] ?? "";
        print(passBookUrl);
        print(cancelledChequeUrl);
      }
    } else {
      final userData = service.getUserDetail();
      bankName.text = userData?.bankName ?? "";
      holderName.text = userData?.accountHolderName ?? "";
      accountNumber.text = userData?.accountNumber ?? "";
      ifscCode.text = userData?.ifscCode ?? "";
    }
  }
}
//   // Method to submit bank details
//   Future<void> submitBankDetails() async {
//     submittingBankDetails.value = true;
//     var body = {
//       "bank_name": bankNameController.text,
//       "account_number": bankAccountController.text,
//       "ifsc_code": bankIFSCController.text,
//       "account_holder_name": bankIFSCController.text,
//       "legal_documents": {
//         "0": uploadImagePan,
//         "1": uploadImageCheque,
//       },
//       "in_onboarding": 1
//     };
//     final response = await userRepository.updateBankDetailsApi(body);
//     if (response.success == true) {
//       updateBankResponse = response;
//       submittingBankDetails.value = false;
//       status = response.data.status!;
//
//       divineSnackBar(data: response.message);
//     } else {
//       submittingBankDetails.value = false;
//     }
//   }
// }
