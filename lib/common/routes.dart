import 'package:divine_astrologer/screens/pages/blocked_user/BlockedUser_bindings.dart';
import 'package:divine_astrologer/screens/pages/blocked_user/BlockedUser_UI.dart';
import 'package:divine_astrologer/screens/pages/dashboard/dashboard_ui.dart';
import 'package:divine_astrologer/screens/pages/edit_profile/EditProfile_binding.dart';
import 'package:get/get.dart';

import '../screens/pages/dashboard/dashboard_bindings.dart';
import '../screens/pages/edit_profile/EditProfile_UI.dart';
import '../screens/splash/splash_binding.dart';
import '../screens/splash/splash_ui.dart';

class RouteName {
  static const initial = dashboard;

  static const String root = "/";
  static const String dashboard = "/dashboard";
  static const String blockedUser = "/blockedUser";
  static const String editProfileUI = "/editProfileUI";
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
    GetPage(
        page: () => const BlockedUserUI(),
        name: RouteName.blockedUser,
        binding: BlockedUserBinding()),
    GetPage(
        page: () => const EditProfileUI(),
        name: RouteName.editProfileUI,
        binding: EditProfileBinding()),
  ];
}
