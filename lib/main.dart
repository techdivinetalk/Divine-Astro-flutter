import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'common/colors.dart';
import 'common/routes.dart';
import 'common/app_theme.dart';
import 'common/custom_progress_dialog.dart';
import 'di/firebase_network_service.dart';

import 'di/progress_service.dart';
import 'di/shared_preference_service.dart';
import 'gen/fonts.gen.dart';
import 'localization/translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => ProgressService().init());
  await Get.putAsync(() => SharedPreferenceService().init());
  // await Get.putAsync(() => NetworkService().init());
  await Get.putAsync(() => FirebaseNetworkService().init());
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
              color: AppColors.white,
              debugShowCheckedModeBanner: false,
              initialRoute: RouteName.initial,
              getPages: Routes.routes,
              locale: AppTranslations.locale,
              fallbackLocale: AppTranslations.fallbackLocale,
              translations: AppTranslations(),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
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
                    // StreamBuilder<bool?>(
                    //   initialData: true,
                    //   stream: Get.find<FirebaseNetworkService>()
                    //       .databaseConnectionStream,
                    //   builder: (context, snapshot) {
                    //     final appTheme = AppTheme.of(context);
                    //     return SafeArea(
                    //       child: AnimatedContainer(
                    //         height: snapshot.data as bool
                    //             ? 0
                    //             : appTheme.getHeight(36),
                    //         duration: Utils.animationDuration,
                    //         color: appTheme.redColor,
                    //         child: Material(
                    //           type: MaterialType.transparency,
                    //           child: Center(
                    //               child: Text(AppString.noInternetConnection,
                    //                   style: appTheme.customTextStyle(
                    //                     fontSize: 16.sp,
                    //                     color: appTheme.whiteColor,
                    //                   ))),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
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
