import 'package:divine_astrologer/screens/pages/bank_details/bank_detail_binding.dart';
import 'package:divine_astrologer/screens/pages/bank_details/bank_details_ui.dart';
import 'package:divine_astrologer/screens/pages/blocked_user/blockedUser_bindings.dart';
import 'package:divine_astrologer/screens/pages/blocked_user/blockedUser_UI.dart';
import 'package:divine_astrologer/screens/pages/dashboard/dashboard_ui.dart';
import 'package:divine_astrologer/screens/pages/edit_profile/editProfile_binding.dart';
import 'package:divine_astrologer/screens/pages/number_change/number_change_binding.dart';
import 'package:divine_astrologer/screens/pages/number_change/number_change_ui.dart';
import 'package:divine_astrologer/screens/pages/price_change/price_change_binding.dart';
import 'package:divine_astrologer/screens/pages/price_change/price_change_ui.dart';

import 'package:get/get.dart';

import '../screens/pages/dashboard/dashboard_bindings.dart';
import '../screens/pages/edit_profile/editProfile_UI.dart';
import '../screens/pages/price_history/price_history_binding.dart';
import '../screens/pages/price_history/price_history_ui.dart';
import '../screens/splash/splash_binding.dart';
import '../screens/splash/splash_ui.dart';

class RouteName {
  static const initial = dashboard;

  static const String root = "/";
  static const String dashboard = "/dashboard";
  static const String blockedUser = "/blockedUser";
  static const String editProfileUI = "/editProfileUI";
  static const String priceHistoryUI = "/priceHistoryUI";
  static const String priceChangeReqUI = "/priceChangeReqUI";
  static const String numberChangeReqUI = "/numberChangeReqUI";
  static const String bankDetailsUI = "/bankDetailsUI";
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
    GetPage(
        page: () => const PriceHistoryUI(),
        name: RouteName.priceHistoryUI,
        binding: PriceHistoryBinding()),
    GetPage(
        page: () => const PriceChangeReqUI(),
        name: RouteName.priceChangeReqUI,
        binding: PriceChangeReqBinding()),
    GetPage(
        page: () => const NumberChangeReqUI(),
        name: RouteName.numberChangeReqUI,
        binding: NumberChangeReqBinding()),
    GetPage(
        page: () => const BankDetailsUI(),
        name: RouteName.bankDetailsUI,
        binding: BankDetailBinding()),
  ];
}
