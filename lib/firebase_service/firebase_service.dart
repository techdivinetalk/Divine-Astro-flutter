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
import "package:flutter/material.dart";
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import "package:get/get.dart";

import "../model/chat_offline_model.dart";
import "../screens/live_page/constant.dart";

bool isLogOut = false;
RxInt giftCountUpdate = 0.obs;
RxString giftImageUpdate = "".obs;
RxMap<dynamic, dynamic> callKunadliUpdated = {}.obs;

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

  HiveServices hiveServices = HiveServices(boxName: userChatData);
  String tableName = "";

  readData(String path) async {
    try {
      var chatMessages = <ChatMessage>[].obs;
      var databaseMessage = ChatMessagesOffline().obs;
      await hiveServices.initialize();
      database.child(path).onValue.listen((event) async {
        debugPrint("real time $path ---> ${event.snapshot.value}");
        if (preferenceService.getToken() == null ||
            preferenceService.getToken() == "") {
          return;
        }

        if (event.snapshot.value is Map<Object?, Object?>) {
          Map<String, dynamic>? realTimeData = Map<String, dynamic>.from(
              event.snapshot.value! as Map<Object?, Object?>);
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
            Get.put(ProfilePageController(Get.put(UserRepository()))).update();
          }
          // if (realTimeData["engageId"] != null) {
          //   tableName = "chat_${realTimeData["engageId"]}";
          //   debugPrint("tableName ${tableName}");
          // }
          // var res = await hiveServices.getData(key: tableName);
          // if (res != null) {
          //   var msg = ChatMessagesOffline.fromOfflineJson(jsonDecode(res));
          //   chatMessages.value = msg.chatMessages ?? [];
          //   databaseMessage.value.chatMessages = chatMessages;
          //   debugPrint("msg.chatMessages ${msg.chatMessages?.length}");
          // }
          if (realTimeData["isEngagedStatus"] != null) {
            print(realTimeData["isEngagedStatus"]);
            print('realTimeData["isEngagedStatus"]');
            isEngagedStatus(realTimeData['isEngagedStatus']);
          } else {
            isEngagedStatus(0);
          }
          if (realTimeData["notification"] != null) {
            final HiveServices hiveServices =
                HiveServices(boxName: userChatData);
            await hiveServices.initialize();
            realTimeData["notification"].forEach((key, notificationData) async {
              if (notificationData["type"] == 2) {
                final Map<String, dynamic> chatListMap =
                    jsonDecode(notificationData["chatList"]);
                final ChatMessage chatMessage =
                    ChatMessage.fromOfflineJson(chatListMap);
                chatMessages.add(chatMessage);
                databaseMessage.value.chatMessages = chatMessages;
                await hiveServices.addData(
                    key: tableName,
                    data: jsonEncode(databaseMessage.value.toOfflineJson()));
              }

              //   debugPrint("local notification $notificationData");
              //   if (notificationData != null) {
              //     showNotificationWithActions(
              //         title: notificationData["value"] ?? "",
              //         message: notificationData["message"] ??€ "",
              //         payload: notificationData,
              //         hiveServices: hiveServices);
              //   }
            });
            FirebaseDatabase.instance.ref("$path/notification").remove();
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
            callKunadliUpdated(realTimeData['callKundli']);
            sendBroadcast(
                BroadcastMessage(name: "callKundli", data: callKundli));
            // FirebaseDatabase.instance.ref("$path/callKundli").remove();
          } else {
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
          if (realTimeData["order_id"] != null) {
            watcher.strValue = realTimeData["order_id"].toString();
          }
        }
      });
    } catch (e) {
      debugPrint("Error reading data from the database: $e");
    }

    watcher.nameStream.listen(
      (value) {
        if (value != "") {
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
                          await Get.toNamed(RouteName.acceptChatRequestScreen);
                        }
                        break;
                      case "1":
                        if (Get.currentRoute !=
                            RouteName.acceptChatRequestScreen) {
                          await Get.toNamed(RouteName.acceptChatRequestScreen);
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
                  }else{
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
}
