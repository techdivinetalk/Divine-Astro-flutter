import "dart:async";
import "dart:convert";

import "package:divine_astrologer/app_socket/app_socket.dart";
import "package:divine_astrologer/common/accept_chat_request_screen.dart";
import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/common/routes.dart";
import "package:divine_astrologer/di/hive_services.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/model/res_login.dart";
import "package:divine_astrologer/pages/profile/profile_page_controller.dart";
import "package:divine_astrologer/repository/pre_defind_repository.dart";
import "package:divine_astrologer/repository/user_repository.dart";
import "package:divine_astrologer/screens/dashboard/dashboard_controller.dart";
import "package:divine_astrologer/screens/live_dharam/live_global_singleton.dart";
import "package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart";
import "package:divine_astrologer/screens/side_menu/settings/settings_controller.dart";
import "package:divine_astrologer/watcher/real_time_watcher.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import "package:get/get.dart";

import "../model/chat_offline_model.dart";
import "../screens/live_page/constant.dart";

bool isLogOut = false;
RxInt giftCountUpdate = 0.obs;
RxString giftImageUpdate = "".obs;

RxInt isCall = 1.obs;
RxInt isRemidies = 1.obs;
RxInt isEcom = 1.obs;
RxInt isVOIP = 0.obs;
RxInt isChatAssistance = 1.obs;
RxInt isChat = 1.obs;
RxInt isKundli = 1.obs;
RxInt isTemplates = 1.obs;
RxInt isCamera = 1.obs;
RxInt isLive = 1.obs;
RxInt isQueue = 1.obs;
RxInt isGifts = 1.obs;
RxInt isTime = 0.obs;
// RxInt isTruecaller = 1.obs;
RxInt isLiveCall = 1.obs;
RxInt homePage = 1.obs;
RxMap<dynamic, dynamic> callKunadliUpdated = {}.obs;
StreamSubscription<DatabaseEvent>? _subscription;

class AppFirebaseService {
  AppFirebaseService._privateConstructor();

  static final AppFirebaseService _instance =
      AppFirebaseService._privateConstructor();

  factory AppFirebaseService() {
    return _instance;
  }

  var watcher = RealTimeWatcher();
  var acceptBottomWatcher = RealTimeWatcher();
  final appSocket = AppSocket();
  var openChatUserId = "";
  var imagePath = "";
  RxMap<String, dynamic> orderData = <String, dynamic>{}.obs;
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  Future<void> writeData(String path, Map<String, dynamic> data) async {
    try {
      await database.child(path).update(data);
    } catch (e) {
      debugPrint("Error writing data to the database: $e");
    }
  }

  String tableName = "";

  // int x = 0;
  // checkFirebaseConnection() {
  //   final connectedRef = FirebaseDatabase.instance.ref(".info/connected");
  //   connectedRef.onValue.listen((event) async {
  //     final connected = event.snapshot.value as bool? ?? false;
  //     if (!connected) {
  //       print("trying to reconnect in 4 seconds");
  //       // await Future.delayed(const Duration(seconds: 4));
  //       // String path = "";
  //       // if (preferenceService.getUserDetail() != null) {
  //       //   path = 'astrologer/${preferenceService.getUserDetail()!.id}/realTime';
  //       // }
  //       // const masterPath = 'masters';
  //       // readData(path);
  //       // masterData(masterPath);
  //     } else {
  //       print("disconnected");
  //     }
  //   });
  // }
  Future<void> userRealTime(String key, dynamic value, String path) async {
    debugPrint("test_callKunadliUpdated_4");
    debugPrint("test_userRealTime: value: $value");

    switch (key) {
      case "order_id":
        watcher.strValue = value.toString();
        break;
      case "isEngagedStatus":
        isEngagedStatus(value);
        break;
      case "callKundli":
        Map<String, dynamic>? callKundli =
            Map<String, dynamic>.from(value as Map<Object?, Object?>);
        print(callKundli);
        print("realTimeData['callKundli']");
        debugPrint("test_callKunadliUpdated_3");
        callKunadliUpdated(callKundli);
        sendBroadcast(BroadcastMessage(name: "callKundli", data: callKundli));
        break;
      case "giftCount":
        giftCountUpdate(value["giftCount"]);
        giftImageUpdate(value["giftImage"]);
        print(
            "gift broadcase called ${value["giftCount"]} ${value["giftImage"]}");
        sendBroadcast(
          BroadcastMessage(
            name: "giftCount",
            data: {
              'giftCount': value["giftCount"],
              "giftImage": value["giftImage"],
            },
          ),
        );
        FirebaseDatabase.instance.ref("$path/giftCount").remove();
        FirebaseDatabase.instance.ref("$path/giftImage").remove();
        break;
      case "voiceCallStatus":
        callSwitch(value > 0);

        if (value <= 1) {
          debugPrint("test_callKunadliUpdated_6");
          callKunadliUpdated({});
        }
        break;
      case "chatStatus":
        chatSwitch(value > 0);
        break;
      case "videoCallStatus":
        callSwitch(value > 0);
        break;
      case "totalGift":
        callSwitch(value > 0);
        break;
      case "deliveredMsg":
        sendBroadcast(BroadcastMessage(
            name: "deliveredMsg", data: {'deliveredMsgList': value}));
        break;
      case "uniqueId":
        String uniqueId = await getDeviceId() ?? "";
        debugPrint(
          'check uniqueId ${value.toString()}\ngetDeviceId ${uniqueId.toString()}',
        );
        if (value.toString() != uniqueId) {
          print("logout --- start");
          await LiveGlobalSingleton().leaveLiveIfIsInLiveScreen();
          print("logout --- end");
          Get.put(SettingsController()).logOut();
        }
        break;
      case "profilePhoto":
        UserData? userData =
            Get.find<SharedPreferenceService>().getUserDetail();
        userData!.image = value.toString();
        String? baseAmazonUrl =
            Get.find<SharedPreferenceService>().getBaseImageURL();
        Get.find<SharedPreferenceService>().setUserDetail(userData);
        Get.put(DashboardController(Get.put(PreDefineRepository())))
            .userProfileImage
            .value = "$baseAmazonUrl/${userData.image!}";
        Get.put(ProfilePageController(Get.put(UserRepository())))
            .userProfileImage
            .value = "$baseAmazonUrl/${userData.image!}";
        Get.put(DashboardController(Get.put(PreDefineRepository()))).update();
        Get.put(ProfilePageController(Get.put(UserRepository()))).update();
        break;
      case "totalGift":
        sendBroadcast(
          BroadcastMessage(
            name: "totalGift",
            data: {'totalGift': value},
          ),
        );
        break;
    }
  }

  readData(String path) async {
    print("readData $path");
    try {
      if (kDebugMode) {
        database.child(path).onChildChanged.listen((event) {
          final key = event.snapshot.key; // Get the key of the changed child
          final value =
              event.snapshot.value; // Get the new value of the changed child
          if (event.snapshot.value != null) {
            print("onChildChanged $key");
            print("onChildChanged $value");
            userRealTime(key!, value, path);
          }
        });
        database.child(path).onChildAdded.listen((event) {
          final key = event.snapshot.key; // Get the key of the changed child
          final value =
              event.snapshot.value; // Get the new value of the changed child
          if (event.snapshot.value != null) {
            print("onChildAdded $key");
            print("onChildAdded $value");
            print("onChildAdded $value");
            userRealTime(key!, value, path);
          }
        });
      } else {
        database.child(path).onValue.listen((event) async {
          debugPrint("test_callKunadliUpdated_5");
          debugPrint("real time $path ---> ${event.snapshot.value}");
          if (preferenceService.getToken() == null ||
              preferenceService.getToken() == "") {
            return;
          }

          if (event.snapshot.value is Map<Object?, Object?>) {
            Map<String, dynamic>? realTimeData = Map<String, dynamic>.from(
                event.snapshot.value! as Map<Object?, Object?>);
            if (realTimeData["order_id"] != null) {
              watcher.strValue = realTimeData["order_id"].toString();
            }

            final isCallSwitchRes = realTimeData["voiceCallStatus"] ?? 0;
            callSwitch(isCallSwitchRes > 0);

            final isChatSwitchRes = realTimeData["chatStatus"] ?? 0;
            chatSwitch(isChatSwitchRes > 0);

            final isVideoCallSwitchRes = realTimeData["videoCallStatus"] ?? 0;
            videoSwitch(isVideoCallSwitchRes > 0);

            if (realTimeData["uniqueId"] != null) {
              print("uniqueId ---- uniqueId ${realTimeData["uniqueId"]}");

              String uniqueId = await getDeviceId() ?? "";
              debugPrint(
                'check uniqueId ${realTimeData['uniqueId']}\ngetDeviceId ${uniqueId.toString()}',
              );
              if (realTimeData["uniqueId"] != uniqueId) {
                print("logout --- start");
                await LiveGlobalSingleton().leaveLiveIfIsInLiveScreen();
                print("logout --- end");
                Get.put(SettingsController()).logOut();
              }
            }

            if (realTimeData["profilePhoto"] != null) {
              print("beforeGoing 0 - first");
              UserData? userData =
                  Get.find<SharedPreferenceService>().getUserDetail();
              userData!.image = realTimeData["profilePhoto"];
              String? baseAmazonUrl =
                  Get.find<SharedPreferenceService>().getBaseImageURL();
              Get.find<SharedPreferenceService>().setUserDetail(userData);
              Get.put(DashboardController(Get.put(PreDefineRepository())))
                  .userProfileImage
                  .value = "$baseAmazonUrl/${userData.image!}";
              Get.put(ProfilePageController(Get.put(UserRepository())))
                  .userProfileImage
                  .value = "$baseAmazonUrl/${userData.image!}";
              Get.put(DashboardController(Get.put(PreDefineRepository())))
                  .update();
              Get.put(ProfilePageController(Get.put(UserRepository())))
                  .update();
            }
            if (realTimeData["isEngagedStatus"] != null) {
              print(realTimeData["isEngagedStatus"]);
              print('realTimeData["isEngagedStatus"]');
              isEngagedStatus(realTimeData['isEngagedStatus']);
            } else {
              isEngagedStatus(0);
            }
            if (realTimeData['giftCount'] != null) {
              giftCountUpdate(realTimeData["giftCount"]);
              giftImageUpdate(realTimeData["giftImage"]);
              print(
                  "gift broadcase called ${realTimeData["giftCount"]} ${realTimeData["giftImage"]}");
              sendBroadcast(
                BroadcastMessage(
                  name: "giftCount",
                  data: {
                    'giftCount': realTimeData["giftCount"],
                    "giftImage": realTimeData["giftImage"],
                  },
                ),
              );
              FirebaseDatabase.instance.ref("$path/giftCount").remove();
              FirebaseDatabase.instance.ref("$path/giftImage").remove();
            }
            if (realTimeData['callKundli'] != null) {
              Map<String, dynamic>? callKundli = Map<String, dynamic>.from(
                  realTimeData['callKundli'] as Map<Object?, Object?>);
              print(realTimeData['callKundli']);
              print("realTimeData['callKundli']");
              debugPrint("test_callKunadliUpdated_2");
              callKunadliUpdated(realTimeData['callKundli']);
              sendBroadcast(
                  BroadcastMessage(name: "callKundli", data: callKundli));
              // FirebaseDatabase.instance.ref("$path/callKundli").remove();
            } else {
              debugPrint("test_callKunadliUpdated_1");
              callKunadliUpdated({});
            }
            if (realTimeData["deliveredMsg"] != null) {
              print("deliveredMsg rec");
              sendBroadcast(BroadcastMessage(
                  name: "deliveredMsg",
                  data: {'deliveredMsgList': realTimeData["deliveredMsg"]}));
            }
            if (realTimeData["totalGift"] != null) {
              sendBroadcast(
                BroadcastMessage(
                  name: "totalGift",
                  data: {'totalGift': realTimeData["totalGift"]},
                ),
              );
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error reading data from the database: $e");
    }

    watcher.nameStream.listen(
      (value) {
        if (value != "") {
          print("object");
          database.child("order/$value").onValue.listen(
            (DatabaseEvent event) async {
              final DataSnapshot dataSnapshot = event.snapshot;
              if (dataSnapshot.exists) {
                print("data from snapshot ${dataSnapshot.value}");
                if (dataSnapshot.value is Map<dynamic, dynamic>) {
                  Map<dynamic, dynamic> map = <dynamic, dynamic>{};
                  map = (dataSnapshot.value ?? <dynamic, dynamic>{})
                      as Map<dynamic, dynamic>;
                  orderData(Map<String, dynamic>.from(map));
                  if (orderData.value["status"] != null) {
                    if (orderData.value["orderType"] == "chat") {
                      switch ((orderData.value["status"])) {
                        case "0":
                          if (Get.currentRoute !=
                              RouteName.acceptChatRequestScreen) {
                            await Get.toNamed(
                                RouteName.acceptChatRequestScreen);
                          }
                          break;
                        case "1":
                          if (Get.currentRoute !=
                              RouteName.acceptChatRequestScreen) {
                            await Get.toNamed(
                                RouteName.acceptChatRequestScreen);
                          }
                          break;

                        case "2":
                          if (Get.currentRoute !=
                              RouteName.chatMessageWithSocketUI) {
                            await Get.toNamed(
                              RouteName.chatMessageWithSocketUI,
                              arguments: {"orderData": orderData},
                            );
                          }
                          break;

                        case "3":
                          if (Get.currentRoute !=
                              RouteName.chatMessageWithSocketUI) {
                            await Get.toNamed(
                              RouteName.chatMessageWithSocketUI,
                              arguments: {"orderData": orderData},
                            );
                          }
                          break;

                        default:
                          break;
                      }
                    } else {
                      orderData({});
                    }
                  } else {}
                } else {}
              } else {
                orderData({});
                sendBroadcast(BroadcastMessage(name: "orderEnd"));
              }
            },
          );
        } else {
          orderData({});
          sendBroadcast(BroadcastMessage(name: "orderEnd"));
        }
      },
    );
  }

  saveMasterData(DataSnapshot dataSnapshot) {
    print("dataSnapshot-Value ${dataSnapshot.value}");
    switch (dataSnapshot.key) {
      case "call":
        isCall(int.parse(dataSnapshot.value.toString()));
        break;
      case "camera":
        isCamera(int.parse(dataSnapshot.value.toString()));
        break;
      case "chat":
        isChat(int.parse(dataSnapshot.value.toString()));
        break;
      case "chat_assistance":
        isChatAssistance(int.parse(dataSnapshot.value.toString()));
        break;
      case "gifts":
        isGifts(int.parse(dataSnapshot.value.toString()));
        break;
      case "isTime":
        isTime(int.parse(dataSnapshot.value.toString()));
        break;
      case "remidies":
        isRemidies(int.parse(dataSnapshot.value.toString()));
        break;
      case "ecom":
        isEcom(int.parse(dataSnapshot.value.toString()));
        break;
      case "isLiveCall":
        isLiveCall(int.parse(dataSnapshot.value.toString()));
        break;
      case "kundli":
        isKundli(int.parse(dataSnapshot.value.toString()));
        break;
      case "live":
        isLive(int.parse(dataSnapshot.value.toString()));
        break;
      case "queue":
        isQueue(int.parse(dataSnapshot.value.toString()));
        break;
      // case "tarrotCard":
      //   isRemidies(int.parse(dataSnapshot.value.toString()));
      //   break;
      case "templates":
        isTemplates(int.parse(dataSnapshot.value.toString()));
        break;
      // case "truecaller":
      //   isTruecaller(int.parse(dataSnapshot.value.toString()));
      //   break;
      case "voip":
        isVOIP(int.parse(dataSnapshot.value.toString()));
        break;
      default:
        preferenceService.setStringPref(
            dataSnapshot.key.toString(), dataSnapshot.value.toString());
        break;
    }
  }

  Future<DatabaseEvent?> masterData(String path) async {
    print("dataSnapshot-1");
    try {
      database.child(path).onChildAdded.listen((event) {
        print("dataSnapshot-Key ${event.snapshot.key}");
        saveMasterData(event.snapshot);
      });
      database.child(path).onChildChanged.listen((event) {
        print("dataSnapshot-Key ${event.snapshot.key}");
        saveMasterData(event.snapshot);
      });
    } catch (e) {
      debugPrint("Error reading data from the database: $e");
    }
  }
}
