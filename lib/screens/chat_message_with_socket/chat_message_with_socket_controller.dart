import "dart:async";
import "dart:collection";
import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:audio_waveforms/audio_waveforms.dart";
import "package:audioplayers/audioplayers.dart";
import "package:camera/camera.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:divine_astrologer/app_socket/app_socket.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/custom_widgets.dart";
import "package:divine_astrologer/common/routes.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/model/chat_histroy_response.dart";
import "package:divine_astrologer/model/chat_offline_model.dart";
import "package:divine_astrologer/model/res_login.dart";
import "package:divine_astrologer/repository/message_template_repository.dart";
import "package:divine_astrologer/repository/user_repository.dart";
import "package:divine_astrologer/screens/chat_message_with_socket/custom_puja/saved_remedies.dart";
import "package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_list_model.dart";
import "package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:divine_astrologer/screens/live_dharam/zego_team/player.dart";
import "package:divine_astrologer/screens/live_page/constant.dart";
import "package:divine_astrologer/zego_call/zego_service.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:http/http.dart" as http;
import "package:image_cropper/image_cropper.dart";
import "package:image_picker/image_picker.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:socket_io_client/socket_io_client.dart";
import "package:svgaplayer_flutter/svgaplayer_flutter.dart";
import "package:url_launcher/url_launcher.dart";

import "../../cache/custom_cache_manager.dart";
import "../../common/MiddleWare.dart";
import "../../common/app_exception.dart";
import "../../common/app_textstyle.dart";
import "../../common/ask_for_gift_bottom_sheet.dart";
import "../../common/camera.dart";
import "../../common/common_functions.dart";
import "../../common/show_permission_widget.dart";
import "../../di/api_provider.dart";
import "../../firebase_service/firebase_service.dart";
import "../../model/RitentionPopupModel.dart";
import "../../model/astrologer_gift_response.dart";
import "../../model/message_template_response.dart";
import "../../model/notice_response.dart";
import "../../model/res_product_detail.dart";
import "../../model/save_remedies_response.dart";
import "../../model/tarot_response.dart";
import "../../repository/chat_repository.dart";
import "../../repository/notice_repository.dart";
import "../../tarotCard/FlutterCarousel.dart";
import "../../utils/enum.dart";
import "../../utils/is_bad_word.dart";
import "../chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/get_single_pooja_response.dart";
import "../live_dharam/gifts_singleton.dart";

class ChatMessageWithSocketController extends GetxController
    with
        WidgetsBindingObserver,
        GetTickerProviderStateMixin,
        WidgetsBindingObserver {
  late SVGAAnimationController svgController;

  var pref = Get.find<SharedPreferenceService>();
  final UserRepository userRepository = Get.find<UserRepository>();
  final MessageTemplateRepo messageTemplateRepository =
      Get.put(MessageTemplateRepo());
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  RxBool isAudioPlaying = false.obs;
  TextEditingController messageController = TextEditingController();
  UserData? userData = UserData();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  Rx<ChatMessagesOffline> databaseMessage = ChatMessagesOffline().obs;
  ScrollController messgeScrollController = ScrollController();
  ScrollController typingScrollController = ScrollController();
  File? image;
  ImagePicker picker = ImagePicker();
  File? uploadFile;
  final SharedPreferenceService preference =
      Get.find<SharedPreferenceService>();
  RxInt currentUserId = 0.obs;
  String userDataKey = "";
  bool sendReadMessageStatus = false;
  RxBool isEmojiShowing = false.obs;
  Rx<String> extraTalkTime = "".obs;
  RxInt unreadMessageIndex = 0.obs;
  RxBool scrollToBottom = false.obs;
  RxInt unreadMsgCount = 0.obs;
  RxString customerName = "".obs;
  RxString profileImage = "".obs;
  RxBool isOngoingChat = false.obs;
  RxList<MessageTemplates> messageTemplatesList = <MessageTemplates>[].obs;
  RxBool isTyping = false.obs;
  final AppSocket socket = AppSocket();

  // Timer? extraTimer;
  // Timer? chatTimer;
  Timer? _timer2;

  Rx<bool> isRecording = false.obs;
  Rx<bool> hasMessage = false.obs;
  Rx<bool> isCardBotOpen = false.obs;
  bool isGalleryOpen = false;

  Future<bool> checkIfEmojisOpen() async {
    if (isEmojiShowing.value) {
      isEmojiShowing.value = false;
    } else {
      print("emoji backFunction");
      backFunction();
    }
    return false;
  }

  void startTimer() {
    int _start = 5;
    if (_timer2 != null) {
      _timer2!.cancel();
    }
    const Duration oneSec = Duration(seconds: 1);
    _timer2 = Timer.periodic(
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
    print("AppResume ${AppFirebaseService().orderData.value["status"]}");
    if (state == AppLifecycleState.resumed) {
      if (AppFirebaseService().orderData.value["status"] == null) {
        print("The order is null going back From Resume");
        if (MiddleWare.instance.currentPage ==
            RouteName.chatMessageWithSocketUI) {
          Get.until(
            (route) {
              return Get.currentRoute == RouteName.dashboard;
            },
          );
        }
      }
    }
  }

  StreamSubscription? _appLinkingStreamSubscription;

//end
  @override
  void onClose() {
    ZegoGiftPlayer().clear();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _appLinkingStreamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    ZegoGiftPlayer().clear();
    messgeScrollController.dispose();
    // chatTimer?.cancel();
    // chatTimer = null;
    print("WentBack dispose-5");
    // extraTimer?.cancel();
    // extraTimer = null;
    svgController.dispose();
    messgeScrollController.removeListener(_scrollListener);
    messgeScrollController.dispose();
    orderRemovedListener?.cancel();
    chatAddedListener?.cancel();
    typingListener?.cancel();
    super.dispose();
  }

  bool isRecordingCompleted = false;

  void startOrStopRecording() async {
    bool isPermission = await requestMicroPhone();
    if (isPermission) {
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
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        isRecording.value = !isRecording.value;
        update();
      }
    }
  }

  Future<bool> requestMicroPhone() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40.0)),
              color: appColors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              20.verticalSpace,
              Icon(
                Icons.query_builder_rounded,
                color: appColors.red,
                size: 60.h,
              ),
              10.verticalSpace,
              const CustomText(
                "please allow microphone permission for send voice message",
                fontSize: 16.0,
                maxLines: 5,
                textAlign: TextAlign.center,
              ),
              10.verticalSpace,
              CommonButton(
                  buttonText: "Open setting",
                  buttonCallback: () {
                    Get.back();
                    openAppSettings();
                  }),
              SizedBox(
                  height: MediaQuery.of(Get.context!).padding.bottom + 20.0),
            ],
          ),
        ),
      );
      return false;
    } else if (status.isDenied) {
      final statusAsk = await Permission.microphone.request();
      if (statusAsk.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
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

  RecorderController? recorderController;

  void initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  List<String> chatIdList = []; // Initial list

  void openShowDeck(
      BuildContext context, ChatMessageWithSocketController controller) {
    isCardBotOpen.value = true;
    showCardChoiceBottomSheet(context, controller);
  }

  Future<void> openRemedies() async {
    var result = await Get.toNamed(RouteName.chatSuggestRemedy);
    if (await checkIfChatIsEnded()) {
      if (result != null) {
        final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
        addNewMessage(
          time,
          MsgType.remedies,
          messageText: result.toString(),
        );
      }
    }
  }

  Future<void> openProduct(ChatMessageWithSocketController controller) async {
    var result = await Get.toNamed(RouteName.chatAssistProductPage, arguments: {
      'customerId':
          int.parse(AppFirebaseService().orderData.value["userId"].toString())
    });
    if (await checkIfChatIsEnded()) {
      if (result != null) {
        final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
        controller.addNewMessage(
          time,
          MsgType.product,
          data: {
            'data': result,
          },
          messageText: 'Product',
        );
      }
    }
  }

  // Future<void> openProduct(ChatMessageWithSocketController controller) async {
  //   var result = await Get.toNamed(RouteName.chatAssistProductPage, arguments: {
  //     'customerId':
  //         int.parse(AppFirebaseService().orderData.value["userId"].toString())
  //   })
  //   !
  //       .then(
  //     (value) async {
  //       await controller.checkIfChatIsEnded();
  //       if (result != null) {
  //         final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
  //         controller.addNewMessage(
  //           time,
  //           MsgType.product,
  //           data: {
  //             'data': result,
  //           },
  //           messageText: 'Product',
  //         );
  //       }
  //     },
  //   );
  //
  // }

  void openCustomShop(ChatMessageWithSocketController controller) {
    print(customProductData);
    print("controller.customProductData");
    Get.bottomSheet(
      SavedRemediesBottomSheet(
        controller: controller,
        customProductData: controller.customProductData,
      ),
    );
  }

  // updateOrderInfo(String key, dynamic value, bool isRemoved) {
  //   switch (key) {
  //     case "":
  //       break;
  //   }
  // }
  Future<void> receiveMessage(DataSnapshot snapshot) async {
    Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
    var chatMessage = ChatMessage.fromOfflineJson(values);
    print("chatMessage.title");
    print(chatMessage.message);
    print(MiddleWare.instance.currentPage == RouteName.chatMessageWithSocketUI);
    if (chatMessage.msgType.toString() != "MsgType.text" ||
        (chatMessage.msgType.toString() == "MsgType.text" &&
            !isBadWord(chatMessage.message ?? ""))) {
      // int index = chatMessages.indexWhere((element) {
      //   return element.time == chatMessage.time;
      // });
      //   if (index == -1 || index == AppFirebaseService().orderData.value['userId'] || index == AppFirebaseService().orderData.value['astroId']) {
      chatMessages.add(chatMessage);
      // isPlaying.add(false);
      // progress.add(0.0);
      chatMessages.refresh();
      scrollToBottomFunc();
      if (chatMessage.msgType == MsgType.sendgifts) {
        if (chatMessage.productId != null) {
          if (MiddleWare.instance.currentPage ==
              RouteName.chatMessageWithSocketUI) {
            playAnimation(id: chatMessage.productId ?? "");
          } else {
            divineSnackBar(
                data: "gift received in chat", color: appColors.redColor);
          }
        }
      }
      //    }
    } else {
      print("BadWordDetected ${chatMessage.message}");
    }
    print("Message.fromOffli2");
    AppFirebaseService()
        .database
        .child(
            "chatMessages/${AppFirebaseService().orderData.value["orderId"]}")
        .child(snapshot.key!)
        .remove();
  }

  var isHistoryLoading = false;

  void _scrollListener() {
    if (messgeScrollController.hasClients) {
      final double maxScrollExtent =
          messgeScrollController.position.maxScrollExtent;
      final double currentScrollPosition =
          messgeScrollController.position.pixels;
      final double threshold = maxScrollExtent * 0.1;

      if (currentScrollPosition <= threshold && !isHistoryLoading) {
        isHistoryLoading = true;
        print('Reached the top 90% of the ListView');
        currentPage.value = currentPage.value + 1;
        getChatList();
      }
    }
  }

  var timeCountDown = 0;

  @override
  void onInit() {
    super.onInit();
    showTalkTime.value = "";
    svgController = SVGAAnimationController(vsync: this);
    svgController.addListener(() {
      if (svgController.isCompleted) {
        svgController.reset();
        svgController.stop();
      }
    });
    WidgetsBinding.instance.addObserver(this);
    if (showRetentionPopup.toString() == "1") {
      print("callling popup api from this side");
      getRitentionPopUpDataApi();
    } else {
      print("not popup api from this side");
    }
    getDir();
    initialiseControllers();
    noticeAPi();
    getSavedRemedies();
    AppFirebaseService().orderData.listen((Map<String, dynamic> p0) async {
      if (p0["astroId"] == null) {
        if (AppFirebaseService().currentOrder == "") {
          print("realTimeChange backFunction");
          backFunction();
        }
      }
    });
    messgeScrollController.addListener(_scrollListener);
    messageController.addListener(_onMessageChanged);
    socketReconnect();
    checkIsCustomerJoinedPrivateChat();
    typingListenerSocket();
    sendMessageListenerSocket();
    listenerMessageStatusSocket();
    customerLeavedPrivateChatListenerSocket();
    astrologerJoinedPrivateChat();
    socket.startAstroCustumerSocketEvent(
      orderId: AppFirebaseService().orderData.value["orderId"].toString(),
      userId: AppFirebaseService().orderData.value["userId"],
    );
    svgController = SVGAAnimationController(vsync: this);
    svgController.addListener(() {
      if (svgController.isCompleted) {
        svgController.reset();
        svgController.stop();
      }
    });
    sendReadMessageStatus = true;

    isOngoingChat.value = true;

    currentUserId.value =
        int.parse(AppFirebaseService().orderData.value['userId'].toString());
    customerName.value =
        AppFirebaseService().orderData.value["customerName"] ?? "";
    profileImage.value = AppFirebaseService()
                .orderData
                .value["customerImage"] !=
            null
        ? "${preference.getBaseImageURL()}/${AppFirebaseService().orderData.value['customerImage']}"
        : "";
    if (astroChatWatcher.value.orderId != null) {
      timer.startMinuteTimer(astroChatWatcher.value.talktime ?? 0,
          astroChatWatcher.value.orderId!);
    }
    userData = preferenceService.getUserDetail();
    userDataKey = "chat_${currentUserId.value}";
    getChatList();
    socketReconnect();
    if (AppFirebaseService().orderData.value["end_time"] != null) {
      timeCountDown = AppFirebaseService().orderData.value["end_time"] -
          (AppFirebaseService().currentTime().millisecondsSinceEpoch ~/ 1000);
      print("timeCountDown $timeCountDown");
    }
    Future.delayed(const Duration(milliseconds: 3000)).then((value) {
      getMessageTemplates();
    });
    AppFirebaseService()
        .database
        .child("order/${AppFirebaseService().orderData.value["orderId"]}")
        .onChildChanged
        .listen((event) async {
      var snapshot = event.snapshot;
      print("onChildChanged ${snapshot.key}");
      makeRealTimeOrderChanges(snapshot);
    });
    AppFirebaseService()
        .database
        .child("order/${AppFirebaseService().orderData.value["orderId"]}")
        .onChildAdded
        .listen((event) async {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        var snapshot = event.snapshot;
        print("onChildAdded ${snapshot.key}");
        makeRealTimeOrderChanges(snapshot);
      }
    });
    messageController.addListener(() {
      String text = messageController.text;
      if (text.length % 3 == 0 && text.isNotEmpty) {
        FirebaseDatabase.instance
            .ref(
                "order/${AppFirebaseService().orderData.value["orderId"]}/isAstroTyping")
            .set(AppFirebaseService().currentTime().millisecondsSinceEpoch);
      }
    });
    runTimer();
    setRealTime();
  }

  StreamSubscription? orderRemovedListener;
  StreamSubscription? chatAddedListener;
  StreamSubscription? typingListener;

  void setRealTime() {
    // Cancel existing listeners to prevent duplication
    orderRemovedListener?.cancel();
    chatAddedListener?.cancel();
    typingListener?.cancel();

    // Listen for order removal
    orderRemovedListener = AppFirebaseService()
        .database
        .child("order/${AppFirebaseService().currentOrder}")
        .onChildRemoved
        .listen((event) async {
      if (AppFirebaseService().orderData.value["status"] == null) {
        print("The order is null, going back");
        if (MiddleWare.instance.currentPage ==
            RouteName.chatMessageWithSocketUI) {
          Get.until((route) {
            return Get.currentRoute == RouteName.dashboard;
          });
        }
      }
    });

    // Listen for new chat messages
    chatAddedListener = AppFirebaseService()
        .database
        .child("chatMessages/${AppFirebaseService().currentOrder}")
        .orderByChild("msg_send_by")
        .equalTo("0")
        .onChildAdded
        .listen((event) async {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        print("Received new message");
        await receiveMessage(snapshot);
      }
    });

    // Listen for typing status changes
    typingListener = AppFirebaseService()
        .database
        .child("order/${AppFirebaseService().currentOrder}/isCustTyping")
        .onValue
        .listen((event) async {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        isTyping.value = true;
        startTimer();
        scrollToBottomFunc();
      }
    });
  }

  checkIfChatIsEnded() {
    print("checkIfChatIsEnded");
    if (AppFirebaseService().orderData.value["status"] == null) {
      if (MiddleWare.instance.currentPage ==
          RouteName.chatMessageWithSocketUI) {
        Get.until((route) {
          return Get.currentRoute == RouteName.dashboard;
        });
      }
    }
    return AppFirebaseService().orderData.value["status"] != null;
  }

  runTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (AppFirebaseService().orderData.value["status"] == null) {
        timer.cancel();
      }
      if (MiddleWare.instance.currentPage == RouteName.dashboard) {
        timer.cancel();
      }
      if (AppFirebaseService().orderData.value["status"].toString() == "2" ||
          AppFirebaseService().orderData.value["status"].toString() == "3") {
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            AppFirebaseService().orderData.value["end_time"] * 1000);
        timeDifference =
            dateTime.difference(AppFirebaseService().currentTime());
        if (timeDifference!.isNegative ||
            (timeDifference!.inSeconds == 0 &&
                timeDifference!.inMinutes == 0 &&
                timeDifference!.inHours == 0)) {
          await closedChat();
        } else {
          workingChat(timer);
        }
      } else if (AppFirebaseService().orderData.value["status"].toString() ==
          "4") {
        Duration timeLeft = const Duration(minutes: 1);
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            AppFirebaseService().orderData.value["order_end_time"]);
        final difference =
            dateTime.difference(AppFirebaseService().currentTime());
        if (difference.isNegative ||
            (difference.inSeconds == 0 &&
                difference.inMinutes == 0 &&
                difference.inHours == 0)) {
          if (AppFirebaseService().orderData.value["orderId"] != null ||
              AppFirebaseService().orderData.value["status"] == "4") {
            //extraTimer?.cancel();
            extraTalkTime.value = "0";
            timer.cancel();
            print("WentBack timeUp");
            timeLeft = Duration.zero;
            backFunction();
          }
        } else {
          timeLeft = difference;
          extraTalkTime.value =
              "${timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
              "${timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0')}";
          print("ExtraTime ${extraTalkTime.value}");
          if (MiddleWare.instance.currentPage == RouteName.dashboard ||
              AppFirebaseService().orderData.value["status"] == "3") {
            print("ExtraTalktime is closing");
          }
        }
      } else {
        timer.cancel();
      }
    });
  }

  makeRealTimeOrderChanges(DataSnapshot snapshot) {
    switch (snapshot.key) {
      case "end_time":
        timeCountDown = int.parse(snapshot.value.toString()) -
            (AppFirebaseService().currentTime().millisecondsSinceEpoch ~/ 1000);
        break;
      case "order_end_time":
        print("order_end_time");
        //  startExtraTimer2();
        break;
    }
  }

  getMessageTemplates() async {
    try {
      final response = await messageTemplateRepository.fetchTemplates();
      if (response.data != null) {
        messageTemplateList.value = response.data!;
      }
      messageTemplatesList.value.clear();
      for (int i = 0; i < messageTemplateList.length; i++) {
        if (await getBoolFromPrefs(messageTemplateList[i].id.toString()) || messageTemplateList[i].type.toString() =="0") {
          messageTemplatesList.value.add(messageTemplateList[i]);
        }
      }
      update();
    } catch (error) {
      divineSnackBar(data: error.toString(), color: appColors.redColor);
    }
  }

  Future<bool> getBoolFromPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("${key}template") ?? false;
  }
  Duration? timeDifference;
  String formatTime(int seconds) {
    // Calculate hours, minutes, and seconds
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    // Format the time as HH:MM:SS
    String formattedTime = '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  Future<void> workingChat2(Timer timer) async {
    showTalkTime.value = formatTime(timeCountDown);
    timeCountDown = timeCountDown - 1;
    if (MiddleWare.instance.currentPage == RouteName.dashboard) {
      timer.cancel();
    }
    print("timeCountDown:1 - $timeCountDown");
  }

  Future<void> workingChat(Timer timer) async {
    // extraTimer?.cancel();
    showTalkTime.value =
        "${timeDifference!.inHours.toString().padLeft(2, '0')}:"
        "${timeDifference!.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
        "${timeDifference!.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    if (MiddleWare.instance.currentPage == RouteName.dashboard) {
      timer.cancel();
    }
    print("${MiddleWare.instance.currentPage}");
  }

  Future<void> closedChat() async {
    await callHangup();
    showTalkTime.value = "-1";
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (showTalkTime.value == "-1") {
        print('showTalkTime Chat ending on cust app closed');
        print(AppFirebaseService().orderData.value["status"].toString());
        if (AppFirebaseService().orderData.value["status"].toString() == "3" ||
            AppFirebaseService().orderData.value["status"].toString() == "2") {
          DatabaseReference ref = FirebaseDatabase.instance
              .ref("order/${AppFirebaseService().orderData.value["orderId"]}");
          ref.update({
            "status": "4",
            "source": "astrorApp",
            "order_end_time":
                AppFirebaseService().currentTime().millisecondsSinceEpoch +
                    60000
          });
        }
      }
    });
  }

  String convertSeconds(int totalMilliseconds) {
    // Divide the given milliseconds by 1000 to get total seconds
    double totalSeconds = totalMilliseconds / 1000.0;

    // Calculate hours, minutes, and seconds
    int hours = (totalSeconds ~/ 3600);
    int remainingSeconds = (totalSeconds % 3600).toInt();
    int minutes = remainingSeconds ~/ 60;
    double seconds = totalSeconds % 60;

    // Format the time as a string
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toStringAsFixed(0).padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  Loading loading = Loading.initial;

  endChatApi() async {
    Map<String, dynamic> param = HashMap();
    param["order_id"] = AppFirebaseService().orderData.value["orderId"];
    param["queue_id"] = AppFirebaseService().orderData.value["queue_id"];
    param["source"] = "Astro App";
    loading = Loading.loading;
    update();
    try {
      await ChatRepository().endChat(param);
      loading = Loading.loaded;
      WidgetsBinding.instance.endOfFrame.then(
        (_) async {
          socket.socket?.disconnect();
          FirebaseDatabase.instance
              .ref(
                  "user/${AppFirebaseService().orderData.value["userId"]}/realTime/queue_list/${param["order_id"]}")
              .remove();
          Get.until(
            (route) {
              return Get.currentRoute == RouteName.dashboard;
            },
          );
        },
      );
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
      loading = Loading.loaded;
    }
    update();
  }

  void backFunction() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        print("userLeavePrivateChatListenerSocket");
        socket.leavePrivateChatEmit(userData?.id.toString(),
            AppFirebaseService().orderData.value["userId"], "0");
        if (MiddleWare.instance.currentPage ==
            RouteName.chatMessageWithSocketUI) {
          Get.until(
            (route) {
              return Get.currentRoute == RouteName.dashboard;
            },
          );
        }
      },
    );
    return;
  }

// Added by divine-dharam
  Future<void> callHangup() {
    print("ZegoService().controller.hangUp start");
    ZegoService().controller.hangUp(Get.context!, showConfirmation: false);
    print("ZegoService().controller.hangUp end");
    return Future<void>.value();
  }

//

  socketReconnect() {
    if (socket.socket!.disconnected) {
      socket.socket
        ?..disconnect()
        ..connect();
    }
    socket.socket!.onConnect((_) {
      socket.startAstroCustumerSocketEvent(
        orderId: AppFirebaseService().orderData.value["orderId"].toString(),
        userId: AppFirebaseService().orderData.value["userId"],
      );
      log("Socket startAstroCustumerSocketEvent connected successfully");
    });
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 200)).then((value) async {
      scrollToBottomFunc();

      await ZegoService().canInit();
    });
  }

// void isAstroJoinedChat() {
//   socket.isAstroJoinedChat((data) {
//     debugPrint("private chat Joined event $data");
//   });
// }

  void tyingSocket() {
    debugPrint(
      'tyingSocket orderId:${AppFirebaseService().orderData.value['orderId'].toString()}, userId: ${AppFirebaseService().orderData.value['userId']}',
    );
    socket.typingSocket(
      orderId: AppFirebaseService().orderData.value["orderId"].toString(),
      userId: AppFirebaseService().orderData.value["userId"].toString(),
    );
    // update();
  }

  void checkIsCustomerJoinedPrivateChat() {
    socket.isCustomerJoinedChat((data) {
      debugPrint("Yes customer joined chat successfully $data");
      socket.startAstroCustumerSocketEvent(
        orderId: AppFirebaseService().orderData.value["orderId"].toString(),
        userId: AppFirebaseService().orderData.value["userId"],
      );
      debugPrint("emited Data $data");
      updateReadMessage();
    });
  }

  Future<void> updateReadMessage() async {
    var filteredMessages = chatMessages
        .where((chatMessage) =>
            chatMessage.type.toString() == "1" ||
            chatMessage.type.toString() == "0")
        .toList();
    debugPrint("astrojoined1 ${filteredMessages.length}");
    for (int i = 0; i < filteredMessages.length; i++) {
      ChatMessage message = filteredMessages[i];
      debugPrint("astrojoined2 ${message.message}");
      var index = chatMessages.indexWhere((element) {
        return element.time.toString() == message.time.toString();
      });
      debugPrint("astrojoined3 ${index}");
      if (index != -1) {
        print("goinggoinggoinggoinggoing");
        chatMessages[index].type = 3;
        chatMessages[index].seenStatus = 3;
        update();
      }
    }
    // await hiveServices.addData(
    //     key: userDataKey,
    //     data: jsonEncode(databaseMessage.value.toOfflineJson()));
  }

  void typingListenerSocket() {
    socket.typingListenerSocket((data) {
      debugPrint('data ........ ${data}');
      debugPrint(
          '${data['data']["typist"].toString()}  ${AppFirebaseService().orderData.value["userId"].toString()}');
      if (data['data']["typist"].toString() ==
          AppFirebaseService().orderData.value["userId"].toString()) {
        //  isTyping.value = true;
        //chatStatus.value = "Typing";
        // if (isScrollAtBottom()) {
        //   scrollToBottomFunc();
        // }
        startTimer();
      }
    });
  }

// void sendMessageSocketListenerSocket() {
//   socket.sendMessageSocketListenerSocket((data) {
//     debugPrint("sendMessageSocketListenerSocket $data");
//   });
// }

  void listenerMessageStatusSocket() {
    print('listener function called');
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

  void astrologerJoinedPrivateChat() {
    socket.astrologerJoinedPrivateChat((data) {
      debugPrint("Astro-joined-the-chat");
    });
  }

  void sendMessageListenerSocket() {
    socket.sendMessageListenerSocket((data) {
      debugPrint("sendMessageListenerSocketssss ${data["msgSendBy"]}");
      debugPrint("sendMessageListenerSocket context ${Get.context!}");
      if (fireChat.value == 0) {
        if (data is Map<String, dynamic>) {
          //  isTyping.value = false;
          final ChatMessage chatMessage =
              ChatMessage.fromOfflineJson(data["data"]);
          final String time =
              "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
          log('chatMessage.msgType ${chatMessage.msgType}');
          if (chatMessage.msgType == MsgType.sendgifts) {
            if (chatMessage.productId != null) {
              playAnimation(id: chatMessage.productId ?? "");
            }
          }
          if (data["data"]["receiverId"].toString() ==
              preferenceService.getUserDetail()!.id.toString()) {
            socket.messageReceivedStatusUpdate(
              receiverId: preferenceService.getUserDetail()!.id.toString(),
              chatMessageId: chatMessage.id.toString(),
              chatStatus: "read",
              time: time,
              orderId:
                  AppFirebaseService().orderData.value["orderId"].toString(),
            );
          }
          updateChatMessages(chatMessage, false, isSendMessage: false);
          scrollToBottomFunc();
          //}
        }
      }
      debugPrint("chatMessage.value.length ${chatMessages.length}");
    });
  }

  void playAnimation({required String id}) async {
    print("playAnimation string id $id");
    List<GiftData> data = GiftsSingleton().gifts.data?.where(
          (element) {
            return element.id == int.parse(id);
          },
        ).toList() ??
        <GiftData>[];
    if (data.isNotEmpty) {
      print("playAnimation string id 2111 $id");
      print("data.first.animation ${data.first.animation}");
      // print("GiftPlayerSource.url ${GiftPlayerSource.url}");
      // ZegoGiftPlayer().play(
      //   Get.context!,
      //   GiftPlayerData(
      //     GiftPlayerSource.url,
      //     data.first.animation,
      //   ),
      // );
      const SVGAParser parser = SVGAParser();
      File file =
          await CustomCacheManager().getFile(data.first.animation ?? '');
      var videoItem = await parser.decodeFromBuffer(file.readAsBytesSync());
      svgController.videoItem = videoItem;
      svgController.forward();
    } else {
      print("playAnimation string id 3333 $id");
    }
    print("playAnimation string id 3 $id");
    return;
  }

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

  Future getImage(bool isCamera) async {
    isGalleryOpen = true;
    if (isCamera) {
      AppFirebaseService().imagePath = "";
      List<CameraDescription> cameras = await availableCameras();
      final String? imagePath = await Get.to<String?>(
        () => CameraPage(cameras: cameras),
      );
      print('Image path received in Page A: ${AppFirebaseService().imagePath}');
      if (AppFirebaseService().imagePath != "") {
        print('Image-in');
        image = File(AppFirebaseService().imagePath);
        await cropImage();
      }
    } else {
      final bool result = await permissionPhotoOrStorage();
      print("photo permission $result");
      if (result) {
        var pickedFile = await picker.pickImage(
            source: isCamera ? ImageSource.camera : ImageSource.gallery);
        print("photo permission $result");
        if (pickedFile != null) {
          image = File(pickedFile!.path);
          await cropImage();
        }
      } else {
        await showPermissionDialog(
          permissionName: 'Gallery permission',
          isForOverlayPermission: false,
        );
      }
    }
  }

  Future<void> cropImage() async {
    isGalleryOpen = true;
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
          toolbarColor: appColors.white,
          toolbarWidgetColor: appColors.blackColor,
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
      minWidth: 10,
      quality: 1,
    );
    final List<int> imageBytes = File(result!.path).readAsBytesSync();
    final String base64Image = base64Encode(imageBytes);
    final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";

    final String? uploadFile = await uploadImageFileToAws(
        file: File(fileData.path), moduleName: "Chat");
    if (uploadFile != "" || uploadFile != null) {
      print(
          "image message upload file ${uploadFile} base64Image==> ${base64Image}");
      addNewMessage(time, MsgType.image,
          messageText: uploadFile,
          base64Image: base64Image,
          downloadedPath: '');
      scrollToBottomFunc();
    }
  }

  addNewMessage(
    String time,
    MsgType? msgType, {
    Map? data,
    String? messageText,
    String? awsUrl,
    String? base64Image,
    String? downloadedPath,
    String? kundliId,
    String? giftId,
    String? title,
    String? productPrice,
    String? productId,
    String? shopId,
    String? suggestedId,
    String? customProductId,
    CustomProduct? getCustomProduct,
  }) async {
    late ChatMessage newMessage;
    if (msgType == MsgType.customProduct) {
      newMessage = ChatMessage(
        orderId: AppFirebaseService().orderData.value["orderId"],
        id: int.parse(time),
        message: messageText,
        receiverId: int.parse(
            AppFirebaseService().orderData.value["userId"].toString()),
        senderId: preference.getUserDetail()!.id,
        time: int.parse(time),
        msgSendBy: "1",
        awsUrl: awsUrl,
        base64Image: base64Image,
        downloadedPath: downloadedPath,
        msgType: msgType,
        kundliId: kundliId,
        productPrice: productPrice,
        title: giftId ?? "${userData?.name} sent you a message.",
        type: 0,
        productId: productId,
        userType: "astrologer",
        getCustomProduct: getCustomProduct,
      );
    } else if (msgType == MsgType.product) {
      final isPooja = data?['data']['isPooja'] as bool;
      if (isPooja) {
        final productDetails = data?['data']['poojaData'] as Pooja;
        final saveRemediesData =
            data?['data']['saveRemediesData'] as SaveRemediesResponse;
        newMessage = ChatMessage(
          message: productDetails.poojaName,
          astrologerId: userData?.id,
          id: int.parse(time),
          time: int.parse(time),
          isSuspicious: 0,
          isPoojaProduct: true,
          awsUrl: productDetails.poojaImg ?? '',
          msgType: MsgType.pooja,
          suggestedId: saveRemediesData.data!.id,
          type: 0,
          msgSendBy: "1",
          orderId: AppFirebaseService().orderData.value["orderId"],
          userType: "astrologer",
          memberId: saveRemediesData.data!.id,
          productId: productDetails.id.toString(),
          shopId: productDetails.id.toString(),
          // msgStatus: MsgStatus.sent,
          receiverId: int.parse(
              AppFirebaseService().orderData.value["userId"].toString()),
          senderId: preference.getUserDetail()!.id,
          getPooja: GetPooja(
            poojaName: productDetails.poojaName,
            id: productDetails.id,
            gst: productDetails.gst,
            poojaDesc: productDetails.poojaDesc,
            poojaImage: productDetails.poojaImg,
            poojaPriceInr: productDetails.poojaStartingPriceInr,
          ),
        );
      } else {
        final productData =
            data?['data']['saveRemedies'] as SaveRemediesResponse;
        final productDetails = data?['data']['product_detail'] as Products;
        print("going in");
        newMessage = ChatMessage(
            message: productDetails.prodName,
            title: productDetails.prodName,
            astrologerId: preferenceService.getUserDetail()!.id,
            time: int.parse(time),
            id: int.parse(time),
            isSuspicious: 0,
            suggestedId: productData.data!.id,
            userType: "astrologer",
            isPoojaProduct: false,
            awsUrl: userData?.image ?? '',
            msgType: MsgType.product,
            msgSendBy: "1",
            type: 0,
            orderId: AppFirebaseService().orderData.value["orderId"],
            memberId: productData.data?.id ?? 0,
            productId: productData.data?.productId.toString(),
            shopId: productData.data?.shopId.toString(),
            receiverId: int.parse(
                AppFirebaseService().orderData.value["userId"].toString()),
            senderId: preference.getUserDetail()!.id,
            getProduct: GetProduct(
              prodName: productDetails.prodName,
              id: productDetails.id,
              gst: productDetails.gst,
              prodDesc: productDetails.prodDesc,
              prodImage: productDetails.prodImage,
              productLongDesc: productDetails.productLongDesc,
              productPriceInr: productDetails.productPriceInr,
            ));
      }
    } else {
      print("new message added text type");
      newMessage = ChatMessage(
        orderId: AppFirebaseService().orderData.value["orderId"],
        id: int.parse(time),
        message: messageText,
        receiverId: int.parse(
            AppFirebaseService().orderData.value["userId"].toString()),
        senderId: preference.getUserDetail()!.id,
        time: int.parse(time),
        awsUrl: awsUrl,
        msgSendBy: "1",
        productId: productId,
        base64Image: base64Image,
        downloadedPath: downloadedPath,
        msgType: msgType,
        kundliId: kundliId,
        title: giftId ?? "${userData?.name} sent you a message.",
        type: 0,
        userType: "astrologer",
      );
    }
    print("newMessage.msgType");
    print(newMessage.msgType.toString());
    if (newMessage.msgType.toString() != "MsgType.text" ||
        (newMessage.msgType.toString() == "MsgType.text" &&
            !isBadWord(newMessage.message ?? ""))) {
      if (fireChat.value == 1) {
        print("SendingMessageToFireBase");
        print("${newMessage.message}");
        await firebaseDatabase
            .ref()
            .child(
                "chatMessages/${AppFirebaseService().orderData.value["orderId"]}/$time")
            .update(
              newMessage.chatToJson(),
            );
      }
    } else {
      if (kDebugMode) {
        Fluttertoast.showToast(msg: "Bad word detected ${newMessage.message}");
      }
      print("SendingMessageToFireBase Failed");
      print("${newMessage.message}");
    }
    chatMessages.add(newMessage);
    // isPlaying.add(false);
    // progress.add(0.0);
    chatMessages.refresh();
    update();
    scrollToBottomFunc();
    socket.sendMessageSocket(newMessage);
    // updateChatMessages(newMessage, false, isSendMessage: true);
    print("last message---  ${chatMessages.last.message}");
  }

  updateChatMessages(ChatMessage newMessage, bool isFromNotification,
      {bool isSendMessage = false}) async {
    final int index = chatMessages
        .indexWhere((ChatMessage element) => newMessage.time == element.time);
    print("newMessage2 ${newMessage.type}");
    if (index >= 0) {
      print("newMessage3");
      chatMessages[index].seenStatus = newMessage.type;
      chatMessages.refresh();
    } else {
      print("newMessage4");
      if (isFromNotification && messgeScrollController.hasClients) {
        print("newMessage5");
        if (messgeScrollController.position.pixels >
            messgeScrollController.position.maxScrollExtent - 100) {
          print("newMessage6");
          newMessage.type = 2;
          chatMessages.add(newMessage);
          // isPlaying.add(false);
          // progress.add(0.0);
          scrollToBottomFunc();
          updateMsgDelieveredStatus(newMessage, 2);
          if (messgeScrollController.position.pixels ==
              messgeScrollController.position.maxScrollExtent) {
            scrollToBottomFunc();
          }
        } else {
          print("newMessage5");
          newMessage.type = isSendMessage ? 0 : 1;
          chatMessages.add(newMessage);
          // isPlaying.add(false);
          // progress.add(0.0);
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
        // isPlaying.add(false);
        // progress.add(0.0);
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

    if (!isFromNotification) {
      print("isFromNotification-->>$isFromNotification");
      updateReadMessageStatus();
      // scrollToBottomFunc();
    }
  }

  scrollToBottomFunc() {
    if (messgeScrollController.hasClients) {
      print("objectobjectobjectobject");
      Timer(
        const Duration(milliseconds: 100),
        () => messgeScrollController.animateTo(
          messgeScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        ),
      );
      // update();
    }
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
            print('number of gifts $quantity');
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
      addNewMessage(time, MsgType.gift,
          messageText: item.giftName,
          productId: item.id.toString(),
          awsUrl: item.fullGiftImage,
          giftId: item.id.toString());
    }
  }

  updateReadMessageStatus() async {
    for (int i = 0; i < chatMessages.length; i++) {
      if (chatMessages[i].type != 2 &&
          chatMessages[i].senderId != preference.getUserDetail()!.id) {
        // updateMsgDelieveredStatus(chatMessages[i], 2);
        chatMessages[i].type = 2;
      }
    }
    databaseMessage.value.chatMessages = chatMessages;
    unreadMsgCount.value = 0;
    chatMessages.refresh();

    Future.delayed(const Duration(seconds: 1))
        .then((value) => unreadMessageIndex.value = -1);
  }

  sendMsg() {
    if (messageController.text.trim().isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500));
      final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
      // type 1= New chat message, 2 = Delivered, 3= Msg read, 4= Other messages
      unreadMessageIndex.value = -1;
      addNewMessage(time, MsgType.text,
          messageText: messageController.text.trim());
      messageController.clear();
    }
  }

  Future<void> sendTarotCard(int? choice) async {
    HashMap<String, dynamic> hsMap = HashMap();
    hsMap["isCardVisible"] = false;
    var randomTarotCards = await printRandomTarotCards(choice);
    hsMap["listOfCard"] = randomTarotCards;
    int orderId = AppFirebaseService().orderData.value["orderId"] ?? 0;
    print("hashmap" + hsMap.toString());
    if (orderId != 0) {
      await FirebaseDatabase.instance
          .ref()
          .child("order/$orderId/card")
          .set(hsMap);
    }
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
    addNewMessage(time, MsgType.text, messageText: msg.description);
    scrollToBottomFunc();
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

  int getListOfCardLength(BuildContext context) {
    var orderData = AppFirebaseService().orderData.value;
    if ((orderData["card"] != null
            ? (orderData["card"]["isCardVisible"] ?? false)
            : false) &&
        orderData.containsKey("card")) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (AppFirebaseService().orderData.value['card']['listOfCard'] != null) {
        var listOfCard =
            AppFirebaseService().orderData.value['card']['listOfCard'] as Map;
        print("listOfCard ${listOfCard.length}");
        return listOfCard.length;
      } else {
        return 0;
      }
    }
    return 0;
  }

  String getValueByPosition(int position) {
    var card = AppFirebaseService().orderData.value['card'];
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
    var orderData = AppFirebaseService().orderData.value;
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

  final CallChatHistoryRepository callChatFeedBackRepository =
      Get.put(CallChatHistoryRepository());
  RxInt currentPage = 1.obs;

  getChatList() async {
    update();
    try {
      var userId = int.parse(AppFirebaseService().orderData.value["userId"]);
      var astroId = int.parse(AppFirebaseService().orderData.value["astroId"]);

      var response = await callChatFeedBackRepository.getAstrologerChats(
          userId, astroId, currentPage.value);

      if (response.success ?? false) {
        List<ChatMessage> fetchedMessages = response.chatMessages ?? [];

        if (fetchedMessages.isNotEmpty) {
          if (currentPage.value.toString() == "1") {
            chatMessages.clear();
            chatMessages.addAll(response.chatMessages!.reversed);
            scrollToBottomFunc();
          } else {
            chatMessages.insertAll(0, response.chatMessages!.reversed);
          }

          scrollToBottomFunc();
          chatMessages.refresh();
          // for (var i = 0; i < chatMessages.length; i++) {
          //   isPlaying.add(false);
          //   progress.add(0.0);
          //   print('selectedIndexForTranslate');
          // }
        }
      } else {
        throw CustomException(response.message ?? 'Failed to get chat history');
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    } finally {
      update();
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    print("keyBoardOpen");
    final bool isKeyboardOpen =
        MediaQuery.of(Get.context!).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      Timer(
          const Duration(milliseconds: 300),
          () => messgeScrollController.animateTo(
                messgeScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              ));
    }
  }

  uploadAudioFile(File soundFile) async {
    final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    final uploadFile =
        await uploadImageFileToAws(file: soundFile, moduleName: "chat");
    if (uploadFile != "" && uploadFile != null) {
      addNewMessage(time, MsgType.audio, awsUrl: uploadFile);
    }
  }

  downloadImage(
      {required String fileName,
      required ChatMessage chatDetail,
      required int index}) async {
    final http.Response response =
        await http.get(Uri.parse(chatDetail.message!));
    final Directory documentDirectory =
        await getApplicationDocumentsDirectory();
    final String firstPath = "${documentDirectory.path}/images";
    final String filePathAndName =
        "${documentDirectory.path}/images/${chatDetail.id}.jpg";

    await Directory(firstPath).create(recursive: true);
    final File file2 = File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    int index2 = chatMessages.indexWhere((element) {
      return element.id == chatDetail.id;
    });
    chatMessages[index2].downloadedPath = filePathAndName;
    chatMessages.refresh();

    update();
  }

  /// ------------------ check if file exists  ----------------------- ///
  Future<String?> getDownloadedImagePath(
    int chatDetailId,
  ) async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var filePathAndName = "${documentDirectory.path}/images/$chatDetailId.jpg";

    // Check if the file already exists
    if (await File(filePathAndName).exists()) {
      return filePathAndName;
    } else {
      return null;
    }
  }

// void leavePrivateChat() {
//   socket.leavePrivateChat((data) {
//     debugPrint("userLeavePrivateChatListenerSocket $data");
//   });
// }

  void customerLeavedPrivateChatListenerSocket() {
    socket.customerLeavedPrivateChatListenerSocket((data) {
      debugPrint("Yes customer leaved chat successfully $data");
      //chatStatus("Offline");
    });
  }

  File getFile(String base64String) {
    Directory? appDocumentsDirectory;
    getApplicationDocumentsDirectory().then((value) {
      debugPrint('what is value $value');
      appDocumentsDirectory = value;
    });
    if (appDocumentsDirectory != null) {
      String filePath =
          '${appDocumentsDirectory!.path}/${AppFirebaseService().currentTime()}';
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

  RitentionPopupModel? ritentionPopupModel;

  getRitentionPopUpDataApi() async {
    try {
      log(222.toString());

      final response = await userRepository.getRitentionDataApi({});
      if (response.success == true) {
        ritentionPopupModel = response;
        if (ritentionPopupModel!.data != null) {
          print("showing popup -- ritention");
          showRitentionPopup();
        } else {
          print("not showing popup -- ritention");
        }
      } else {
        log(3.toString());
      }
    } catch (error) {
      log(33.toString());

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    update();
  }

  Future<void> showRitentionPopup() async {
    try {
      print("isssssssssssssssssssssssss");
      return Get.dialog(
        barrierDismissible: true,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
          content: ConstrainedBox(
            constraints:
                const BoxConstraints(maxHeight: 600.0), // Adjust as needed
            child: ritentionPoupWidget(Get.context!),
          ),

          // content: ritentionPoupWidget(Get.context!),
          contentPadding: EdgeInsets.all(5),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Ok",
                style: AppTextStyle.textStyle18(
                  fontWeight: FontWeight.w500,
                  fontColor: appColors.darkBlue,
                ),
              ),
            )
          ],
        ),
      );
    } catch (e, stackTrace) {
      print('Error showing popup: $e');
      print('StackTrace: $stackTrace');
    }
  }

  Widget ritentionPoupWidget(BuildContext context) {
    return GetBuilder<ChatMessageWithSocketController>(builder: (controller) {
      return SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 10.h),
          child: ritentionPopupModel!.data == null
              ? SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Html(
                      shrinkWrap: true,
                      data: ritentionPopupModel!.data!.type ?? "" * 9,
                      onLinkTap: (url, attributes, element) {
                        launchUrl(Uri.parse(url ?? ''));
                      },
                    ),
                    Html(
                      shrinkWrap: true,
                      data: ritentionPopupModel!.data!.message ?? "" * 99,
                      onLinkTap: (url, attributes, element) {
                        launchUrl(Uri.parse(url ?? ''));
                      },
                    ),
                  ],
                ),
        ),
      );
    });
  }

  final noticeRepository = Get.put(NoticeRepository());
  List<NoticeDatum> noticeDataChat = [];

  noticeAPi() async {
    try {
      final response = await noticeRepository.get(
          "${ApiProvider.getAstroAllNoticeType3}&orderId=${AppFirebaseService().orderData.value["orderId"].toString()}&userId=${AppFirebaseService().orderData.value["userId"].toString()}",
          headers: await noticeRepository.getJsonHeaderURL());

      if (response.statusCode == 200) {
        final noticeResponse = noticeResponseFromJson(response.body);
        if (noticeResponse.statusCode == noticeRepository.successResponse &&
            noticeResponse.success!) {
          noticeDataChat = noticeResponse.data;
          print(noticeDataChat.length);
          print("noticeDataChat.length");
          update();
        } else {
          throw CustomException(json.decode(response.body));
        }
      } else {
        throw CustomException(json.decode(response.body));
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  List<CustomProductData> customProductData = [];

  getSavedRemedies() async {
    try {
      final response = await noticeRepository.get(ApiProvider.getCustomEcom,
          headers: await noticeRepository.getJsonHeaderURL());
      CustomProductListModel savedRemediesData =
          CustomProductListModel.fromJson(jsonDecode(response.body));
      if (savedRemediesData.statusCode == 200) {
        customProductData = savedRemediesData.data!;
        print(jsonEncode(customProductData));
        print(customProductData.length);
        print("customProductData.length");
        update();
      } else {
        customProductData = [];
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  /// new audio logic
  var selectedIndex = 0.obs;

  // var isPlaying = [].obs;
  // var progress = [].obs;
  late AudioPlayer audioPlayer;
  Rx<Duration> durationTime = Duration().obs;
  Rx<Duration> currentDurationTime = Duration().obs;

  Future<void> initAudioPlayer({path, index}) async {
    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((Duration duration) {
      durationTime.value = duration;
    });
    currentDurationTime.value = Duration(seconds: 0);
    audioPlayer.onPositionChanged.listen((Duration position) {
      currentDurationTime.value = Duration(seconds: position.inSeconds);
      if (currentDurationTime.value.inSeconds == durationTime.value.inSeconds) {
        audioPlayer.pause();
        chatMessages[index].isPlaying = false;
        update();
      }
      currentDurationTime.value = Duration(seconds: position.inSeconds);
      if (durationTime.value.inMilliseconds != 0) {
        chatMessages[index].progress =
            position.inMilliseconds / durationTime.value.inMilliseconds;
        update();
      }
    });
    audioPlayer.play(UrlSource(path));
    chatMessages[index].isPlaying = true;
    update();
  }
}
