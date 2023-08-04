// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/appbar.dart';
import '../../common/colors.dart';
import '../../common/common_options_row.dart';
import '../../common/strings.dart';
import '../../gen/assets.gen.dart';
import '../side_menu/side_menu_ui.dart';
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
            title: AppString.orderHistory,
            trailingWidget: InkWell(
              child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Assets.images.icOrderHistory.svg()),
            )),
        body: Container(
          color: AppColors.white,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
                          item,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w400,
                              fontColor: AppColors.darkBlue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))
                .toList(),
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
            value: controller.selectedValue.value,
            onChanged: (String? value) {
              controller.selectedValue.value = value ?? "Daily";
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
              offset: const Offset(-8, -17),
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
    scrollController = ScrollController(initialScrollOffset: 23);
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
              unselectedLabelStyle:
                  AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
              tabs: [
                "  ${AppString.all}  ",
                AppString.chat,
                AppString.call,
                AppString.liveGifts,
                AppString.remedysuggested
              ].map((e) => Tab(text: e)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabbarController,
              children: [
                OrderInfo(controller: scrollController),
                OrderInfo(controller: scrollController),
                OrderInfo(controller: scrollController),
                OrderInfo(controller: scrollController),
                OrderInfo(controller: scrollController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderInfo extends StatelessWidget {
  const OrderInfo({Key? key, this.controller}) : super(key: key);

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 7,
      padding: EdgeInsets.only(top: 30),
      itemBuilder: (context, index) {
        Widget separator = const SizedBox(height: 20);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 2)
              orderDetailView(
                  orderId: 785421,
                  type: "PENALTY",
                  amount: "- ₹100000",
                  details:
                      "Policy Violation - Shared Personal Information with User  ",
                  time: "23 June 23, 02:46 PM"),
            if (index % 2 == 0 && index != 2)
              orderDetailView(
                  orderId: 785421,
                  type: "CHAT",
                  amount: "+ ₹100000",
                  details: "with Username(user id) for 8 minutes ",
                  time: "23 June 23, 02:46 PM"),
            if (index % 2 == 1)
              orderDetailView(
                  orderId: 785421,
                  type: "CALL",
                  amount: "- ₹100000",
                  details:
                      "Policy Violation - Shared Personal Information with User  ",
                  time: "23 June 23, 02:46 PM"),
            separator,
          ],
        );
      },
    );
  }

  Widget orderDetailView(
      {required int orderId,
      required String? type,
      required String? amount,
      required String? details,
      required String? time}) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 3.0,
                  offset: const Offset(0.3, 3.0)),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order Id : $orderId",
                  style: AppTextStyle.textStyle12(fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.help_outline,
                  size: 20,
                  color: AppColors.darkBlue.withOpacity(0.5),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$type",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: "$type" == "PENALTY"
                          ? AppColors.appRedColour
                          : AppColors.darkBlue),
                ),
                Text(
                  "$amount",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: amount!.contains("+")
                          ? AppColors.lightGreen
                          : AppColors.appRedColour),
                )
              ],
            ),
            Text(
              "$details ",
              textAlign: TextAlign.start,
              style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                  fontColor: AppColors.darkBlue.withOpacity(0.5)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "$time",
                  textAlign: TextAlign.end,
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: AppColors.darkBlue.withOpacity(0.5)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CommonOptionRow(
              leftBtnTitle: AppString.refund,
              onLeftTap: () {},
              onRightTap: () {},
              rightBtnTitle: AppString.suggestedRemediesEarning,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
