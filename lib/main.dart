import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:camera/camera.dart';
import 'package:divine_astrologer/common/getStorage/get_storage.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_function.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_key.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/remote_config/remote_config_helper.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/auth/login/login_controller.dart';
import 'package:divine_astrologer/screens/dashboard/dashboard_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/gifts_singleton.dart';
import 'package:divine_astrologer/screens/live_dharam/live_shared_preferences_singleton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'common/GlobalLifecycleObserver.dart';
import 'common/MiddleWare.dart';
import 'common/app_theme.dart';
import 'common/colors.dart';
import 'common/common_functions.dart';
import 'common/generic_loading_widget.dart';
import 'common/routes.dart';
import 'di/fcm_notification.dart';
import 'di/firebase_network_service.dart';
import 'di/network_service.dart';
import 'di/progress_service.dart';
import 'di/shared_preference_service.dart';
import 'firebase_service/firebase_service.dart';
import 'gen/fonts.gen.dart';
import 'localization/translations.dart';
import 'model/constant_details_model_class.dart';
import 'screens/live_page/constant.dart';

/// sahil pushed
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late List<CameraDescription>? cameras;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('channel_id: ${message.data}');
  showNotification(
    message.data["title"],
    message.data["message"],
    message.data['type'],
    message.data,
  );
  // if (message.data["type"].toString() == "2") {
  // log('Handling a background message when type is 2: ${message.data}');
  //   flutterLocalNotificationsPlugin.show(
  //     message.data.hashCode,
  //     message.data['title'],
  //     message.data['message'],
  //     payload: jsonEncode(message.data),
  //      NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         "${channel.id}_${Random().nextInt(100)}",
  //         "divine_accept_notification_${Random().nextInt(100)}",
  //         channelDescription: channel.description,
  //         importance: Importance.max,
  //         priority: Priority.high,
  //         icon: '@mipmap/ic_launcher',
  //         playSound: true,
  //         enableVibration: true,
  //         sound:  const RawResourceAndroidNotificationSound('accept'),
  //       ),
  //     ),
  //   );
  // }
}

//// Onboarding Code Done

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // initMessaging();
  AppFirebaseService().masterData("masters");

  cameras = await availableCameras();
  Get.put(AppColors());
  final remoteConfig = FirebaseRemoteConfig.instance;

  final remoteConfigHelper = RemoteConfigHelper(remoteConfig: remoteConfig);
  await remoteConfigHelper.initialize();
  remoteConfigHelper.updateGlobalConstantWithFirebaseData();
  await GetStorage.init();
  /*Future<void> showFlutterNotification(RemoteMessage message,
      {String? type}) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    log("message.notification?.android---${type}");
    if (notification != null && android != null && Platform.isAndroid) {

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        payload: jsonEncode(message.data),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
            sound:const RawResourceAndroidNotificationSound('accept'),
          ),
        ),
      );

    }
  }*/

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log("check on message notification : ${message.data}------${message.data["type"]}");
    log("pushNotification1 ${message.notification?.title ?? ""}");
    // if (message.data["type"] == "2" /*|| message.data["type"] == "20"*/) {
    //   log("showFlutterNotification---showFlutterNotification");
    //   showFlutterNotification(message, type: message.data["type"].toString());
    //   return;
    // }
    if (message.data["type"].toString() == "1") {
      if (MiddleWare.instance.currentPage !=
          RouteName.chatMessageWithSocketUI) {
        log("messageReceive21 ${MiddleWare.instance.currentPage}");
        showNotification(message.data["title"], message.data["message"],
            message.data['type'], message.data);
      }
      HashMap<String, dynamic> updateData = HashMap();
      updateData[message.data["chatId"] ?? "0"] = 1;
      log('Message data-:-users ${message.data}');
      log("test_notification: Enable fullscreen incoming call notification");
      sendBroadcast(
          BroadcastMessage(name: "messageReceive", data: message.data));
    } else if (message.data["type"] == "8") {
      log("inside page for realtime notification ${message.data} ${MiddleWare.instance.currentPage}");
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
      showNotification(message.data["title"], message.data["message"],
          message.data['type'], message.data);
    }
    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification?.title}');
    }
  });
  if (await Permission.notification.status.isPermanentlyDenied ||
      await Permission.notification.status.isRestricted ||
      await Permission.notification.status.isDenied) {
    await Permission.notification.request();
    if (Get.isRegistered<LoginController>()) {
      Get.find<LoginController>().onReady();
    }
  }
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

    try {
      runApp(MyApp());
    } catch (error, stacktrace) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stacktrace, fatal: true);
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stacktrace);
    }
  });

  // Permission.notification.isDenied.then((value) async {
  //   if (value) {
  //     await Permission.notification.request();
  //
  //     if (Get.isRegistered<LoginController>()) {
  //       Get.find<LoginController>().onReady();
  //     }
  //   }
  // });
  AppFirebaseService().masterData("masters");
  if (!kDebugMode) {
    AppFirebaseService().masterData("masters");
  }
}

Future<bool> saveLanguage(String? lang) async {
  final box = GetStorage();
  await box.write('lang', lang);
  return true;
}

saveLanguageId(int userLanguageId) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (kDebugMode) {
    log("userLanguageId ++${userLanguageId.toString()}");
  }
  await pref.setInt('languageIds', userLanguageId);
}

Future<void> initServices() async {
  await Get.putAsync(() => ProgressService().init());
  await Get.putAsync(() => SharedPreferenceService().init());
  await Get.putAsync(() => NetworkService().init());
  await Get.putAsync(() => FirebaseNetworkService().init());
}

Future<void> showNotification(String title, String message, String type,
    Map<String, dynamic> data) async {
  // androidNotificationDetails;
  log("typetypetypetypetypetype----->>>>>${type}");
  AndroidNotificationDetails? androidNotificationDetails;
  if (type == "2") {
    // Type 2: Custom sound
    androidNotificationDetails = AndroidNotificationDetails(
      "DivineCustomer_${Random().nextInt(100)}",
      "CustomerNotification_${Random().nextInt(100)}",
      importance: Importance.max,
      priority: Priority.high,
      icon: "divine_logo_tran",
      autoCancel: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('accept'),
      // Use custom sound
      setAsGroupSummary: true,
      styleInformation:const BigTextStyleInformation(''),
    );
  } else {
    // Default notification (no custom sound)
    androidNotificationDetails = const AndroidNotificationDetails(
      "DivineCustomer",
      "CustomerNotification",
      importance: Importance.max,
      priority: Priority.high,
      icon: "divine_logo_tran",
      autoCancel: true,
      playSound: true,
      setAsGroupSummary: true,
      styleInformation: BigTextStyleInformation(''),
    );
  }

  NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  // Show notification
  await flutterLocalNotificationsPlugin.show(
      Random().nextInt(90000), title, message, notificationDetails,
      payload: json.encode(data));
  // if (type == "1") {
  //
  // }  else {
  //
  // }
}

// void initMessaging() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings("@mipmap/ic_launcher");
//   const DarwinInitializationSettings initializationSettingsDarwin =
//       DarwinInitializationSettings(
//           onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//           );
//
//   const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin);
//   flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalLifecycleObserver _lifecycleObserver = GlobalLifecycleObserver();
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataSnapshot = await AppFirebaseService()
          .database
          .child("masters/disableOnboarding")
          .get();
      log("dataSnapshot.value.toString() -- ${dataSnapshot.value.toString()}");
      if (dataSnapshot.value.toString() == "0") {
        checkOnBoarding();

        // if (verifyOnboarding.toString() == "0") {
        //   log("from 0");
        // } else {
        //   log("from 1");
        //   if (preferenceService.getUserDetail()?.id == null) {
        //     Get.offAllNamed(RouteName.login);
        //   } else {
        //     log("Gone to here");
        //
        //     Get.offAllNamed(RouteName.dashboard);
        //   }
        // }
      } else {
        normalBoaring();
      }
    });
  }

  normalBoaring() {
    log("normal onboaringin process");
    if (preferenceService.getUserDetail()?.id == null) {
      Get.offAllNamed(RouteName.login);
    } else {
      log("Gone to here");

      Get.offAllNamed(RouteName.dashboard);
    }
  }

  var isOnboardings;

  checkOnBoarding() async {
    if (preferenceService.getUserDetail()?.id == null) {
      Get.offAllNamed(RouteName.login);
    } else {
      final dataSnapshot = await AppFirebaseService()
          .database
          .child(
              "astrologer/${preferenceService.getUserDetail()!.id}/realTime/isOnboarding")
          .get();
      log("response of isOnboarding - ${isOnboardings.toString()}");
      isOnboardings = dataSnapshot.value;
      ConstantDetailsModelClass? commonConstants;
      log("response of isOnboarding - ${isOnboardings.toString()}");
      if (preferenceService.getUserDetail()?.id == null) {
        Get.offAllNamed(RouteName.login);
      } else if (isOnboardings.toString() == "4" // || isOnboardings == null
          ) {
        log('homeeeee1');

        Get.offAllNamed(RouteName.dashboard);
      } else {
        commonConstants = await userRepository.constantDetailsData2api();
        log('--------------response----------${commonConstants.toJson()}');
        if (commonConstants.success == true) {
          if (commonConstants?.data != null) {
            imageUploadBaseUrl.value =
                commonConstants?.data?.imageUploadBaseUrl ?? "";
            onboarding_training_videoData =
                commonConstants.data!.onboarding_training_video;
          }
          preferenceService
              .setBaseImageURL(commonConstants.data!.awsCredentails.baseurl!);
          Get.find<SharedPreferenceService>()
              .setAmazonUrl(commonConstants.data!.awsCredentails.baseurl!);
          navigateForOnBoardingGlobal(commonConstants);
        } else if (commonConstants.success == false &&
            commonConstants.statusCode == 401) {
          await preferenceService.erase();

          Get.offAllNamed(RouteName.login);

          // Handle any failure case here
        } else {}
      }
    }

    // Once data is fetched, stop loading
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  showSecondNotification("title", "body", AppFirebaseService().payload);
    return AppTheme(
      child: ScreenUtilInit(
          designSize: const Size(411, 736), // Use your design's dimensions here
          minTextAdapt: true, // Ensure text adapts even on smaller screens
          splitScreenMode: true, // Ensure split screen is handled properly
          builder: (context, child) {
            return OverlaySupport.global(
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.noScaling),
                child: GetMaterialApp(
                  navigatorObservers: <NavigatorObserver>[
                    GetObserver(MiddleWare.instance.observer, Get.routing),
                  ],
                  defaultTransition: Transition.fadeIn,
                  navigatorKey: navigatorKey,
                  color: appColors.white,
                  debugShowCheckedModeBanner: false,
                  // initialRoute: preferenceService.getUserDetail()?.id == null
                  //     ? RouteName.login
                  //     : onBoard == "1"
                  //         ? RouteName.root
                  //         : RouteName.dashboard,
                  // initialRoute: initialRoute,
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
                  // Show a loading screen while data is being fetched
                  home: _isLoading
                      ? Scaffold(
                          body: const Center(
                            child: GenericLoadingWidget(),
                          ),
                        )
                      : Scaffold(), // Optionally return an empty container since navigation is handled elsewhere

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
                  //   //     //         duration: Utils.animationDurat
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
              ),
            );
          }),
    );
  }
}
