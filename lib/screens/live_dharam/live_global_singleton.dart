import 'package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LiveGlobalSingleton {
  static final LiveGlobalSingleton _singleton = LiveGlobalSingleton._internal();

  factory LiveGlobalSingleton() {
    return _singleton;
  }

  LiveGlobalSingleton._internal();

  final RxBool _isInLiveScreen = false.obs;

  bool get isInLiveScreen => _isInLiveScreen.value;
  set isInLiveScreen(bool value) => _isInLiveScreen(value);

  final Rx<BuildContext> _buildContext = Get.context!.obs;

  BuildContext get buildContext => _buildContext.value;
  set buildContext(BuildContext value) => _buildContext(value);

  Future<void> leaveLiveIfIsInLiveScreen() async {
    print(
        "LiveGlobalSingleton:: leaveLiveIfIsInLiveScreen():: isInLiveScreen:: $isInLiveScreen");
    bool canLeave = false;
    if (isInLiveScreen) {
      canLeave = await zegoController.leave(buildContext);
    } else {}
    print(
        "LiveGlobalSingleton:: leaveLiveIfIsInLiveScreen():: canLeave:: $canLeave");
    return Future<void>.value();
  }

  //
  bool isAlreadyInWaitlistPopupOpen = false;
  bool isGiftPopupOpen = false;
  bool isLeaderboardPopupOpen = false;
  bool isWaitListPopupOpen = false;
  bool isDisconnectPopupOpen = false;
  bool isExitWaitListPopupOpen = false;
  bool isRequestPopupOpen = false;
  bool isEndLiveSessionPopupOpen = false;
  bool isLowBalancePopupOpen = false;
  bool isCallAstrologerPopupOpen = false;
  bool isMoreOptionsPopupOpen = false;
  bool isMoreOptionsForModPopupOpen = false;
  bool isBlockUnblockPopupOpen = false;
  bool isWaitingForUserToSelectCardsPopupOpen = false;
  bool isShowCardDeckToUserPopupOpen = false;
  bool isShowCardDeckToUser1PopupOpen = false;
  bool isShowCardDeckToUser2PopupOpen = false;
  bool isYouAreBlockedPopupOpen = false;
  bool isExtendTimeWidgetPopupOpen = false;
  bool isHostingAndCoHostingPopupOpen = false;
  bool isShowAllAvailAstroPopupOpen = false;
  bool isFollowPopupOpen = false;
  bool isCannotSpendMoneyPopupOpen = false;
  bool isShopPopupOpen = false;
  bool isKeyboardPopupOpen = false;
  //

  int getCountOfOpenDialogs() {
    final List<dynamic> temp = <dynamic>[];

    if (isAlreadyInWaitlistPopupOpen) {
      temp.add(true);
    } else {}

    if (isGiftPopupOpen) {
      temp.add(true);
    } else {}

    if (isLeaderboardPopupOpen) {
      temp.add(true);
    } else {}

    if (isWaitListPopupOpen) {
      temp.add(true);
    } else {}

    if (isDisconnectPopupOpen) {
      temp.add(true);
    } else {}

    if (isExitWaitListPopupOpen) {
      temp.add(true);
    } else {}

    if (isRequestPopupOpen) {
      temp.add(true);
    } else {}

    if (isEndLiveSessionPopupOpen) {
      temp.add(true);
    } else {}

    if (isLowBalancePopupOpen) {
      temp.add(true);
    } else {}

    if (isCallAstrologerPopupOpen) {
      temp.add(true);
    } else {}

    if (isMoreOptionsPopupOpen) {
      temp.add(true);
    } else {}

    if (isMoreOptionsForModPopupOpen) {
      temp.add(true);
    } else {}

    if (isBlockUnblockPopupOpen) {
      temp.add(true);
    } else {}

    if (isWaitingForUserToSelectCardsPopupOpen) {
      temp.add(true);
    } else {}

    if (isShowCardDeckToUserPopupOpen) {
      temp.add(true);
    } else {}

    if (isShowCardDeckToUser1PopupOpen) {
      temp.add(true);
    } else {}

    if (isShowCardDeckToUser2PopupOpen) {
      temp.add(true);
    } else {}

    if (isYouAreBlockedPopupOpen) {
      temp.add(true);
    } else {}

    if (isExtendTimeWidgetPopupOpen) {
      temp.add(true);
    } else {}

    if (isHostingAndCoHostingPopupOpen) {
      temp.add(true);
    } else {}

    if (isShowAllAvailAstroPopupOpen) {
      temp.add(true);
    } else {}

    if (isFollowPopupOpen) {
      temp.add(true);
    } else {}

    if (isCannotSpendMoneyPopupOpen) {
      temp.add(true);
    } else {}

    if (isShopPopupOpen) {
      temp.add(true);
    } else {}

    if (isKeyboardPopupOpen) {
      temp.add(true);
    } else {}

    return temp.length;
  }
}
