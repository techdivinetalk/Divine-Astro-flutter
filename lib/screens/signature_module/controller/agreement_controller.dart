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

  @override
  void onInit() {
    getAstrologerStatus();
    super.onInit();
  }

  // Future<String> loadPdfFromAssets() async {
  //   final ByteData data =
  //       await rootBundle.load('assets/docx/sodapdf-converted.pdf');
  //   final Uint8List bytes = data.buffer.asUint8List();
  //   final Directory directory = await getTemporaryDirectory();
  //   final File file = File('${directory.path}/example.pdf');
  //   await file.writeAsBytes(bytes);
  //   return file.path;
  // }

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
      final response = await Dio().get(
        "${ApiProvider.astrologerAgreement}${userData!.id}",
      );
      print("astrologerAgreement.data${jsonEncode(response.data)}");
      AgreementModel agreementModel = AgreementModel.fromJson(response.data);
      if (agreementModel.data != null) {
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
