import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:divine_astrologer/common/getStorage/get_storage.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_function.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_key.dart';
import 'package:divine_astrologer/firebase_options.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/remote_config/remote_config_helper.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/live_dharam/gifts_singleton.dart';
import 'package:divine_astrologer/screens/live_dharam/live_shared_preferences_singleton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_transition_mixin.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'common/MiddleWare.dart';
import 'common/app_theme.dart';
import 'common/colors.dart';
import 'common/custom_progress_dialog.dart';
import 'common/routes.dart';
import 'common/strings.dart';
import 'di/fcm_notification.dart';
import 'di/firebase_network_service.dart';
import 'di/network_service.dart';
import 'di/progress_service.dart';
import 'di/shared_preference_service.dart';
import 'gen/fonts.gen.dart';
import 'localization/translations.dart';
import 'screens/live_page/constant.dart';
import 'utils/utils.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initMessaging();
  Get.put(AppColors());

  // await RemoteConfigService.instance.initFirebaseRemoteConfig();

  final remoteConfig = FirebaseRemoteConfig.instance;
  final remoteConfigHelper = RemoteConfigHelper(remoteConfig: remoteConfig);
  await remoteConfigHelper.initialize();
  remoteConfigHelper.updateGlobalConstantWithFirebaseData();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await GetStorage.init();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("pushNotification1");
    print('Message data: ${message.data}');
    print('Message data-: ${message.data["type"] == "1"}');
    print(
        'Message data-: ${MiddleWare.instance.currentPage != RouteName.chatMessageWithSocketUI}');
    if (message.data["type"] == "1" &&
        MiddleWare.instance.currentPage != RouteName.chatMessageWithSocketUI) {
      showNotification(message.data["title"], message.data["message"],
          message.data['type'], message.data);
      HashMap<String, dynamic> updateData = HashMap();
      updateData[message.data["chatId"]] = 1;
      FirebaseDatabase.instance
          .ref("astrologer")
          .child(
              "${message.data['sender_id']}/realTime/deliveredMsg/${message.data["userid"]}")
          .update(updateData);
    } else if (message.data["type"] == "3") {
      print('Message data:- ${MiddleWare.instance.currentPage}');
      print("chat assist realtime notification with data ${message.data}");
      if (MiddleWare.instance.currentPage == RouteName.chatMessageUI) {
        assistChatNewMsg.add(message.data);
        // sendBroadcast(
        //     BroadcastMessage(name: "chatAssist", data: {'msg': message.data}));
      } else {
        showNotification(message.data["title"], message.data["message"],
            message.data['type'], message.data);
        final responseMsg = message.data;
        assistChatNewMsg.add(AssistChatData(
            message: responseMsg["message"],
            astrologerId: int.parse(responseMsg?["sender_id"].toString() ?? ''),
            createdAt: DateTime.parse(responseMsg?["created_at"])
                .millisecondsSinceEpoch
                .toString(),
            // id: responseMsg["chatId"] != null && responseMsg["chatId"] != '' && responseMsg["chatId"]=='undefined'
            //     ? int.parse(responseMsg["chatId"])
            //     : null,
            isSuspicious: 0,
            sendBy: SendBy.customer,
            msgType: responseMsg['msg_type'] != null
                ? msgTypeValues.map[responseMsg["msg_type"]]
                : MsgType.text,
            seenStatus: SeenStatus.received,
            customerId: int.parse(responseMsg["sender_id"] ?? 0)));
      }
    } else {
      showNotification(message.data["title"], message.data["message"],
          message.data['type'], message.data);
    }
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  await initServices();
  Get.put(UserRepository());
  /* Get.put(DashboardController(PreDefineRepository()));
  var data = await userRepository.constantDetailsData();
  preferenceService.setConstantDetails(data);*/

    GiftsSingleton().init();
    LiveSharedPreferencesSingleton().init();

  // final navigatorKey = GlobalKey<NavigatorState>();
  // ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  // ZegoUIKit().initLog().then((value) {
  //   ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
  //     [ZegoUIKitSignalingPlugin()],
  //   );
  //   runApp(const MyApp());
  // });

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    runApp(MyApp());
  });
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("pushNotification");
  FirebaseDatabase.instance.ref().child("pushR").set(DateTime.now());
  showNotification(message.data["title"], message.data["message"],
      message.data['type'], message.data);
  if (message.data['type'] == "1") {
    HashMap<String, dynamic> updateData = HashMap();
    updateData[message.data["chatId"]] = 1;
    FirebaseDatabase.instance
        .ref("user")
        .child(
            "${message.data['sender_id']}/realTime/deliveredMsg/${message.data["userid"]}")
        .update(updateData);
  }
}

Future<void> showNotification(String title, String message, String type,
    Map<String, dynamic> data) async {
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails("DivineCustomer", "CustomerNotification",
          importance: Importance.max,
          priority: Priority.high,
          autoCancel: true,
          actions: type == "1"
              ? [
                  const AndroidNotificationAction(
                    'accept',
                    'Accept',
                  ),
                ]
              : type=="3"? []:[]);
  if (type == "1") {
    androidNotificationDetails = const AndroidNotificationDetails(
        "DivineCustomer", "CustomerNotification",
        sound: RawResourceAndroidNotificationSound('accept_ring'),
        importance: Importance.max,
        priority: Priority.high,
        autoCancel: true);
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
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
    print("fcm token ${token}");
  });
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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed || Platform.isAndroid) {
      print("resumed state called");
      SharedPreferenceService().getChatAssistUnreadMessage();
    }
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      print("hidden state called");
      SharedPreferenceService().saveChatAssistUnreadMessage();
    }
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
                initialRoute: RouteName.initial,
                getPages: Routes.routes,
                // home: ZegoLoginScreen(),
                locale: getLanStrToLocale(
                    GetStorages.get(GetStorageKeys.language) ?? ""),
                fallbackLocale: AppTranslations.fallbackLocale,
                translations: AppTranslations(),
                theme: ThemeData(
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
