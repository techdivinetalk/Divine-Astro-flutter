import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/hive_services.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/dashboard/dashboard_controller.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ChatMessageWithSocketController extends GetxController {
  final userRepository = Get.find<UserRepository>();
  SharedPreferenceService preferenceService = Get.find<SharedPreferenceService>();
  TextEditingController messageController = TextEditingController();
  UserData? userData = UserData();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  var chatMessages = <ChatMessage>[].obs;
  var databaseMessage = ChatMessagesOffline().obs;
  ScrollController messgeScrollController = ScrollController();
  ScrollController typingScrollController = ScrollController();
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

  // final KundliRepository? kundliRepository;
  // final ChatRepository chatRepository;
  RxString customerName = "".obs;
  RxString profileImage = "".obs;
  RxBool isDataLoad = false.obs;
  RxBool isOngoingChat = false.obs;
  RxString chatStatus = "".obs;
  DashboardController dashboardController = Get.find<DashboardController>();
  RxBool isTyping = false.obs;

  final socket = AppSocket();
  var arguments;

  Timer? _timer;

  void startTimer() {
    int _start = 5;
    if (_timer != null) {
      _timer!.cancel();
    }
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          isTyping.value = false;
        } else {
          _start--;
        }
        update();
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    arguments = Get.arguments;
    socket.startAstroCustumerSocketEvent(orderId: arguments['orderId']);
    isAstroJoinedChat();
    checkIsCustomerJoinedPrivateChat();
    typingListenerSocket();
    sendMessageListenerSocket();
  }

  void isAstroJoinedChat() {
    socket.isAstroJoinedChat((data) {
      debugPrint('private chat Joined event $data');
    });
  }

  void tyingSocket() {
    debugPrint('tyingSocket orderId:${arguments['orderId']}, userId: ${arguments['userId']}');
    socket.typingSocket(orderId: arguments['orderId'].toString(), userId: arguments['userId'].toString());
  }

  void checkIsCustomerJoinedPrivateChat() {
    socket.isCustomerJoinedChat((data) {
      debugPrint('Yes astro joined chat successfully $data');
    });
  }

  void typingListenerSocket() {
    socket.typingListenerSocket((data) {
      isTyping.value = true;
      update();
      startTimer();
      debugPrint('typingListenerSocket $data');
    });
  }

  void sendMessageSocket({required String messageType, required String message}) {
    debugPrint('sendMessageSocket $messageType $message');
    socket.sendMessageSocket(
        astroId: arguments['userId'].toString(),
        message: message,
        messageType: messageType,
        orderId: arguments['orderId']);
  }

  void sendMessageListenerSocket() {
    socket.sendMessageListenerSocket((data) {
      debugPrint('sendMessageListenerSocket $data');
    });
  }

  Future getImage(bool isCamera) async {
    pickedFile = await picker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);

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
      addNewMessage(time, "image", awsUrl: uploadFile, base64Image: base64Image, downloadedPath: outPath);
    }
  }

//Cannot end chat
  cannotEndChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Divine Customer"),
          content: const Text("You cannot end chat before 1 min."),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () async {
                Get.back();
              },
            ),
          ],
        );
      },
    );
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
                Get.back();
                //   await onEndChat();
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
        title: "${userData?.name} sent you message.",
        type: 0);

    isDataLoad.value = true;

    firebaseDatabase.ref("astrologer/${userData?.id}/realTime/engagement").set(newMessage.toOfflineJson());
    updateChatMessages(newMessage, false, isSendMessage: true);
    //Firebase node is not working.
    firebaseDatabase
        .ref("user/${currentChatUserId.value}/realTime/notification/$time")
        .set(newMessage.toOfflineJson());
  }

  updateChatMessages(ChatMessage newMessage, bool isFromNotification, {bool isSendMessage = false}) async {
    var index = chatMessages.indexWhere((element) => newMessage.id == element.id);
    if (index >= 0) {
      chatMessages[index].type = newMessage.type;
      chatMessages.refresh();
    } else {
      if (isFromNotification && messgeScrollController.hasClients) {
        if (messgeScrollController.position.pixels > messgeScrollController.position.maxScrollExtent - 100) {
          newMessage.type = 2;
          chatMessages.add(newMessage);
          //  scrollToBottomFunc();
          updateMsgDelieveredStatus(newMessage, 2);
          if (messgeScrollController.position.pixels == messgeScrollController.position.maxScrollExtent) {
            Future.delayed(const Duration(seconds: 1)).then((value) {
              //   scrollToBottomFunc();
            });
          }
        } else {
          newMessage.type = isSendMessage ? 0 : 1;
          chatMessages.add(newMessage);
          unreadMsgCount.value = chatMessages.where((e) => e.type != 2 && e.senderId != userData?.id).length;
          if (!isSendMessage) {
            updateMsgDelieveredStatus(newMessage, 1);
          }
        }
      } else {
        newMessage.type = isSendMessage ? 0 : 1;
        chatMessages.add(newMessage);
        unreadMsgCount.value = chatMessages.where((e) => e.type != 2 && e.senderId != userData?.id).length;
        if (!isSendMessage) {
          updateMsgDelieveredStatus(newMessage, 1);
        }
      }
    }
    unreadMessageIndex.value = chatMessages
            .firstWhere(
              (element) => element.type != 2 && element.senderId != userData?.id,
              orElse: () => ChatMessage(),
            )
            .id ??
        -1;
    chatMessages.refresh();
    //setHiveDatabase();
    if (!isFromNotification) {
      //  updateReadMessageStatus();
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        //    scrollToBottomFunc();
      });
    }
  }
}
