import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:divine_astrologer/common/camera.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/show_permission_widget.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:divine_astrologer/utils/utils.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class NewChatController extends GetxController {
  TextEditingController messageController = TextEditingController();
  TextEditingController reportMessageController = TextEditingController();
  ScrollController messageScrollController = ScrollController();
  ScrollController typingScrollController = ScrollController();
  final preference = Get.find<SharedPreferenceService>();
  RxString astrologerBackgroundColor = "".obs;
  RxString showTalkTime = "".obs;
  RxString extraTalkTime = "".obs;
  RecorderController? recorderController;
  RxBool isOfferVisible = false.obs;
  RxBool isRecording = false.obs;
  RxBool hasMessage = false.obs;
  RxBool isEmojiShowing = false.obs;
  Loading loading = Loading.initial;
  RxBool isAudioPlaying = false.obs;
  RxString astrologerName = "".obs;


  Duration? timeDifference;

  @override
  void onInit() {
    initialiseControllers();
    getDir();
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        scrollToBottomFunc();
      },
    );

    super.onInit();
  }

  @override
  void onClose() {
    if (recorderController != null) {
      recorderController?.dispose();
    }
    super.onClose();
  }

  /// ------------------ get All chat history  ----------------------- ///
  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;

  /// ------------------ scroll to bottom  ----------------------- ///
  scrollToBottomFunc() {
    if (messageScrollController.hasClients) {
      Timer(
        const Duration(milliseconds: 300),
        () => messageScrollController.animateTo(
          messageScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        ),
      );
    }
    update();
  }

  /// ------------------ download image  ----------------------- ///
  downloadImage(
      {required String fileName,
      required ChatMessage chatDetail,
      required int id}) async {
    var response = await http
        .get(Uri.parse("${preference.getAmazonUrl()}${chatDetail.awsUrl}"));

    if (response.statusCode == HttpStatus.unauthorized) {
      Utils().handleStatusCodeUnauthorizedServer();
    } else if (response.statusCode == HttpStatus.badRequest) {
      Utils().handleStatusCode400(response.body);
    }
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName =
        "${documentDirectory.path}/images/${chatDetail.id}.jpg";

    await Directory(firstPath).create(recursive: true);
    File file2 = File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    print("chat download path $filePathAndName");
    // int index = chatMessages.indexWhere((element) {
    //   return element.id == id;
    // });
    // chatMessages[index].downloadedPath = filePathAndName;
    // chatMessages.refresh();
    // write code
    update();
  }

  /// ------------------ audio recording func ----------------------- ///
  bool isRecordingCompleted = false;

  void startOrStopRecording() async {
    try {
      print("is working");
      if (isRecording.value) {
        recorderController!.reset();
        print(isRecording.value);
        print("isRecording.value");

        final path = await recorderController!.stop(false);
        print(path);
        print("pathpathpathpathpath");
        if (path != null) {
          isRecordingCompleted = true;
          uploadAudioFile(File(path));
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }
      } else {
        await recorderController!.record(path: path);
      }

      update();
    } catch (e) {
      print("failed to record ===== ${e}");
      debugPrint(e.toString());
    } finally {
      print("finally record");
      isRecording.value = !isRecording.value;
      update();
    }
  }

  Directory? appDirectory;
  String path = "";

  void getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory!.path}/recording.m4a";
    update();
  }

  void refreshWave() {
    if (isRecording.value) {
      recorderController!.stop(true);
      isRecording.value = false;
      update();
    }
  }

  uploadAudioFile(File soundFile) async {
    try {
      String time = ("${DateTime.now().millisecondsSinceEpoch ~/ 1000}");
      var uploadFile =
          await uploadImageFileToAws(file: soundFile, moduleName: "chat");
      if (uploadFile != "" && uploadFile != null) {
        print("is uploaded the file from recorder");

        /// write logic for send audio msg

        // addNewMessage(time, MsgType.audio, awsUrl: uploadFile); <===== old code
      } else {}
    } catch (e) {
      print("getting error while sending audio ${e}");
    }
  }

  void initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
    update();
  }

  /// ------------------ image sending func ----------------------- ///
  bool isGalleryOpen = false;
  File? image;

  XFile? pickedFile;

  Future getImage(bool isCamera) async {
    isGalleryOpen = true;
    print("openGallery isGalleryOpen");
    final bool result = await permissionPhotoOrStorage();
    print("photo permission $result");
    if (result) {
      if (isCamera) {
        List<CameraDescription> cameras = await availableCameras();
        await Get.to<String?>(
          () => CameraPage(cameras: cameras),
        );
        print(
            'Image path received in Page A: ${AppFirebaseService().imagePath}');
        if (AppFirebaseService().imagePath != "") {
          print('Image-in');
          image = File(AppFirebaseService().imagePath);
          await cropImage();
        }
      } else {
        pickedFile = await ImagePicker().pickImage(
            source: isCamera ? ImageSource.camera : ImageSource.gallery);
        if (pickedFile != null) {
          image = File(pickedFile!.path);
          // isDataLoad.value = false;
          await cropImage();
        }
      }
    } else {
      await showPermissionDialog(
        permissionName: 'Gallery permission',
        isForOverlayPermission: false,
      );
    }
  }

  cropImage() async {
    isGalleryOpen = true;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "Send Photo",
            toolbarColor: appColors.white,
            toolbarWidgetColor: appColors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: "Send Photo",
        ),
      ],
    );
    if (croppedFile != null) {
      File uploadFile = File(croppedFile.path);
      final filePath = uploadFile!.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r".png|.jp"));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 500,
      );
      print("cropped file step reached");
      if (result != null) {
        getBase64Image(File(result.path));
      }
    } else {
      //    isDataLoad.value = true;
      debugPrint("Image is not cropped.");
    }
  }

  getBase64Image(File fileData) async {
    print("IMAGE STEP UPLOAD 1");
    final filePath = fileData.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r".png|.jp"));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minWidth: 20,
    );
    List<int> imageBytes = File(result!.path).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    print("IMAGE STEP UPLOAD 2");
    // print("IMAGE STEP UPLOAD 2 ${fileData.path}");
    String time = ("${DateTime.now().millisecondsSinceEpoch ~/ 1000}");
    var uploadFile = await uploadImageFileToAws(
        file: File(fileData.path), moduleName: "chat");
    print("IMAGE STEP UPLOAD 3 $uploadFile");
    if (uploadFile != null || uploadFile != "") {
      /// write a code for sending image
    } else {
      // addNewMessage(time, "image", awsUrl: uploadFile, base64Image: base64Image, downloadedPath: outPath);
    }
  }

  /// ------------------ permission photo or storage ----------------------- ///
  Future<bool> permissionPhotoOrStorage() async {
    bool perm = false;
    if (Platform.isIOS) {
      perm = await permissionPhotos();
    } else if (Platform.isAndroid) {
      final AndroidDeviceInfo android = await DeviceInfoPlugin().androidInfo;
      final int sdkInt = android.version.sdkInt;
      perm = sdkInt > 32 ? await permissionPhotos() : await permissionStorage();
    } else {}
    return Future<bool>.value(perm);
  }

  Future<bool> permissionPhotos() async {
    bool hasPhotosPermission = false;
    final PermissionStatus try0 = await Permission.photos.status;
    if (try0 == PermissionStatus.granted) {
      hasPhotosPermission = true;
    } else {
      final PermissionStatus try1 = await Permission.photos.request();
      if (try1 == PermissionStatus.granted) {
        hasPhotosPermission = true;
      } else {}
    }
    return Future<bool>.value(hasPhotosPermission);
  }

  Future<bool> permissionStorage() async {
    bool hasStoragePermission = false;
    final PermissionStatus try0 = await Permission.storage.status;
    if (try0 == PermissionStatus.granted) {
      hasStoragePermission = true;
    } else {
      final PermissionStatus try1 = await Permission.storage.request();
      if (try1 == PermissionStatus.granted) {
        hasStoragePermission = true;
      } else {}
    }
    return Future<bool>.value(hasStoragePermission);
  }
}
