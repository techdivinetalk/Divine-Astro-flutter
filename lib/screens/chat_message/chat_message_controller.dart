// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:divine_astrologer/model/res_login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../di/hive_services.dart';
import '../../di/shared_preference_service.dart';
import '../../model/chat_offline_model.dart';
import '../../repository/user_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../live_page/constant.dart';

class ChatMessageController extends GetxController {
  final UserRepository userRepository = Get.find<UserRepository>();
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  TextEditingController messageController = TextEditingController();
  UserData? userData = UserData();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  var chatMessages = <ChatMessage>[].obs;
  var databaseMessage = ChatMessagesOffline().obs;
  ScrollController messgeScrollController = ScrollController();
  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;
  final preference = Get.find<SharedPreferenceService>();
  RxInt currentUserId = 8601.obs;
  String userDataKey = "userKey";
  bool sendReadMessageStatus = false;
  RxBool emojiShowing = true.obs;
  FocusNode msgFocus = FocusNode();
  RxInt unreadMessageIndex = 0.obs;
  RxBool scrollToBottom = false.obs;
  HiveServices hiveServices = HiveServices(boxName: userChatData);
  RxInt unreadMsgCount = 0.obs;
  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      if (Get.arguments is bool) {
        sendReadMessageStatus = true;
      }
    }
    userData = preferenceService.getUserDetail();
    currentUserId.value = 8601;
    userDataKey = "userKey_${userData?.id}_$currentUserId";
    getChatList();

    msgFocus.addListener(() {
      if (msgFocus.hasFocus) {
        emojiShowing.value = true;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      scrollToBottomFunc();
    });
  }

  scrollToBottomFunc() {
    messgeScrollController.animateTo(
        messgeScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut);
  }

  getChatList() async {
    chatMessages.clear();
    await hiveServices.initialize();
    var res = await hiveServices.getData(key: userDataKey);
    if (res != null) {
      var msg = ChatMessagesOffline.fromOfflineJson(jsonDecode(res));
      chatMessages.value = msg.chatMessages ?? [];
      if (sendReadMessageStatus) {
        unreadMessageIndex.value = chatMessages
                .firstWhere(
                    (element) =>
                        element.type != 2 && element.senderId != userData?.id,
                    orElse: () => ChatMessage())
                .id ??
            -1;
        if (unreadMessageIndex.value != -1) {
          updateReadMessageStatus();
        } else {}
      }
    }
  }

  updateReadMessageStatus() async {
    for (int i = 0; i < chatMessages.length; i++) {
      if (chatMessages[i].type != 2) {
        updateMsgDelieveredStatus(chatMessages[i], 2);
        chatMessages[i].type = 2;
      }
    }
    databaseMessage.value.chatMessages = chatMessages;
    unreadMsgCount.value = 0;
    await hiveServices.addData(
        key: userDataKey,
        data: jsonEncode(databaseMessage.value.toOfflineJson()));
    Future.delayed(const Duration(seconds: 1))
        .then((value) => unreadMessageIndex.value = -1);
  }

  sendMsg() {
    if (messageController.text.trim().isNotEmpty) {
      var time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
      // type 1= New chat message, 2 = Delievered, 3= Msg read, 4= Other messages
      addNewMessage(time, "text", messageText: messageController.text.trim());
      messageController.clear();
    }
  }

  addNewMessage(String time, String? msgType,
      {String? messageText,
      String? awsUrl,
      String? base64Image,
      String? downloadedPath,
      String? kundliId}) async {
    var newMessage = ChatMessage(
        id: int.parse(time),
        message: messageText,
        receiverId: 8601,
        senderId: 573,
        time: int.parse(time),
        awsUrl: awsUrl,
        base64Image: base64Image,
        downloadedPath: downloadedPath,
        msgType: msgType,
        kundliId: kundliId,
        type: 0);
    updateChatMessages(newMessage, false);

    firebaseDatabase
        .ref("user/8601/realTime/notification/$time")
        .set(newMessage.toOfflineJson());
  }

  updateChatMessages(ChatMessage newMessage, bool isFromNotification) async {
    var index =
        chatMessages.indexWhere((element) => newMessage.id == element.id);
    if (index >= 0) {
      chatMessages[index].type = newMessage.type;
      chatMessages.refresh();
    } else {
      if (isFromNotification &&
          messgeScrollController.position.pixels >
              messgeScrollController.position.maxScrollExtent - 100) {
        newMessage.type = 2;
        chatMessages.add(newMessage);

        updateMsgDelieveredStatus(newMessage, 2);
        scrollToBottomFunc();
      } else {
        newMessage.type = 1;
        chatMessages.add(newMessage);
        unreadMsgCount.value = chatMessages
            .where((e) => e.type != 2 && e.senderId != userData?.id)
            .length;
        updateMsgDelieveredStatus(newMessage, 1);
      }
    }
    unreadMessageIndex.value = chatMessages
            .firstWhere(
              (element) =>
                  element.type != 2 && element.senderId != userData?.id,
              orElse: () => ChatMessage(),
            )
            .id ??
        -1;
    setHiveDatabase();
    if (!isFromNotification) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        scrollToBottomFunc();
      });
    }
  }

  void setHiveDatabase() async {
    var userDataKey = "userKey_${userData?.id}_$currentUserId";
    HiveServices hiveServices = HiveServices(boxName: userChatData);
    await hiveServices.initialize();
    databaseMessage.value.chatMessages = chatMessages;
    await hiveServices.addData(
        key: userDataKey,
        data: jsonEncode(databaseMessage.value.toOfflineJson()));
  }

//MARK: Download image
  downloadImage(
      {required String fileName,
      required ChatMessage chatDetail,
      required int index}) async {
    var response = await http.get(Uri.parse(chatDetail.awsUrl!));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName =
        '${documentDirectory.path}/images/${chatDetail.id}.jpg';

    await Directory(firstPath).create(recursive: true);
    File file2 = File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    chatMessages[index].downloadedPath = filePathAndName;
    chatMessages.refresh();
    setHiveDatabase();
  }

//MARK: Upload image
  Future getImage(bool isCamera) async {
    pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile!.path);

      await cropImage();
    }
  }

  cropImage() async {
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
            toolbarTitle: 'Update image',
            toolbarColor: AppColors.white,
            toolbarWidgetColor: AppColors.blackColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Update image',
        ),
      ],
    );
    if (croppedFile != null) {
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
        getBase64Image(File(result.path));
      }
    } else {
      debugPrint("Image is not cropped.");
    }
  }

  getBase64Image(File fileData) async {
    final filePath = fileData.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minWidth: 20,
    );
    List<int> imageBytes = File(result!.path).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    String time = ("${DateTime.now().millisecondsSinceEpoch ~/ 1000}");

    var uploadFile = await uploadImageToS3Bucket(File(fileData.path), time);
    if (uploadFile != "") {
      addNewMessage(time, "image",
          awsUrl: uploadFile,
          base64Image: base64Image,
          downloadedPath: outPath);
    }
  }
}
