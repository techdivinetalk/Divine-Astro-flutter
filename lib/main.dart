import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:divine_astrologer/common/getStorage/get_storage.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_function.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_key.dart';
import 'package:divine_astrologer/firebase_options.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/remote_config/remote_config_helper.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/live_dharam/gifts_singleton.dart';
import 'package:divine_astrologer/screens/live_dharam/live_shared_preferences_singleton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'common/MiddleWare.dart';
import 'common/app_theme.dart';
import 'common/colors.dart';
import 'common/common_functions.dart';

import 'common/routes.dart';

import 'di/fcm_notification.dart';
import 'di/firebase_network_service.dart';
import 'di/network_service.dart';
import 'di/progress_service.dart';
import 'di/shared_preference_service.dart';
import 'firebase_service/firebase_service.dart';
import 'gen/fonts.gen.dart';
import 'localization/translations.dart';
import 'screens/live_page/constant.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initMessaging();
  cameras = await availableCameras();
  Get.put(AppColors());
  // await RemoteConfigService.instance.initFirebaseRemoteConfig();
  final remoteConfig = FirebaseRemoteConfig.instance;

  final remoteConfigHelper = RemoteConfigHelper(remoteConfig: remoteConfig);
  await remoteConfigHelper.initialize();
  remoteConfigHelper.updateGlobalConstantWithFirebaseData();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await GetStorage.init();
  InAppUpdate.checkForUpdate().then((updateInfo) {
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      if (updateInfo.immediateUpdateAllowed) {
        // Perform immediate update
        InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            Fluttertoast.showToast(msg: "AppUpdated lets Re-start");
          }
        });
      } else if (updateInfo.flexibleUpdateAllowed) {
        //Perform flexible update
        InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            //App Update successful
            InAppUpdate.completeFlexibleUpdate();
          }
        });
      }
    }
  });
  // Non-async exceptions
  const fatalError = true;
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("pushNotification1");
    print('Message data-: dasboardCurrentIndex');
    print(
        'Message data-: ${MiddleWare.instance.currentPage != RouteName.chatMessageWithSocketUI}');
    if (message.data["type"] == "2") {
      print('msg ---- from notification');
      return;
    }
    if (message.data["type"] == "1") {
      print('msg ---- from notification');
      return;
    }
    if (message.data["type"] == "1" &&
        MiddleWare.instance.currentPage != RouteName.chatMessageWithSocketUI) {
      showNotification(message.data["title"], message.data["message"],
          message.data['type'], message.data);
      HashMap<String, dynamic> updateData = HashMap();
      updateData[message.data["chatId"]] = 1;
      print('Message data-:-users ${message.data}');
      FirebaseDatabase.instance
          .ref("user")
          .child(
              "${message.data['sender_id']}/realTime/deliveredMsg/${message.data["userid"]}")
          .update(updateData);
      print('Message data: ${message.data['userid']}');
      print('Message data: ${message.data['sender_id']}');
    } else if (message.data["type"] == "8") {
      print(
          "inside page for realtime notification ${message.data} ${MiddleWare.instance.currentPage}");
      if (MiddleWare.instance.currentPage == RouteName.chatMessageUI &&
          chatAssistantCurrentUserId.value.toString() ==
              message.data['sender_id'].toString()) {
        assistChatNewMsg([...assistChatNewMsg, message.data]);
        assistChatNewMsg.refresh();
        // sendBroadcast(
        //     BroadcastMessage(name: "chatAssist", data: {'msg': message.data}));
      } else {
        // assistChatUnreadMessages([...assistChatUnreadMessages, message.data]);
        if (dasboardCurrentIndex.value == 2) {
          final responseMsg = message.data;
          assistChatUnreadMessages([
            ...assistChatUnreadMessages,
            AssistChatData(
                message: responseMsg["message"],
                id: int.parse(responseMsg["chatId"].toString() ?? ''),
                customerId:
                    int.parse(responseMsg["sender_id"].toString() ?? ''),
                createdAt: DateTime.parse(responseMsg["created_at"])
                    .millisecondsSinceEpoch
                    .toString(),
                isSuspicious: 0,
                suggestedRemediesId:
                    int.parse(responseMsg["suggestedRemediesId"] ?? "0"),
                isPoojaProduct:
                    responseMsg['is_pooja_product'].toString() == '1'
                        ? true
                        : false,
                productId: responseMsg["product_id"].toString(),
                shopId: responseMsg["shop_id"].toString(),
                sendBy: SendBy.astrologer,
                msgType: responseMsg['msg_type'] != null
                    ? msgTypeValues.map[responseMsg["msg_type"]]
                    : MsgType.text,
                seenStatus: SeenStatus.received,
                astrologerId: int.parse(responseMsg["userid"] ?? 0))
          ]);
        }
        switch (message.data['msg_type']) {
          case "0":
            showNotification(message.data["title"], message.data["message"],
                message.data['type'], message.data);
            break;
          case "1":
            showNotification(message.data["title"], 'sendNotificationImage'.tr,
                message.data['type'], message.data);
            break;
          case "2":
            showNotification(message.data["title"], 'sendNotificationRemedy'.tr,
                message.data['type'], message.data);
            break;
          case "3":
            showNotification(
                message.data["title"],
                'sendNotificationProduct'.tr,
                message.data['type'],
                message.data);
            break;
          case "8":
            showNotification(message.data["title"], 'sendNotificationGift'.tr,
                message.data['type'], message.data);
            break;
        }
      }
    } else {
      print("message.data");
      showNotification(message.data["title"], message.data["message"],
          message.data['type'], message.data);
    }
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  await initServices();
  Get.put(UserRepository());
  GiftsSingleton().init();
  LiveSharedPreferencesSingleton().init();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    runApp(MyApp());
  });
  Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  AppFirebaseService().masterData("masters");
}

Future<bool> saveLanguage(String? lang) async {
  final box = GetStorage();
  await box.write('lang', lang);
  return true;
}

saveLanguageId(int userLanguageId) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (kDebugMode) {
    print("userLanguageId ++${userLanguageId.toString()}");
  }
  await pref.setInt('languageIds', userLanguageId);
}

Future<void> initServices() async {
  await Get.putAsync(() => ProgressService().init());
  await Get.putAsync(() => SharedPreferenceService().init());
  await Get.putAsync(() => NetworkService().init());
  await Get.putAsync(() => FirebaseNetworkService().init());
  await Hive.initFlutter();
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FirebaseDatabase.instance.ref().child("pushR").set(DateTime.now());

  if (message.data["type"] == "8" &&
      MiddleWare.instance.currentPage == RouteName.chatMessageUI &&
      chatAssistantCurrentUserId.value.toString() ==
          message.data['sender_id'].toString()) {
    assistChatNewMsg([...assistChatNewMsg, message.data]);
    assistChatNewMsg.refresh();
  }

  if (message.data['type'] == "1") {
    HashMap<String, dynamic> updateData = HashMap();
    updateData[message.data["chatId"]] = 1;
    FirebaseDatabase.instance
        .ref("user")
        .child(
            "${message.data['sender_id']}/realTime/deliveredMsg/${message.data["userid"]}")
        .update(updateData);
  }
  showNotification(message.data["title"], message.data["message"],
      message.data['type'], message.data);
}

Future<void> showNotification(String title, String message, String type,
    Map<String, dynamic> data) async {
  AndroidNotificationDetails? androidNotificationDetails;
  if (type == "1") {
    androidNotificationDetails = const AndroidNotificationDetails(
      "DivineCustomer", "CustomerNotification",
      // sound: RawResourceAndroidNotificationSound('accept_ring'),
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: true,
      playSound: true,
      setAsGroupSummary: true,
      styleInformation: BigTextStyleInformation(''),
    );
  } else {
    androidNotificationDetails = AndroidNotificationDetails(
      "DivineCustomer",
      "CustomerNotification",
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: true,
      actions: type == "2"
          ? [
              const AndroidNotificationAction(
                'accept',
                'ACCEPT',
              ),
            ]
          : [],
    );
  }
  NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      Random().nextInt(90000), title, message, notificationDetails,
      payload: json.encode(data));
}

void initMessaging() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkForUpdate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      child: ScreenUtilInit(
          designSize: Size(MediaQuery.sizeOf(context).width,
              MediaQuery.sizeOf(context).height),
          builder: (context, child) {
            return OverlaySupport.global(
              child: GetMaterialApp(
                navigatorObservers: <NavigatorObserver>[
                  GetObserver(MiddleWare.instance.observer, Get.routing),
                ],
                defaultTransition: Transition.fadeIn,
                navigatorKey: navigatorKey,
                color: appColors.white,
                debugShowCheckedModeBanner: false,
                initialRoute: preferenceService.getUserDetail()?.id == null
                    ? RouteName.login
                    : RouteName.dashboard,
                 getPages: Routes.routes,
                // home: ZegoLoginScreen(),
                locale: getLanStrToLocale(
                    GetStorages.get(GetStorageKeys.language) ?? ""),
                fallbackLocale: AppTranslations.fallbackLocale,
                translations: AppTranslations(),
                theme: ThemeData(
                  bottomSheetTheme: const BottomSheetThemeData(
                      backgroundColor: Colors.transparent, modalElevation: 0),
                  splashColor: appColors.transparent,
                  highlightColor: Colors.transparent,
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.white,
                      background: appColors.white,
                      surfaceTint: appColors.white),
                  useMaterial3: true,
                  fontFamily: FontFamily.poppins,
                  // cardTheme: const CardTheme(
                  //     color: appColors.white, surfaceTintColor: appColors.white),
                ),
                localizationsDelegates: const [
                  DefaultMaterialLocalizations.delegate,
                  DefaultWidgetsLocalizations.delegate,
                ],
                // builder: (context, widget) {
                //   return widget ?? const SizedBox();
                //   // Container();
                //   //   Stack(
                //   //   children: <Widget>[
                //   //     // Obx(() => IgnorePointer(
                //   //     //     ignoring:
                //   //     //         Get.find<ProgressService>().showProgress.value,
                //   //     //     child: widget)),
                //   //
                //   //     //
                //   //     widget ?? SizedBox(),
                //   //     //
                //   //     // StreamBuilder<bool?>(
                //   //     //   initialData: true,
                //   //     //   stream: Get.find<FirebaseNetworkService>()
                //   //     //       .databaseConnectionStream,
                //   //     //   builder: (context, snapshot) {
                //   //     //     final appTheme = AppTheme.of(context);
                //   //     //     return SafeArea(
                //   //     //       child: AnimatedContainer(
                //   //     //         height: snapshot.data as bool
                //   //     //             ? 0
                //   //     //             : appTheme.getHeight(36),
                //   //     //         duration: Utils.animationDuration,
                //   //     //         color: appTheme.redColor,
                //   //     //         child: Material(
                //   //     //           type: MaterialType.transparency,
                //   //     //           child: Center(
                //   //     //               child: Text(AppString.noInternetConnection,
                //   //     //                   style: appTheme.customTextStyle(
                //   //     //                     fontSize: 16.sp,
                //   //     //                     color: appTheme.whiteColor,
                //   //     //                   ))),
                //   //     //         ),
                //   //     //       ),
                //   //     //     );
                //   //     //   },
                //   //     // ),
                //   //     // Obx(() => Get.find<ProgressService>().showProgress.isTrue
                //   //     //     ? Center(child: CustomProgressDialog())
                //   //     //     : const Offstage())
                //   //   ],
                //   // );
                // },
              ),
            );
          }),
    );
  }
}
