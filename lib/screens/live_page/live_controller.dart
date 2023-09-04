import 'dart:async';

import 'package:custom_timer/custom_timer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../common/app_exception.dart';
import '../../common/block_success.dart';
import '../../di/shared_preference_service.dart';
import '../../model/res_blocked_customers.dart';
import '../../repository/user_repository.dart';

class LiveController extends GetxController {
  var pref = Get.find<SharedPreferenceService>();

  LiveController(this.userRepository);

  final UserRepository userRepository;

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
  var isCameraOn = true.obs;
  var isMicroPhoneOn = true.obs;
  var isCallOnOff = true.obs;
  var duration = "".obs;
  var typeOfCall = "";
  var audioStream = false;
  int total = 0;
  var blockIds = <String>[];
  FirebaseDatabase database = FirebaseDatabase.instance;
  ResBlockedCustomers? blockedUserData;
  var blockCustomer = <AstroBlockCustomer>[].obs;

  getBlockedCustomerList() async {
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
          for (var element in data.first.astroBlockCustomer!) {
            blockIds.add(element.customerId.toString());
          }
        }
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

  unblockUser({required String customerId, required String name}) async {
    Map<String, dynamic> params = {
      "role_id": pref.getUserDetail()?.roleId ?? 0,
      "customer_id": customerId,
      "is_block": 0
    };
    try {
      ResBlockedCustomers response =
          await userRepository.blockUnblockCustomer(params);
      showDialog(
          context: Get.context!,
          builder: (builder) {
            return BlockSuccess(text: "$name has been Unblocked!");
          });
      getBlockedCustomerList();
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
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
      showDialog(
          context: Get.context!,
          builder: (builder) {
            return BlockSuccess(text: "$name has been blocked!");
          });
      getBlockedCustomerList();
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

  stopStream(String id) {
    Get.back();
    database.ref().child("live/$id").remove();
  }

  setCallType(String id) {
    database.ref().child("live/$id").update({"callType": ""});
  }

  setAvailibility(String id, bool available,CustomTimerController controller) {
    database.ref().child("live/$id").update({"isAvailable": available});
    database.ref().child("live/$id/coHostUser").onValue.listen((event) {
      final user = event.snapshot.value as String? ?? "";
      if (user.isEmpty) {
        isCoHosting.value = false;
        controller.reset();
      }
    });
  }

  setBusyStatus(String id, int status, {customerId}) {
    database.ref().child("live/$id").update({"isEngaged": status});
    database.ref().child("live/$id").update({"coHostUser": customerId});
  }

  Future<String> getCallType(String id) async {
    var snapShot = await database.ref().child("live/$id").get();
    return (snapShot.value as Map)["callType"];
  }

  setVisibilityCoHost(String isAudioCall) {
    typeOfCall = isAudioCall;
    if (typeOfCall == "video") {
      hostConfig.audioVideoViewConfig.visible = (
        ZegoUIKitUser localUser,
        ZegoLiveStreamingRole localRole,
        ZegoUIKitUser targetUser,
        ZegoLiveStreamingRole targetUserRole,
      ) {
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
    } else {
      hostConfig.audioVideoViewConfig.visible = (
        ZegoUIKitUser localUser,
        ZegoLiveStreamingRole localRole,
        ZegoUIKitUser targetUser,
        ZegoLiveStreamingRole targetUserRole,
      ) {
        /// if user is a co-host, only show host's audio-video view
        return targetUserRole == ZegoLiveStreamingRole.host;
      };
    }
  }
}
