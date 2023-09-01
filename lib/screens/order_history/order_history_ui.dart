// ignore_for_file: prefer_const_constructors

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
import 'Widget/call_order_history_ui..dart';
import 'Widget/chat_order_history_ui..dart';
import 'Widget/suggest_remedies_history.dart';
import 'all_tab/all_option_ui.dart';
import 'order_history_controller.dart';

class OrderHistoryUI extends GetView<OrderHistoryController> {
  const OrderHistoryUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        drawer: const SideMenuDrawer(),
        appBar: commonDetailAppbar(
            title: "orderHistory".tr,
            trailingWidget: InkWell(
              child: Padding(
                  padding: EdgeInsets.only(right: 20.w), child: Assets.images.icOrderHistory.svg()),
            )),
        body: Container(
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3.0,
                          offset: const Offset(0.0, 3.0)),
                    ],
                    color: AppColors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: durationOptions(),
              ),
              const SizedBox(height: 20),
              OrderTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget durationOptions() {
    return Obx(() => DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              "June - 2023 ",
              style: AppTextStyle.textStyle16(
                  fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
            ),
            items: controller.durationOptions
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          item.tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))
                .toList(),
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
            value: controller.selectedValue.value,
            onChanged: (String? value) {
              controller.selectedValue.value = value ?? "daily".tr;
            },
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down,
              ),
              iconSize: 35,
              iconEnabledColor: AppColors.blackColor,
            ),
            dropdownStyleData: DropdownStyleData(
              width: ScreenUtil().screenWidth * 0.88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.white,
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
  const OrderTab({Key? key}) : super(key: key);

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
    controller.tabbarController = TabController(length: 5, vsync: this);
    scrollController = ScrollController();
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
              controller: controller.tabbarController,
              labelColor: AppColors.blackColor,
              unselectedLabelColor: AppColors.blackColor,
              labelStyle: AppTextStyle.textStyle16(fontWeight: FontWeight.w700),
              onTap: (index) {
                debugPrint("$index");
                //  (index) => onSelection(enumValue[index])
              },
              indicatorColor: AppColors.blackColor,
              indicatorWeight: 4,
              dividerColor: AppColors.blackColor,
              unselectedLabelStyle: AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
              tabs: [
                ("all".tr),
                "chat".tr,
                "call".tr,
                "liveGifts".tr,
                ("remedySuggested".tr),
              ].map((e) => Tab(text: e)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabbarController,
              children: [
                AllTabInfo(), //done
                ChatOrderHistory(), //done
                CallOrderHistory(), //done
                LiveGiftsHistory(),
                SuggestRemedies(), //done
              ],
            ),
          ),
        ],
      ),
    );
  }
}
