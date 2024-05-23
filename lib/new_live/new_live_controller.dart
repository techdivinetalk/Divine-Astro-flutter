import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/live/blocked_customer_list_res.dart';
import 'package:divine_astrologer/model/live/blocked_customer_res.dart';
import 'package:divine_astrologer/model/live/deck_card_model.dart';
import 'package:divine_astrologer/model/live/notice_board_res.dart';
import 'package:divine_astrologer/new_live/widget/snack_bar_widget.dart';
import 'package:divine_astrologer/repository/astrologer_profile_repository.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/live_global_singleton.dart';
import 'package:divine_astrologer/screens/live_dharam/live_shared_preferences_singleton.dart';
import 'package:divine_astrologer/screens/live_dharam/live_tarot_game/chosen_cards.dart';
import 'package:divine_astrologer/screens/live_dharam/live_tarot_game/live_carousal.dart';
import 'package:divine_astrologer/screens/live_dharam/live_tarot_game/show_card_deck_to_user.dart';
import 'package:divine_astrologer/screens/live_dharam/live_tarot_game/waiting_for_user_to_select_cards.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/disconnect_call_widget.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/end_session_widget.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/follow_player.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/notif_overlay.dart';
import 'package:divine_astrologer/screens/live_dharam/zego_team/player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:zego_uikit_beauty_plugin/zego_uikit_beauty_plugin.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../model/res_login.dart';
import '../screens/live_dharam/widgets/call_accept_or_reject_widget.dart';

class NewLiveController extends GetxController {
  FirebaseDatabase database = FirebaseDatabase.instance;

  final SharedPreferenceService pref = Get.put(SharedPreferenceService());
  int appID = 696414715;

  String appSign =
      "bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa";

  String serverSecret = "89ceddc6c59909af326ddb7209cb1c16";

  final ZegoUIKitPrebuiltLiveStreamingController zegoController =
      ZegoUIKitPrebuiltLiveStreamingController();

  @override
  void onInit() {
    preferanceAstrologerData();
    getLiveAstrologerData();
    noticeBoard();
    startTimer();
    ZegoUIKit()
        .getSignalingPlugin()
        .getInRoomCommandMessageReceivedEventStream()
        .listen(onInRoomCommandMessageReceived);
    super.onInit();
  }

  RxString astroId = "".obs;
  RxString astroName = "".obs;
  RxString astroAvatar = "".obs;
  RxString liveId = "".obs;
  RxString hostSpeciality = "".obs;
  RxInt timerCurrentIndex = 1.obs;
  RxBool isFront = false.obs;
  RxBool isCamOn = false.obs;
  RxBool extendTimeWidgetVisible = false.obs;
  RxBool isMicOn = false.obs;
  RxBool isHostAvailable = true.obs;
  RxBool showCardDeckToUserPopupTimeoutHappening = false.obs;
  RxBool waitingForUserToSelectCardsPopupVisible = false.obs;

  List<LeaderboardModel> leaderboardModel = [];
  List<WaitListModel> waitList = [];
  List firebaseBlockUsersIds = [];
  WaitListModel? orderModel;
  WaitListModel? currentCaller;
  BlockedCustomerListRes? blockedCustomerListRes;
  NoticeBoardRes? noticeBoardRes;
  TarotGameModel? tarotGameModel;
  List<DeckCardModel> deckCardModelList = [];
  RxBool isAcceptPopupOpen = false.obs;
  ZegoUIKitUser isAcceptPopupOpenFor = ZegoUIKitUser(id: "", name: "");

  preferanceAstrologerData() {
    astroId(pref.getUserDetail()?.id.toString());

    astroName(pref.getUserDetail()?.name ?? "");
    final String awsURL = pref.getAmazonUrl() ?? "";
    final String image = pref.getUserDetail()?.image ?? "";
    astroAvatar(isValidImageURL(imageURL: "$awsURL/$image"));

    liveId(pref.getUserDetail()?.id.toString());

    hostSpeciality(getSpeciality());

    waitList = <WaitListModel>[];
    orderModel = WaitListModel(
      isRequest: false,
      isEngaded: false,
      callType: "",
      totalTime: "",
      avatar: "",
      userName: "",
      id: "",
      generatedOrderId: 0,
      totalMin: 0,
      offerId: 0,
      callStatus: 0,
    );
    isFront(true);
    isCamOn(true);
    isMicOn(true);
    currentCaller = WaitListModel(
      isRequest: false,
      isEngaded: false,
      callType: "",
      totalTime: "",
      avatar: "",
      userName: "",
      id: "",
      generatedOrderId: 0,
      offerId: 0,
      totalMin: 0,
      callStatus: 0,
    );
    blockedCustomerListRes = BlockedCustomerListRes();
    deckCardModelList = [];
    tarotGameModel = TarotGameModel();
    extendTimeWidgetVisible(false);
    update();
    // hasReInitCoHost = false;
  }

  /// ---------------------  extra logic -------------------- ///
  final ScrollController scrollControllerForTop = ScrollController();
  final ScrollController scrollControllerForBottom = ScrollController();

  String isValidImageURL({required String imageURL}) {
    if (GetUtils.isURL(imageURL)) {
      return imageURL;
    } else {
      imageURL = "${pref.getAmazonUrl()}$imageURL";
      if (GetUtils.isURL(imageURL)) {
        return imageURL;
      } else {
        return "";
      }
    }
  }

  Future<bool> permissionCheck() async {
    bool hasAllPerm = false;
    await AppPermissionService.instance.onPressedAstrologerGoLive(
      () async {
        hasAllPerm = true;
      },
    );
    return Future<bool>.value(hasAllPerm);
  }

  String getSpeciality() {
    final List<String> pivotList = <String>[];
    pref.getUserDetail()?.astroCatPivot?.forEach(
          (AstroCatPivot e) => pivotList.add(e.categoryDetails?.name ?? ""),
        );
    return pivotList.join(", ");
  }

  bool hasMessageContainsAnyBadWord(String input) {
    List<String> badWords = LiveSharedPreferencesSingleton().getBadWordsList();
    print("hasBadWord: ${badWords.length}");
    List<String> words = input.toLowerCase().split(' ');

    for (String word in words) {
      if (badWords.contains(word)) {
        return true;
      }
    }

    return false;
  }

  final RegExp indianPhoneNumberRegex = RegExp(r'\b(?:\+?91|0)?[ -]?\d{10}\b');
  final RegExp emailRegex =
      RegExp(r'\b[A-Za-z0-9._%+-]+@\b[A-Za-z0-9.-]+\.[A-Z|a-z]{2,6}\b');
  final RegExp instagramIdRegex = RegExp(r'@[a-zA-Z0-9_]{1,30}\b');

  String algoForSendMessage(String input) {
    final bool hasPhoneNumber = indianPhoneNumberRegex.hasMatch(input);
    final bool hasEmail = emailRegex.hasMatch(input);
    final bool hasInstagramId = instagramIdRegex.hasMatch(input);
    final List<String> data = <String>[];
    if (hasPhoneNumber) {
      data.add("Phone Number");
    } else {}
    if (hasEmail) {
      data.add("Email Address");
    } else {}
    if (hasInstagramId) {
      data.add("Instagram Id");
    } else {}
    return data.isEmpty ? "" : data.join(", ");
  }

  void scrollDownForTop() {
    if (scrollControllerForTop.hasClients) {
      final double maxScr = scrollControllerForTop.position.minScrollExtent;
      scrollControllerForTop.animateTo(
        maxScr,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
      );
      update();
    } else {}
    return;
  }

  void scrollDownForBottom() {
    if (scrollControllerForBottom.hasClients) {
      final double maxScr = scrollControllerForBottom.position.minScrollExtent;
      scrollControllerForBottom.animateTo(
        maxScr,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
      );
      update();
    } else {}
    return;
  }

  void getUntil() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (Get.context!.mounted) {
          final int length = LiveGlobalSingleton().getCountOfOpenDialogs();
          print("getUntil():: closing $length items");
          for (int i = 0; i < length; i++) {
            Navigator.of(Get.context!).pop();
          }
        } else {}
      },
    );
    return;
  }

  String _twoDigits(int n) {
    return n >= 10 ? '$n' : '0$n';
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  /// Timer logic every some second
  void startTimer() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (Get.context!.mounted) {
          const duration = Duration(seconds: 1);
          timer = Timer.periodic(
            duration,
            (Timer timer) async {
              if (timer.tick % 30 == 0) {
                timerCurrentIndex.value++;
                if (timerCurrentIndex > (noticeBoardRes!.data?.length ?? 0)) {
                  timerCurrentIndex.value = 1;
                } else {}
              } else {}

              if (timer.tick % 300 == 0) {
                final ZegoCustomMessage model = ZegoCustomMessage(
                  type: 1,
                  liveId: liveId.value,
                  userId: "0",
                  userName: "Live Monitoring Team",
                  avatar:
                      "https://divinenew-prod.s3.ap-south-1.amazonaws.com/astrologers/February2024/j2Jk4GAUbEipC81xRPKt.png",
                  message: "Live Monitoring Team Joined",
                  timeStamp: DateTime.now().toString(),
                  fullGiftImage: "",
                  isBlockedCustomer: false,
                  isMod: true,
                );
                await sendMessageToZego(model);
              } else {}

              if (timer.tick % 600 == 0) {
                final ZegoCustomMessage model = ZegoCustomMessage(
                  type: 1,
                  liveId: liveId.value,
                  userId: "0",
                  userName: "Quality Team",
                  avatar:
                      "https://divinenew-prod.s3.ap-south-1.amazonaws.com/astrologers/February2024/j2Jk4GAUbEipC81xRPKt.png",
                  message: "Quality Team Joined",
                  timeStamp: DateTime.now().toString(),
                  fullGiftImage: "",
                  isBlockedCustomer: false,
                  isMod: true,
                );
                await sendMessageToZego(model);
              } else {}
            },
          );
        } else {}
      },
    );
  }

  // ------------------------ All Live Api Calls ------------------------- ///
  UserRepository userRepository = UserRepository();
  AstrologerProfileRepository liveRepository = AstrologerProfileRepository();

  Future<List<String>> callBlockedCustomerListRes() async {
    final List<String> blockedCustomerList = [];
    final Map<String, dynamic> param = <String, dynamic>{"role_id": 7};
    BlockedCustomerListRes res = BlockedCustomerListRes();
    res = await liveRepository.blockedCustomerListAPI(
      params: param,
      successCallBack: log,
      failureCallBack: log,
    );
    res.statusCode == HttpStatus.ok
        ? BlockedCustomerListRes.fromJson(res.toJson())
        : BlockedCustomerListRes.fromJson(BlockedCustomerListRes().toJson());
    res.data?.forEach(
      (element) {
        blockedCustomerList.add((element.customerId ?? 0).toString());
      },
    );
    return Future<List<String>>.value(blockedCustomerList);
  }

  /// Get notice board
  noticeBoard() async {
    NoticeBoardRes res = NoticeBoardRes();
    res = await liveRepository.noticeBoardAPI(
      failureCallBack: (message) {
        liveSnackBar(msg: message);
      },
    );
    noticeBoardRes = res.statusCode == HttpStatus.ok
        ? NoticeBoardRes.fromJson(res.toJson())
        : NoticeBoardRes.fromJson(NoticeBoardRes().toJson());
    update();
  }

  /// Ask for Audio Video Privet Call and Gift Api
  Future<void> sendGiftAPI({
    required Map<String, dynamic> data,
  }) async {
    try {
      final String accessToken = pref.getToken() ?? "";
      const String url = "https://zego-virtual-gift.vercel.app/api/send_gift";
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "app_id": appID,
            "server_secret": serverSecret,
            "room_id": liveId.value,
            "user_id": astroId.value,
            "user_name": astroName.value,
            "gift_type": data,
            "gift_count": 1,
            "access_token": accessToken,
            "timestamp": DateTime.now().millisecondsSinceEpoch,
          },
        ),
      );
      if (response.statusCode != HttpStatus.ok) {
        liveSnackBar(msg: "[ERROR], Send Gift Fail: ${response.statusCode}");
      }
    } on Exception catch (error) {
      liveSnackBar(msg: "[ERROR], Send Gift Fail: ${error}");
    }
    return Future<void>.value();
  }

  /// Tarot card close
  Future<void> sendTaroCardClose() async {
    var data = {
      "room_id": liveId.value,
      "user_id": astroId.value,
      "user_name": astroName.value,
      "item": {},
      "type": "Tarot Card Close",
    };
    await sendGiftAPI(data: data);
    update();
    return Future<void>.value();
  }

  ///------------------------ After Live Start ------------------------ ///
  Timer? timer;
  Timer? msgTimerForFollowPopup;
  Timer? msgTimerForTarotCardPopup;
  bool isKeyboardSheetOpen = false;

  /// Astrologer Leaving live module
  Future<void> exitFunc() async {
    final bool isEngaded = currentCaller!.isEngaded;
    if (isEngaded) {
      LiveGlobalSingleton().isDisconnectPopupOpen = true;
      await showCupertinoModalPopup(
        context: Get.context!,
        builder: (BuildContext context) {
          return DisconnectWidget(
            onClose: Get.back,
            noDisconnect: () {
              Get.back();
            },
            yesDisconnect: () async {
              Get.back();
              // await removeCoHostOrStopCoHost();
            },
            isAstro: true,
            astroAvatar: astroAvatar.value,
            astroUserName: astroName.value,
            custoAvatar: currentCaller!.avatar,
            custoUserName: currentCaller!.userName,
          );
        },
      );
      LiveGlobalSingleton().isDisconnectPopupOpen = false;
    } else {
      LiveGlobalSingleton().isEndLiveSessionPopupOpen = true;
      await showCupertinoModalPopup(
        context: Get.context!,
        builder: (BuildContext context) {
          return EndSessionWidget(
            onClose: Get.back,
            continueLive: Get.back,
            endLive: () async {
              if (Get.context!.mounted) {
                timer?.cancel();
                msgTimerForFollowPopup?.cancel();
                msgTimerForTarotCardPopup?.cancel();
                await zegoController.leave(Get.context!);
                Get.back();
                update();
              } else {}
            },
          );
        },
      );
      LiveGlobalSingleton().isEndLiveSessionPopupOpen = false;
    }
    return Future<void>.value();
  }

  /// Customer is block or not checking function
  bool isBlocked({required int id}) {
    BlockedCustomerListResData? data = blockedCustomerListRes!.data?.firstWhere(
      (element) => (element.getCustomers?.id ?? 0) == id,
      orElse: () => BlockedCustomerListResData(),
    );
    return (data?.isBlock ?? 0) == 1;
  }

  Future<void> callblockCustomer({
    required int id,
  }) async {
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{
      "customer_id": id,
      "is_block": isBlocked(id: id),
      "role_id": 7,
    };
    BlockedCustomerRes blockedCustListRes = BlockedCustomerRes();
    blockedCustListRes = await liveRepository.blockedCustomerAPI(
      params: param,
      successCallBack: (message) {},
      failureCallBack: (message) {
        liveSnackBar(msg: message);
      },
    );
    blockedCustListRes = blockedCustListRes.statusCode == HttpStatus.ok
        ? BlockedCustomerRes.fromJson(blockedCustListRes.toJson())
        : BlockedCustomerRes.fromJson(BlockedCustomerRes().toJson());
    await callBlockedCustomerListRes();
    await updateBlockListToFirebase();
    return Future<void>.value();
  }

  /// ------------------------ All Zego Logic here ------------------------- ///
  ZegoUIKitPrebuiltLiveStreamingConfig get streamingConfig {
    final ZegoUIKitSignalingPlugin plugin = ZegoUIKitSignalingPlugin();
    final List<IZegoUIKitPlugin> pluginsList = <IZegoUIKitPlugin>[
      plugin,
      ZegoUIKitBeautyPlugin(),
      getBeautyPlugin()
    ];
    return ZegoUIKitPrebuiltLiveStreamingConfig.host(plugins: pluginsList);
  }

  /// code for beautification
  ZegoUIKitBeautyPlugin getBeautyPlugin() {
    final plugin = ZegoUIKitBeautyPlugin();
    final config = ZegoBeautyParamConfig(
        ZegoBeautyPluginEffectsType.beautyBasicSmoothing, true,
        value: 80);
    final config1 = ZegoBeautyParamConfig(
        ZegoBeautyPluginEffectsType.backgroundMosaicing, true,
        value: 90);
    plugin.setBeautyParams([config, config1], forceUpdateCache: true);
    return plugin;
  }

  /// msg update to zego cloud
  Future<void> sendKeyboardMesage(msg) async {
    final String text = algoForSendMessage(msg);
    final bool hasBadWord = hasMessageContainsAnyBadWord(msg);
    if (text.isNotEmpty) {
      liveSnackBar(msg: "$text is restricted text");
    } else if (hasBadWord) {
      liveSnackBar(msg: "Bad words are restricted");
    } else {
      final ZegoCustomMessage model = ZegoCustomMessage(
        type: 1,
        liveId: liveId.value,
        userId: astroId.value,
        userName: astroName.value,
        avatar: astroAvatar.value,
        message: msg,
        timeStamp: DateTime.now().toString(),
        fullGiftImage: "",
        isBlockedCustomer: false,
        isMod: false,
      );
      await sendMessageToZego(model);
    }

    FocusManager.instance.primaryFocus?.unfocus();
    scrollDownForTop();
    scrollDownForBottom();
    getUntil();
    update();
    return Future<void>.value();
  }

  final liveStateNotifier =
      ValueNotifier<ZegoLiveStreamingState>(ZegoLiveStreamingState.idle);


  ZegoLayout galleryLayout() {
    // final bool isEngaged = _controller.engagedCoHostWithAstro().isEngaded;
    // final String callType = _controller.engagedCoHostWithAstro().callType;
    final bool isEngaged = currentCaller!.isEngaded;
    final String callType = currentCaller!.callType;
    return isEngaged == true && callType == "video"
        ? ZegoLayout.gallery()
        : ZegoLayout.pictureInPicture(smallViewSize: const Size(0, 0));
    update(); 
  }


  /// Zego receiver msg
  ZegoCustomMessage receiveMessageToZego(String model) {
    final Map<String, dynamic> decodedMap = json.decode(model);
    final ZegoCustomMessage msgModel = ZegoCustomMessage.fromJson(decodedMap);
    return msgModel;
  }

  /// Zego sender msg
  Future<void> sendMessageToZego(ZegoCustomMessage model) async {
    final String encodedstring = json.encode(model.toJson());
    await zegoController.message.send(encodedstring);
    return Future<void>.value();
  }

  Future<void> onInRoomCommandMessageReceived(
      ZegoSignalingPluginInRoomCommandMessageReceivedEvent event) async {
    final List<ZegoSignalingPluginInRoomCommandMessage> msgs = event.messages;
    for (final ZegoSignalingPluginInRoomCommandMessage commandMessage in msgs) {
      final String senderUserID = commandMessage.senderUserID;
      final String message = utf8.decode(commandMessage.message);
      final Map<String, dynamic> decodedMessage = jsonDecode(message);
      // final int appId = decodedMessage["app_id"];
      // final String serverSecret = decodedMessage["server_secret"];
      final String roomId = decodedMessage["room_id"];
      final String userId = decodedMessage["user_id"];
      final String userName = decodedMessage["user_name"];
      final Map<String, dynamic> giftType = decodedMessage["gift_type"];
      final Map<String, dynamic> item = decodedMessage["gift_type"]["item"];
      final String type = decodedMessage["gift_type"]["type"];
      final String receiverUserId = decodedMessage["gift_type"]["user_id"];
      final num giftCount = decodedMessage["gift_count"];
      // final String accessToken = decodedMessage["access_token"];
      // final int timestamp = decodedMessage["timestamp"];

      final bool askForGift = type == "Ask For Gift";
      final bool askForVideo = type == "Ask For Video Call";
      final bool askForVoice = type == "Ask For Voice Call";
      final bool askForPrivate = type == "Ask For Private Call";
      final bool askFor =
          askForGift || askForVideo || askForVoice || askForPrivate;

      if (senderUserID != astroId.value) {
        if (roomId == liveId.value) {
          if (type == "") {
            if (Get.context!.mounted) {
              print(item["animation"]);
              print("objectobjectobjectobject");
              ZegoGiftPlayer().play(
                Get.context!,
                GiftPlayerData(GiftPlayerSource.url, item["animation"]),
              );
            } else {}
            await showHideTopBanner();
          } else if (type == "Started following") {
            FollowPlayer().play(
              Get.context!,
              FollowPlayerData(
                FollowPlayerSource.asset,
                "assets/lottie/live_follow_heart.json",
                userName,
              ),
            );
          } else if (askFor) {
            if (receiverUserId == astroId.value) {
            } else {}
          } else if (type == "Block/Unblock") {
          } else if (type == "Tarot Card") {
            final TarotGameModel model = TarotGameModel.fromJson(item);

            if (model.receiverId == astroId.value) {
              tarotGameModel = model;
              final int step = tarotGameModel?.currentStep ?? 0;
              if (waitingForUserToSelectCardsPopupVisible.value) {
                Get.back();
              }
              switch (step) {
                case 0:
                  await showCardDeckToUserPopup();
                  break;
                case 1:
                  final singleton = LiveSharedPreferencesSingleton();
                  final String tarotCard = singleton.getSingleTarotCard();
                  tarotCard.isEmpty
                      ? WidgetsBinding.instance.endOfFrame.then(
                          (_) async {
                            if (Get.context!.mounted) {
                              liveSnackBar(
                                  msg: "Unable to load tarot card game.");
                              await sendTaroCardClose();
                            } else {}
                          },
                        )
                      : await showCardDeckToUserPopup1();
                  break;
                case 2:
                  await showCardDeckToUserPopup2();
                  break;
                default:
                  break;
              }
            } else {}
          } else if (type == "Tarot Card Close") {
            if (waitingForUserToSelectCardsPopupVisible.value) {
              Get.back();
            } else {}
            liveSnackBar(msg: "User closed Card Selection");
          } else if (type == "Notify Astro For Exit WaitList") {
            final bool cond2 = isAcceptPopupOpen.value;
            final bool cond3 = roomId == astroId.value;
            final bool cond4 = userId == isAcceptPopupOpenFor.id;
            final bool cond5 = userName == isAcceptPopupOpenFor.name;

            if (cond2 && cond3 && cond4 && cond5) {
              Get.back();
            } else {}
          } else {}
        } else {}
      } else {}
    }
    return Future<void>.value();
  }

  /// Zego events
  ZegoUIKitPrebuiltLiveStreamingEvents get events {
    return ZegoUIKitPrebuiltLiveStreamingEvents(
      onStateUpdated: (state) {},
      audioVideo: ZegoLiveStreamingAudioVideoEvents(
        onCameraTurnOnByOthersConfirmation: (context) {
          return Future<bool>.value(true);
        },
        onMicrophoneTurnOnByOthersConfirmation: (context) {
          return Future<bool>.value(true);
        },
      ),
      topMenuBar: ZegoLiveStreamingTopMenuBarEvents(
        onHostAvatarClicked: (host) {},
      ),
      memberList: ZegoLiveStreamingMemberListEvents(
        onClicked: (user) {},
      ),
      inRoomMessage: ZegoLiveStreamingInRoomMessageEvents(
        onClicked: (message) {},
        onLocalSend: (message) {},
        onLongPress: (message) {},
      ),
      duration: ZegoLiveStreamingDurationEvents(
        onUpdated: (duration) {},
      ),
      coHost: ZegoLiveStreamingCoHostEvents(
        coHost: ZegoLiveStreamingCoHostCoHostEvents(
          onLocalDisconnected: () {
            Fluttertoast.showToast(msg: "user left");
          },
          onLocalConnectStateUpdated:
              (ZegoLiveStreamingAudienceConnectState connectState) {
            print(connectState);
            print("connectState");
          },
        ),
        host: ZegoLiveStreamingCoHostHostEvents(
          onRequestReceived: (ZegoUIKitUser user) async {
            showNotifOverlay(user: user, msg: "onCoHostRequestReceived");

            await onCoHostRequest(
              user: user,
              userId: user.id,
              userName: user.name,
              avatar: "https://robohash.org/avatarWidget",
            );
          },
          onRequestCanceled: (ZegoUIKitUser user) async {
            showNotifOverlay(user: user, msg: "onCoHostRequestCanceled");
            // await onCoHostRequestCanceled(user);
          },
          onRequestTimeout: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostRequestTimeout");
          },
          onActionAcceptRequest: () {
            showNotifOverlay(user: null, msg: "onActionAcceptCoHostRequest");
          },
          onActionRefuseRequest: () {
            showNotifOverlay(user: null, msg: "onActionRefuseCoHostRequest");
          },
          onInvitationSent: (ZegoUIKitUser user) async {
            showNotifOverlay(user: user, msg: "onCoHostInvitationSent");
            await addUpdateToWaitList(
              userId: user.id,
              callType: "",
              isEngaded: false,
              isRequest: false,
              callStatus: 1,
              isForAdd: false,
            );
          },
          onInvitationTimeout: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostInvitationTimeout");

            if (isAcceptPopupOpen.value) {
              Get.back();
            } else {}

            liveSnackBar(msg: "${user.name} timeout to take the call");
          },
          onInvitationAccepted: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostInvitationAccepted");
          },
          onInvitationRefused: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostInvitationRefused");

            if (isAcceptPopupOpen.value) {
              Get.back();
            } else {}

            liveSnackBar(msg: "${user.name} refused to take the call");
          },
        ),
        audience: ZegoLiveStreamingCoHostAudienceEvents(
          onRequestSent: () {
            showNotifOverlay(user: null, msg: "onCoHostRequestSent");
          },
          onActionCancelRequest: () {
            showNotifOverlay(user: null, msg: "onActionCancelCoHostRequest");
          },
          onRequestTimeout: () {
            showNotifOverlay(user: null, msg: "onCoHostRequestTimeout");
          },
          onRequestAccepted: () {
            showNotifOverlay(user: null, msg: "onCoHostRequestAccepted");
          },
          onRequestRefused: () {
            showNotifOverlay(user: null, msg: "onCoHostRequestRefused");
          },
          onInvitationReceived: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostInvitationReceived");
          },
          onInvitationTimeout: () {
            showNotifOverlay(user: null, msg: "onCoHostInvitationTimeout");
          },
          onActionAcceptInvitation: () {
            showNotifOverlay(user: null, msg: "onActionAcceptCoHostInvitation");
          },
          onActionRefuseInvitation: () {
            showNotifOverlay(user: null, msg: "onActionRefuseCoHostInvitation");
          },
        ),
      ),
      onEnded: (ZegoLiveStreamingEndEvent event, VoidCallback defaultAction) {},
      user: ZegoLiveStreamingUserEvents(
        onEnter: (ZegoUIKitUser zegoUIKitUser) async {
          // await onUserJoin(zegoUIKitUser);
        },
        onLeave: (ZegoUIKitUser zegoUIKitUser) async {
          final bool cond2 = currentCaller!.isEngaded;
          final bool cond3 = currentCaller!.id == zegoUIKitUser.id;
          final bool cond4 = zegoUIKitUser.id != liveId.value;
          if (cond2 && cond3 && cond4) {
            print("on user leave");
            // removing part is left
            // await removeCoHostOrStopCoHost();
          } else {}
        },
      ),
      room: ZegoLiveStreamingRoomEvents(
        onStateChanged: (state) {
          print(state.reason);
          print("state.reasonstate.reasonstate.reasonstate.reason");
        },
      )
    );
  }

  Future<void> addUpdateToWaitList({
    required String userId,
    required String callType,
    required bool isEngaded,
    required bool isRequest,
    required int callStatus,
    // required int totalMin,
    required bool isForAdd,
  }) async {
    String previousType = callType != "" ? callType : "";
    final DataSnapshot dataSnapshot = await reference
        .child("liveTest/$liveId/realTime/waitList/$userId")
        .get();

    if (dataSnapshot.exists) {
      if (dataSnapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> map = <dynamic, dynamic>{};
        map = (dataSnapshot.value ?? <dynamic, dynamic>{})
            as Map<dynamic, dynamic>;
        final String type = map["callType"] ?? "";
        previousType = type;
      } else {}
    } else {}
    //
    final ogOrderDetails = <String, dynamic>{
      "isRequest": isRequest,
      "isEngaded": isEngaded,
      "callType": previousType.toLowerCase(),

      "userName": astroName.value,
      "avatar": astroAvatar.value,
      // "totalMin": totalMin,
      "id": userId,
      // "generatedOrderId": (orderGenerate.data?.generatedOrderId ?? 0),
      // "offerId": (details.data?.offerDetails?.offerId ?? 0)
      "callStatus": callStatus,
    };
    final Map<String, dynamic> moOrderDetails = isForAdd
        ? ogOrderDetails
        : <String, dynamic>{
            "callStatus": callStatus,
          };
    //
    await reference
        .child("liveTest/$liveId/realTime/waitList/$userId")
        .update(moOrderDetails);
    //
    // if (callStatus == 2) {
    //   await addUpdateOrder(ogOrderDetails);
    //   await removeFromWaitList();
    // } else {}
    return Future<void>.value();
  }

  Future<void> onCoHostRequest({
    required ZegoUIKitUser user,
    required String userId,
    required String userName,
    required String avatar,
  }) async {
    isAcceptPopupOpen.value = true;
    isAcceptPopupOpenFor = user;
    update();
    await hostingAndCoHostingPopup(
      onClose: () {},
      needAcceptButton: true,
      needDeclinetButton: false,
      onAcceptButton: () async {
        print("calling accept button");
        final connectInvite = zegoController.coHost;
        await connectInvite.hostSendCoHostInvitationToAudience(user);
      },
      onDeclineButton: () {},
      user: user,
      userId: userId,
      userName: userName,
      avatar: avatar,
    );
    isAcceptPopupOpen.value = false;
    isAcceptPopupOpenFor = ZegoUIKitUser(id: "", name: "");
    return Future<void>.value();
  }

  Future<void> hostingAndCoHostingPopup({
    required Function() onClose,
    required bool needAcceptButton,
    required bool needDeclinetButton,
    required Function() onAcceptButton,
    required Function() onDeclineButton,
    required ZegoUIKitUser user,
    required String userId,
    required String userName,
    required String avatar,
  }) async {
    LiveGlobalSingleton().isHostingAndCoHostingPopupOpen = true;
    await showCupertinoModalPopup(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CallAcceptOrRejectWidget(
          onClose: () {
            Get.back();
            onClose();
          },
          needAcceptButton: needAcceptButton,
          needDeclinetButton: needDeclinetButton,
          onAcceptButton: () {
            Get.back();
            onAcceptButton();
          },
          onDeclineButton: () {
            Get.back();
            onDeclineButton();
          },
          userId: userId,
          avatar: avatar,
          userName: userName,
          isHost: true,
          onTimeout: () {
            Get.back();
          },
        );
      },
    );
    LiveGlobalSingleton().isHostingAndCoHostingPopupOpen = false;
    return Future<void>.value();
  }

  // Future<void> addUpdateOrder(Map<String, dynamic> orderDetails) async {
  //   await reference.child("liveTest/$liveId/realTime/order").update(orderDetails);
  //   return Future<void>.value();
  // }
  //
  // Future<void> removeFromWaitList() async {
  //   await reference.child("liveTest/$liveId/realTime/waitList/${astroId.value}").remove();
  //   return Future<void>.value();
  // }

  Future<void> onLiveStreamingStateUpdate(ZegoLiveStreamingState state) async {
    /*if (state == ZegoLiveStreamingState.idle) {
      ZegoGiftPlayer().clear();
    } else {}

    if (state == ZegoLiveStreamingState.ended) {
      ZegoGiftPlayer().clear();

      getUntil();

      await endOrderFirst();
      await Future<void>.delayed(const Duration(seconds: 2));

      _controller.initData();
      _controller.updateInfo();

      final List<dynamic> list = await _controller.onLiveStreamingEnded();
      print("onLiveStreamingEnded: $list");

      if (list.isNotEmpty) {
        zegoController.swiping.next();

        _controller.initData();
        _controller.updateInfo();
      } else {}
    } else {}*/

    return Future<void>.value();
  }

  RxBool showTopBanner = false.obs;

  Future<void> showHideTopBanner() async {
    showTopBanner.value = true;
    await Future<void>.delayed(const Duration(seconds: 15));
    showTopBanner.value = false;
    update();
    return Future<void>.value();
  }

  /// -------------------- Tarrot card  -------------------- ///
  Future<void> showCardDeckToUserPopup() async {
    LiveGlobalSingleton().isShowCardDeckToUserPopupOpen = true;
    await showCupertinoModalPopup(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowCardDeckToUser(
          onClose: Get.back,
          onSelect: (int value) async {
            Get.back();
            var item = TarotGameModel(
              currentStep: 1,
              canPick: value,
              userPicked: [],
              senderId: astroId.value,
              receiverId: currentCaller!.id,
            );
            Future.delayed(const Duration(milliseconds: 200));
            var data = {
              "room_id": liveId.value,
              "user_id": astroId.value,
              "user_name": astroName.value,
              "item": item.toJson(),
              "type": "Tarot Card",
            };
            await sendGiftAPI(data: data);

            waitingForUserToSelectCardsPopupVisible.value = true;
            LiveGlobalSingleton().isWaitingForUserToSelectCardsPopupOpen = true;
            await showCupertinoModalPopup(
              context: Get.context!,
              builder: (BuildContext context) {
                return WaitingForUserToSelectCards(
                  onClose: Get.back,
                  userName: currentCaller!.userName,
                  onTimeout: () async {
                    Get.back();
                    liveSnackBar(
                      msg: "Card Selection Timeout",
                    );
                    // await sendTaroCardClose();
                  },
                );
              },
            );
            waitingForUserToSelectCardsPopupVisible.value = false;
            LiveGlobalSingleton().isWaitingForUserToSelectCardsPopupOpen =
                false;
            update();
          },
          userName: currentCaller!.userName,
          onTimeout: () async {
            Get.back();
            await sendTaroCardClose();
          },
          totalTime: /*controller.engagedCoHostWithAstro().totalTime*/ "0",
        );
      },
    );
    LiveGlobalSingleton().isShowCardDeckToUserPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> showCardDeckToUserPopup1() async {
    showCardDeckToUserPopupTimeoutHappening.value = true;
    LiveGlobalSingleton().isShowCardDeckToUser1PopupOpen = true;

    startMsgTimerForTarotCardPopup();

    bool hasSelected = false;

    await showCupertinoModalPopup(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LiveCarousal(
          onClose: () async {
            Get.back();
            endMsgTimerForTarotCardPopup();

            await sendTaroCardClose();
          },
          allCards: deckCardModelList,
          onSelect: (List<DeckCardModel> selectedCards) async {
            Get.back();
            endMsgTimerForTarotCardPopup();

            hasSelected = true;

            final List<UserPicked> userPicked = [];
            for (DeckCardModel element in selectedCards) {
              userPicked.add(
                UserPicked(
                  id: element.id,
                  name: element.name,
                  status: element.status,
                  image: element.image,
                ),
              );
            }
            var item = TarotGameModel(
              currentStep: 2,
              canPick: tarotGameModel?.canPick ?? 0,
              userPicked: userPicked,
              senderId: astroId.value,
              receiverId: currentCaller?.id,
            );
            await sendTaroCard(item);
          },
          numOfSelection: tarotGameModel?.canPick ?? 0,
          userName: currentCaller?.userName ?? "",
        );
      },
    );

    showCardDeckToUserPopupTimeoutHappening.value = false;
    LiveGlobalSingleton().isShowCardDeckToUser1PopupOpen = false;

    endMsgTimerForTarotCardPopup();

    if (hasSelected) {
    } else {
      await sendTaroCardClose();
    }
    return Future<void>.value();
  }

  Future<void> showCardDeckToUserPopup2() async {
    LiveGlobalSingleton().isShowCardDeckToUser2PopupOpen = true;
    await showCupertinoModalPopup(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final List<DeckCardModel> userPicked = [];
        for (UserPicked element in tarotGameModel?.userPicked ?? []) {
          userPicked.add(
            DeckCardModel(
              id: element.id,
              name: element.name,
              status: element.status,
              image: element.image,
            ),
          );
        }
        return ChosenCards(
          onClose: Get.back,
          userChosenCards: userPicked,
          userName: currentCaller?.userName ?? "",
        );
      },
    );
    LiveGlobalSingleton().isShowCardDeckToUser2PopupOpen = false;
    return Future<void>.value();
  }

  Future<void> sendTaroCard(item) async {
    var data = {
      "room_id": liveId.value,
      "user_id": astroId.value,
      "user_name": astroName.value,
      "item": item.toJson(),
      "type": "Tarot Card",
    };
    await sendGiftAPI(data: data);
    return Future<void>.value();
  }

  void startMsgTimerForTarotCardPopup() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (Get.context!.mounted) {
          const duration = Duration(seconds: 1);
          msgTimerForTarotCardPopup = Timer.periodic(
            duration,
            (Timer timer) async {
              print("_startMsgTimerForTarotCardPopup(): ${timer.tick}");

              if (timer.tick % 60 == 0) {
                if (showCardDeckToUserPopupTimeoutHappening.value) {
                  Get.back();
                  endMsgTimerForTarotCardPopup();
                } else {}

                liveSnackBar(msg: "Card Selection Timeout");

                endMsgTimerForTarotCardPopup();
              } else {}
            },
          );
        } else {}
      },
    );
  }

  void endMsgTimerForTarotCardPopup() {
    if (msgTimerForTarotCardPopup?.isActive ?? false) {
      msgTimerForTarotCardPopup?.cancel();
      update();
    } else {}
    return;
  }

  /// -------------------- Firebase logic -------------------- ///
  final DatabaseReference reference = FirebaseDatabase.instance.ref();

  /// update block list on firebase
  Future<void> updateBlockListToFirebase() async {
    final List<dynamic> temp = [];
    blockedCustomerListRes!.data?.forEach(
      (element) {
        temp.add((element.customerId ?? 0).toString());
      },
    );
    await reference.child("liveTest/$liveId").update(
      <String, Object?>{"blockList": temp ?? []},
    );
    return Future<void>.value();
  }

  /// get all total time from waitlist
  String getTotalWaitTime() {
    String time = "";
    int totalMinutes = 0;
    final List<String> tempList = <String>[];
    for (final WaitListModel element in waitList) {
      tempList.add(element.totalTime);
    }
    if (tempList.isEmpty) {
      time = "00:00:00";
    } else {
      for (String time in tempList) {
        totalMinutes += int.parse(time);
      }
      Duration duration = Duration(minutes: totalMinutes);
      String formattedTime = formatDuration(duration);
      time = formattedTime;
    }
    return time;
  }

  getLiveAstrologerData() async {
    var liveData = await reference.child("liveTest/${liveId}").get();
    reference.child("liveTest/${liveId}/realTime").onChildAdded.listen((event) {
      final key = event.snapshot.key;
      final value = event.snapshot.value;
      getAllDataAndUpdatingFromFirebase(
          value: value as Map<dynamic, dynamic>, key: key);
      update();
    });

    reference
        .child("liveTest/${liveId}/realTime")
        .onChildChanged
        .listen((event) {
      final key = event.snapshot.key;
      final value = event.snapshot.value;
      getAllDataAndUpdatingFromFirebase(
          value: value as Map<dynamic, dynamic>, key: key);
    });

    reference
        .child("liveTest/${liveId}/realTime")
        .onChildRemoved
        .listen((event) {
      final key = event.snapshot.key;
      if (key == "leaderboard") {}
      if (key == "waitList") {}
      if (key == "gift") {}
      if (key == "order") {}
      if (key == "tarotCard") {}
    });
  }

  getAllDataAndUpdatingFromFirebase(
      {String? key, Map<dynamic, dynamic>? value}) {
    if (key == "leaderboard") {
      leaderboardModel.clear();
      value!.forEach((key, leaderBoardData) {
        leaderboardModel.add(LeaderboardModel(
          amount: leaderBoardData!["amount"] ?? 0,
          avatar: leaderBoardData["avatar"] ?? "",
          userName: leaderBoardData["userName"] ?? "",
          id: leaderBoardData["id"] ?? "",
        ));
      });
      update();
      leaderboardModel.sort(
        (LeaderboardModel a, LeaderboardModel b) {
          return b.amount.compareTo(a.amount);
        },
      );
      update();
    }
    if (key == "waitList") {
      waitList.clear();
      value!.forEach(
        (key, value) {
          waitList.add(
            WaitListModel(
              isRequest: value["isRequest"] ?? false,
              isEngaded: value["isEngaded"] ?? false,
              callType: value["callType"] ?? "",
              totalTime: value["totalTime"] ?? "",
              totalMin: value["totalMin"] ?? 0,
              avatar: value["avatar"] ?? "",
              userName: value["userName"] ?? "",
              id: value["id"] ?? "",
              generatedOrderId: value["generatedOrderId"] ?? 0,
              offerId: value["offerId"] ?? 0,
              callStatus: value["callStatus"] ?? 0,
            ),
          );
          update();
        },
      );
    }
    if (key == "gift") {}
    if (key == "order") {}
    if (key == "tarotCard") {}
  }
}
