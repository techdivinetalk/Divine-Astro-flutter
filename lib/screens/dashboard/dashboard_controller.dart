import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/speciality_list.dart';
import 'package:divine_astrologer/repository/pre_defind_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/common_functions.dart';
import '../../common/permission_handler.dart';
import '../../di/fcm_notification.dart';
import '../../model/res_login.dart';

class DashboardController extends GetxController with GetSingleTickerProviderStateMixin {
  final PreDefineRepository repository;

  DashboardController(this.repository);

  RxInt selectedIndex = 0.obs;
  RxString userProfileImage = " ".obs;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  SharedPreferenceService preferenceService = Get.find<SharedPreferenceService>();
  UserData? userData;
  final appFirebaseService = AppFirebaseService();
  BroadcastReceiver broadcastReceiver = BroadcastReceiver(names: <String>["AcceptChat", "ReJoinChat"]);

  // StreamSubscription<DatabaseEvent>? realTimeListener;
  // StreamSubscription<DatabaseEvent>? astroChatListener;
  // Socket? socket;

  @override
  void onInit() async {
    super.onInit();
    broadcastReceiver.start();
    broadcastReceiver.messages.listen((event) {
      debugPrint('broadcastReceiver ${event.name} ---- ${event.data}');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        appFirebaseService.readData('astrologer/${preferenceService.getUserDetail()!.id}/realTime');
      });
    });
    var commonConstants = await userRepository.constantDetailsData();
    preferenceService.setConstantDetails(commonConstants);
    preferenceService.setBaseImageURL(commonConstants.data.awsCredentails.baseurl!);

    userProfileImage.value =
        userData?.image != null ? "${preferenceService.getBaseImageURL()}/${userData?.image}" : "";
    //  connectSocket();
    loadPreDefineData();
    firebaseMessagingConfig(Get.context!);
    notificationPermission();
  }

  notificationPermission() async {
    await PermissionHelper().askNotificationPermission();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   userData = preferenceService.getUserDetail();
  //   realTimeListener ??= FirebaseDatabase.instance
  //       .ref("astrologer/${userData?.id}/realTime")
  //       .onValue
  //       .listen((DatabaseEvent event) {
  //     if (event.snapshot.value is Map) {
  //       final data = event.snapshot.value as Map;
  //
  //       // walletBalance.value = data["walletBalance"] as int;
  //       if (data["notification"] != null) {
  //         checkNotification(
  //             isFromNotification: false, updatedData: data["notification"]);
  //       }
  //     }
  //   });
  //   astroChatListener ??= FirebaseDatabase.instance
  //       .ref("astroChat")
  //       .onValue
  //       .listen((DatabaseEvent event) {
  //     if (event.snapshot.children.isNotEmpty) {
  //       List<int> keyArray = [];
  //
  //       for (final dataSnapShot in event.snapshot.children) {
  //         keyArray.add(int.parse(dataSnapShot.key ?? "0"));
  //         if (int.tryParse(dataSnapShot.key!) == userData!.id &&
  //             dataSnapShot.value != null) {
  //           DataSnapshot innerChild = dataSnapShot.children.first;
  //
  //           final value = innerChild.value as Map;
  //           astroChatWatcher.value = ResAstroChatListener(
  //             customerId: int.parse(innerChild.key ?? "0"),
  //             astroId: value['astroId'],
  //             astroImage: value['astroImage'],
  //             astroName: value['astroName'],
  //             chatMessage: value['chat_message'],
  //             customeName: value['custome_name'],
  //             customerImage: value['customer_image'],
  //             extraTalktime: value['extra_talktime'],
  //             isRechargeContinue: value['is_recharge_continue'],
  //             isTimeout: value['is_timeout'],
  //             ivrTime: value['ivr_time'],
  //             notification: value['notification'],
  //             orderId: value['orderId'],
  //             orderType: value['orderType'],
  //             queueId: value['queue_id'],
  //             status: value['status'],
  //             talktime: value['talktime'],
  //           );
  //           if (value['status'] == 0 || value['status'] == 1) {
  //             Get.toNamed(RouteName.videoCallPage,
  //                 arguments: astroChatWatcher.value);
  //           } else if (value['status'] == 2) {
  //             if (Get.currentRoute != RouteName.chatMessageUI) {
  //               Future.delayed(const Duration(seconds: 10)).then((value) {
  //                 socket?.emit(ApiProvider().initChat, {
  //                   "requestFrom": 'astrologer',
  //                   "userId": userData?.id.toString(),
  //                   "userSocketId": socket?.id ?? ''
  //                 });
  //               });
  //               if (Get.currentRoute == RouteName.videoCallPage) {
  //                 Get.offNamed(RouteName.chatMessageUI,
  //                     arguments: astroChatWatcher.value);
  //               } else {
  //                 Get.toNamed(RouteName.chatMessageUI,
  //                     arguments: astroChatWatcher.value);
  //               }
  //             }
  //           }
  //
  //           return;
  //         }
  //       }
  //       if (!keyArray.contains(userData!.id)) {
  //         onEndChat();
  //         astroChatWatcher.value = ResAstroChatListener();
  //         if (Get.currentRoute == RouteName.videoCallPage) {
  //           Get.back();
  //         }
  //       }
  //     }
  //   });
  // }

  @override
  void onClose() {
    super.onClose();
    // if (realTimeListener != null) {
    //   realTimeListener!.cancel();
    //   socket?.dispose();
    // }
  }

  // void connectSocket() {
  //   socket = io(
  //       ApiProvider.socketUrl,
  //       OptionBuilder()
  //           .enableAutoConnect()
  //           .setTransports(['websocket']) // for Flutter or Dart VM
  //           .build());
  //   socket?.connect();
  //   socket?.onConnect((_) {
  //     socket?.on(ApiProvider().initChatResponse, (data) {
  //       ResChatSocketInit.fromJson(data);
  //       chatSession.value = ResChatSocketInit.fromJson(data);
  //     });
  //     socket?.on(ApiProvider().chatTypeResponse, (data) {
  //       if (Get.isRegistered<ChatMessageController>()) {
  //         var chatRes = data as Map<String, dynamic>;
  //         var controller = Get.find<ChatMessageController>();
  //         debugPrint("Chat typing :: $data");
  //         if (int.parse(chatRes["userID"]) == controller.currentUserId.value) {
  //           controller.isTyping.value =
  //               chatRes["message"] == "Typing" ? true : false;
  //           if ((controller.messgeScrollController.position.pixels ==
  //                   controller
  //                       .messgeScrollController.position.maxScrollExtent) &&
  //               chatRes["message"] == "Typing") {
  //             Future.delayed(const Duration(milliseconds: 500), () {
  //               controller.messgeScrollController.animateTo(
  //                   controller.messgeScrollController.position.maxScrollExtent,
  //                   duration: const Duration(milliseconds: 100),
  //                   curve: Curves.easeIn);
  //             });
  //           }
  //         }
  //       }
  //     });
  //   });
  // }

  void loadPreDefineData() async {
    SpecialityList response = await repository.loadPreDefineData();
    await preferenceService.setSpecialAbility(response.toPrettyJson());
  }

  void askPermission() async {
    await [Permission.camera, Permission.microphone, Permission.contacts].request();

    PermissionStatus? permissionStatus;
    if (permissionStatus == PermissionStatus.granted) {
      await checkContacts();
    }
    while (permissionStatus != PermissionStatus.granted) {
      try {
        permissionStatus = await _getContactPermission();
        if (permissionStatus != PermissionStatus.granted) {
          await openAppSettings();
        } else {}
      } catch (e) {
        await openAppSettings();
      }
    }
  }

  checkContacts() async {
    var allContacts = await ContactsService.getContacts();
    var isContactExists = allContacts.any((element) {
      if (element.phones != null) {
        return element.phones!.any((element) => element.value!.contains("+91 9876543210"));
      } else {
        return false;
      }
    });
    if (!isContactExists) {
      Get.toNamed(RouteName.importantNumbers);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted) {
      final result = await Permission.contacts.request();
      return result;
    } else {
      return status;
    }
  }
}
