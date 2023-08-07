
import 'package:divine_astrologer/screens/blocked_user/blocked_user_bindings.dart';
import 'package:divine_astrologer/screens/chat_message/chat_message_binding.dart';
import 'package:divine_astrologer/screens/chat_message/chat_message_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_binding.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/earning/earning_bindings.dart';
import 'package:divine_astrologer/screens/home_screen_options/earning/earning_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail.binding.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_bindings.dart';
import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_ui.dart';
import 'package:divine_astrologer/screens/side_menu/donation/donation_ui.dart';
import 'package:get/get.dart';
import '../screens/bank_details/bank_detail_binding.dart';
import '../screens/bank_details/bank_details_ui.dart';
import '../screens/blocked_user/blocked_user_ui.dart';
import '../screens/dashboard/dashboard_bindings.dart';
import '../screens/dashboard/dashboard_ui.dart';
import '../screens/edit_profile/edit_profile_ui.dart';
import '../screens/edit_profile/edit_profile_binding.dart';
import '../screens/number_change/number_change_binding.dart';
import '../screens/number_change/number_change_ui.dart';
import '../screens/order_history/order_history_ui.dart';
import '../screens/order_history/order_history_binding.dart';
import '../screens/price_change/price_change_binding.dart';
import '../screens/price_change/price_change_ui.dart';
import '../screens/price_history/price_history_binding.dart';
import '../screens/price_history/price_history_ui.dart';
<<<<<<< HEAD
import '../screens/side_menu/donation/donation_binding.dart';
import '../screens/side_menu/donation_detail/donation_detail_ui.dart';
=======
import '../screens/rank_system/rank_system_binding.dart';
import '../screens/rank_system/rank_system_ui.dart';
>>>>>>> yashdev
import '../screens/splash/splash_binding.dart';
import '../screens/splash/splash_ui.dart';

class RouteName {
  static const initial = dashboard;

  static const String root = "/";
  static const String dashboard = "/dashboard";
  static const String blockedUser = "/blockedUser";
  static const String editProfileUI = "/editProfileUI";
  static const String orderHistory = "/orderHistory";
  static const String referAstrologer = "/referAstrologer";
  static const String yourEarning = "/yourEarning";
  static const String priceHistoryUI = "/priceHistoryUI";
  static const String priceChangeReqUI = "/priceChangeReqUI";
  static const String numberChangeReqUI = "/numberChangeReqUI";
  static const String bankDetailsUI = "/bankDetailsUI";
  static const String checkKundli = "/checkKundli";
  static const String rankSystemUI = "/rankSystemUI";
<<<<<<< HEAD
  static const String kundliDetail = "/kundliDetail";
  static const String donationUi = "/donationUi";
  static const String donationDetailPage = "/donationDetailPage";
=======
  static const String chatMessageUI = "/chatMessageUI";
>>>>>>> yashdev
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
        page: () => const OrderHistoryUI(),
        name: RouteName.orderHistory,
        binding: OrderHistoryBinding()),
    GetPage(
        page: () => const ReferAnAstrologer(),
        name: RouteName.referAstrologer,
        binding: ReferAstrologerBinding()),
    GetPage(
        page: () => const YourEarning(),
        name: RouteName.yourEarning,
        binding: YourEarningBinding()),
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
    GetPage(
        page: () => const KundliUi(),
        name: RouteName.checkKundli,
        binding: KundliBinding()),
    GetPage(
        page: () => const RankSystemUI(),
        name: RouteName.rankSystemUI,
        binding: RankSystemBinding()),
    GetPage(

        page: () => const KundliDetailUi(),
        name: RouteName.kundliDetail,
        binding: KundliDetailBinding()),
    GetPage(
        page: () => const DonationUi(),
        name: RouteName.donationUi,
        binding: DonationBinding()),
    GetPage(
        page: () => const DonationDetailUi(),
        name: RouteName.donationDetailPage,
        binding: DonationBinding()),
   GetPage(
        page: () => const ChatMessageUI(),
        name: RouteName.chatMessageUI,
        binding: ChatMessageBinding()),

  ];
}
