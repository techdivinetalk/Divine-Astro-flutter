import 'package:divine_astrologer/common/getStorage/get_storage.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_function.dart';
import 'package:divine_astrologer/common/getStorage/get_storage_key.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'common/app_theme.dart';
import 'common/colors.dart';
import 'common/common_functions.dart';
import 'common/custom_progress_dialog.dart';
import 'common/routes.dart';
import 'common/strings.dart';
import 'di/firebase_network_service.dart';
import 'di/network_service.dart';
import 'di/progress_service.dart';
import 'di/shared_preference_service.dart';
import 'gen/fonts.gen.dart';
import 'localization/translations.dart';
import 'utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await initServices();
  final navigatorKey = GlobalKey<NavigatorState>();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    runApp(const MyApp());
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
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Hive.initFlutter();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      child: ScreenUtilInit(
          designSize: Size(Get.width, Get.height),
          builder: (context, child) {
            return GetMaterialApp(
              navigatorKey: navigatorKey,
              color: AppColors.white,
              debugShowCheckedModeBanner: false,
              initialRoute: RouteName.initial,
              getPages: Routes.routes,
              locale: getLanStrToLocale(
                  GetStorages.get(GetStorageKeys.language) ?? ""),
              fallbackLocale: AppTranslations.fallbackLocale,
              translations: AppTranslations(),
              theme: ThemeData(
                splashColor: AppColors.transparent,
                highlightColor: Colors.transparent,
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.white,
                    background: AppColors.white,
                    surfaceTint: AppColors.white),
                useMaterial3: true,
                fontFamily: FontFamily.poppins,
                // cardTheme: const CardTheme(
                //     color: AppColors.white, surfaceTintColor: AppColors.white),
              ),
              localizationsDelegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
              ],
              builder: (context, widget) {
                return Stack(
                  children: <Widget>[
                    Obx(() => IgnorePointer(
                        ignoring:
                            Get.find<ProgressService>().showProgress.value,
                        child: widget)),
                    StreamBuilder<bool?>(
                      initialData: true,
                      stream: Get.find<FirebaseNetworkService>()
                          .databaseConnectionStream,
                      builder: (context, snapshot) {
                        final appTheme = AppTheme.of(context);
                        return SafeArea(
                          child: AnimatedContainer(
                            height: snapshot.data as bool
                                ? 0
                                : appTheme.getHeight(36),
                            duration: Utils.animationDuration,
                            color: appTheme.redColor,
                            child: Material(
                              type: MaterialType.transparency,
                              child: Center(
                                  child: Text(AppString.noInternetConnection,
                                      style: appTheme.customTextStyle(
                                        fontSize: 16.sp,
                                        color: appTheme.whiteColor,
                                      ))),
                            ),
                          ),
                        );
                      },
                    ),
                    Obx(() => Get.find<ProgressService>().showProgress.isTrue
                        ? Center(child: CustomProgressDialog())
                        : const Offstage())
                  ],
                );
              },
            );
          }),
    );
  }
}
