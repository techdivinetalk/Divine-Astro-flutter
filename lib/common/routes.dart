import 'package:divine_astrologer/pages/wallet/wallet_binding.dart';
import 'package:divine_astrologer/pages/wallet/wallet_ui.dart';
import 'package:divine_astrologer/screens/auth/login/login_binding.dart';
import 'package:divine_astrologer/screens/auth/login/login_ui.dart';
import 'package:divine_astrologer/screens/blocked_user/blocked_user_bindings.dart';
import 'package:divine_astrologer/screens/chat_message/chat_message_binding.dart';
import 'package:divine_astrologer/screens/chat_message/chat_message_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/notice_board/notice_board_bindings.dart';
import 'package:divine_astrologer/screens/home_screen_options/notice_board/notice_board_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/notice_board_detail/notice_detail_ui.dart';
import 'package:divine_astrologer/screens/live_tips/live_tips_binding.dart';
import 'package:divine_astrologer/screens/live_tips/live_tips_ui.dart';
import 'package:divine_astrologer/screens/side_menu/settings/settings_ui.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/final_sub_remedy/final_remedies_sub_binding.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/final_sub_remedy/final_remedies_sub_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_binding.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/earning/earning_bindings.dart';
import 'package:divine_astrologer/screens/home_screen_options/earning/earning_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail.binding.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_bindings.dart';
import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_ui.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/category_detail/category_detail_binding.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/category_detail/category_detail_ui.dart';
import 'package:divine_astrologer/screens/side_menu/donation/donation_ui.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/suggest_remedies_sub/suggest_remedies_sub_binding.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/suggest_remedies_sub/suggest_remedies_sub_ui.dart';
import 'package:get/get.dart';
import '../screens/bank_details/bank_detail_binding.dart';
import '../screens/bank_details/bank_details_ui.dart';
import '../screens/blocked_user/blocked_user_ui.dart';
import '../screens/chat_message/widgets/image_preview.dart';
import '../screens/dashboard/dashboard_bindings.dart';
import '../screens/dashboard/dashboard_ui.dart';
import '../screens/edit_profile/edit_profile_ui.dart';
import '../screens/edit_profile/edit_profile_binding.dart';
import '../screens/home_screen_options/notice_board_detail/notice_detail_bindings.dart';
import '../screens/number_change/number_change_binding.dart';
import '../screens/number_change/number_change_ui.dart';
import '../screens/order_history/all_tab/suggest_remedies_view.dart';
import '../screens/order_history/order_history_ui.dart';
import '../screens/order_history/order_history_binding.dart';
import '../screens/price_change/price_change_binding.dart';
import '../screens/price_change/price_change_ui.dart';
import '../screens/price_history/price_history_binding.dart';
import '../screens/price_history/price_history_ui.dart';
import '../screens/profile_options/upload_story/upload_story_ui.dart';
import '../screens/profile_options/upload_your_photos/upload_your_photos.dart';
import '../screens/side_menu/donation/donation_binding.dart';
import '../screens/side_menu/donation_detail/donation_detail_ui.dart';
import '../screens/rank_system/rank_system_binding.dart';
import '../screens/rank_system/rank_system_ui.dart';
import '../screens/side_menu/important_numbers/important_numbers_binding.dart';
import '../screens/side_menu/important_numbers/important_numbers_ui.dart';
import '../screens/side_menu/settings/settings_binding.dart';
import '../screens/side_menu/wait_list/wait_list_binding.dart';
import '../screens/side_menu/wait_list/wait_list_ui.dart';
import '../screens/splash/splash_binding.dart';
import '../screens/splash/splash_ui.dart';

class RouteName {
  static const initial = root;

  static const String root = "/";
  static const String login = "/login";
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
  static const String kundliDetail = "/kundliDetail";
  static const String donationUi = "/donationUi";
  static const String donationDetailPage = "/donationDetailPage";
  static const String chatMessageUI = "/chatMessageUI";
  static const String suggestRemediesSubUI = "/suggestRemediesSubUI";
  static const String finalRemediesSubUI = "/finalRemediesSubUI";
  static const String categoryDetail = "/categoryDetail";
  static const String noticeBoard = "/noticeBoard";
  static const String noticeDetail = "/noticeDetail";
  static const String importantNumbers = "/importantNumbers";
  static const String waitList = "/waitList";
  static const String settingsUI = "/settingsUI";
  static const String liveTipsUI = "/liveTipsUI";
  static const String suggestRemediesView = "/suggestRemediesView";
  static const String uploadYourPhotosUi = "/uploadYourPhotosUi";
  static const String uploadStoryUi = "/uploadStoryUi";
  static const String imagePreviewUi = "/imagePreviewUi";
  static const String walletScreenUI = "/walletScreenUI";
}

class Routes {
  static final routes = <GetPage>[
    GetPage(
        page: () => const SplashUI(),
        name: RouteName.root,
        binding: SplashBinding()),
    GetPage(
      page: () => LoginUI(),
      name: RouteName.login,
      binding: LoginBinding(),
    ),
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
    GetPage(
        page: () => const SuggestRemediesView(),
        name: RouteName.suggestRemediesView),
    GetPage(
        page: () => const SuggestRemediesSubUI(),
        name: RouteName.suggestRemediesSubUI,
        binding: SuggestRemediesSubBinding()),
    GetPage(
        page: () => const FinalRemediesSubUI(),
        name: RouteName.finalRemediesSubUI,
        binding: FinalRemediesSubBinding()),
    GetPage(
        page: () => const CategoryDetailUi(),
        name: RouteName.categoryDetail,
        binding: CategoryDetailBinding()),
    GetPage(
        page: () => const NoticeBoardUi(),
        name: RouteName.noticeBoard,
        binding: NoticeBoardBinding()),
    GetPage(
        page: () => const NoticeDetailUi(),
        name: RouteName.noticeDetail,
        binding: NoticeDetailBinding()),
    GetPage(
        page: () => const ImportantNumbersUI(),
        name: RouteName.importantNumbers,
        binding: ImportantNumbersBinding()),
    GetPage(
        page: () => const WaitListUI(),
        name: RouteName.waitList,
        binding: WaitListBinding()),
    GetPage(
        page: () => const SettingsUI(),
        name: RouteName.settingsUI,
        binding: SettingsBinding()),
    GetPage(
        page: () => const LiveTipsUI(),
        name: RouteName.liveTipsUI,
        binding: LiveTipsBinding()),
    GetPage(
        page: () => const UploadYourPhotosUi(),
        name: RouteName.uploadYourPhotosUi),
    GetPage(page: () => const UploadStoryUi(), name: RouteName.uploadStoryUi),
    GetPage(
      page: () => const ImagePreviewUi(),
      name: RouteName.imagePreviewUi,
    ),
    GetPage(
        page: () => const WalletUI(),
        name: RouteName.walletScreenUI,
        binding: WalletBinding()),
  ];
}
