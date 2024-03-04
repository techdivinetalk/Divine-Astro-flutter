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
            String uniqueId = await getDeviceId() ?? "";
            debugPrint(
                'check uniqueId ${realTimeData['uniqueId']}\ngetDeviceId ${uniqueId.toString()}');
            if (realTimeData["uniqueId"] != uniqueId) {
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
          if (realTimeData["engageId"] != null) {
            tableName = "chat_${realTimeData["engageId"]}";
            debugPrint("tableName ${tableName}");
          }
          var res = await hiveServices.getData(key: tableName);
          if (res != null) {
            var msg = ChatMessagesOffline.fromOfflineJson(jsonDecode(res));
            chatMessages.value = msg.chatMessages ?? [];
            databaseMessage.value.chatMessages = chatMessages;
            debugPrint("msg.chatMessages ${msg.chatMessages?.length}");
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
            sendBroadcast(BroadcastMessage(
                name: "deliveredMsg",
                data: {'deliveredMsgList': realTimeData["deliveredMsg"]}));
          }
          if (realTimeData["totalGift"] != null) {
            sendBroadcast(BroadcastMessage(
                name: "totalGift",
                data: {'totalGift': realTimeData["totalGift"]}));
          }
          if (realTimeData["order_id"] != null) {
            watcher.strValue = realTimeData["order_id"].toString();
          }
        }
      });
    } catch (e) {
      debugPrint("Error reading data from the database: $e");
    }

    // watcher.nameStream.listen((value) {
    //   if (value != "") {
    //     _database.child("order/$value").onValue.listen((event) async {
    //       orderData(event.snapshot.value == null
    //           ? <String, String>{}
    //           : Map<String, dynamic>.from(
    //               event.snapshot.value! as Map<Object?, Object?>));
    //       if (event.snapshot.value != null) {
    //         Map<String, dynamic>? orderData = Map<String, dynamic>.from(
    //             event.snapshot.value! as Map<Object?, Object?>);
    //         debugPrint("orderData-------> $orderData");
    //         if (orderData["status"] != null) {
    //           if (orderData["status"] == "0") {
    //             acceptBottomWatcher.strValue = "0";
    //             await Navigator.of(Get.context!).push(
    //               MaterialPageRoute(
    //                 builder: (context) {
    //                   return const AcceptChatRequestScreen();
    //                 },
    //               ),
    //             );
    //           } else if (orderData["status"] == "1") {
    //             if (acceptBottomWatcher.currentName != "1") {
    //               acceptBottomWatcher.strValue = "1";
    //               await Navigator.of(Get.context!).push(
    //                 MaterialPageRoute(
    //                   builder: (context) {
    //                     return const AcceptChatRequestScreen();
    //                   },
    //                 ),
    //               );
    //             }
    //           } else if (orderData["status"] == "2") {

    //           } else if (orderData["status"] == "3") {
    //            await sendBroadcast(BroadcastMessage(
    //                 name: "ReJoinChat",
    //                 data: {"orderId": value, "orderData": orderData}));
    //             // WidgetsBinding.instance.endOfFrame.then(
    //             //   (_) async {
    //             //     await Get.toNamed(RouteName.chatMessageWithSocketUI,
    //             //         arguments: {"orderData": orderData});
    //             //   },
    //             // );
    //           }
    //         }
    //       }
    //     });
    //   }

    //   debugPrint("value changed to: $value");
    // });

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
                  print("data from snapshot ${dataSnapshot.value}");
                  if (orderData.value["status"] != null) {
                    switch ((orderData.value["status"])) {
                      case "0":
                        await commonNavigationForStatus0And1();
                        break;

                      case "1":
                        await commonNavigationForStatus0And1();
                        break;

                      case "2":
                        await commonNavigationForStatus2And3();
                        break;

                      case "3":
                        await commonNavigationForStatus2And3();
                        break;

                      default:
                        break;
                    }
                  } else {}
                } else {}
              } else {
                sendBroadcast(BroadcastMessage(name: "orderEnd"));
              }
            },
          );
        } else {
          sendBroadcast(BroadcastMessage(name: "orderEnd"));
        }
      },
    );
  }

  Future<void> commonNavigationForStatus0And1() async {
    if (Get.currentRoute != RouteName.acceptChatRequestScreen) {
      await Get.toNamed(RouteName.acceptChatRequestScreen);

      final valueMap = AppFirebaseService().orderData.value ?? {};
      final dynamic status = valueMap['status'];
      if (status == "0" || status == 0) {
        await furtherProcedure();
      } else {}
    } else {}
    return Future<void>.value();
  }

  Future<void> commonNavigationForStatus2And3() async {
    if (Get.currentRoute != RouteName.chatMessageWithSocketUI) {
      await Get.toNamed(
        RouteName.chatMessageWithSocketUI,
        arguments: {"orderData": orderData},
      );
    } else {}
    return Future<void>.value();
  }

  Future<void> furtherProcedure() async {
    final valueMap = AppFirebaseService().orderData.value ?? {};
    final bool isAccepted = await acceptOrRejectChat(
      orderId: valueMap['orderId'],
      queueId: valueMap["queue_id"],
    );
    if (isAccepted) {
      // bool value = await AppPermissionService.instance.hasAllPermissions();
      // String path = "order/${valueMap['orderId']}";
      // await AppFirebaseService().database.child(path).update(
      //   <String, dynamic>{
      //     "status": "1",
      //     "astrologer_permission": value,
      //   },
      // );

      final bool value = await AppPermissionService.instance.hasAllPermissions();
      final int orderId = valueMap["orderId"] ?? 0;
      if (orderId != 0) {
        await AppFirebaseService().database.child("order/$orderId").update(
          <String, dynamic>{"status": "1", "astrologer_permission": value},
        );
      } else {}
      
    } else {}
    appSocket.sendConnectRequest(
      astroId: valueMap["astroId"],
      custId: valueMap["userId"],
    );
    return Future<void>.value();
  }
}
