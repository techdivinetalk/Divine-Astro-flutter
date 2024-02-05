import 'dart:io';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/update_bank_request.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BankDetailController extends GetxController {
  final state = BankDetailState();

  GlobalKey<FormState> get formKey => state.formState;

  File? passBook;
  File? cancelledCheque;

  @override
  void onInit() {
    super.onInit();
    state.init();
  }

  @override
  void dispose() {
    super.dispose();
    state.dispose();
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

  void uploadToBucket() {
    if (passBook != null && cancelledCheque != null) {
      state.uploadImagesToS3Bucket(
        passBook: passBook!,
        cancelledCheque: cancelledCheque!,
        uploadDone: () => divineSnackBar(
            data: "Uploading Done", duration: const Duration(seconds: 1)),
      );
      divineSnackBar(
          data: "Uploading Images", duration: const Duration(seconds: 1));
    }
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      updateDetails();
    } else {
      divineSnackBar(data: "Please Fill All Data", color: AppColors.redColor);
    }
  }

  void updateDetails() async {
    if (state.passBookUrl == null && state.cancelledChequeUrl == null) {
      divineSnackBar(
          data: "Please pick your documents",
          duration: const Duration(seconds: 1));
      return;
    }
    if (!state.isImagesUploaded) {
      divineSnackBar(
          data: "Images Not uploaded yet",
          duration: const Duration(seconds: 1));
      return;
    }
    UpdateBankRequest request = state.getFormData().copyWith(
          legalDocuments: LegalDocuments(
            the0: state.passBookUrl.toString(),
            the1: state.cancelledChequeUrl.toString(),
          ),
        );
    final response =
        await userRepository.updateBankDetailsApi(request.toJson());
    await state.saveUpdatedBankDetails(response.toPrettyString());
    divineSnackBar(data: response.message);
  }
}

class BankDetailState {
  BankDetailState() {
    service = Get.find<SharedPreferenceService>();
    final userData = service.getUserDetail();
    userId = userData!.id!;
  }

  late int userId;
  late SharedPreferenceService service;
  late TextEditingController bankName;
  late TextEditingController holderName;
  late TextEditingController accountNumber;
  late TextEditingController ifscCode;
  bool isImagesUploaded = false;
  String? passBookUrl;
  String? cancelledChequeUrl;

  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  void init() {
    bankName = TextEditingController();
    holderName = TextEditingController();
    accountNumber = TextEditingController();
    ifscCode = TextEditingController();
    setUserData();
  }

  void setUserData() {
    final details = service.getUpdatedBankDetails();
    if (details != null) {
      bankName.text = details.data.bankName;
      holderName.text = details.data.accountHolderName;
      accountNumber.text = details.data.accountNumber;
      ifscCode.text = details.data.ifscCode;
    } else {
      final userData = service.getUserDetail();
      bankName.text = userData?.bankName ?? "";
      holderName.text = userData?.accountHolderName ?? "";
      accountNumber.text = userData?.accountNumber ?? "";
      ifscCode.text = userData?.ifscCode ?? "";
    }
  }

  void dispose() {
    bankName.dispose();
    holderName.dispose();
    accountNumber.dispose();
    ifscCode.dispose();
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
}
