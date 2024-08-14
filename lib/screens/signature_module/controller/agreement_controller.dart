import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class AgreementController extends GetxController {
  late Future<String> pdfPath;
bool isLastPage = false;
  @override
  void onInit() {
    pdfPath = loadPdfFromAssets();
    super.onInit();
  }

  Future<String> loadPdfFromAssets() async {
    final ByteData data =
        await rootBundle.load('assets/docx/sodapdf-converted.pdf');
    final Uint8List bytes = data.buffer.asUint8List();
    final Directory directory = await getTemporaryDirectory();
    final File file = File('${directory.path}/example.pdf');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
