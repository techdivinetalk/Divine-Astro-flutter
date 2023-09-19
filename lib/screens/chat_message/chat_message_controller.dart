// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:divine_astrologer/model/chat/req_common_chat_model.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:divine_astrologer/screens/dashboard/dashboard_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../di/api_provider.dart';
import '../../di/hive_services.dart';
import '../../di/shared_preference_service.dart';
import '../../model/chat/chat_socket/chat_socket_init.dart';
import '../../model/chat/res_astro_chat_listener.dart';
import '../../model/chat/res_common_chat_success.dart';
import '../../model/chat_offline_model.dart';
import '../../repository/chat_repository.dart';
import '../../repository/kundli_repository.dart';
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
  RxInt currentUserId = 0.obs;
  String userDataKey = "userKey";
  bool sendReadMessageStatus = false;
  RxBool isEmojiShowing = false.obs;
  // FocusNode msgFocus = FocusNode();
  RxInt unreadMessageIndex = 0.obs;
  RxBool scrollToBottom = false.obs;
  HiveServices hiveServices = HiveServices(boxName: userChatData);
  RxInt unreadMsgCount = 0.obs;
  ChatMessageController(this.kundliRepository, this.chatRepository);
  final KundliRepository? kundliRepository;
  final ChatRepository chatRepository;
  RxString customerName = "".obs;
  RxString profileImage = "".obs;
  RxBool isDataLoad = false.obs;
  RxBool isOngoingChat = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      if (Get.arguments is bool) {
        sendReadMessageStatus = true;
      } else if (Get.arguments is ResAstroChatListener) {
        isOngoingChat.value = true;
        var data = Get.arguments;
        currentChatUserId.value = data!.customerId;
        currentUserId.value = data!.customerId;
        customerName.value = data!.customeName ?? "";
        profileImage.value =
            "${preference.getBaseImageURL()}/${data!.customerImage}";
        if (astroChatWatcher.value.orderId != null) {
          timer.startMinuteTimer(astroChatWatcher.value.talktime ?? 0,
              astroChatWatcher.value.orderId!);
        }
      }
    }
    userData = preferenceService.getUserDetail();
    // currentUserId.value = 0;
    // currentChatUserId.value = 0;
    userDataKey = "userKey_${userData?.id}_${currentUserId.value}";
    getChatList();
    chatSocketInit();
    // msgFocus.addListener(() {
    //   if (msgFocus.hasFocus) {
    //     emojiShowing.value = true;
    //   }
    // });
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      scrollToBottomFunc();
    });
  }

  scrollToBottomFunc() {
    messgeScrollController.hasClients
        ? messgeScrollController.animateTo(
            messgeScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut)
        : null;
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
    } else {
      // Map<String, int> params = {"customer_id": currentUserId.value};
      // var response = await chatRepository.getChatListApi(params);
      // debugPrint("$response");
    }
    isDataLoad.value = true;
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
        orderId: astroChatWatcher.value.orderId,
        id: int.parse(time),
        message: messageText,
        receiverId: currentUserId.value,
        senderId: userData?.id,
        time: int.parse(time),
        awsUrl: awsUrl,
        base64Image: base64Image,
        downloadedPath: downloadedPath,
        msgType: msgType,
        kundliId: kundliId,
        type: 0);
    updateChatMessages(newMessage, false);
    isDataLoad.value = true;

    firebaseDatabase
        .ref("user/${currentChatUserId.value}/realTime/notification/$time")
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
        scrollToBottomFunc();
        updateMsgDelieveredStatus(newMessage, 2);
        if (messgeScrollController.position.pixels ==
            messgeScrollController.position.maxScrollExtent) {
          Future.delayed(const Duration(seconds: 1)).then((value) {
            scrollToBottomFunc();
          });
        }
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
      // updateReadMessageStatus();
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        scrollToBottomFunc();
      });
    }
  }

  void setHiveDatabase() async {
    var userDataKey = "userKey_${userData?.id}_${currentUserId.value}";
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
      isDataLoad.value = false;
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
      isDataLoad.value = true;
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

//End Chat
  confirmChatEnd(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Divine Astrologer"),
          content: const Text("Are you sure you want to end this chat?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                isDataLoad.value = false;
                isOngoingChat.value = false;
                Get.back();
                await onEndChat();
                isDataLoad.value = true;
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () async {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}

chatSocketInit() {
  DashboardController dashboardController = Get.find<DashboardController>();
  dashboardController.socket?.emit(ApiProvider().initChat, {
    "requestFrom": 'astrologer',
    "userId": userData?.id.toString(),
    "userSocketId": dashboardController.socket?.id ?? ''
  });
  dashboardController.socket?.on(ApiProvider().initChatResponse, (data) {
    ResChatSocketInit.fromJson(data);
    chatSession.value = ResChatSocketInit.fromJson(data);
    debugPrint("Chat session ${chatSession.value}");
  });
}

onEndChat() async {
  timer.stopTimer();
  if (astroChatWatcher.value.orderId != 0 &&
      astroChatWatcher.value.orderId != null) {
    ResCommonChatStatus response = await ChatRepository().endChat(
        ReqCommonChatParams(
                orderId: astroChatWatcher.value.orderId,
                queueId: astroChatWatcher.value.queueId)
            .toJson());
    if (response.statusCode == 200) {
      divineSnackBar(data: "Chat ended.", color: AppColors.redColor);
    } else {
      divineSnackBar(data: "Chat has been ended.", color: AppColors.redColor);
    }
  }
}
