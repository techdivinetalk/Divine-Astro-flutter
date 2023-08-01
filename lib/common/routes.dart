import 'package:divine_astrologer/screens/profile/profile_binding.dart';
import 'package:divine_astrologer/screens/profile/profile_ui.dart';
import 'package:get/get.dart';

import '../screens/splash/splash_binding.dart';
import '../screens/splash/splash_ui.dart';

class RouteName {
  static const initial = profilePage;

  static const String root = "/";
  static const String profilePage = "/profilePage";
}

class Routes {
  static final routes = <GetPage>[
    GetPage(
        page: () => const SplashUI(),
        name: RouteName.root,
        binding: SplashBinding()),
    GetPage(
        page: () => const ProfileUI(),
        name: RouteName.profilePage,
        binding: ProfileBinding()),
  ];
}
