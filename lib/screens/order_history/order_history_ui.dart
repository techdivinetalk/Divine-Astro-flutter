import 'package:divine_astrologer/common/custom_progress_dialog.dart';
import 'package:divine_astrologer/screens/order_history/Widget/live_gifts_order_history_ui.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/appbar.dart';
import '../../common/colors.dart';
import '../../gen/assets.gen.dart';
import '../side_menu/side_menu_ui.dart';
import 'Widget/all_order_history_ui.dart';
import 'Widget/call_order_history_ui.dart';
import 'Widget/chat_order_history_ui.dart';
import 'Widget/suggest_remedies_history.dart';
import 'order_history_controller.dart';

class OrderHistoryUI extends GetView<OrderHistoryController> {
  const OrderHistoryUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderHistoryController>(
      init: OrderHistoryController(),
      assignId: true,
      builder: (controller) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          child: Scaffold(
            drawer: const SideMenuDrawer(),
            appBar: commonDetailAppbar(
                title: "orderHistory".tr,
                trailingWidget: InkWell(
                  child: Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Assets.images.icOrderHistory.svg()),
                )),
            body: Container(
              color: appColors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// remove filter ui
                  // Container(
                  //   margin: const EdgeInsets.only(left: 20, right: 20),
                  //   padding: EdgeInsets.all(12.h),
                  //   decoration: BoxDecoration(
                  //       boxShadow: [
                  //         BoxShadow(
                  //             color: Colors.black.withOpacity(0.2),
                  //             blurRadius: 3.0,
                  //             offset: const Offset(0.0, 3.0)),
                  //       ],
                  //       color: appColors.white,
                  //       borderRadius: const BorderRadius.all(Radius.circular(20))),
                  //   child: durationOptions(),
                  // ),
                  // const SizedBox(height: 20),
                  OrderTab(initialPage: controller.initialPage),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget durationOptions() {
    return Obx(() => DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              "June - 2023 ",
              style: AppTextStyle.textStyle16(
                  fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
            ),
            items: controller.durationOptions
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          item.tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w400,
                              fontColor: appColors.darkBlue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))
                .toList(),
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
            value: controller.selectedValue.value,
            onChanged: (String? value) {
              controller.selectedValue.value = value ?? "daily".tr;
              // controller.getFilterDate(type: controller.selectedValue.value);
            },
            iconStyleData: IconStyleData(
              icon: const Icon(
                Icons.keyboard_arrow_down,
              ),
              iconSize: 35,
              iconEnabledColor: appColors.blackColor,
            ),
            dropdownStyleData: DropdownStyleData(
              width: ScreenUtil().screenWidth * 0.88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: appColors.white,
              ),
              offset: const Offset(-10, -17),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(false),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ));
  }
}

class OrderTab extends StatefulWidget {
  final int? initialPage;

  const OrderTab({Key? key, this.initialPage}) : super(key: key);

  @override
  State<OrderTab> createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> with TickerProviderStateMixin {
  late final OrderHistoryController controller;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<OrderHistoryController>();
    controller.tabbarController = TabController(
        length: 5, vsync: this, initialIndex: widget.initialPage ?? 0);
    scrollController = ScrollController();
    /*controller.tabbarController!.addListener(() {
      if (controller.tabbarController!.index == 0) {
        controller.getOrderHistory(
            type: 0, page: controller.allPageCount); //wallet
      } else if (controller.tabbarController!.index == 1) {
        controller.getOrderHistory(
            type: 1, page: controller.chatPageCount); //chat
      } else if (controller.tabbarController!.index == 2) {
        controller.getOrderHistory(
            type: 2, page: controller.callPageCount); //call
      } else if (controller.tabbarController!.index == 3) {
        controller.getOrderHistory(
            type: 3,
            page: controller.liveGiftPageCount); // liveGiftPageCount
      } else if (controller.tabbarController!.index == 4) {
        controller.getOrderHistory(
            type: 4, page: controller.remedyPageCount); // shop
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Theme(
            data: ThemeData(useMaterial3: true),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              controller: controller.tabbarController,
              labelColor: appColors.blackColor,
              unselectedLabelColor: appColors.blackColor,
              labelStyle: AppTextStyle.textStyle16(fontWeight: FontWeight.w700),
              onTap: (value) {
                if (value == 0) {
                  controller.getOrderHistory(
                      type: 0, page: controller.allPageCount); //wallet
                } else if (value == 1) {
                  controller.getOrderHistory(
                      type: 1, page: controller.chatPageCount); //chat
                } else if (value == 2) {
                  controller.getOrderHistory(
                      type: 2, page: controller.callPageCount); //call
                } else if (value == 3) {
                  controller.getOrderHistory(
                      type: 3,
                      page: controller.liveGiftPageCount); // liveGiftPageCount
                } else if (value == 4) {
                  controller.getOrderHistory(
                      type: 4, page: controller.remedyPageCount); // shop
                }
              },
              indicatorColor: appColors.blackColor,
              indicatorWeight: 4,
              dividerColor: appColors.blackColor,
              unselectedLabelStyle:
                  AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
              tabs: [
                ("all".tr),
                "call".tr,
                "chat".tr,
                "Gifts".tr,
                ("remedySuggested".tr),
              ].map((e) => Tab(text: e)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller.tabbarController,
              children: [
                Obx(() => (controller.apiCalling.value &&
                    controller.allPageCount == 1)
                    ? const LoadingWidget()
                    : const AllOrderHistoryUi()),
                Obx(() => (controller.apiCalling.value &&
                    controller.callPageCount == 1)
                    ? const LoadingWidget()
                    : const CallOrderHistory()),
                Obx(() => (controller.apiCalling.value &&
                    controller.chatPageCount == 1)
                    ? const LoadingWidget()
                    : const ChatOrderHistory()),
                Obx(() => (controller.apiCalling.value &&
                    controller.liveGiftPageCount == 1)
                    ? const LoadingWidget()
                    :  LiveGiftsHistory()),
                Obx(() => (controller.apiCalling.value &&
                    controller.remedyPageCount == 1)
                    ? const LoadingWidget()
                    :  SuggestRemedies()),
               /* Obx(() => (controller.apiCalling.value &&
                    controller.chatPageCount == 1)
                    ? const LoadingWidget()
                    : const ChatOrderHistory()),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
