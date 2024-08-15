import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_message/widgets/product/pooja/widgets/custom_widget/pooja_common_list.dart';
import 'package:divine_astrologer/screens/signature_module/model/agreement_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../common/routes.dart';

class SignatureController extends GetxController {
  GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();
  bool isRadius = true;
  double minimumStrokeWidth = 3;
  TextEditingController signature = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  Color selectedBackgroundColor = Colors.white;
  String astrologerProfilePhoto = "";

  Color selectedStrokeColor = appColors.guideColor;
  Color containerColor = Color(0xffFFFFFF);
  String selectedBackgroundImage = "";

  @override
  void onInit() {
    if (Get.arguments != null) {
      astrologerProfilePhoto = Get.arguments["astrologerProfilePhoto"];
    }
    getDeviceDetails();
    super.onInit();
  }

  saveDrawSignature() {
    if (signaturePadKey.currentState!.toPathList().isNotEmpty) {
      screenShotImage();
    } else {
      divineSnackBar(data: "Please draw signature");
    }
  }

  screenShotImage() async {
    screenshotController.capture().then((Uint8List? image) async {
      Directory downloadPath = await getDownloadPath();
      String fileName =
          "${downloadPath.path}/Draw_signature_${DateTime.now().microsecond}${DateTime.now().millisecond}.png";
      bool isPermission = await askStoragePermission();
      print("isPermission ----->$isPermission");
      if (isPermission) {
        await File(fileName).writeAsBytes(image!);
        uploadSignatureImage(File(fileName));
      } else {
        divineSnackBar(data: "Permission denied");
      }
      isRadius = true;
      update();
    }).catchError((onError) {
      print(onError);
    });
    isRadius = false;
    update();
  }

  Future<Directory> getDownloadPath() async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      return directory;
    } else {
      Directory appDocDirFolder = Directory('/storage/emulated/0/Download');
      bool isPermission = await askStoragePermission();
      if (isPermission) {
        directory = Directory('/storage/emulated/0/Download');
        appDocDirFolder = Directory('${directory.path}/divinetalkAstrology');
        if (await appDocDirFolder.exists()) {
          return appDocDirFolder;
        } else {
          final Directory _appDocDirNewFolder =
              await appDocDirFolder.create(recursive: true);
          return _appDocDirNewFolder;
        }
      }
      return appDocDirFolder;
    }
  }

  Future<bool> askStoragePermission() async {
    bool isPermission = false;
    if (currentSdk >= 32) {
      var checkPermission = await Permission.photos.status;
      if (checkPermission.isDenied) {
        var status = await Permission.photos.request();
        if (status.isGranted) {
          isPermission = true;
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
        }
      } else if (checkPermission.isGranted) {
        isPermission = true;
      } else if (checkPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      var checkPermission = await Permission.storage.status;

      if (checkPermission.isDenied) {
        var status = await Permission.storage.request();
        if (status.isGranted) {
          isPermission = true;
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
        }
      } else if (checkPermission.isGranted) {
        isPermission = true;
      } else if (checkPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    }
    return isPermission;
  }

  int currentSdk = 0;

  getDeviceDetails() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      currentSdk = androidDeviceInfo.version.sdkInt ?? 0;
      debugPrint("currentSdk : $currentSdk");
      update();
    }
  }

  Future<void> uploadSignatureImage(File imageFile) async {
    print(imageFile);
    print("imageFileimageFile");
    UserData? userData = await pref.getUserDetail();
    try {
      var uri = "${ApiProvider.astrologerAstroSign}${userData!.id}";
      var data = await Dio().get(uri,
          data: FormData.fromMap({
            "signFile": imageFile != null
                ? await MultipartFile.fromFile(imageFile!.path,
                    filename: imageFile.path.split('/').last)
                : null,
          }));
      print(data.data);
      print("data.data-->>${data.data}");
      AgreementModel agreementModel = AgreementModel.fromJson(data.data);
      if (agreementModel.status!.code == 200) {
        print(
            "agreementModel.data!.signLink-->>${agreementModel.data!.signLink}----${astrologerProfilePhoto}");
        savePdf(
            astrologerProfilePhoto: astrologerProfilePhoto,
            astrologerSignaturePhoto: agreementModel.data!.signLink);
      }
    } on DioException catch (e) {
      print("objectobjectobjectobject----${e}");
    }
  }

  Future<void> uploadSignaturePdf(File imageFile) async {
    UserData? userData = await pref.getUserDetail();
    try {
      var uri = "${ApiProvider.astrologerSignPdf}${userData!.id}";
      var data = await Dio().get(uri,
          data: FormData.fromMap({
            "signPdf": imageFile != null
                ? await MultipartFile.fromFile(imageFile!.path,
                    filename: imageFile.path.split('/').last)
                : null,
          }));
      print(data.data);
      print("data.uploadSignaturePdf-->>${data.data}");
      AgreementModel agreementModel = AgreementModel.fromJson(data.data);
      if (agreementModel.status!.code == 200) {
        print(
            "agreementModel.data!.signLink-->>${agreementModel.data!.signLink}");
        Get.until(
          (route) {
            return Get.currentRoute == RouteName.dashboard;
          },
        );
      }
    } on DioException catch (e) {
      print("objectobjectobjectobject----${e}");
    }
  }

  savePdf({String? astrologerProfilePhoto, astrologerSignaturePhoto}) async {
    final pdf = pw.Document();
    UserData? userData = await pref.getUserDetail();
    final profilePhoto = await networkImage(astrologerProfilePhoto!);
    final signaturePhoto = await networkImage(astrologerSignaturePhoto);
    final ceoProfilePhoto = await networkImage(
        'https://divineprod.blob.core.windows.net/divinecrm/agreement_ceo_profile_picture.jpg');
    final ceoSignaturePhoto = await networkImage(
        'https://divineprod.blob.core.windows.net/divinecrm/agreement_ceo_signature.jpg');

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          color: const PdfColor.fromInt(0xfffffff),
          height: double.infinity,
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.SizedBox(
                          height: 100,
                          width: 100,
                          child: pw.Image(
                            ceoSignaturePhoto,
                            height: 100,
                            width: 100,

                          ),
                        ),
                        pw.Divider(color: const PdfColor.fromInt(0xf000000)),
                        pw.Text(
                          "Divinetalk Director Signature",
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.SizedBox(
                          height: 100,
                          width: 100,
                          child: pw.Image(
                            ceoProfilePhoto,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        pw.Divider(color: PdfColor.fromInt(0xf000000)),
                        pw.Text(
                          "Divinetalk Director Photo",
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Column(
                children: [
                  pw.Text("Dr. Paras Ajay Shah"),
                  pw.SizedBox(
                      width: 150,
                      child: pw.Divider(
                        color: const PdfColor.fromInt(0xf000000),
                        height: 5,
                      )),
                  pw.Text(
                    "Divinetalk Director Name",
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
              pw.SizedBox(height: 100),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Container(
                          height: 100,
                          width: 100,
                          child: pw.Image(
                            signaturePhoto,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        pw.Text(
                          DateFormat("dd/mm/yyyy hh:mm a")
                              .format(DateTime.now()),
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Divider(color: const PdfColor.fromInt(0xf000000)),
                        pw.Text(
                          "Astrologer Signature",
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Container(
                          height: 100,
                          width: 100,
                          child: pw.Image(
                            profilePhoto,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        pw.Text(
                          "",
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Divider(color: const PdfColor.fromInt(0xf000000)),
                        pw.Text(
                          "Astrologer Photo",
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Column(
                children: [
                  pw.Text("${userData!.name}"),
                  pw.SizedBox(
                      width: 110,
                      child: pw.Divider(
                        color: const PdfColor.fromInt(0xf000000),
                        height: 5,
                      )),
                  pw.Text(
                    "Astrologer Name",
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );

    Directory appDocDirFolder =
        Directory('/storage/emulated/0/Download/divinetalkAstrology');
    final filePath = '${appDocDirFolder.path}/astrologer_sign_and_photo.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await uploadSignaturePdf(File(filePath));
      },
    );
  }
}
