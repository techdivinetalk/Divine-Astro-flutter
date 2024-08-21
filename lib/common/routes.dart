import 'package:divine_astrologer/common/accept_chat_request_screen.dart';
import 'package:divine_astrologer/model/add_custom_product/add_custom_product_binding.dart';
import 'package:divine_astrologer/model/add_custom_product/add_custom_product_view.dart';
import 'package:divine_astrologer/model/custom_product/custom_product__list_binding.dart';
import 'package:divine_astrologer/pages/profile/profile_binding.dart';
import 'package:divine_astrologer/pages/profile/profile_ui.dart';
import 'package:divine_astrologer/pages/wallet/wallet_binding.dart';
import 'package:divine_astrologer/pages/wallet/wallet_ui.dart';
import 'package:divine_astrologer/screens/add_puja/add_puja_binding.dart';
import 'package:divine_astrologer/screens/add_puja/add_puja_form.dart';
import 'package:divine_astrologer/screens/all_fine_details/all_fine_detail_list.dart';
import 'package:divine_astrologer/screens/all_fine_details/all_fine_details_binding.dart';
import 'package:divine_astrologer/screens/auth/login/login_binding.dart';
import 'package:divine_astrologer/screens/auth/login/login_ui.dart';
import 'package:divine_astrologer/screens/blocked_user/blocked_user_bindings.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_message/widgets/product/sub_product/sub_product_ui.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/chat_message_with_socket_binding.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/chat_message_with_socket_ui.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/remedy_view/remedies_detail_binding.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/remedy_view/renedies_detail_view.dart';
import 'package:divine_astrologer/screens/chat_remedies/chat_suggest_remedies.dart';
import 'package:divine_astrologer/screens/chat_remedies/chat_suggest_remedies_binding.dart';
import 'package:divine_astrologer/screens/chat_remedies_details/chat_suggest_remedies_details.dart';
import 'package:divine_astrologer/screens/chat_remedies_details/chat_suggets_remedies_detail_binding.dart';
import 'package:divine_astrologer/screens/faq/faqs_binding.dart';
import 'package:divine_astrologer/screens/faq/faqs_ui.dart';
import 'package:divine_astrologer/screens/financial_support/financial_support_screen.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_binding.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/discount_offers/discount_offers.dart';
import 'package:divine_astrologer/screens/home_screen_options/earning/earning_bindings.dart';
import 'package:divine_astrologer/screens/home_screen_options/earning/earning_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail.binding.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/notice_board/notice_board_bindings.dart';
import 'package:divine_astrologer/screens/home_screen_options/notice_board/notice_board_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/notice_board_detail/notice_detail_ui.dart';
import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_bindings.dart';
import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_ui.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_binding.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart';
import 'package:divine_astrologer/screens/live_logs/live_logs_binding.dart';
import 'package:divine_astrologer/screens/live_logs/live_logs_ui.dart';
import 'package:divine_astrologer/screens/live_tips/live_tips_binding.dart';
import 'package:divine_astrologer/screens/live_tips/live_tips_ui.dart';
import 'package:divine_astrologer/screens/message_template/message_template_bindings.dart';
import 'package:divine_astrologer/screens/message_template/message_template_ui.dart';
import 'package:divine_astrologer/screens/number_change/sub_screen/otp_screen_for_update_mobile_number.dart';
import 'package:divine_astrologer/screens/order_chat_call_feedback/feedback.dart';
import 'package:divine_astrologer/screens/order_chat_call_feedback/feedback_binding.dart';
import 'package:divine_astrologer/screens/order_feedback/order_feedback_binding.dart';
import 'package:divine_astrologer/screens/order_feedback/order_feedback_ui.dart';
import 'package:divine_astrologer/screens/otp_verification/otp_verification_binding.dart';
import 'package:divine_astrologer/screens/otp_verification/otp_verification_ui.dart';
import 'package:divine_astrologer/screens/passbook/passbook_binding.dart';
import 'package:divine_astrologer/screens/passbook/passbook_screen.dart';
import 'package:divine_astrologer/screens/puja/puja_binding.dart';
import 'package:divine_astrologer/screens/puja/puja_view.dart';
import 'package:divine_astrologer/screens/remedies/binding/add_remedies_binding.dart';
import 'package:divine_astrologer/screens/remedies/binding/remedies_binding.dart';
import 'package:divine_astrologer/screens/remedies/screen/add_remedies_screen.dart';
import 'package:divine_astrologer/screens/remedies/screen/remedies_screen.dart';
import 'package:divine_astrologer/screens/side_menu/donation/donation_ui.dart';
import 'package:divine_astrologer/screens/side_menu/settings/inner_pages/privacy_policy_ui.dart';
import 'package:divine_astrologer/screens/side_menu/settings/inner_pages/terms_condition_ui.dart';
import 'package:divine_astrologer/screens/side_menu/settings/settings_ui.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/category_detail/category_detail_binding.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/category_detail/category_detail_ui.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/final_sub_remedy/final_remedies_sub_binding.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/final_sub_remedy/final_remedies_sub_ui.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/suggest_remedies_sub/suggest_remedies_sub_binding.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/suggest_remedies_sub/suggest_remedies_sub_ui.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/suggested_remedies/suggested_ramedies_screen.dart';
import 'package:divine_astrologer/screens/support/chat_support/chat_support_binding.dart';
import 'package:divine_astrologer/screens/support/chat_support/chat_support_screen.dart';
import 'package:divine_astrologer/screens/support/help_support/help_support_binding.dart';
import 'package:divine_astrologer/screens/support/help_support/widgets/problem_answer_screen.dart';
import 'package:divine_astrologer/screens/support/help_support/widgets/problem_questions_screen.dart';
import 'package:divine_astrologer/screens/support/support_binding.dart';
import 'package:divine_astrologer/screens/support/support_screen.dart';
import 'package:divine_astrologer/screens/support_issue/support_all_issues/all_support_issues_screen.dart';
import 'package:divine_astrologer/screens/support_issue/support_issue_screen.dart';
import 'package:divine_astrologer/screens/terms_and_condition/terms_and_condition_binding.dart';
import 'package:divine_astrologer/screens/terms_and_condition/terms_and_condition_screen.dart';
import 'package:get/get.dart';

import '../model/custom_product/custom_product_list_view.dart';
import '../pages/home/passbook/passbook_ui.dart';
import '../screens/add_message_template/add_message_template_binding.dart';
import '../screens/add_message_template/add_message_template_ui.dart';
import '../screens/bank_details/bank_detail_binding.dart';
import '../screens/bank_details/bank_details_ui.dart';
import '../screens/blocked_user/blocked_user_ui.dart';
import '../screens/chat_assistance/chat_message/chat_assistant_message_binding.dart';
import '../screens/chat_assistance/chat_message/chat_assistant_message_ui.dart';
import '../screens/chat_assistance/chat_message/widgets/image_preview.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_binding.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_ui.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/widgets/address_flow/add_update/address_add_update_binding.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/widgets/address_flow/add_update/address_add_update_screen.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/widgets/address_flow/view/address_view_binding.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/widgets/address_flow/view/address_view_screen.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/widgets/details/pooja_dharam_details_binding.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/widgets/details/pooja_dharam_details_screen.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/widgets/summary/pooja_dharam_summary_binding.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/widgets/summary/pooja_dharam_summary_screen.dart';
import '../screens/chat_assistance/chat_message/widgets/product/sub_product/sub_product_binding.dart';
import '../screens/chat_assistance/chat_message/widgets/product/suggest_product_binding.dart';
import '../screens/chat_assistance/chat_message/widgets/product/suggest_products.dart';
import '../screens/chat_assistance/chat_message/widgets/remedy/chatAssistSuggestBindingRemedy.dart';
import '../screens/chat_assistance/chat_message/widgets/remedy/chatAssistSuggestRemedies/chatAssistSuggestRemediesDetail.dart';
import '../screens/chat_assistance/chat_message/widgets/remedy/chatAssistSuggestRemedies/chatAssistSuggestRemediesDetailBinding.dart';
import '../screens/chat_assistance/chat_message/widgets/remedy/chatAssistSuggestRemedy.dart';
import '../screens/dashboard/dashboard_bindings.dart';
import '../screens/dashboard/dashboard_ui.dart';
import '../screens/edit_profile/edit_profile_binding.dart';
import '../screens/edit_profile/edit_profile_ui.dart';
import '../screens/financial_support/financial_all_issues/all_financial_issues_screen.dart';
import '../screens/financial_support/financial_support_binding.dart';
import '../screens/home_screen_options/discount_offers/discount_offers_bindings.dart';
import '../screens/home_screen_options/notice_board_detail/notice_detail_bindings.dart';
import '../screens/leave_and_resignation/leave_and_resignation.dart';
import '../screens/number_change/number_change_binding.dart';
import '../screens/number_change/number_change_ui.dart';
import '../screens/order_history/order_history_binding.dart';
import '../screens/order_history/order_history_ui.dart';
import '../screens/price_change/price_change_binding.dart';
import '../screens/price_change/price_change_ui.dart';
import '../screens/price_history/price_history_binding.dart';
import '../screens/price_history/price_history_ui.dart';
import '../screens/profile_options/upload_story/upload_story_ui.dart';
import '../screens/profile_options/upload_your_photos/upload_your_photos.dart';
import '../screens/rank_system/rank_system_binding.dart';
import '../screens/rank_system/rank_system_ui.dart';
import '../screens/side_menu/donation/donation_binding.dart';
import '../screens/side_menu/donation_detail/donation_detail_ui.dart';
import '../screens/side_menu/important_numbers/important_numbers_binding.dart';
import '../screens/side_menu/important_numbers/important_numbers_ui.dart';
import '../screens/side_menu/settings/settings_binding.dart';
import '../screens/side_menu/testing/testing_binding.dart';
import '../screens/side_menu/testing/testing_ui.dart';
import '../screens/side_menu/wait_list/wait_list_binding.dart';
import '../screens/side_menu/wait_list/wait_list_ui.dart';
import '../screens/splash/splash_binding.dart';
import '../screens/splash/splash_ui.dart';
import '../screens/support/help_support/help_support_screen.dart';
import '../screens/support_issue/support_issue_binding.dart';
import '../screens/technical_issue/issue_binding.dart';
import '../screens/technical_issue/issue_screen.dart';
import '../screens/technical_issue/issues_screen/all_isssue_screen.dart';

class RouteName {
  static const initial = root;

  static const String root = "/";
  static const String login = "/login";
  static const String otpVerificationPage = "/otpVerificationPage";
  static const String dashboard = "/dashboard";
  static const String resignation = "/resignation";
  static const String blockedUser = "/blockedUser";
  static const String profileUi = "/profileUi";
  static const String poojaDharamMainScreen = "/poojaDharamMainScreen";
  static const String poojaDharamDetailsScreen = "/poojaDharamDetailsScreen";
  static const String poojaDharamSummaryScreen = "/poojaDharamSummaryScreen";
  static const String addressViewScreen = "/addressViewScreen";
  static const String addressAddUpdateScreen = "/addressAddUpdateScreen";
  static const String editProfileUI = "/editProfileUI";
  static const String orderHistory = "/orderHistory";
  static const String messageTemplate = "/messageTemplate";
  static const String addMessageTemplate = "/addMessageTemplate";
  static const String referAstrologer = "/referAstrologer";
  static const String yourEarning = "/yourEarning";
  static const String wallet = "/walletPage";
  static const String priceHistoryUI = "/priceHistoryUI";
  static const String priceChangeReqUI = "/priceChangeReqUI";
  static const String homePageUI = "/homePageUI";
  static const String numberChangeReqUI = "/numberChangeReqUI";
  static const String bankDetailsUI = "/bankDetailsUI";
  static const String checkKundli = "/checkKundli";
  static const String rankSystemUI = "/rankSystemUI";
  static const String kundliDetail = "/kundliDetail";
  static const String discountOffers = "/discountOffers";
  static const String donationUi = "/donationUi";
  static const String donationDetailPage = "/donationDetailPage";
  static const String chatMessageUI = "/chatMessageUI";
  static const String chatMessageWithSocketUI = "/chatMessageWithSocketUI";
  static const String suggestRemediesSubUI = "/suggestRemediesSubUI";
  static const String finalRemediesSubUI = "/finalRemediesSubUI";
  static const String categoryDetail = "/categoryDetail";
  static const String noticeBoard = "/noticeBoard";
  static const String noticeDetail = "/noticeDetail";
  static const String importantNumbers = "/importantNumbers";
  static const String chatAssistProductPage = "/chatAssistProductPage";
  static const String chatAssistProductSubPage = "/chatAssistProductSubPage";
  static const String waitList = "/waitList";
  static const String settingsUI = "/settingsUI";
  static const String liveTipsUI = "/liveTipsUI";
  static const String suggestRemediesView = "/suggestRemediesView";
  static const String uploadYourPhotosUi = "/uploadYourPhotosUi";
  static const String uploadStoryUi = "/uploadStoryUi";
  static const String imagePreviewUi = "/imagePreviewUi";
  static const String walletScreenUI = "/walletScreenUI";
  static const String privacyPolicy = "/privacyPolicy";
  static const String remedies = "/remedies";
  static const String addRemedies = "/addRemedies";
  static const String termsCondition = "/termsCondition";
  static const String videoCallPage = "/videoCallPage";
  static const String videoCall = "/videoCall";
  static const String numberChangeOtpScreen = "/numberChangeOtpScreen";
  static const String orderFeedback = "/orderFeedback";
  static const String chatSuggestRemedy = "/chatSuggestRemedy";
  static const String chatAssistSuggestRemedy = "/chatAssistSuggestRemedy";
  static const String chatAssistSuggestRemedyDetails =
      "/chatAssistSuggestRemedyDetails";
  static const String chatSuggestRemedyDetails = "/chatSuggestRemedyDetails";
  static const String feedback = "/feedback";
  static const String fineAllDetails = "/fineAllDetails";
  static const String liveDharamScreen = "/liveDharamScreen";
  static const String faq = "/faqPage";
  static const String puja = "/puja";
  static const String addPuja = "/addPujaScreen";
  static const String remediesDetail = "/RemediesDetailsView";
  static const String acceptChatRequestScreen = "/AcceptChatRequestScreen";
  static const String liveLogsScreen = "/LiveLogsScreen";
  static const String supportScreen = "/SupportScreen";
  static const String helpSupportScreen = "/HelpSupportScreen";
  static const String supportQuestionScreen = "/SupportQuestionScreen";
  static const String supportAnswerScreen = "/SupportAnswerScreen";
  static const String chatSupportScreen = "/ChatSupportScreen";
  static const String technicalIssues = "/technicalIssues";
  static const String financialSupport = "/financialSupport";
  static const String newSupportScreen = "/newSupportScreen";
  static const String testingScreen = "/testingScreen";
  static const String allTechnicalIssues = "/AllTechnicalIssues";
  static const String allFinancialSupportIssues = "/allFinancialSupportIssues";
  static const String allSupportIssuesScreen = "/allSupportIssuesScreen";
  static const String termsAndConditionScreen = "/TermsAndConditionScreen";
  static const String addCustomProduct = "/addCustomProduct";
  static const String customProduct = "/customProduct";
  static const String passbook = "/passbook";
  static const String passbookUI = "/passbookUI";
}

final Set<String> validRoutes = {
  RouteName.chatMessageUI,
  RouteName.faq,
  RouteName.puja,
  RouteName.passbook,
  RouteName.customProduct,
  RouteName.addPuja,
  RouteName.remedies,
  RouteName.addRemedies,
  RouteName.addCustomProduct,
  RouteName.remediesDetail,
  RouteName.acceptChatRequestScreen,
};

class Routes {
  static final routes = <GetPage>[
    GetPage(
      page: () => const SplashUI(),
      name: RouteName.root,
      binding: SplashBinding(),
    ),
    GetPage(
      page: () => LoginUI(),
      name: RouteName.login,
      binding: LoginBinding(),
    ),
    GetPage(
      page: () => const OtpVerificationUI(),
      name: RouteName.otpVerificationPage,
      binding: OtpVerificationBinding(),
    ),
    GetPage(
        page: () => const AcceptChatRequestScreen(),
        name: RouteName.acceptChatRequestScreen),
    GetPage(
        page: () => const DashboardScreen(),
        name: RouteName.dashboard,
        binding: DashboardBinding()),
    GetPage(
        page: () => const CustomProductListView(),
        name: RouteName.customProduct,
        binding: CustomProductListBinding()),
    GetPage(
        page: () => const PassbookScreen(),
        name: RouteName.passbook,
        binding: PassbookBinding()),
    GetPage(
        page: () => AddCustomProductView(),
        name: RouteName.addCustomProduct,
        binding: AddCustomProductBinding()),
    GetPage(
      page: () => const leaveAndResignationTab(),
      name: RouteName.resignation,
      // binding: RegistrationBinding()
    ),
    GetPage(
        page: () => SupportScreen(),
        name: RouteName.supportScreen,
        binding: SupportBinding()),
    GetPage(
        page: () => HelpSupportScreen(),
        name: RouteName.helpSupportScreen,
        binding: HelpSupportBinding()),
    GetPage(
      page: () => ProblemQuestionsScreen(),
      name: RouteName.supportQuestionScreen,
      binding: HelpSupportBinding(),
    ),
    GetPage(
      page: () => ProblemAnswersScreen(),
      name: RouteName.supportAnswerScreen,
      binding: ProblemAnswerBinding(),
    ),
    GetPage(
      page: () => ChatSupportScreen(),
      name: RouteName.chatSupportScreen,
      binding: ChatSupportBinding(),
    ),
    GetPage(
      page: () => TechnicalIssueScreen(),
      name: RouteName.technicalIssues,
      binding: TechnicalBinding(),
    ),
    GetPage(
      page: () => FinancialSupportScreen(),
      name: RouteName.financialSupport,
      binding: FinancialSupportBinding(),
    ),
    GetPage(
      page: () => SupportIssueScreen(),
      name: RouteName.newSupportScreen,
      binding: SupportIssueBinding(),
    ),
    GetPage(
      page: () => TestingUI(),
      name: RouteName.testingScreen,
      binding: TestingBinding(),
    ),
    GetPage(
      page: () => PassbookUi(),
      name: RouteName.passbookUI,
      binding: PassbookBinding(),
    ),
    GetPage(
      page: () => AllTechnicalIssueScreen(),
      name: RouteName.allTechnicalIssues,
      binding: TechnicalIssuesBinding(),
    ),
    GetPage(
      page: () => AllFinancialIssuesScreen(),
      name: RouteName.allFinancialSupportIssues,
      binding: AllFinancialIssuesBinding(),
    ),
    GetPage(
      page: () => AllSupportIssuesScreen(),
      name: RouteName.allSupportIssuesScreen,
      binding: AllSupportIssuesBinding(),
    ),
    GetPage(
        page: () => const BlockedUserUI(),
        name: RouteName.blockedUser,
        binding: BlockedUserBinding()),
    GetPage(
        page: () => ProfileUI(),
        name: RouteName.profileUi,
        binding: ProfileBinding()),
    GetPage(
      name: RouteName.poojaDharamMainScreen,
      page: () => const PoojaDharamMainScreen(),
      binding: PoojaDharamMainBinding(),
    ),

    GetPage<dynamic>(
      name: RouteName.poojaDharamDetailsScreen,
      page: PoojaDharamDetailsScreen.new,
      binding: PoojaDharamDetailsBinding(),
    ),

    GetPage<dynamic>(
      name: RouteName.poojaDharamSummaryScreen,
      page: PoojaDharamSummaryScreen.new,
      binding: PoojaDharamSummaryBinding(),
    ),
    /*// GetPage(
    //     name: RouteName.editProfileUI, page: () => const EditProfileUI(),
    // ),*/
    GetPage(
        page: () => const EditProfileUI(),
        name: RouteName.editProfileUI,
        binding: EditProfileBinding()),
    GetPage(
        page: () => const OrderHistoryUI(),
        name: RouteName.orderHistory,
        binding: OrderHistoryBinding()),
    GetPage(
        page: () => const MessageTemplateUI(),
        name: RouteName.messageTemplate,
        binding: MessageTemplateBinding()),
    GetPage(
        page: () => const AddMessageTemplateUI(),
        name: RouteName.addMessageTemplate,
        binding: AddMessageTemplateBinding()),
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
        page: () => const DiscountOfferUI(),
        name: RouteName.discountOffers,
        binding: DiscountOfferBindings()),
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
        page: () => const ChatMessageSupportUI(),
        name: RouteName.chatMessageUI,
        binding: ChatMessageBinding()),
    GetPage(
        page: () => ChatMessageWithSocketUI(),
        name: RouteName.chatMessageWithSocketUI,
        binding: ChatMessageWithSocketBinding()),
    GetPage(
        page: () => SuggestedRemediesScreen(),
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
      page: () => WalletPage(),
      name: RouteName.wallet,
      binding: WalletBinding(),
    ),
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
      page: () => PrivacyPolicyUI(),
      name: RouteName.privacyPolicy,
    ),
    GetPage(
      page: () => const RemediesScreen(),
      name: RouteName.remedies,
      binding: RemediesBindings(),
      // name: RouteName.remedies,
    ),
    GetPage(
      page: () => AddRemedies(),
      name: RouteName.addRemedies,  // GetPage(
      //   page: () => const VideoCallPage(),
      //   name: RouteName.videoCallPage,
      //   binding: VideoCallPageBinding(),
      // ),
      binding: AddRemediesBindings(),
      // name: RouteName.remedies,
    ),
    GetPage(
      page: () => TermsConditionUI(),
      name: RouteName.termsCondition,
    ),

    GetPage(
        name: RouteName.chatAssistProductPage,
        page: () => const SuggestProducts(),
        binding: SuggestProductBinding()),
    GetPage(
        name: RouteName.chatAssistProductSubPage,
        page: () => const SubProductUi(),
        binding: SubProductBinding()),
    // GetPage(
    //   page: () => const VideoCall(),
    //   name: RouteName.videoCall,
    //   binding: VideoCallBinding(),
    // ),
    GetPage(
      page: () => const OtpVerificationForNumberChange(),
      name: RouteName.numberChangeOtpScreen,
    ),
    GetPage(
        page: () => const OrderFeedbackUI(),
        name: RouteName.orderFeedback,
        binding: OrderFeedbackBinding()),
    GetPage(
        page: () => const ChatSuggestRemedyPage(),
        name: RouteName.chatSuggestRemedy,
        binding: ChatSuggestRemediesBinding()),
    GetPage(
        page: () => const ChatAssistSuggestRemedyPage(),
        name: RouteName.chatAssistSuggestRemedy,
        binding: ChatAssistSuggestRemediesBinding()),
    GetPage(
        page: () => const ChatAssistSuggestRemediesDetailsPage(),
        name: RouteName.chatAssistSuggestRemedyDetails,
        binding: ChatAssistSuggestRemediesDetailsBinding()),
    GetPage(
        page: () => const ChatSuggestRemediesDetailsPage(),
        name: RouteName.chatSuggestRemedyDetails,
        binding: ChatSuggestRemediesDetailsBinding()),

    GetPage(
        page: () => const FeedBack(),
        name: RouteName.feedback,
        binding: FeedbackBinding()),

    GetPage(
        page: () => const AllFineDetailsList(),
        name: RouteName.fineAllDetails,
        binding: AllFineDetailsBindings()),
    GetPage<dynamic>(
      name: RouteName.liveDharamScreen,
      page: LiveDharamScreen.new,
      binding: LiveDharamBinding(),
    ),
    GetPage(
      page: () => const FAQsUI(),
      name: RouteName.faq,
      binding: FAQsBindings(),
    ),
    GetPage(
      page: () => const PujaScreen(),
      name: RouteName.puja,
      binding: PujaBindings(),
    ),
    GetPage(
      page: () => const AddPujaScreen(),
      name: RouteName.addPuja,
      binding: AddPujaBindings(),
    ),
    GetPage(
      page: () => const RemediesDetailPage(),
      name: RouteName.remediesDetail,
      binding: RemediesDetailBinding(),
    ),

    GetPage<dynamic>(
      name: RouteName.addressViewScreen,
      page: AddressViewScreen.new,
      binding: AddressViewBinding(),
    ),

    GetPage<dynamic>(
      name: RouteName.addressAddUpdateScreen,
      page: AddressAddUpdateScreen.new,
      binding: AddressAddUpdateBinding(),
    ),
    GetPage<dynamic>(
      name: RouteName.liveLogsScreen,
      page: LiveLogsUI.new,
      binding: LiveLogsBinding(),
    ),

    GetPage(
      page: () => TermsAndConditionScreen(),
      name: RouteName.termsAndConditionScreen,
      binding: TermsAndConditionBinding(),
    ),
  ];
}
