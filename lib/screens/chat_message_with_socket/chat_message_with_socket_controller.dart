import "dart:async";
import "dart:collection";
import "dart:convert";
import "dart:developer";
import "dart:io";
import "dart:typed_data";

import "package:divine_astrologer/app_socket/app_socket.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/routes.dart";
import "package:divine_astrologer/di/hive_services.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/model/chat_offline_model.dart";
import "package:divine_astrologer/model/res_login.dart";
import "package:divine_astrologer/repository/message_template_repository.dart";
import "package:divine_astrologer/repository/user_repository.dart";
import "package:divine_astrologer/screens/dashboard/dashboard_controller.dart";
import "package:divine_astrologer/screens/live_page/constant.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";
import "package:http/http.dart" as http;
import "package:image_cropper/image_cropper.dart";
import "package:image_picker/image_picker.dart";
import "package:path_provider/path_provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:socket_io_client/socket_io_client.dart";
import "package:velocity_x/velocity_x.dart";

import "../../common/ask_for_gift_bottom_sheet.dart";
import "../../common/common_functions.dart";
import "../../firebase_service/firebase_service.dart";
import "../../model/astrologer_gift_response.dart";
import "../../model/message_template_response.dart";
import "../../model/tarot_response.dart";
import "../live_dharam/gifts_singleton.dart";
import "package:divine_astrologer/zego_call/zego_service.dart";

class ChatMessageWithSocketController extends GetxController
    with WidgetsBindingObserver {
  final UserRepository userRepository = Get.find<UserRepository>();
  final MessageTemplateRepo messageTemplateRepository =
      Get.put(MessageTemplateRepo());
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  TextEditingController messageController = TextEditingController();
  UserData? userData = UserData();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  Rx<ChatMessagesOffline> databaseMessage = ChatMessagesOffline().obs;
  ScrollController messgeScrollController = ScrollController();
  ScrollController typingScrollController = ScrollController();
  File? image;
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;
  final SharedPreferenceService preference =
      Get.find<SharedPreferenceService>();
  RxInt currentUserId = 0.obs;
  String userDataKey = "";
  bool sendReadMessageStatus = false;
  RxBool isEmojiShowing = false.obs;
  Rx<String> showTalkTime = "".obs;

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
  RxString chatStatus = "Offline".obs;
  DashboardController dashboardController = Get.find<DashboardController>();
  RxBool isTyping = false.obs;
  BroadcastReceiver broadcastReceiver = BroadcastReceiver(
      names: <String>["EndChat", "deliveredMsg", "updateTime","displayCard"]);

  RxList<MessageTemplates> messageTemplates = <MessageTemplates>[].obs;

  final AppSocket socket = AppSocket();
  var arguments;

  Timer? _timer;

  Rx<bool> isRecording = false.obs;
  Rx<bool> hasMessage = false.obs;

  void startTimer() {
    int _start = 5;
    if (_timer != null) {
      _timer!.cancel();
    }
    const Duration oneSec = Duration(seconds: 1);
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

  _onMessageChanged() {
    hasMessage.value = messageController.text.isNotEmpty;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        socket.socketConnect();

        break;
      case AppLifecycleState.inactive:
        debugPrint("App Inactive");
        break;
      case AppLifecycleState.paused:
        debugPrint("App Paused");
        break;
      case AppLifecycleState.detached:
        debugPrint("App Detached");
        break;
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
  var isCardVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    arguments = Get.arguments;
    broadcastReceiver.start();
    broadcastReceiver.messages.listen((BroadcastMessage event) {
      if (event.name == "displayCard") {
        isCardVisible.value = AppFirebaseService().orderData.value["card"]
        ["isCardVisible"];
      }
      if (event.name == "updateTime") {
        debugPrint("talkTime hello: ${event.data?["talktime"]}");
        updateTime(event.data?["talktime"], true);
      }
      if (event.name == "EndChat") {
        Get.offAllNamed(RouteName.dashboard);
        broadcastReceiver.stop();
      } else if (event.name == 'deliveredMsg') {
        var response = event.data?['deliveredMsgList'];
        response.forEach((key, value) {
          value.forEach((innerKey, innerValue) {
            print(
                'deliveredData Outer Key: $key, Inner Key: $innerKey, Value: $innerValue');
            var index = chatMessages
                .indexWhere((element) => innerKey == element.id.toString());
            if (index >= 0) {
              chatMessages[index].type = innerValue;
              chatMessages.refresh();
            }
          });
        });
        FirebaseDatabase.instance
            .ref(
                "astrologer/${preferenceService.getUserDetail()!.id}/realTime/deliveredMsg/${int.parse(arguments["orderData"]["userId"].toString())}")
            .remove();
      }
    });
    debugPrint("arguments of socket $arguments");
    messageController.addListener(_onMessageChanged);
    getMessageTemplates();
    isAstroJoinedChat();
    checkIsCustomerJoinedPrivateChat();
    typingListenerSocket();
    sendMessageSocketListenerSocket();
    listenerMessageStatusSocket();
    sendMessageListenerSocket();
    userLeavePrivateChatListenerSocket();
    customerLeavedPrivateChatListenerSocket();

    if (Get.arguments != null) {
      final data = Get.arguments;
      debugPrint("data------> ${data.toString()}");
      socket.startAstroCustumerSocketEvent(
        orderId: data["orderData"]["orderId"].toString(),
        userId: data["orderData"]["userId"],
      );
      //  if (Get.arguments is ResAstroChatListener) {
      sendReadMessageStatus = true;
      // if (data!.customerId != null) {
      chatStatus.value = "Chat in - Progress";
      isOngoingChat.value = true;
      //  currentChatUserId.value = data['userId'];
      currentUserId.value = int.parse(data["orderData"]['userId'].toString());
      customerName.value = data["orderData"]["customerName"] ?? "";
      profileImage.value = data["orderData"]["customerImage"] != null
          ? "${preference.getBaseImageURL()}/${data['orderData']['customerImage']}"
          : "";
      if (astroChatWatcher.value.orderId != null) {
        timer.startMinuteTimer(astroChatWatcher.value.talktime ?? 0,
            astroChatWatcher.value.orderId!);
      }
      //  }
      // }
      updateTime(data["orderData"]["talktime"], false);

      // if (data["orderData"]["talktime"] != null) {
      //   if (preferenceService.getTalkTime() == 0) {
      //     final int talkTime =
      //         int.parse((data["orderData"]["talktime"] ?? 0).toString()) +
      //             (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
      //     debugPrint(
      //         "millisecondsSinceEpoch ----> ${DateTime.now().millisecondsSinceEpoch ~/ 1000}");
      //     preferenceService.setTalkTime(talkTime);
      //   } else {
      //     debugPrint("else part - ${preferenceService.getTalkTime() ?? 0}");
      //   }
      //   //   FirebaseDatabase.instance.ref('order/$orderId/talktime').remove();
      // }
      //
      // if (preferenceService.getTalkTime() != null) {
      //   talkTimeStartTimer(preferenceService.getTalkTime() ?? 0);
      // }
    }
    userData = preferenceService.getUserDetail();

    userDataKey = "chat_${currentUserId.value}";
    getChatList();
    socketReconnect();
  }

  updateTime(int? talk, bool isTimeUpdate) {
    debugPrint('my talk: $talk');
    if (talk != null) {
      if (isTimeUpdate) {
        final int talkTime =
            talk + (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
        debugPrint(
            "millisecondsSinceEpoch ----> ${DateTime.now().millisecondsSinceEpoch ~/ 1000}");
        preferenceService.setTalkTime(talkTime);
      } else {
        if (preferenceService.getTalkTime() == 0) {
          final int talkTime =
              talk + (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
          debugPrint(
              "millisecondsSinceEpoch ----> ${DateTime.now().millisecondsSinceEpoch ~/ 1000}");
          preferenceService.setTalkTime(talkTime);
        } else {
          debugPrint("else part - ${preferenceService.getTalkTime() ?? 0}");
        }
      }
    }

    if (preferenceService.getTalkTime() != null) {
      debugPrint('prfs time: ${preferenceService.getTalkTime()}');
      if (_timer?.isActive ?? false) {
        debugPrint('timer is not null');
        _timer!.cancel();
        _timer = null;
      }
      talkTimeStartTimer(preferenceService.getTalkTime() ?? 0);
    }
  }

  getMessageTemplates() async {
    try {
      final response = await messageTemplateRepository.fetchTemplates();
      if (response.data != null) {
        messageTemplates.value = response.data!;
        //await preferenceService.saveMessageTemplates(response.toPrettyString());
      }
      //MessageTemplateResponse? res = preferenceService.getMessageTemplates();
      //debugPrint('res: ${res?.data?.length}');
      //loading = Loading.loaded;
      update();
    } catch (error) {
      divineSnackBar(data: error.toString(), color: AppColors.redColor);
    }
  }

  void talkTimeStartTimer(int talkTime) {
    const Duration oneSecond = Duration(seconds: 1);
    final DateTime futureTime =
        DateTime.fromMillisecondsSinceEpoch(talkTime * 1000);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      final DateTime now = DateTime.now();
      final Duration difference = futureTime.difference(now);

      if (difference.isNegative) {
        timer.cancel();
        showTalkTime.value = "000:00 min Remaining";
      } else {
        final int remainingHours = difference.inHours;
        final int remainingMinutes = difference.inMinutes.remainder(60);
        final int remainingSeconds = difference.inSeconds.remainder(60);

        final String hoursString = remainingHours.toString().padLeft(2, "0");
        final String minutesString =
            remainingMinutes.toString().padLeft(2, "0");
        final String secondsString =
            remainingSeconds.toString().padLeft(2, "0");

        showTalkTime.value =
            "$hoursString:$minutesString:$secondsString Remaining";
      }
    });
  }

  socketReconnect() {
    if (socket.socket!.disconnected) {
      socket.socket
        ?..disconnect()
        ..connect();
    }
    socket.socket!.onConnect((_) {
      socket.startAstroCustumerSocketEvent(
        orderId: arguments["orderData"]["orderId"].toString(),
        userId: arguments["orderData"]["userId"],
      );
      log("Socket startAstroCustumerSocketEvent connected successfully");
    });
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 600)).then((value) async {
      scrollToBottomFunc();
      await ZegoService().canInit();
    });
  }

  void isAstroJoinedChat() {
    socket.isAstroJoinedChat((data) {
      debugPrint("private chat Joined event $data");
    });
  }

  void tyingSocket() {
    debugPrint(
      'tyingSocket orderId:${arguments['orderData']['orderId'].toString()}, userId: ${arguments['orderData']['userId']}',
    );
    socket.typingSocket(
      orderId: arguments["orderData"]["orderId"].toString(),
      userId: arguments["orderData"]["userId"].toString(),
    );
  }

  void checkIsCustomerJoinedPrivateChat() {
    socket.isCustomerJoinedChat((data) {
      debugPrint("Yes astro joined chat successfully $data");
      chatStatus.value = "Chat in - Progress";
    });
  }

  void typingListenerSocket() {
    socket.typingListenerSocket((data) {
      debugPrint('data ........ ${data}');
      debugPrint(
          '${data['data']["typist"].toString()}  ${arguments["orderData"]["userId"].toString()}');
      if (data['data']["typist"].toString() ==
          arguments["orderData"]["userId"].toString()) {
        isTyping.value = true;
        chatStatus.value = "Typing";
        //  scrollToBottomFunc();
        // startTimer();
      }
    });
  }

  void sendMessageSocketListenerSocket() {
    socket.sendMessageSocketListenerSocket((data) {
      debugPrint("sendMessageSocketListenerSocket $data");
    });
  }

  void listenerMessageStatusSocket() {
    socket.listenerMessageStatusSocket((data) {
      debugPrint("listenerMessageStatusSocket $data");

      final int index = chatMessages.indexWhere((ChatMessage element) {
        return element.id.toString() ==
            data['data']["chatMessageId"].toString();
      });

      if (index != -1) {
        chatMessages[index].type = 3;
        chatMessages.refresh();
        debugPrint(
          "listenerMessageStatusSocket ${chatMessages[index].id} type---->  ${chatMessages[index].type}",
        );
      } else {
        debugPrint(
            "listenerMessageStatusSocket: Element not found in chatMessages");
      }
    });
  }

  void sendMessageListenerSocket() {
    socket.sendMessageListenerSocket((data) {
      debugPrint("sendMessageListenerSocket $data");
      if (data is Map<String, dynamic>) {
        isTyping.value = false;
        chatStatus.value = "Chat in - Progress";
        final ChatMessage chatMessage =
        ChatMessage.fromOfflineJson(data["data"]);
        final String time = "${DateTime
            .now()
            .millisecondsSinceEpoch ~/ 1000}";
         if (data["data"]["receiverId"] ==
             preferenceService.getUserDetail()!.id.toString()) {
           if(chatMessage.msgType == "sendGifts"){

           }
        socket.messageReceivedStatusUpdate(
          receiverId: preferenceService.getUserDetail()!.id.toString(),
          chatMessageId: chatMessage.id.toString(),
          chatStatus: "read",
          time: time,
          orderId: arguments["orderData"]["orderId"].toString(),
        );
      }
          updateChatMessages(chatMessage, false, isSendMessage: false);
        //}
      }
      debugPrint("chatMessage.value.length ${chatMessages.length}");
    });
  }

  Future getImage(bool isCamera) async {
    pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile!.path);
      isDataLoad.value = false;
      await cropImage();
    }
  }

  Future<void> cropImage() async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: <CropAspectRatioPreset>[
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          toolbarTitle: "Update image",
          toolbarColor: AppColors.white,
          toolbarWidgetColor: AppColors.blackColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: "Update image"),
      ],
    );
    if (croppedFile != null) {
      uploadFile = File(croppedFile.path);
      final String filePath = uploadFile!.absolute.path;
      final int lastIndex = filePath.lastIndexOf(RegExp(r".png|.jp"));
      final String splitted = filePath.substring(0, lastIndex);
      final String outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 500,
      );
      if (result != null) {
        await getBase64Image(File(result.path));
      }
    } else {
      isDataLoad.value = true;
      debugPrint("Image is not cropped.");
    }
  }

  Future<void> getBase64Image(File fileData) async {
    final String filePath = fileData.absolute.path;
    final int lastIndex = filePath.lastIndexOf(RegExp(r".png|.jp"));
    final String splitted = filePath.substring(0, lastIndex);
    final String outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minWidth: 20,
    );
    final List<int> imageBytes = File(result!.path).readAsBytesSync();
    final String base64Image = base64Encode(imageBytes);
    final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";

    final String uploadFile =
        await uploadImageToS3Bucket(File(fileData.path), time);
    if (uploadFile != "") {
      addNewMessage(time, "image",
          awsUrl: uploadFile, base64Image: base64Image, downloadedPath: '');
    }
  }

//Cannot end chat
  cannotEndChat(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Divine Customer"),
          content: const Text("You cannot end chat before 1 min."),
          actions: <Widget>[
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
          actions: <Widget>[
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

  addNewMessage(
    String time,
    String? msgType, {
    String? messageText,
    String? awsUrl,
    String? base64Image,
    String? downloadedPath,
    String? kundliId,
    String? giftId,
  }) async {
    final ChatMessage newMessage = ChatMessage(
      orderId: int.parse(arguments["orderData"]["orderId"].toString()),
      id: int.parse(time),
      message: messageText,
      receiverId: int.parse(arguments["orderData"]["userId"].toString()),
      senderId: preference.getUserDetail()!.id,
      time: int.parse(time),
      awsUrl: awsUrl,
      base64Image: base64Image,
      downloadedPath: downloadedPath,
      msgType: msgType,
      kundliId: kundliId,
      title: giftId ?? "${userData?.name} sent you a message.",
      type: 0,
      userType: "astrologer",
    );
    socket.sendMessageSocket(newMessage);
    updateChatMessages(newMessage, false, isSendMessage: true);
    isDataLoad.value = true;
  }

  updateChatMessages(ChatMessage newMessage, bool isFromNotification,
      {bool isSendMessage = false}) async {
    final int index = chatMessages
        .indexWhere((ChatMessage element) => newMessage.id == element.id);
    if (index >= 0) {
      chatMessages[index].type = newMessage.type;
      chatMessages.refresh();
    } else {
      if (isFromNotification && messgeScrollController.hasClients) {
        if (messgeScrollController.position.pixels >
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
          newMessage.type = isSendMessage ? 0 : 1;
          chatMessages.add(newMessage);
          unreadMsgCount.value = chatMessages
              .where((ChatMessage e) =>
                  e.type != 2 && e.senderId != preference.getUserDetail()!.id)
              .length;
          if (!isSendMessage) {
            updateMsgDelieveredStatus(newMessage, 1);
          }
        }
      } else {
        newMessage.type = isSendMessage ? 0 : 1;
        chatMessages.add(newMessage);
        unreadMsgCount.value = chatMessages
            .where((ChatMessage e) =>
                e.type != 2 && e.senderId != preference.getUserDetail()!.id)
            .length;
        if (!isSendMessage) {
          updateMsgDelieveredStatus(newMessage, 1);
        }
      }
    }
    unreadMessageIndex.value = chatMessages
            .firstWhere(
              (ChatMessage element) =>
                  element.type != 2 &&
                  element.senderId != preference.getUserDetail()!.id,
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

  Future<void> setHiveDataDatabase() async {
    final HiveServices hiveServices = HiveServices(boxName: userChatData);
    await hiveServices.initialize();
    databaseMessage.value.chatMessages = chatMessages;
    await hiveServices.addData(
        key: userDataKey,
        data: jsonEncode(databaseMessage.value.toOfflineJson()));
  }

  scrollToBottomFunc() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      messgeScrollController.hasClients
          ? messgeScrollController.animateTo(
              messgeScrollController.position.maxScrollExtent * 2,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut)
          : null;
    });
  }

  askForGift() async {
    await showCupertinoModalPopup(
      //backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) {
        return AskForGiftBottomSheet(
          customerName: customerName.value,
          giftList: GiftsSingleton().gifts.data ?? <GiftData>[],
          onSelect: (GiftData item, num quantity) async {
            Get.back();
            await sendGiftFunc(item, quantity);
          },
        );
      },
    );
  }

  sendGiftFunc(GiftData item, num quantity) {
    if (item.giftName.isNotEmpty) {
      final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
      unreadMessageIndex.value = -1;
      addNewMessage(time, "gift",
          messageText: "${quantity}x ${item.giftName}",
          awsUrl: item.fullGiftImage,giftId : item.id.toString());
    }
  }

  updateReadMessageStatus() async {
    for (int i = 0; i < chatMessages.length; i++) {
      if (chatMessages[i].type != 2 &&
          chatMessages[i].senderId != preference.getUserDetail()!.id) {
        updateMsgDelieveredStatus(chatMessages[i], 2);
        chatMessages[i].type = 2;
      }
    }
    databaseMessage.value.chatMessages = chatMessages;
    unreadMsgCount.value = 0;
    chatMessages.refresh();
    await hiveServices.addData(
        key: userDataKey,
        data: jsonEncode(databaseMessage.value.toOfflineJson()));
    Future.delayed(const Duration(seconds: 1))
        .then((value) => unreadMessageIndex.value = -1);
  }

  sendMsg() {
    if (messageController.text.trim().isNotEmpty) {
      final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
      // type 1= New chat message, 2 = Delievered, 3= Msg read, 4= Other messages
      unreadMessageIndex.value = -1;
      addNewMessage(time, "text", messageText: messageController.text.trim());
      messageController.clear();
    }
  }

  sendTarotCard(int? choice) async {
    print("tarot card running 1");
    HashMap<String, dynamic> hsMap = HashMap();
    hsMap["isCardVisible"] = false;
    hsMap["listOfCard"] = await  printRandomTarotCards(choice);
    print("tarot card running 2 ${hsMap}");
    print("tarot card running 3 ${AppFirebaseService().orderData.value["orderId"]}");
    FirebaseDatabase.instance
        .ref()
        .child("order/${AppFirebaseService().orderData.value["orderId"]}/card")
        .set(hsMap);
  }

  Future<HashMap<String, dynamic>> printRandomTarotCards(int? choice) async {
    List<TarotCard> cards = await loadTarotCards();
    HashMap<String, dynamic> listOfCard = HashMap();
    if (cards.isNotEmpty) {
      // Shuffle the list and take the first 3 cards
      cards.shuffle();
      List<TarotCard> randomCards = cards.take(choice!).toList();

      for (var card in randomCards) {
        print(card.name);
        listOfCard["${card.name}"] = card.image;
      }
      return listOfCard;
    } else {
      return HashMap();
    }
  }

  Future<List<TarotCard>> loadTarotCards() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cardsJson = prefs.getString('tarot_cards');

    if (cardsJson != null) {
      List<dynamic> jsonList = json.decode(cardsJson) as List;
      return jsonList.map((jsonItem) => TarotCard.fromJson(jsonItem)).toList();
    } else {
      return [];
    }
  }

  sendMsgTemplate(MessageTemplates msg) {
    final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    unreadMessageIndex.value = -1;
    addNewMessage(time, "text", messageText: msg.description);
  }

  // int getListOfCardLength() {
  //   var orderData = AppFirebaseService().orderData.value;
  //   Map<dynamic, dynamic> listOfCard = Map();
  //   var card = orderData['card'];
  //   listOfCard = card['listOfCard'] as Map;
  //   print("listOfCard ${listOfCard.length}");
  //   return listOfCard.length;
  // }
  // String getKeyByPosition( int position) {
  //   var orderData = AppFirebaseService().orderData.value;
  //   Map<dynamic, dynamic> listOfCard = Map();
  //   var card = orderData['card'];
  //   listOfCard = card['listOfCard'] as Map;
  //   if (position < listOfCard.length) {
  //     return listOfCard[position];
  //   } else {
  //     throw IndexError(position, listOfCard, 'Index out of range');
  //   }
  // }
  var orderData = AppFirebaseService().orderData.value;

  int getListOfCardLength() {
    var card = orderData['card'];
    if(card != null) {
      var listOfCard = card['listOfCard'] as Map;

      print("listOfCard ${listOfCard.length}");
      return listOfCard.length;
    }
    return 0;
  }

  String getValueByPosition(int position) {
    var card = orderData['card'];
    var listOfCard = card['listOfCard'] as Map;
    var keysList = listOfCard.keys.toList();

    if (position < keysList.length) {
      String key = keysList[position];
      print("imgUrl --${listOfCard[key]}");
      return listOfCard[key];
    } else {
      throw IndexError(position, keysList, 'Index out of range');
    }
  }

  String getKeyByPosition(int position) {
    var card = orderData['card'];
    var listOfCard = card['listOfCard'] as Map;
    var keysList = listOfCard.keys.toList();

    if (position < keysList.length) {
      String key = keysList[position];
      //  return keysList[position];
      return key;
    } else {
      throw IndexError(position, keysList, 'Index out of range');
    }
  }

  getChatList() async {
    chatMessages.clear();
    await hiveServices.initialize();
    final res = await hiveServices.getData(key: userDataKey);
    if (res != null) {
      final ChatMessagesOffline msg =
          ChatMessagesOffline.fromOfflineJson(jsonDecode(res));
      chatMessages.value = msg.chatMessages ?? <ChatMessage>[];
      if (sendReadMessageStatus) {
        unreadMessageIndex.value = chatMessages
                .firstWhere(
                  (ChatMessage element) =>
                      element.type != 2 && element.senderId != userData?.id,
                  orElse: () => ChatMessage(),
                )
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

  uploadAudioFile(File soundFile) async {
    final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    final String uploadFile = await uploadImageToS3Bucket(soundFile, time);
    if (uploadFile != "") {
      addNewMessage(time, "audio", awsUrl: uploadFile);
    }
  }

  downloadImage(
      {required String fileName,
      required ChatMessage chatDetail,
      required int index}) async {
    final http.Response response =
        await http.get(Uri.parse(chatDetail.awsUrl!));
    final Directory documentDirectory =
        await getApplicationDocumentsDirectory();
    final String firstPath = "${documentDirectory.path}/images";
    final String filePathAndName =
        "${documentDirectory.path}/images/${chatDetail.id}.jpg";

    await Directory(firstPath).create(recursive: true);
    final File file2 = File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    chatMessages[index].downloadedPath = filePathAndName;
    chatMessages.refresh();
    setHiveDataDatabase();
  }

  void userLeavePrivateChatListenerSocket() {
    socket.userLeavePrivateChat((data) {
      debugPrint("userLeavePrivateChatListenerSocket $data");
    });
  }

  void customerLeavedPrivateChatListenerSocket() {
    socket.customerLeavedPrivateChatListenerSocket((data) {
      debugPrint("customerLeavedPrivateChatListenerSocket $data");
      chatStatus.value = "Offline";
    });
  }

  File getFile(String base64String) {
    Directory? appDocumentsDirectory;
    getApplicationDocumentsDirectory().then((value) {
      debugPrint('what is value $value');
      appDocumentsDirectory = value;
    });
    if (appDocumentsDirectory != null) {
      String filePath = '${appDocumentsDirectory!.path}/${DateTime.now()}';
      String data = base64String.replaceAll('data:image/*;base64,', '');

      Uint8List bytes = base64.decode(data);

      // Create a file and write the bytes to it
      File file = File(filePath);
      file.writeAsBytesSync(bytes);
      return file;
    } else {
      debugPrint('else hit hua');
      return File('');
    }
  }
}
