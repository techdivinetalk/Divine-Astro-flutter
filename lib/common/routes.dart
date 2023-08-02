import 'package:divine_astrologer/screens/pages/dashboard/dashboard_ui.dart';
import 'package:get/get.dart';

import '../screens/pages/dashboard/dashboard_bindings.dart';
import '../screens/splash/splash_binding.dart';
import '../screens/splash/splash_ui.dart';

class RouteName {
  static const initial = dashboard;

  static const String root = "/";
  static const String dashboard = "/dashboard";
}

class Routes {
  static final routes = <GetPage>[
    GetPage(
        page: () => const SplashUI(),
        name: RouteName.root,
        binding: SplashBinding()),
    GetPage(
        page: () => const DashboardScreen(),
        name: RouteName.dashboard,
        binding: DashboardBinding()),
  ];
}
