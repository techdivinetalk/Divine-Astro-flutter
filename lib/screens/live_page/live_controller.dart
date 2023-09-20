// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../common/app_exception.dart';
import '../../common/block_success.dart';
import '../../common/co-host_request.dart';
import '../../common/waitlist_sheet.dart';
import '../../di/api_provider.dart';
import '../../di/shared_preference_service.dart';
import '../../model/leader_board/gift_list_model.dart';
import '../../model/leader_board/live_star_user_model.dart';
import '../../model/leader_board/user_addition_leader_board_model.dart';
import '../../model/res_blocked_customers.dart';
import '../../repository/user_repository.dart';
import 'constant.dart';

class LiveController extends GetxController {
  var pref = Get.find<SharedPreferenceService>();

  LiveController(this.userRepository);

  final UserRepository userRepository;
  Socket? socket;
  var svgaAnime = [
    "blue_lover.svga",
    "box_of_roses.svga",
    "box_of_roses_second.svga",
    "christmas_reindeer_and_sleigh.svga",
    "lovers.svga",
    "new_year_countdown.svga",
    "new_year_gifts.svga",
    "sports_car.svga",
    "white_horse.svga"
  ];

  @override
  void dispose() {
    total = 0;
    duration.value = "";
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  List<String>? badWordsData;

  @override
  void onReady() {
    if (pref.getConstantDetails().data != null) {
      badWordsData = pref.getConstantDetails().data!.badWordsData;
    }
    connectSocket();
    super.onReady();
  }

  final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
    plugins: [ZegoUIKitSignalingPlugin()],
  )
    ..durationConfig.isVisible = false
    ..previewConfig.pageBackIcon = const SizedBox()
    ..previewConfig.beautyEffectIcon = const SizedBox()
    ..previewConfig.switchCameraIcon = const SizedBox()
    ..startLiveButtonBuilder = (context, VoidCallback startLive) {
      return const SizedBox();
    }
    ..previewConfig.showPreviewForHost = false;

  Timer? _timer;
  ZegoUIKitUser? coHostUser;
  var msg = TextEditingController();
  var isCoHosting = false.obs;
  var isStarHide = false.obs;
  var isCameraOn = true.obs;
  var isMicroPhoneOn = true.obs;
  var isCallOnOff = true.obs;
  var duration = "".obs;
  var typeOfNextUserCall = "";
  var typeOfCall = "";
  var audioStream = false;
  int total = 0;
  var blockIds = <String>[];
  FirebaseDatabase database = FirebaseDatabase.instance;
  ResBlockedCustomers? blockedUserData;
  var blockCustomer = <AstroBlockCustomer>[].obs;
  String? astroId;
  var nextPerson = {}.obs;
  var nextuserid = "";
  var scrollController = ScrollController();
  var removedWaitList = "0";
  final liveController = ZegoUIKitPrebuiltLiveStreamingController();
  Timer? countdownTimer;

  stopTimer() {
    if (countdownTimer != null) {
      countdownTimer!.cancel();
      countdownTimer = null;
    }
  }

  String strDigits(int n) => n.toString().padLeft(2, '0');
  RxString hour = "".obs, min = "".obs, sec = "".obs;
  Duration duration1 = Duration.zero;

  startTimer() {
    countdownTimer?.cancel();
    countdownTimer = null;
    duration1 = intToTimeLeft(time); //time
    if (duration1.inHours > 3) {
      duration1 = Duration(hours: 4);
    }
    countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      const reduceSecondsBy = 1;
      if (duration1.inSeconds > 0) {
        duration1 = Duration(seconds: duration1.inSeconds - reduceSecondsBy);
        if (duration1.inSeconds <= 0) {
          duration1 = Duration.zero;
          if (coHostUser != null) {
            setCallType(astroId!);
          }
          setCallStatus();
          setBusyStatus(astroId!, 0, customerId: "");
          liveController.connect.removeCoHost(coHostUser!);
          isCoHosting.value = false;
        } else {
          hour.value = strDigits(duration1.inHours.remainder(24));
          min.value = strDigits(duration1.inMinutes.remainder(60));
          sec.value = strDigits(duration1.inSeconds.remainder(60));
        }
      } else {
        duration1 = Duration.zero;
        countdownTimer?.cancel();
        countdownTimer = null;
      }
    });
  }

  jumpToBottom() {
    scrollController.animateTo(
      -(scrollController.position.maxScrollExtent + 50),
      duration: const Duration(milliseconds: 10),
      curve: Curves.linear,
    );
  }

  //Req event for init LeaderBoard
  initLeaderBoardSessionRequest() {
    log("--In--");
    socket?.emit(ApiProvider().initLeaderBoardSession, {
      "sessionId": astroId,
      "astrologerId": pref.getUserDetail()?.id,
      "socketId": socket?.id
    });
  }

  //Req event for delete Session
  deleteSessionRequest() {
    socket?.emit(ApiProvider().deleteSession, {"sessionId": astroId});
  }

  liveStarUserRequest() {
    socket?.emit(ApiProvider().liveStarUser,
        {"sessionId": astroId.toString(), "socketId": socket?.id ?? ''});
  }

  //Req event for fetch Top 5 Users
  fetchTop5UsersRequest() {
    log("--In--");
    socket?.emit(ApiProvider().fetchTop5Users,
        {"sessionId": astroId.toString(), "socketId": socket?.id ?? ''});
  }

  Rx<UserAdditionInLeaderboardModel> leaderBoard =
      UserAdditionInLeaderboardModel().obs;
  Rx<GiftListModelClass> allGiftList = GiftListModelClass().obs;
  var liveStar = {}.obs;
  var showLiveStar = true.obs;
  RxInt giftTotalPrice = RxInt(0);

  getToatalGiftPrice() {
    int localPrice = 0;
    allGiftList.value.giftDetails?.forEach((element) {
      localPrice += element.price ?? 0;
    });
    giftTotalPrice.value = localPrice;
    return localPrice;
  }

  void connectSocket() {
    socket = io(
        ApiProvider.socketUrl,
        OptionBuilder()
            .enableAutoConnect()
            .setTransports(['websocket']).build());
    socket?.connect();
    socket?.onConnect((_) async {
      log('Socket connected');
      initLeaderBoardSessionRequest();
      fetchTop5UsersRequest();
      liveStarUserRequest();
      socket?.on(ApiProvider().initResponse, (data) {
        log("initResponse=> $data");
      });

      socket?.on(ApiProvider().userGiftResponse, (data) {
        log("userGiftResponse=> ${jsonEncode(data)}");
        allGiftList.value = giftListModelClassFromJson(jsonEncode(data));
        fetchTop5UsersRequest();
        liveStarUserRequest();
      });

      //Response event for init deleteSessionResponse
      socket?.on(ApiProvider().deleteSessionResponse, (data) {
        log("deleteSessionResponse=> $data");
      });

      socket?.on(ApiProvider().liveStarResponse, (data) {
        log("liveStarResponse=> ${jsonEncode(data)}");
        var value = liveStarUserModelFromJson(jsonEncode(data));
        if (value.users != null && value.users!.isNotEmpty) {
          showLiveStar.value = true;
          liveStar.value = {
            "name": value.users?[0].userName,
            "image": value.users?[0].avatar.toString()
          };
          Future.delayed(const Duration(seconds: 20)).then((value) {
            showLiveStar.value = false;
          });
        }
      });

      //Response event for top 5 user
      socket?.on(ApiProvider().top5UsersResponse, (data) {
        log("top5UsersResponse=> $data");
        liveStarUserRequest();
        leaderBoard.value =
            userAdditionInLeaderboardModelFromJson(jsonEncode(data));
        // liveStar.value = liveStarUserModelFromJson(jsonEncode(data));
      });
    });
    log("Socket--->${socket?.connected}");
  }

  @override
  void onClose() {
    stopTimer();
    deleteSessionRequest();
    socket?.dispose();
    super.onClose();
  }

  /*getBlockedCustomerList() async {
    Map<String, dynamic> params = {
      "role_id": pref.getUserDetail()?.roleId ?? 0
    };
    try {
      var blockedUserData = await userRepository.getBlockedCustomerList(params);
      blockIds.clear();
      blockCustomer.clear();
      if (blockedUserData.data != null && blockedUserData.data!.isNotEmpty) {
        var data = blockedUserData.data;
        if (data?.first.astroBlockCustomer != null &&
            data!.first.astroBlockCustomer!.isNotEmpty) {
          blockCustomer.addAll(
              data.first.astroBlockCustomer as Iterable<AstroBlockCustomer>);
        }
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }*/

  unblockUser({required String customerId, required String name}) async {
    Map<String, dynamic> params = {
      "role_id": pref.getUserDetail()?.roleId ?? 0,
      "customer_id": customerId,
      "is_block": 0
    };
    try {
      ResBlockedCustomers response =
          await userRepository.blockUnblockCustomer(params);
      database.ref().child("live/$astroId/blockUser/$customerId/").remove();
      blockIds.remove(customerId);
      showDialog(
          context: Get.context!,
          builder: (builder) {
            return BlockSuccess(text: "$name has been Unblocked!");
          });
      //getBlockedCustomerList();
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  blockUser({required String customerId, required String name}) async {
    Map<String, dynamic> params = {
      "role_id": pref.getUserDetail()?.roleId ?? 0,
      "customer_id": customerId,
      "is_block": 1
    };
    try {
      ResBlockedCustomers response =
          await userRepository.blockUnblockCustomer(params);
      database.ref().child("live/$astroId").update({
        "blockUser": {
          customerId: {"id": customerId, "name": name}
        }
      });
      blockIds.add(customerId);
      //getBlockedCustomerList();
      showDialog(
          context: Get.context!,
          builder: (builder) {
            return BlockSuccess(text: "$name has been blocked!");
          });
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  removeFromWaitList() async {
    var data = await database.ref().child("live/$astroId/waitList").get();
    var first = data.children.toList().first;
    var value = first.value as Map;
    typeOfNextUserCall = value["callType"];
    await Future.delayed(const Duration(seconds: 2));
    showCupertinoModalPopup(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogOpen = true;
          return WaitList(
            data: data.children,
            astroId: astroId,
            showNext: true,
            onAccept: (String id, String name) {
              database
                  .ref()
                  .child("live/$astroId/")
                  .update({"callStatus": 2, "userId": id, "userName": name});
              database
                  .ref()
                  .child("live/$astroId/waitList/${value["id"]}")
                  .remove();
              Get.until((route) => route.settings.name == "/livepage");
            },
          );
        });
  }

  listenWaitlistRemove() async {
    database
        .ref()
        .child("live/$astroId/nextUser")
        .onValue
        .listen((event) async {
      if (event.snapshot.value != null) {
        var data = event.snapshot.value as Map;
        typeOfNextUserCall = data["callType"];
        if (data.isNotEmpty) {
          var waitList =
              await database.ref().child("live/$astroId/waitList").get();
          showCupertinoModalPopup(
              context: Get.context!,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WaitList(
                  data: waitList.children,
                  astroId: astroId,
                  showNext: true,
                  onAccept: (String id, String name) {
                    database.ref().child("live/$astroId/").update(
                        {"callStatus": 2, "userId": id, "userName": name});
                    database
                        .ref()
                        .child("live/$astroId/waitList/${data["id"]}")
                        .remove();
                    Get.until((route) => route.settings.name == "/livepage");
                  },
                );
              });
        }
      }
    });
  }

  bool dialogOpen = false;
  bool dialogOpen2 = false;

  listenCallStatus() {
    database
        .ref()
        .child("live/$astroId/callStatus/")
        .onValue
        .listen((event) async {
      var data = await database.ref().child("live/$astroId/").get();
      if (data.value != null) {
        var userData = data.value as Map;
        if (userData["callStatus"] == 1 && !dialogOpen2) {
          typeOfCall = userData["callType"];
          showCupertinoModalPopup(
              context: Get.context!,
              barrierDismissible: false,
              builder: (BuildContext context) {
                dialogOpen2 = true;
                return CoHostRequest(
                    duration: userData["duration"],
                    name: userData["userName"],
                    onAccept: () {
                      dialogOpen2 = false;
                      database
                          .ref()
                          .child("live/$astroId/")
                          .update({"callStatus": 2});
                      Get.until((route) => route.settings.name == "/livepage");
                    });
              });
        }
      }
    });
  }

  stopStream(String id) {
    endCall();
    database.ref().child("live/$id/callType").remove();
    database.ref().child("live/$id/callStatus").remove();
    database.ref().child("live/$id").remove();
    Get.back();
  }

  setCallType(String id) {
    database.ref().child("live/$id").update({"callType": ""});
  }

  setAvailibility(String id, bool available) {
    database.ref().child("live/$id").update({"isAvailable": available});
    database.ref().child("live/$id/coHostUser").onValue.listen((event) async {
      if (event.snapshot.value != null) {
        final user = event.snapshot.value as String? ?? "";
        if (user.isEmpty) {
          if (isCoHosting.value) {
            isCoHosting.value = false;
            countdownTimer?.cancel();
            countdownTimer = null;
            endCall();
          }
        } else {
          var coHost = await database.ref().child("live/$astroId/coHost").get();
          if (coHost.value != null) {
            var user = coHost.value as Map;
            coHostUser = ZegoUIKitUser(id: user["id"], name: user["name"]);
            offerId = user["offer_id"];
            time = user["duration"];
            orderId = user["order_id"];
            typeOfCall = user["callType"];
            videoConfig(typeOfCall);
            setVisibilityCoHostAudio(typeOfCall);
            setVisibilityCoHostVideo(typeOfCall);
          }
          isCoHosting.value = true;
          startTimer();
        }
      }
    });
  }

  setCallStatus({int value = 0}) {
    database.ref().child("live/$astroId/").update({"callStatus": 0});
  }

  setBusyStatus(String id, int status, {customerId}) {
    database.ref().child("live/$id").update({"isEngaged": status});
    database.ref().child("live/$id").update({"coHostUser": customerId});
  }

  Future<String> getCallType(String id) async {
    var snapShot = await database.ref().child("live/$id").get();
    return (snapShot.value as Map)["callType"];
  }

  Future<int> getDuration(String id) async {
    var snapShot = await database.ref().child("live/$id").get();
    return (snapShot.value as Map)["duration"];
  }

  setVisibilityCoHostVideo(String type) {
    hostConfig.audioVideoViewConfig.playCoHostVideo = (
      ZegoUIKitUser localUser,
      ZegoLiveStreamingRole localRole,
      ZegoUIKitUser coHost,
    ) {
      if (type == "private" || type == "audio") {
        /// private or audio call type, pure audio mode
        return false;
      }

      /// call type is video
      return true;
    };
  }

  videoConfig(String type) {
    hostConfig.audioVideoViewConfig.visible = (
      ZegoUIKitUser localUser,
      ZegoLiveStreamingRole localRole,
      ZegoUIKitUser targetUser,
      ZegoLiveStreamingRole targetUserRole,
    ) {
      if (type == "private" || type == "audio") {
        /// private or audio call type, pure audio mode
        return false;
      }
      if (ZegoLiveStreamingRole.host == localRole) {
        /// host can see all user's view
        return true;
      }

      /// comment below if you want the co-host hide their own audio-video view.
      if (localUser.id == targetUser.id) {
        /// local view
        return true;
      }

      /// if user is a co-host, only show host's audio-video view
      return targetUserRole == ZegoLiveStreamingRole.host;
    };
  }

  setVisibilityCoHostAudio(String type) {
    hostConfig.audioVideoViewConfig.playCoHostAudio = (
      ZegoUIKitUser localUser,
      ZegoLiveStreamingRole localRole,
      ZegoUIKitUser coHost,
    ) {
      if (type == "private") {
        if (ZegoLiveStreamingRole.host == localRole ||
            ZegoLiveStreamingRole.coHost == localRole) {
          return true;
        }

        /// audience
        return false;
      }

      /// call type is video or audio
      return true;
    };
  }

  int orderId = 0;
  int time = 0;
  int offerId = 0;

  void endCall() async {
    Map<String, dynamic> json = {
      "order_id": orderId,
      "duration": time,
      "amount": 0,
      "offer_id": offerId,
      "role_id": roleId,
    };
    Future.delayed(const Duration(seconds: 2)).then((value) async {
      final response = await userRepository.endCall(json);
    });
  }

  Duration intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String result = "$h:$m:$s";
    return Duration(seconds: value);
    return Duration(hours: h, minutes: m, seconds: s);
  }
}
