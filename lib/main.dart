import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:divine_astrologer/common/getStorage/get_storage.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_function.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_key.dart';
import 'package:divine_astrologer/notification_helper/notification_helpe.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'common/GlobalLifecycleObserver.dart';
import 'common/MiddleWare.dart';
import 'common/app_theme.dart';
import 'common/colors.dart';
import 'common/common_functions.dart';
import 'common/generic_loading_widget.dart';
import 'common/routes.dart';
import 'di/firebase_network_service.dart';
import 'di/network_service.dart';
import 'di/progress_service.dart';
import 'di/shared_preference_service.dart';
import 'firebase_service/firebase_service.dart';
import 'gen/fonts.gen.dart';
import 'localization/translations.dart';
import 'model/constant_details_model_class.dart';
import 'screens/live_page/constant.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late List<CameraDescription>? cameras;

@pragma('vm:entry-point')
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  NotificationHelper().showNotification(
    message.data["title"] ?? "",
    message.data["message"] ?? "",
    message.data['type'] ?? "",
    message.data,
  );
}

//// Onboarding Code Done

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // initMessaging();
  AppFirebaseService().masterData("masters");
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  SmsAutoFill().listenForCode;

  cameras = await availableCameras();
  Get.put(AppColors());
  final remoteConfig = FirebaseRemoteConfig.instance;

  final remoteConfigHelper = RemoteConfigHelper(remoteConfig: remoteConfig);
  await remoteConfigHelper.initialize();
  remoteConfigHelper.updateGlobalConstantWithFirebaseData();
  await GetStorage.init();

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

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    showBadge: true,
    importance: Importance.high,
  );

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
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
// old notification code
/*Future<void> showNotification(String title, String message, String type,
    Map<String, dynamic> data) async {
  // androidNotificationDetails;

  AndroidNotificationDetails? androidNotificationDetails;
  if (type == "2") {
    // Type 2: Custom sound
    androidNotificationDetails = const AndroidNotificationDetails(
      "DivineAstrologer",
      "AstrologerNotification",
      importance: Importance.max,
      priority: Priority.high,
      icon: "divine_logo_tran",
      autoCancel: true,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('accept'),
      setAsGroupSummary: true,
      styleInformation: const BigTextStyleInformation(''),
      actions: [
        AndroidNotificationAction(
          'accept',
          'CHAT NOW',
        )
      ],
    );
  } else {
    // Default notification (no custom sound)
    androidNotificationDetails = const AndroidNotificationDetails(
      "DivineAstrologer_Other_type",
      "AstrologerNotification_other_type",
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
}*/

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
    try {
      final userId = preferenceService.getUserDetail()?.id;

      // Check if user details are null, navigate to login if true
      if (userId == null) {
        Get.offAllNamed(RouteName.login);
        return; // Exit the function as user needs to log in
      }

      // Fetch isOnboarding data from Firebase
      final dataSnapshot = await AppFirebaseService()
          .database
          .child("astrologer/$userId/realTime/isOnboarding")
          .get();

      isOnboardings = dataSnapshot.value;
      print("Response of isOnboarding: ${isOnboardings.toString()}");

      // If onboarding value is "4", navigate to the dashboard
      if (isOnboardings.toString() == "4") {
        print('Navigating to dashboard...');
        Get.offAllNamed(RouteName.dashboard);
        return; // Exit after navigation
      }

      // If onboarding is not complete, fetch constant details data
      ConstantDetailsModelClass? commonConstants =
          await userRepository.constantDetailsData2api();
      print('Constant details response: ${commonConstants?.toJson()}');

      // If API call is successful
      if (commonConstants != null && commonConstants.success == true) {
        final data = commonConstants.data;

        if (data != null) {
          // Update URLs and video data
          imageUploadBaseUrl.value = data.imageUploadBaseUrl ?? "";
          onboarding_training_videoData = data.onboarding_training_video;

          // Set Amazon URLs in preferences
          preferenceService.setBaseImageURL(data.awsCredentails.baseurl!);
          Get.find<SharedPreferenceService>()
              .setAmazonUrl(data.awsCredentails.baseurl!);

          // Navigate based on onboarding state
          navigateForOnBoardingGlobal(commonConstants);
        }
      }
      // If API call fails with status 401, log out user
      else if (commonConstants?.success == false &&
          commonConstants?.statusCode == 401) {
        print("status code 401 error log out -------->");
        await preferenceService.erase();
        Get.offAllNamed(RouteName.login);
      } else {
        // Handle other failure cases here if needed
        print('API call failed with unknown error');
      }
    } catch (error) {
      // Handle any potential errors
      print("Error in checkOnBoarding: $error");
      Get.offAllNamed(RouteName.login); // Optionally navigate to login on error
    } finally {
      // Stop loading indicator once everything is done
      setState(() {
        _isLoading = false;
      });
    }
  }
  // checkOnBoarding() async {
  //   if (preferenceService.getUserDetail()?.id == null) {
  //     Get.offAllNamed(RouteName.login);
  //   } else {
  //     final dataSnapshot = await AppFirebaseService()
  //         .database
  //         .child(
  //             "astrologer/${preferenceService.getUserDetail()!.id}/realTime/isOnboarding")
  //         .get();
  //     print("response of isOnboarding - ${isOnboardings.toString()}");
  //     isOnboardings = dataSnapshot.value;
  //     ConstantDetailsModelClass? commonConstants;
  //     print("response of isOnboarding - ${isOnboardings.toString()}");
  //     if (preferenceService.getUserDetail()?.id == null) {
  //       Get.offAllNamed(RouteName.login);
  //     } else if (dataSnapshot.value.toString() == "4") {
  //       print('homeeeee1');
  //
  //       Get.offAllNamed(RouteName.dashboard);
  //     } else {
  //       commonConstants = await userRepository.constantDetailsData2api();
  //       print('--------------response--------${commonConstants.toJson()}');
  //       if (commonConstants.success == true) {
  //         if (commonConstants?.data != null) {
  //           imageUploadBaseUrl.value =
  //               commonConstants?.data?.imageUploadBaseUrl ?? "";
  //           onboarding_training_videoData =
  //               commonConstants.data!.onboarding_training_video;
  //         }
  //         preferenceService
  //             .setBaseImageURL(commonConstants.data!.awsCredentails.baseurl!);
  //         Get.find<SharedPreferenceService>()
  //             .setAmazonUrl(commonConstants.data!.awsCredentails.baseurl!);
  //         navigateForOnBoardingGlobal(commonConstants);
  //       } else if (commonConstants.success == false &&
  //           commonConstants.statusCode == 401) {
  //         await preferenceService.erase();
  //
  //         Get.offAllNamed(RouteName.login);
  //
  //         // Handle any failure case here
  //       } else {}
  //     }
  //   }
  //
  //   // Once data is fetched, stop loading
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

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
