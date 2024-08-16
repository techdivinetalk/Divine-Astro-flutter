import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_message/widgets/product/pooja/widgets/custom_widget/pooja_common_list.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/agreement_model.dart';

class AgreementController extends GetxController {
  Future<String>? pdfPath;
  bool isLastPage = false;

  /// 0(NotSend),1(pending sign),2(underRevie),3(approved),4(not approved)
  int exclusiveAgreementStages = 0;
  String stageMessage = "";

  @override
  void onInit() {
    getAstrologerStatus();
    super.onInit();
  }

  Future<String> loadPdfFromFile(String filePath) async {
    // Check if the file exists
    final File file = File(filePath);

    if (await file.exists()) {
      return file.path;
    } else {
      throw Exception("File not found");
    }
  }

  getAstrologerStatus() async {
    UserData? userData = await pref.getUserDetail();
    print("---------------${userData!.toJson().toString()}");
    try {
      print(
          "ApiProvider.astrologerAgreement${ApiProvider.astrologerAgreement}${userData!.id}");
      Dio().options.headers = {
        'Connection': 'keep-alive',
        'Keep-Alive': 'timeout=5, max=1000',
      };
      final response =
          await Dio().get("${ApiProvider.astrologerAgreement}${userData!.id}");
      print("astrologerAgreement.data${jsonEncode(response.data)}");
      AgreementModel agreementModel = AgreementModel.fromJson(response.data);
      if (agreementModel.data != null) {
        exclusiveAgreementStages =
            agreementModel.data!.exclusiveAgreementStages!;
        print("exclusiveAgreementStages--->>$exclusiveAgreementStages");
        if (agreementModel.data!.stageMessage != null) {
          stageMessage = agreementModel.data!.stageMessage ?? "";
        } else {
          stageMessage = exclusiveAgreementStages == 2
              ? "Your Agreement is under-review"
              : exclusiveAgreementStages == 3
                  ? "Your Agreement is approved"
                  : exclusiveAgreementStages == 4
                      ? "Your Agreement not approved please retry aga"
                      : "";
        }

        update();
        downloadPDF(agreementModel.data!.pdfLink ?? "");
      }
    } catch (e) {
      print("getting error --- astrologerAgreement ${e}");
    }
  }

  String progressMessage = "";

  Future<void> downloadPDF(String url) async {
    try {
      // Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/astrologer_agreement.pdf';

      // Create Dio instance
      Dio dio = Dio();

      // Download the file
      await dio.download(url, filePath);
      pdfPath = loadPdfFromFile(filePath);
      update();
    } catch (e) {
      progressMessage = "Download failed: $e";
    }
  }
}
