import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../../common/appbar.dart';
import '../../../../../../../../common/colors.dart';
import '../../../../../../../../common/common_functions.dart';
import '../../../../../../../../common/custom_widgets.dart';
import '../../../../../../../../common/routes.dart';
import '../../../../../../../../di/shared_preference_service.dart';
import '../../../../../../../../gen/assets.gen.dart';
import '../../../../../../../live_dharam/widgets/custom_image_widget.dart';
import '../../pooja_dharam/get_pooja_addones_response.dart';
import '../../pooja_dharam/get_single_pooja_response.dart';
import '../../pooja_dharam/get_user_address_response.dart';
import '../custom_widget/insufficient_funds_widget.dart';
import '../custom_widget/pooja_custom_button.dart';
import '../custom_widget/thank_you_widget.dart';
import 'pooja_dharam_summary_controller.dart';

class PoojaDharamSummaryScreen extends StatefulWidget {
  const PoojaDharamSummaryScreen({super.key});

  @override
  State<PoojaDharamSummaryScreen> createState() =>
      _PoojaDharamSummaryScreenState();
}

class _PoojaDharamSummaryScreenState extends State<PoojaDharamSummaryScreen>
    with AfterLayoutMixin<PoojaDharamSummaryScreen>, TickerProviderStateMixin {
  final PoojaDharamSummaryController _controller = Get.find();
  final SharedPreferenceService pref = Get.put(SharedPreferenceService());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        title: "Pooja",
        trailingWidget:Row(children: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Assets.images.icSearch.svg(
                colorFilter: ColorFilter.mode(
                  appColors.textColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          CustomButton(
            onTap: () async {
              await Get.toNamed(RouteName.wallet);
            },
            radius: 10.r,
            border: Border.all(color: appColors.textColor),
            child: CustomText('₹${walletBalance.value}'),
          ),
          const SizedBox(width: 16),
        ],),
      ),
      body: SafeArea(
        child: Obx(card),
      ),
    );
  }

  Widget expandedLayout() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  poojaList(),
                  addOnesList(),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Total Amount",
                        style: TextStyle(
                          color: appColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        "${_controller.calculateTotalAmount()}",
                        style: TextStyle(
                          color: appColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 8),
                  Builder(builder: (context) {
                    Pooja pooja = Pooja();
                    pooja = _controller.localSelectedPooja.pooja?[0] ?? Pooja();
                    return pooja.cashbackType == 0 || pooja.cashbackValue == 0
                        ? const SizedBox()
                        : Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            color: const Color(0xff5F3C08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ((pooja.cashbackType ?? 0) == 1)
                                      ? "${pooja.cashbackValue}% Cashback will be added to your wallet."
                                      : ((pooja.cashbackType ?? 0) == 2)
                                          ? "${pooja.cashbackValue}₹ Cashback will be added to your wallet."
                                          : "",
                                  style: TextStyle(
                                    color: appColors.white,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            addressList(),
          ],
        ),
      ),
    );
  }

  Widget stickyButton() {
    return button();
  }

  Widget card() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          expandedLayout(),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          stickyButton(),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget button() {
    return PoojaCustomButton(
      height: 64,
      text: "Proceed to Pay - ${_controller.calculateTotalAmount()}",
      backgroundColor: appColors.guideColor,
      fontColor: appColors.black,
      needCircularBorder: false,
      onPressed: () async {
        await _controller.checkWalletRechargeForBookingPooja(
          needRecharge: (value) {},
          successCallBack: (message) async {
            divineSnackBar(data: message);
            await thankYouWidgetPopup(
              callback: () {
                Get.until(
                  (route) {
                    return Get.currentRoute == RouteName.poojaDharamMainScreen;
                  },
                );
              },
            );
          },
          failureCallBack: (message) async {
            divineSnackBar(data: message);
            await insufficientFundsWidgetPopup();
          },
        );
      },
    );
  }

  Widget poojaList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext buildContext, int index) {
          final GetSinglePoojaResponseData item =
              _controller.localSelectedPooja;
          final startPoint = pref.getAmazonUrl() ?? "";
          final endPoint = item.pooja?[0].poojaImg ?? "";
          final String poojaImg = "$startPoint$endPoint";
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CustomImageWidget(
                  imageUrl: poojaImg,
                  rounded: false,
                  typeEnum: TypeEnum.pooja,
                ),
              ),
              title: Text(
                item.pooja?[0].poojaName ?? "",
                style: TextStyle(color: appColors.black, fontSize: 12),
              ),
              trailing: Text(
                "₹${item.pooja?[0].poojaStartingPriceInr ?? ""}",
                style: TextStyle(
                  color: appColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget addOnesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _controller.localSelectedAddOnesList.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext buildContext, int index) {
          final GetPoojaAddOnesResponseData item =
              _controller.localSelectedAddOnesList[index];
          final startPoint = pref.getAmazonUrl() ?? "";
          final endPoint = item.images ?? "";
          final String poojaImg = "$startPoint$endPoint";
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CustomImageWidget(
                  imageUrl: poojaImg,
                  rounded: false,
                  typeEnum: TypeEnum.pooja,
                ),
              ),
              title: Text(
                item.name ?? "",
                style: TextStyle(color: appColors.black, fontSize: 12),
              ),
              trailing: Text(
                "₹${item.amount ?? ""}",
                style: TextStyle(
                  color: appColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget addressList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 1,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final Addresses address = _controller.localSelectedAddress;

        final String addressTitle = address.addressTitle ?? "";
        final String flat = address.flatNo ?? "";
        final String local = address.locality ?? "";
        final String land = address.landmark ?? "";
        final String city = address.city ?? "";
        final String state = address.state ?? "";
        final String pin = (address.pincode ?? "").toString();
        final String addressFull = "$flat, $local, $land, $city, $state, $pin";
        final phoneNo = address.phoneNo ?? "";
        final alternatePhoneNo = address.alternatePhoneNo ?? "";

        String phoneFull = "";
        if (phoneNo != "" && alternatePhoneNo != "") {
          phoneFull = "$phoneNo, $alternatePhoneNo";
        } else if (phoneNo != "" && alternatePhoneNo == "") {
          phoneFull = "$phoneNo";
        } else if (phoneNo == "" && alternatePhoneNo != "") {
          phoneFull = "$alternatePhoneNo";
        } else if (phoneNo == "" && alternatePhoneNo == "") {
          phoneFull = "-";
        } else {
          phoneFull = "-";
        }
        return Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            side: BorderSide(
              color: appColors.guideColor,
              width: 1.0,
            ),
          ),
          child: InkWell(
            onTap: () async {
              await Get.toNamed(RouteName.addressViewScreen);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          addressTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () async {
                          await Get.toNamed(RouteName.addressViewScreen);
                        },
                        icon: Image.asset(
                          "assets/images/address_new_edit.png",
                          height: 16,
                          width: 16,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/address_new_location.png",
                        height: 16,
                        width: 16,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          addressFull,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/address_new_phone.png",
                        height: 16,
                        width: 16,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          phoneFull,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> thankYouWidgetPopup({required Function() callback}) async {
    bool isNavigated = false;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ThankYouWidget(
          onClose: () async {
            Get.back();
            isNavigated = false;
            callback();
          },
          openOrderHistory: () async {
            Get.back();
            isNavigated = true;
            await Get.toNamed(RouteName.orderHistory);
            callback();
          },
        );
      },
    );
    if (isNavigated) {
    } else {
      callback();
    }
    return Future<void>.value();
  }

  Future<void> insufficientFundsWidgetPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return InsufficientFundsWidget(
          onClose: Get.back,
          amount: "${_controller.calculateTotalAmount()}",
          openRechargeNow: () async {
            Get.back();
            await Get.toNamed(RouteName.wallet);
          },
        );
      },
    );
    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    return Future<void>.value();
  }
}
