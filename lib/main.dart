import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'common/routes.dart';
import 'common/app_theme.dart';
import 'common/custom_progress_dialog.dart';
import 'common/strings.dart';
import 'di/network_service.dart';
import 'di/progress_service.dart';
import 'di/shared_preference_service.dart';
import 'localization/translations.dart';
import 'utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => ProgressService().init());
  await Get.putAsync(() => SharedPreferenceService().init());
  await Get.putAsync(() => NetworkService().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      child: ScreenUtilInit(
          //designSize: Size(Get.width, Get.height),
          builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RouteName.initial,
          getPages: Routes.routes,
          locale: AppTranslations.locale,
          fallbackLocale: AppTranslations.fallbackLocale,
          translations: AppTranslations(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          builder: (context, widget) {
            return Stack(
              children: <Widget>[
                Obx(() => IgnorePointer(
                    ignoring: Get.find<ProgressService>().showProgress.value,
                    child: widget)),
                StreamBuilder<bool?>(
                  initialData: true,
                  stream: Get.find<NetworkService>().internetConnectionStream,
                  builder: (context, snapshot) {
                    final appTheme = AppTheme.of(context);
                    return SafeArea(
                      child: AnimatedContainer(
                        height:
                            snapshot.data as bool ? 0 : appTheme.getHeight(100),
                        duration: Utils.animationDuration,
                        color: appTheme.redColor,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Center(
                              child: Text(AppString.noInternetConnection,
                                  style: appTheme.customTextStyle(
                                    fontSize: 40,
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
