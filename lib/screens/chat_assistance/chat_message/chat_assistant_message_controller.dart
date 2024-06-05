import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:divine_astrologer/model/res_product_detail.dart';
import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_list_model.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app_socket/app_socket.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../common/show_permission_widget.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../../../model/chat_assistant/chat_assistant_chats_response.dart';
import '../../../model/message_template_response.dart';
import '../../../model/save_remedies_response.dart';
import '../../../repository/chat_assistant_repository.dart';
import '../../../repository/chat_repository.dart';
import '../../../repository/kundli_repository.dart';
import '../../live_page/constant.dart';
import 'widgets/product/pooja/pooja_dharam/get_single_pooja_response.dart';

class ChatMessageController extends GetxController with WidgetsBindingObserver {
  final chatAssistantRepository = ChatAssistantRepository();
  final messageScrollController = ScrollController();
  ChatAssistChatResponse? chatAssistChatResponse;
  RxList chatMessageList = [].obs;
  var preference = Get.find<SharedPreferenceService>();

  RxString userProfileImage = "".obs;
  RxList<AssistChatData> unreadMessageList = <AssistChatData>[].obs;
  RxList<MessageTemplates> messageTemplates = <MessageTemplates>[].obs;
  final keyboardVisibilityController = KeyboardVisibilityController();
  RxInt currentPage = 1.obs;
  Set<int> processedPages = {};
  TextEditingController messageController = TextEditingController();
  RxBool isEmojiShowing = false.obs;
  DataList? args;
  RxString? baseImageUrl = "".obs;
  RxBool isCustomerOnline = false.obs;
  RxBool loading = false.obs;
  File? image;
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  final socket = AppSocket();
  Rx<bool> isRecording = false.obs;
  RxMap selectedVoucher = {}.obs;
  List<Map> voucherList = [
    {
      "id": 1,
      "name": "5 Minutes",
      "description": "User can chat free for 5 minutes.",
    },
    {
      "id": 2,
      "name": "10 Minutes",
      "description": "User can chat free for 10 minutes.",
    },
    {
      "id": 3,
      "name": "15 Minutes",
      "description": "User can chat free for 15 minutes.",
    }
  ];
  File? uploadFile;
  RxBool isDataLoad = false.obs;
  final appSocket = AppSocket();

  ChatMessageController(KundliRepository put, ChatRepository put2);

  //variables to manage chat state
  StreamSubscription? _appLinkingStreamSubscription;
  late final AppLifecycleListener _listener;
  late AppLifecycleState? _state;
  final List<String> _states = <String>[];

//end

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    noticeAPi();
    getSavedRemedies();
    args = Get.arguments;
    WidgetsBinding.instance.addObserver(this);
    stateHandling();
  }

  stateHandling() {
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onShow: () {},
      onResume: () {
        //updateFirebaseToken();
        getBackGroundMessages();
      },
      onHide: () {},
      onInactive: () {},
      onPause: () {},
      onDetach: () {},
      onRestart: () {
        // updateFirebaseToken();
        getBackGroundMessages();
      },
      onStateChange: (value) {
        print("on state changed called in chat assistance ${value.name}");
      },
    );
    if (_state != null) {
      _states.add(_state!.name);
    }
  }

  getBackGroundMessages() {
    final newChatList = assistChatNewMsg;
    if (newChatList.isNotEmpty) {
      print("new chat list ${newChatList.length} ");
      for (int index = 0; index < newChatList.length; index++) {
        print("new chat list ${jsonEncode(newChatList[index])} ");
        var responseMsg = newChatList[index];
        if (int.parse(responseMsg?["sender_id"].toString() ?? '') == args?.id) {
          chatMessageList([
            ...chatMessageList,
            AssistChatData(
                isPoojaProduct: responseMsg['message'] == "1" ? true : false,
                message: responseMsg['message'],
                astrologerId:
                    int.parse(responseMsg?["userid"].toString() ?? ''),
                createdAt: DateTime.parse(responseMsg?["created_at"])
                    .millisecondsSinceEpoch
                    .toString(),
                // id: responseMsg["chatId"] != null &&
                //         responseMsg["chatId"] != ''&& responseMsg["chatId"]=='undefined'
                //     ? int.parse(responseMsg["chatId"])
                //     : null,
                id: int.parse(responseMsg?["chatId"].toString() ?? ''),
                isSuspicious: 0,
                suggestedRemediesId:
                    int.parse(responseMsg['suggestedRemediesId'] ?? '0'),
                productId: responseMsg['productId'].toString(),
                sendBy: SendBy.customer,
                msgType: responseMsg["msg_type"] != null
                    ? msgTypeValues.map[responseMsg["msg_type"]]
                    : MsgType.text,
                seenStatus: SeenStatus.received,
                customerId: int.parse(responseMsg['sender_id'] ?? 0))
          ]);
          chatMessageList.refresh();
          scrollToBottomFunc();
          assistChatNewMsg.removeAt(index);
          update();
        }
      }
      update();
    }
  }

  List<NoticeDatum> noticeDataChat = [];
  final noticeRepository = NoticeRepository();

  noticeAPi() async {
    try {
      final response = await noticeRepository.get(
          ApiProvider.getAstroAllNoticeType4,
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

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       socket.socketConnect();
  //       updateFirebaseToken();
  //       break;
  //     case AppLifecycleState.inactive:
  //       debugPrint("App Inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       debugPrint("App Paused");
  //       break;
  //     case AppLifecycleState.detached:
  //       debugPrint("App Detached");
  //       break;
  //     case AppLifecycleState.hidden:
  //       break;
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    // readUnreadMessages();
    isCustomerOnline = false.obs;
    chatMessageList.clear();
    processedPages.clear();
    listenUserEnterChatSocket();
    WidgetsBinding.instance.removeObserver(this);
    currentPage(1);
    super.dispose();
  }

  socketReconnect() {
    print("called socketReconnect ${socket.socket?.disconnected}");
    if (socket.socket?.disconnected == true) {
      socket.socket
        ?..disconnect()
        ..connect();
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      scrollToBottomFunc();
    });
  }

  void readUnreadMessages() {
    if (assistChatUnreadMessages.isNotEmpty) {
      assistChatUnreadMessages
          .removeWhere((element) => element.customerId == args?.id);
    }
    update();
  }

  // getMessageTemplatesLocally() async {
  //   final sharedPreferencesInstance = SharedPreferenceService();
  //   final data = await sharedPreferencesInstance.getMessageTemplates();
  //   messageTemplates(data);
  //   update();
  // }

  getOurImage() async {
    final prefs = await SharedPreferences.getInstance();
    final baseAmazonUrl = prefs.getString(SharedPreferenceService.baseImageUrl);
    userProfileImage("$baseAmazonUrl/${userData?.image}");
  }

  sendMsgTemplate(MessageTemplates msg, bool isTemplateMsg) {
    // final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    print("test_isTemplateMsg: $isTemplateMsg");
    sendMsg(MsgType.text, {'text': msg.description}, isTemplateMsg);
  }

  userEnterChatSocket() {
    appSocket.emitForAstrologerEnterChatAssist(
        args?.id.toString(), userData?.id.toString());
  }

  listenUserEnterChatSocket() {
    appSocket.listenForAstrologerEnterChatAssist(
      (data) {
        print("people in room data from astro left socket ${data}");
      },
    );
  }

  userjoinedChatSocket() {
    appSocket.emitForStartAstroCustChatAssist(
        userData?.id.toString(), args?.id.toString(), 0);
  }

  userleftChatSocket() {
    print("called user left chat socket");
    appSocket.userLeftCustChatAssist(
        userData?.id.toString(), args?.id.toString());
  }

  userleftChatSocketListen() {
    appSocket.userLeftListenChatAssist(
      (data) {
        print("people in room data from left socket $data");
        if (data['msg'] == 2) {
          isCustomerOnline(true);
        }
        isCustomerOnline(false);
        update();
      },
    );
  }

  listenjoinedChatSocket() {
    print("listen joined chat socket called");
    appSocket.listenUserJoinedSocket(
      (data) {
        print("people in room data from joined socket $data");
        if (data['msg'] == 2) {
          isCustomerOnline(true);
        }
        isCustomerOnline(false);
        update();
      },
    );
  }

  void listenSocket() {
    appSocket.listenForAssistantChatMessage((chatData) {
      final newChatData = AssistChatData.fromJson(chatData['msgData']);
      print(
          "new message update in chatassist listen scoket ${newChatData.toJson()}");
      // newChatData.seenStatus = chatData['seen_status'] != null
      //     ? seenStatusValues.map[chatData["seen_status"].toString()]
      //     : SeenStatus.sent;
      final updateAtIndex = chatMessageList
          .indexWhere((oldChatData) => oldChatData.id == newChatData.id);
      if (updateAtIndex == -1) {
        chatMessageList.add(newChatData);
      } else {
        chatMessageList[updateAtIndex] = newChatData;
      }
      print(
          "new message update in chatassist listen scoket ${chatMessageList.last.toJson()}");
      update();
    });
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
    final bool result = await permissionPhotoOrStorage();
    print("photo permission $result");
    if (result) {
      pickedFile = await picker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);

      if (pickedFile != null) {
        image = File(pickedFile!.path);
        isDataLoad.value = false;
        await cropImage();
      }
    } else {
      await showPermissionDialog(
        permissionName: 'Gallery permission',
        isForOverlayPermission: false,
      );
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

    final String uploadFile = await uploadImageFileToAws(
            file: File(fileData.path),
            moduleName: "chat-assistant-astrologer") ??
        "";
    if (uploadFile != "") {
      print("image message upload file ${uploadFile} ${base64Image}");
      final Map<String, dynamic> data = {
        'awsUrl': uploadFile,
        'base64Image': base64Image,
        'time': time,
      };
      sendMsg(MsgType.image, data, false);
    }
  }

  scrollToBottomFunc() {
    print("chat Assist Scrolled to bottom");
    messageScrollController.hasClients
        ? messageScrollController.animateTo(
            messageScrollController.position.maxScrollExtent * 2,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut)
        : ();
  }

  reArrangeChatList() {
    // to remove duplicacy of messages
    // chatMessageList(chatMessageList
    //     .groupBy((chat) => chat.id)
    //     .values
    //     .map((group) => group.first)
    //     .cast<AssistChatData>()
    //     .toList());

    //
    chatMessageList.sort((a, b) {
      if (a is AssistChatData && b is AssistChatData) {
        return a.createdAt?.compareTo(b.createdAt ?? '0') ?? 1;
      }
      return 0;
    });
    update();
  }

  getAssistantChatList() async {
    print("assistant chat ${await FirebaseMessaging.instance.getToken()} ");
    try {
      loading(true);
      if (processedPages.contains(currentPage.value)) {
        loading(false);
        return;
      }
      final map = {"customer_id": args!.id, "page": currentPage.value};
      print("payload data $map");
      final response = await chatAssistantRepository.getAstrologerChats(
          {"customer_id": args!.id, "page": currentPage.value});
      if (response.data != null) {
        if (response.data!.chatAssistMsgList?.isNotEmpty == true) {
          chatMessageList.addAll(response.data!.chatAssistMsgList!);
          print("---------------------chatAssistMsgList--------------------");
          print(response.data?.toJson());
          if (response.data!.nextPageUrl != null) {
            currentPage++;
          } else {
            processedPages.add(currentPage.value);
          }
        } else {
          processedPages.add(currentPage.value);
        }
      }
    } catch (e, s) {
      debugPrint("Error fetching chat messages: $e $s");
    }

    reArrangeChatList();
    loading(false);
  }

  getMessageTemplateForChatAssist() async {
    messageTemplates.clear();

    try {
      final response =
          await chatAssistantRepository.doGetMessageTemplateForChatAssist();
      print("getting message from assistant chat ${response?.toJson()}");

      if (response != null && response.data != null) {
        if (response.data!.isNotEmpty) {
          for (int i = 0; i < response.data!.length; i++) {
            MessageTemplates model = response.data![i];

            if (model.title!.isNotEmpty && model.description!.isNotEmpty) {
              model.message = model.title;
              messageTemplates.add(model);
            }
          }
          debugPrint("test_messageTemplates: ${messageTemplates.length}");
        }
      } else {
        debugPrint("test_response: response or response.data null found");
      }
    } catch (e, s) {
      debugPrint("Error fetching chat messages: $e $s");
    }
  }

  uploadAudioFile(File soundFile) async {
    final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    final String uploadFile = await uploadImageToS3Bucket(soundFile, time);
    if (uploadFile != "") {
      sendMsg(MsgType.audio, {'audioUrl': uploadFile}, false);
    }
  }

  void sendMsg(MsgType msgType, Map data, isTemplateMsg) {
    print("test_isTemplateMsg: $isTemplateMsg");

    late AssistChatData msgData;
    switch (msgType) {
      case MsgType.text:
        msgData = AssistChatData(
            message: data['text'],
            profileImage: userData?.image,
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            msgType: MsgType.text,
            sendBy: SendBy.astrologer,
            seenStatus: SeenStatus.notSent,

            // msgStatus: MsgStatus.sent,
            customerId: args?.id);
        appSocket.sendAssistantMessage(
            customerId: args!.id.toString(),
            msgData: msgData,
            message: data['text'],
            astroId: preferenceService.getUserDetail()!.id.toString());
        break;
      case MsgType.voucher:
        msgData = AssistChatData(
            message: jsonEncode(data['data']),
            profileImage: userData?.image,
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            msgType: MsgType.voucher,
            sendBy: SendBy.astrologer,
            seenStatus: SeenStatus.notSent,

            // msgStatus: MsgStatus.sent,
            customerId: args?.id);
        appSocket.sendAssistantMessage(
            customerId: args!.id.toString(),
            msgData: msgData,
            message: jsonEncode(data['data']),
            astroId: preferenceService.getUserDetail()!.id.toString());
        break;
      case MsgType.audio:
        msgData = AssistChatData(
            message: data['audioUrl'],
            profileImage: userData?.image,
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            msgType: MsgType.audio,
            sendBy: SendBy.astrologer,
            seenStatus: SeenStatus.notSent,

            // msgStatus: MsgStatus.sent,
            customerId: args?.id);
        appSocket.sendAssistantMessage(
            customerId: args!.id.toString(),
            msgData: msgData,
            message: data['audioUrl'],
            astroId: preferenceService.getUserDetail()!.id.toString());
        break;
      case MsgType.remedies:
        msgData = AssistChatData(
            message: data['message'],
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            profileImage: userData?.image,
            msgType: MsgType.remedies,
            sendBy: SendBy.astrologer,
            seenStatus: SeenStatus.notSent,
            customerId: args?.id);
        appSocket.sendAssistantMessage(
            customerId: args!.id.toString(),
            msgData: msgData,
            message: data['message'],
            astroId: preferenceService.getUserDetail()!.id.toString());
        break;
      case MsgType.image:
        msgData = AssistChatData(
            message: data['awsUrl'],
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            profileImage: userData?.image,
            msgType: MsgType.image,
            sendBy: SendBy.astrologer,
            seenStatus: SeenStatus.notSent,
            // msgStatus: MsgStatus.sent,
            customerId: args?.id);
        appSocket.sendAssistantMessage(
            customerId: args!.id.toString(),
            msgData: msgData,
            message: data['awsUrl'],
            astroId: preferenceService.getUserDetail()!.id.toString());
        break;
      case MsgType.product:
        final isPooja = data['data']['isPooja'] as bool;
        if (isPooja) {
          final productDetails = data['data']['poojaData'] as Pooja;
          final saveRemediesData =
              data['data']['saveRemediesData'] as SaveRemediesResponse;
          msgData = AssistChatData(
              message: productDetails.poojaName,
              astrologerId: preferenceService.getUserDetail()!.id,
              createdAt: DateTime.now().toIso8601String(),
              id: DateTime.now().millisecondsSinceEpoch,
              isSuspicious: 0,
              isPoojaProduct: true,
              profileImage: userData?.image,
              msgType: MsgType.pooja,
              sendBy: SendBy.astrologer,
              product: Product(
                id: productDetails.id,
              ),
              suggestedRemediesId: saveRemediesData.data?.id,
              productImage: productDetails.poojaImg ?? '',
              productId: productDetails.id.toString(),
              shopId: productDetails.id.toString(),
              seenStatus: SeenStatus.notSent,
              // msgStatus: MsgStatus.sent,
              customerId: args?.id);
          appSocket.sendAssistantMessage(
              customerId: args!.id.toString(),
              msgData: msgData,
              message: productDetails.poojaName ?? '',
              astroId: preferenceService.getUserDetail()!.id.toString());
        } else {
          final productData =
              data['data']['saveRemedies'] as SaveRemediesResponse;
          final productDetails = data['data']['product_detail'] as Products;
          print("delete product data ${productDetails} ${productData}");
          msgData = AssistChatData(
              message: productDetails.prodName,
              astrologerId: preferenceService.getUserDetail()!.id,
              createdAt: DateTime.now().toIso8601String(),
              id: DateTime.now().millisecondsSinceEpoch,
              isSuspicious: 0,
              isPoojaProduct: false,
              profileImage: userData?.image,
              msgType: MsgType.product,
              suggestedRemediesId: productData.data?.id ?? 0,
              sendBy: SendBy.astrologer,
              product: Product(
                  id: productData.data?.shopId,
                  prodName: productDetails.prodName),
              productImage: productDetails.prodImage ?? '',
              productId: productData.data?.productId.toString(),
              shopId: productData.data?.shopId.toString(),
              seenStatus: SeenStatus.notSent,
              // msgStatus: MsgStatus.sent,
              customerId: args?.id);
          appSocket.sendAssistantMessage(
              customerId: args!.id.toString(),
              msgData: msgData,
              message: productDetails.prodName ?? '',
              astroId: preferenceService.getUserDetail()!.id.toString());
        }
        break;
      case MsgType.customProduct:
        msgData = AssistChatData(
            message: data["title"],
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            profileImage: userData?.image,
            msgType: MsgType.customProduct,
            sendBy: SendBy.astrologer,
            seenStatus: SeenStatus.notSent,
            productImage: data["image"],
            // msgStatus: MsgStatus.sent,
            productPrice: data["product_price"],
            productId: data["product_id"].toString(),
            customerId: args?.id);
        print(msgData.msgType);
        print("msgData.msgType");
        appSocket.sendAssistantMessage(
          customerId: args!.id.toString(),
          msgData: msgData,
          message: data["title"],
          astroId: preferenceService.getUserDetail()!.id.toString(),
        );
      default:
    }

    // print("socket msg");
    // print(preferenceService.getUserDetail()!.id.toString());
    // print(args!.id.toString());
    print("adding data ${msgData.toJson()}");
    chatMessageList.add(msgData
      ..createdAt = DateTime.parse(msgData.createdAt ?? '')
          .millisecondsSinceEpoch
          .toString());
    scrollToBottomFunc();
    messageController.clear();

    print("test_isTemplateMsg: $isTemplateMsg");
    if (isTemplateMsg) {
      Get.back();
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
}
