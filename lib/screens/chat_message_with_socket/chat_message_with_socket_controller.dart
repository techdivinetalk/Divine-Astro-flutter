import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/di/hive_services.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/chat/res_astro_chat_listener.dart';
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

import '../../common/common_functions.dart';

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
    socket.startAstroCustumerSocketEvent(orderId: arguments['orderId'],userId:arguments['userId']);
    isAstroJoinedChat();
    checkIsCustomerJoinedPrivateChat();
    typingListenerSocket();
    sendMessageSocketListenerSocket();
    sendMessageListenerSocket();

    if (Get.arguments != null) {
      if (Get.arguments is ResAstroChatListener) {
        sendReadMessageStatus = true;
        var data = Get.arguments;
        if (data!.customerId != null) {
          chatStatus.value = "Chat in - Progress";
          isOngoingChat.value = true;
          currentChatUserId.value = data!.customerId;
          currentUserId.value = data!.customerId;
          customerName.value = data!.customeName ?? "";
          profileImage.value =
              data!.customerImage != null ? "${preference.getBaseImageURL()}/${data!.customerImage}" : "";
          if (astroChatWatcher.value.orderId != null) {
            timer.startMinuteTimer(astroChatWatcher.value.talktime ?? 0, astroChatWatcher.value.orderId!);
          }
        }
      }
    }
    userData = preferenceService.getUserDetail();

    userDataKey = "userKey_${userData?.id}_${currentUserId.value}";
    getChatList();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      scrollToBottomFunc();
    });
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
      if (data['typist'].toString() != userData!.id.toString()) {
        isTyping.value = true;
        update();
        startTimer();
        debugPrint('typingListenerSocket $data');
      }
    });
  }

  void sendMessageSocketListenerSocket(){
    socket.sendMessageSocketListenerSocket((data) {
      debugPrint('sendMessageSocketListenerSocket $data');
    });
  }

  void sendMessageListenerSocket() {
    socket.sendMessageListenerSocket((data) {
      debugPrint('sendMessageListenerSocket $data');
      if (data is Map<String, dynamic>) {
        isTyping.value = false;
        var chatMessage = ChatMessage.fromOfflineJson(data['data']);
        updateChatMessages(chatMessage, false, isSendMessage: false);
      }
      debugPrint('chatMessage.value.length ${chatMessages.length}');
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
        orderId: int.parse(arguments['orderId'].toString()),
        id: int.parse(time),
        message: messageText,
        receiverId: int.parse(arguments['userId'].toString()),
        senderId: preference.getUserDetail()!.id,
        time: int.parse(time),
        awsUrl: awsUrl,
        base64Image: base64Image,
        downloadedPath: downloadedPath,
        msgType: msgType,
        kundliId: kundliId,
        title: "${userData?.name} sent you message.",
        type: 0,
        userType:"astrologer"
      );
    socket.sendMessageSocket(newMessage);
    updateChatMessages(newMessage,false,isSendMessage: true);
    isDataLoad.value = true;
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
          scrollToBottomFunc();
          updateMsgDelieveredStatus(newMessage, 2);
          if (messgeScrollController.position.pixels == messgeScrollController.position.maxScrollExtent) {
            Future.delayed(const Duration(seconds: 1)).then((value) {
              scrollToBottomFunc();
            });
          }
        } else {
          newMessage.type = isSendMessage ? 0 : 1;
          chatMessages.add(newMessage);
          unreadMsgCount.value =
              chatMessages.where((e) => e.type != 2 && e.senderId != preference.getUserDetail()!.id).length;
          if (!isSendMessage) {
            updateMsgDelieveredStatus(newMessage, 1);
          }
        }
      } else {
        newMessage.type = isSendMessage ? 0 : 1;
        chatMessages.add(newMessage);
        unreadMsgCount.value =
            chatMessages.where((e) => e.type != 2 && e.senderId != preference.getUserDetail()!.id).length;
        if (!isSendMessage) {
          updateMsgDelieveredStatus(newMessage, 1);
        }
      }
    }
    unreadMessageIndex.value = chatMessages
            .firstWhere(
              (element) => element.type != 2 && element.senderId != preference.getUserDetail()!.id,
              orElse: () => ChatMessage(),
            )
            .id ??
        -1;
    chatMessages.refresh();
    setHiveDataDatabase();
    if (!isFromNotification) {
      updateReadMessageStatus();
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        scrollToBottomFunc();
      });
    }
  }

  void setHiveDataDatabase() async {
    var userDataKey = "userKey_${userData?.id}_${currentUserId.value}";
    HiveServices hiveServices = HiveServices(boxName: userChatData);
    await hiveServices.initialize();
    databaseMessage.value.chatMessages = chatMessages;
    await hiveServices.addData(key: userDataKey, data: jsonEncode(databaseMessage.value.toOfflineJson()));
  }

  scrollToBottomFunc() {
    messgeScrollController.hasClients
        ? messgeScrollController.animateTo(messgeScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 600), curve: Curves.easeOut)
        : null;
  }

  updateReadMessageStatus() async {
    for (int i = 0; i < chatMessages.length; i++) {
      if (chatMessages[i].type != 2 && chatMessages[i].senderId != preference.getUserDetail()!.id) {
        updateMsgDelieveredStatus(chatMessages[i], 2);
        chatMessages[i].type = 2;
      }
    }
    databaseMessage.value.chatMessages = chatMessages;
    unreadMsgCount.value = 0;
    chatMessages.refresh();
    await hiveServices.addData(key: userDataKey, data: jsonEncode(databaseMessage.value.toOfflineJson()));
    Future.delayed(const Duration(seconds: 1)).then((value) => unreadMessageIndex.value = -1);
  }

  sendMsg() {
    if (messageController.text.trim().isNotEmpty) {
      var time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
      // type 1= New chat message, 2 = Delievered, 3= Msg read, 4= Other messages
      unreadMessageIndex.value = -1;
      addNewMessage(time, "text", messageText: messageController.text.trim());
      messageController.clear();
    }
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
                .firstWhere((element) => element.type != 2 && element.senderId != userData?.id,
                    orElse: () => ChatMessage())
                .id ??
            -1;
        if (unreadMessageIndex.value != -1) {
          updateReadMessageStatus();
        }
      }
    } else {
      // Map<String, int> params = {"customer_id": currentUserId.value};
      // var response = await chatRepository.getChatListApi(params);
      // debugPrint("$response");
    }
    isDataLoad.value = true;
  }
}
