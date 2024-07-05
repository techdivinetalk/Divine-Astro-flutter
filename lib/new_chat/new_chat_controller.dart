import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:divine_astrologer/utils/is_bad_word.dart';
import "package:flutter/scheduler.dart" as scheduler;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/MiddleWare.dart';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/ask_for_gift_bottom_sheet.dart';
import 'package:divine_astrologer/common/camera.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/common/show_permission_widget.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/astrologer_gift_response.dart';
import 'package:divine_astrologer/model/chat_histroy_response.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/model/message_template_response.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:divine_astrologer/model/save_remedies_response.dart';
import 'package:divine_astrologer/model/tarot_response.dart';
import 'package:divine_astrologer/repository/message_template_repository.dart';
import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/get_single_pooja_response.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/custom_puja/saved_remedies.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_list_model.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart';
import 'package:divine_astrologer/screens/live_dharam/gifts_singleton.dart';
import 'package:divine_astrologer/tarotCard/FlutterCarousel.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:divine_astrologer/zego_call/zego_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import '../cache/custom_cache_manager.dart';
import '../di/api_provider.dart';
import '../model/res_product_detail.dart';
import '../screens/live_page/constant.dart';


class NewChatController extends GetxController
    with GetTickerProviderStateMixin {
  late SVGAAnimationController svgaController;
  TextEditingController messageController = TextEditingController();
  TextEditingController reportMessageController = TextEditingController();
  ScrollController messageScrollController = ScrollController();
  ScrollController typingScrollController = ScrollController();
  final preference = Get.find<SharedPreferenceService>();
  RxString astrologerBackgroundColor = "".obs;
  RxString showTalkTime = "".obs;
  RxString extraTalkTime = "".obs;
  RecorderController? recorderController;

  RxBool isRecording = false.obs;
  RxBool hasMessage = false.obs;
  RxBool isEmojiShowing = false.obs;
  Loading loading = Loading.initial;
  RxBool isAudioPlaying = false.obs;
  RxString astrologerName = "".obs;
  RxString customerName = "".obs;
  AppSocket appSocket = AppSocket();
  Duration? timeDifference;
  AppLifecycleState? _state;
  final List<String> _states = <String>[];
  late AppLifecycleListener _listener;
  StreamSubscription? msgAddSubscription;
  StreamSubscription? msgUpdateSubscription;


  @override
  void onInit() {
    super.onInit();
    svgaController = SVGAAnimationController(vsync: this);
    svgaController.addListener(() {
      if (svgaController.isCompleted == true) {
        svgaController.reset();
        svgaController.stop();
      }
    });
    if (AppFirebaseService().orderData.isNotEmpty) {
      initialiseControllers();
      joinRoomSocketEvent();
    }
    appSocket.socket!.on(
      ApiProvider.message,
      (data) {
        log("when i am listening message");
      },
    );
    getDir();
    getAllApiDataInChat();
    typingListenerSocket();
    messageController.addListener(onMessageChanged);
    if (astroChatWatcher.value.orderId != null) {
      timer.startMinuteTimer(astroChatWatcher.value.talktime ?? 0,
          astroChatWatcher.value.orderId!);
    }

    initTask(AppFirebaseService().orderData);
    msgAddSubscription = FirebaseDatabase.instance
        .ref("chatMessages/${AppFirebaseService().orderData.value["orderId"]}")
        .onChildAdded
        .listen(
      (event) {
        print(jsonDecode(jsonEncode(event.snapshot.value)));
        print("jsonDecode(jsonEncode(event.snapshot.value))");
        ChatMessage chatMessage = ChatMessage.fromOfflineJson(
            jsonDecode(jsonEncode(event.snapshot.value)));

        chatMessage.id = int.parse(event.snapshot.key ?? "0");
        chatMessages.add(chatMessage);
        scrollToBottomFunc();
        if (chatMessage.animation != null) {
          playGift(chatMessage.animation);
        }
        update();
        if (MiddleWare.instance.currentPage == RouteName.newChat) {
          if (chatMessage.userType == "customer") {
            print("chatMessage.userType");
            FirebaseDatabase.instance
                .ref(
                    "chatMessages/${AppFirebaseService().orderData.value["orderId"]}/${chatMessage.id}")
                .update({
              "type": 3,
            });
          }
        }
      },
    );
    if (MiddleWare.instance.currentPage == RouteName.newChat) {
      msgUpdateSubscription = FirebaseDatabase.instance
          .ref(
              "chatMessages/${AppFirebaseService().orderData.value["orderId"]}")
          .onChildChanged
          .listen(
        (event) {
          ChatMessage chatMessage = ChatMessage.fromOfflineJson(
              jsonDecode(jsonEncode(event.snapshot.value)));
          chatMessage.id = int.parse(event.snapshot.key ?? "0");
          if (chatMessages.isNotEmpty) {
            for (int i = 0; i < chatMessages.length; i++) {
              if (chatMessages[i].id == chatMessage.id) {
                chatMessages[i].type = chatMessage.type;
                print("updating ticks");
                update();
                break;
              }
            }
          }
        },
      );
    }
    _state = scheduler.SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onShow: () {},
      onResume: () {
        print("when app is resume from background");
        if (!isGalleryOpen) {
          getChatList();
        }
        joinRoomSocketEvent();
        initTask(AppFirebaseService().orderData);
        isGalleryOpen = false;
      },
      onHide: () {
        print("when app is in background");
      },
      onInactive: () {
        print("when app is in onInactive");
        leaveRoomSocketEvent();
      },
      onPause: () {
        print("when app is in onPause");
      },
      onDetach: () {
        leaveRoomSocketEvent();
        WidgetsBinding.instance.removeObserver(_listener);
        Get.until(
          (route) {
            return Get.currentRoute == RouteName.dashboard;
          },
        );
        //  Get.find<SocketChatWithAstrologerController>().dispose();
      },
      onRestart: () {},
      onStateChange: (value) {
        print("on state changed called ${value.name}");
      },
    );
    if (_state != null) {
      _states.add(_state!.name);
    }
  }

  getAllApiDataInChat() async {
    await getChatList();
    await getMessageTemplates();
    await getMessageTemplatesLocally();
    await noticeAPi();
    getCustomEcom();
  }

  // @override
  // void dispose() {
  //   unsubscribeFromMessageUpdates();
  //    super.dispose();
  // }

  void unsubscribeFromMessageUpdates() {
    if (msgUpdateSubscription != null) {
      msgUpdateSubscription?.cancel();
      msgUpdateSubscription = null;
    }
    if (msgAddSubscription != null) {
      msgAddSubscription?.cancel();
      msgAddSubscription = null;
    }
  }

  @override
  void onReady() {
    super.onReady();
    AppFirebaseService().orderData.listen((Map<String, dynamic> p0) async {
      if (p0["status"] == null || p0["astroId"] == null) {
        backFunction();
      } else {
        print("orderData Changed");
        initTask(p0);
      }
    });
  }

  @override
  void onClose() {
    if (recorderController != null) {
      recorderController?.dispose();
    }
    unsubscribeFromMessageUpdates();
    print("on close msgUpdateSubscription");
    leaveRoomSocketEvent();
    super.onClose();
  }

  /// ------------ timer functions -------------- ///
  Timer? extraTimer;
  Timer? chatTimer;

  void initTask(Map<String, dynamic> p0) {
    if (p0["status"] == null || p0["status"] == "5") {
      WidgetsBinding.instance.endOfFrame.then(
        (_) async {
          chatTimer?.cancel();
          print("WentBack Status-5");
          extraTimer?.cancel();
          Get.until(
            (route) {
              return Get.currentRoute == RouteName.dashboard;
            },
          );
        },
      );
      return;
    }
    if (p0["status"] == "3" || p0["status"] == "2") {
      extraTimer?.cancel();
      print("extraTime closing");
      int remainingTime = AppFirebaseService().orderData.value["end_time"] ?? 0;
      talkTimeStartTimer(remainingTime);
    } else {
      if (p0["order_end_time"] != null) {
        startExtraTimer(p0["order_end_time"], p0["status"]);
      }
    }

    // if (p0["isCustEntered"] != null &&
    //     p0["isCustEntered"] > DateTime.now().microsecondsSinceEpoch) {
    //   updateReadMessage();
    // }
    print("extraTime ${p0["status"]}");

    isCardVisible.value =
        p0["card"] != null ? (p0["card"]["isCardVisible"] ?? false) : false;

    if (isCardBotOpen == true &&
        p0["card"] != null &&
        !(p0["card"]["isCardVisible"])) {
      // "Picking tarot card...";
      update();
    }
  }

  void startExtraTimer(int futureTimeInEpochMillis, String status) {
    if (status == "4") {
      chatTimer?.cancel();
      showTalkTime.value = "-1";
      print("objectobjectobjectobjectobjectobject");
    }
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(futureTimeInEpochMillis);
    Duration timeLeft = const Duration(minutes: 1);
    extraTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // final currentTime = DateTime.now();
      final difference = dateTime.difference(DateTime.now());
      if (difference.isNegative ||
          (difference.inSeconds == 0 &&
              difference.inMinutes == 0 &&
              difference.inHours == 0)) {
        if (AppFirebaseService().orderData.value["orderId"] != null ||
            AppFirebaseService().orderData.value["status"] == "4") {
          extraTimer?.cancel();
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
        print("time Left ${extraTalkTime.value}");
        if (MiddleWare.instance.currentPage == RouteName.dashboard ||
            AppFirebaseService().orderData.value["status"] == "3") {
          print("ExtraTalktime is closing");
          extraTimer?.cancel();
          //AppFirebaseService().orderData.value={};
          //  endChatApi();
        }
        print("time Left ${MiddleWare.instance.currentPage}");
      }
    });
  }

  void talkTimeStartTimer(int futureTimeInEpochMillis) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(futureTimeInEpochMillis * 1000);
    print("futureTime.minute $futureTimeInEpochMillis");
    chatTimer?.cancel();
    chatTimer = null;
    chatTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      timeDifference = dateTime.difference(DateTime.now());

      if (timeDifference!.isNegative ||
          (timeDifference?.inSeconds == 0 &&
              timeDifference?.inMinutes == 0 &&
              timeDifference?.inHours == 0)) {
        await callHangup();
        showTalkTime.value = "-1";
        print("chatTimeLeft ${showTalkTime.value}");
        chatTimer?.cancel();
        Future.delayed(const Duration(seconds: 4)).then((value) {
          if (AppFirebaseService().orderData.value["status"] == "3" &&
              showTalkTime.value == "-1") {
            DatabaseReference ref = FirebaseDatabase.instance.ref(
                "order/${AppFirebaseService().orderData.value["orderId"]}");
            ref.update({
              "status": "4",
              "source": "astrorApp",
              "order_end_time": DateTime.now().millisecondsSinceEpoch + 60000
            });
          }
        });
      } else {
        extraTimer?.cancel();
        //         print('Countdown working');
        showTalkTime.value =
            "${timeDifference?.inHours.toString().padLeft(2, '0')}:"
            "${timeDifference?.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
            "${timeDifference?.inSeconds.remainder(60).toString().padLeft(2, '0')}";
        if (MiddleWare.instance.currentPage == RouteName.dashboard) {
          timer.cancel();
        }
        print("${MiddleWare.instance.currentPage}");
        print(
            'chatTimeLeft ${timeDifference?.inHours}:${timeDifference?.inMinutes.remainder(60)}:${timeDifference?.inSeconds.remainder(60)}');
      }
    });
  }

  Future<void> callHangup() {
    ZegoService().controller.hangUp(Get.context!, showConfirmation: false);
    update();
    return Future<void>.value();
  }

  /// ------------ joinRoom socket event -------------- ///
  joinRoomSocketEvent() {
    if (appSocket.socket!.disconnected) {
      appSocket.socketConnect();
    }
    appSocket.socket!.emit(ApiProvider.enterRoom, {
      "name": AppFirebaseService().orderData.value['astrologerName'],
      "room": AppFirebaseService().orderData.value['orderId'],
    });
  }

  /// ------------ leave room socket event -------------- ///
  leaveRoomSocketEvent() {
    if (appSocket.socket!.disconnected) {
      appSocket.socketConnect();
    }
    appSocket.socket!.emit(ApiProvider.leaveRoom,
        AppFirebaseService().orderData.value['astrologerName']);
  }

  /// ------------------ back function  ----------------------- ///
  void backFunction() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        print("userLeavePrivateChatListenerSocket");

        chatTimer?.cancel();
        extraTimer?.cancel();
        Get.until(
          (route) {
            return Get.currentRoute == RouteName.dashboard;
          },
        );
      },
    );
    return;
  }

  /// ------------------ send message socket functions  ----------------------- ///
  sendMessageInSocket(ChatMessage? newMessage) {
    // log(jsonEncode(newMessage));
    // log(jsonEncode(newMessage).runtimeType.toString());
    print("jsonEncode(newMessage)");
    log(newMessage!.toOfflineJson().toString());
    print("newMessage!.toJson()");
    appSocket.socket!.emit(
      ApiProvider.sendNewMessage,
      newMessage!.toOfflineJson(),
    );
  }

  /// ------------------ typing functions  ----------------------- ///
  Timer? _timer2;
  RxBool isTyping = false.obs;

  void typingListenerSocket() {
    appSocket.socket!.on(ApiProvider.activity, (data) {
      isTyping.value = true;
      typingTimer();
      scrollToBottomFunc();
      update();
      debugPrint("typingListenerSocket $data");
    });
  }

  void typingTimer() {
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

  void tyingSocket() {
    debugPrint(
        'tyingSocket orderId\n${AppFirebaseService().orderData.value['orderId'].toString()},\nuserId: ${AppFirebaseService().orderData.value['userId']}');
    if (AppSocket().socket!.disconnected) {
      AppSocket().socketConnect();
    }
    appSocket.socket!.emit(
      ApiProvider.activity,
      AppFirebaseService().orderData.value['astrologerName'],
    );
  }

  /// ------------------ scroll to bottom  ----------------------- ///
  scrollToBottomFunc() {
    if (messageScrollController.hasClients) {
      print("messageScrollController.hasClients");
      Timer(
        const Duration(milliseconds: 150),
        () => messageScrollController.animateTo(
          messageScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        ),
      );
    }
    // update();
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
    int index = chatMessages.indexWhere((element) {
      return element.id == id;
    });
    chatMessages[index].downloadedPath = filePathAndName;
    chatMessages.refresh();
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
      var uploadFile =
          await uploadImageFileToAws(file: soundFile, moduleName: "chat");
      if (uploadFile != "" && uploadFile != null) {
        print("is uploaded the file from recorder");

        /// write logic for send audio msg
        addNewMessage(msgType: MsgType.audio, awsUrl: uploadFile);
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
    var uploadFile = await uploadImageFileToAws(
        file: File(fileData.path), moduleName: "chat");
    print("IMAGE STEP UPLOAD 3 $uploadFile");
    if (uploadFile != null || uploadFile != "") {
      /// write a code for sending image
      addNewMessage(
        msgType: MsgType.image,
        messageText: uploadFile,
        base64Image: base64Image,
        downloadedPath: '',
      );
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

  /// ------------------ Product bottom sheet ----------------------- ///
  Future<void> openProduct() async {
    var result = await Get.toNamed(RouteName.chatAssistProductPage, arguments: {
      'customerId':
          int.parse(AppFirebaseService().orderData.value["userId"].toString())
    });
    if (result != null) {
      // write code for send product
      addNewMessage(
        msgType: MsgType.product,
        data: {
          'data': result,
        },
        messageText: 'Product',
      );
    }
  }

  /// ------------------ Custom Product bottom sheet ----------------------- ///
  List<CustomProductData> customProductData = [];
  NoticeRepository noticeRepository = NoticeRepository();

  void openCustomShop() {
    Get.bottomSheet(
      SavedRemediesBottomSheet(
        newChatController: NewChatController(),
        customProductData: customProductData,
      ),
    );
  }

  getCustomEcom() async {
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

  /// ------------------ Notice Board Api ----------------------- ///

  List<NoticeDatum> noticeDataChat = [];

  noticeAPi() async {
    try {
      final response = await noticeRepository.get(
          ApiProvider.getAstroAllNoticeType3,
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

  /// ------------------ Tarrot card bottom sheet ----------------------- ///
  RxBool isCardBotOpen = false.obs;
  RxBool isCardVisible = false.obs;

  void openShowDeck() {
    isCardBotOpen.value = true;
    showCardChoiceBottomSheet(Get.context!,NewChatController());
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

  int getListOfCardLength(BuildContext context) {
    var orderData = AppFirebaseService().orderData.value;
    if (isCardVisible.value == true && orderData.containsKey("card")) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      var listOfCard =
          AppFirebaseService().orderData.value['card']['listOfCard'] as Map;

      print("listOfCard ${listOfCard.length}");
      return listOfCard.length;
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

  /// ------------------ Remedies bottom sheet ----------------------- ///
  Future<void> openRemedies() async {
    var result = await Get.toNamed(RouteName.chatSuggestRemedy);
    if (result != null) {
      print(result);
      addNewMessage(
        msgType: MsgType.remedies,
        messageText: result["remedies"].toString(),
        suggestedId: result["remedies_id"].toString(),
      );
    }
  }

  /// ------------------ Ask gift bottom sheet ----------------------- ///
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
      /// write code ask gift
      // unreadMessageIndex.value = -1;
      addNewMessage(
        msgType: MsgType.gift,
        messageText: item.giftName,
        productId: item.id.toString(),
        awsUrl: item.fullGiftImage,
        giftId: item.id.toString(),
      );
    }
  }

  /// ------------------ TextEditing onchanged  ----------------------- ///
  onMessageChanged() {
    hasMessage.value = messageController.text.isNotEmpty;
    update();
  }

  /// -------------------------- chat history API ------------------------ ///
  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  CallChatHistoryRepository callChatFeedBackRepository =
      CallChatHistoryRepository();

  getChatList() async {
    try {
      print(AppFirebaseService().orderData.value["orderId"]);
      print("AppFirebaseService().orderData.value");
      // endChatLoader.value = chatMessages.isEmpty;
      var userId = int.parse(AppFirebaseService().orderData.value["userId"]);
      var astroId = int.parse(AppFirebaseService().orderData.value["astroId"]);

      var response = await callChatFeedBackRepository.getAstrologerChats(
        userId,
        astroId,
      );
      if (response.success ?? false) {
        if (response.chatMessages!.isNotEmpty) {
          chatMessages.clear();
          chatMessages.addAll(response.chatMessages!.reversed);
          update();
          Future.delayed(
            const Duration(milliseconds: 200),
            () {
              scrollToBottomFunc();
            },
          );
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

  /// -------------------------- send message firebase  ------------------------ ///
  RxList<MessageTemplates> messageTemplates = <MessageTemplates>[].obs;
  MessageTemplateRepo messageTemplateRepository = MessageTemplateRepo();

  getMessageTemplates() async {
    try {
      final response = await messageTemplateRepository.fetchTemplates();
      if (response.data != null) {
        messageTemplates.value = response.data!;
      }
      update();
    } catch (error) {
      divineSnackBar(data: error.toString(), color: appColors.redColor);
    }
  }

  getMessageTemplatesLocally() async {
    final sharedPreferencesInstance = SharedPreferenceService();
    try {
      final data = await sharedPreferencesInstance.getMessageTemplates();
      if (data.isNotEmpty) {
        messageTemplates(data);
      }
    } catch (e) {
      //error handling
      print('Error retrieving message templates: $e');
    }
    update();
  }

  /// -------------------------- send message firebase  ------------------------ ///
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  addNewMessage({
    MsgType? msgType,
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
    final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    late ChatMessage newMessage;
    if (msgType == MsgType.customProduct) {
      newMessage = ChatMessage(
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
        productId: getCustomProduct!.id.toString(),
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
          time: int.parse(time),
          isSuspicious: 0,
          isPoojaProduct: true,
          awsUrl: productDetails.poojaImg ?? '',
          msgType: MsgType.pooja,
          // suggestedId: saveRemediesData.data!.id,
          type: 0,
          msgSendBy: "1",
          userType: "astrologer",
          productId: productDetails.id.toString(),
          shopId: productDetails.id.toString(),
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
            isSuspicious: 0,
            userType: "astrologer",
            isPoojaProduct: false,
            awsUrl: userData?.image ?? '',
            msgType: MsgType.product,
            msgSendBy: "1",
            type: 0,
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
        suggestedId: int.parse(suggestedId ?? "0"),
        kundliId: kundliId,
        title: giftId ?? "${userData?.name} sent you a message.",
        type: 0,
        userType: "astrologer",
      );
    }
    newMessage.isSuspicious = isBadWord(messageText ?? "") ? 1 : 0;
    firebaseDatabase
        .ref()
        .child(
            "chatMessages/${AppFirebaseService().orderData.value["orderId"]}/$time")
        .update(
          jsonDecode(jsonEncode(newMessage)),
        );
    update();
    log("last message ----- ${jsonDecode(jsonEncode(newMessage))}");
    print(
        "last message ----- ${jsonDecode(jsonEncode(newMessage)).runtimeType}");
    sendMessageInSocket(newMessage);
  }

  playGift(String? url) async {
    const SVGAParser parser = SVGAParser();
    File file = await CustomCacheManager().getFile(url ?? '');
    await parser.decodeFromBuffer(file.readAsBytesSync()).then((videoItem) {
      svgaController.videoItem = videoItem;
      svgaController.forward();
    });
  }
}
