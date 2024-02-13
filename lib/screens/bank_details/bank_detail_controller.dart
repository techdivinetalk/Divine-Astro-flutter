import 'dart:convert';
import 'dart:io';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/update_bank_request.dart';
import 'package:divine_astrologer/model/update_bank_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BankDetailController extends GetxController {


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
    setUserData();
    super.onInit();

  }

  @override
  void dispose() {
    super.dispose();

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
    uploadToBucket();
    update();
  }

  void addCancelledCheque(File file) {
    cancelledCheque = file;
    uploadToBucket();
    update();
  }

  void submit() {
    if (formState.currentState!.validate()) {
      updateDetails();
    } else {
      divineSnackBar(data: "Please Fill All Data", color: appColors.redColor);
    }
  }

  void uploadToBucket() {

    if (passBook != null && cancelledCheque != null) {
      uploadImagesToS3Bucket(
        passBook: passBook!, 
        cancelledCheque: cancelledCheque!,
        uploadDone: () => divineSnackBar(
            data: "Uploading Done", duration: const Duration(seconds: 1)),
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
    final response =
        await userRepository.updateBankDetailsApi(request.toJson());
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
    required File passBook,
    required File cancelledCheque,
    required void Function() uploadDone,
  }) async {
    isImagesUploaded = false;
    List<Future> futures = <Future>[];
    futures.add(uploadImageToS3Bucket(passBook, "${userId}_PASSBOOK"));
    futures.add(
        uploadImageToS3Bucket(cancelledCheque, "${userId}_CANCELLED_CHEQUE"));
    List<dynamic> data = await Future.wait(futures);
    passBookUrl = data.first;
    cancelledChequeUrl = data.last;
    isImagesUploaded = true;
    uploadDone();
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


