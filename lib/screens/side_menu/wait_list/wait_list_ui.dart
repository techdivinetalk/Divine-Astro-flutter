import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/waiting_list_queue.dart';
import 'package:divine_astrologer/repository/waiting_list_queue_repository.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/cached_network_image.dart';
import '../../../common/colors.dart';

import '../../../gen/assets.gen.dart';
import '../../../utils/enum.dart';
import 'wait_list_controller.dart';

class WaitListUI extends GetView<WaitListUIController> {
  const WaitListUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: appColors.white,
        title: Text("waitlist".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: appColors.darkBlue,
            )),
      ),
      body: GetBuilder<WaitListUIController>(
          init: WaitListUIController(WaitingListQueueRepo()),
          assignId: true,
          builder: (controller) {
            if (controller.loading == Loading.loading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(Colors.yellow),
                ),
              );
            } else if (controller.waitingPersons.isEmpty) {
              return Center(
                child: Text("jobTitle".tr),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "nextInLine".tr,
                        style: AppTextStyle.textStyle20(
                            fontColor: appColors.darkBlue),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      waitingListTile(
                          controller.waitingPersons[0].getCustomers!,
                          controller.waitingPersons[0].waitTime ?? 0,
                          controller.waitingPersons[0],
                          controller: controller),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const Divider(),
                      ),
                      Text(
                        "waitingQueue".tr,
                        style: AppTextStyle.textStyle20(
                            fontColor: appColors.darkBlue),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      ListView.builder(
                        itemCount: controller.waitingPersons.length - 1,
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          WaitingListQueueData person =
                              controller.waitingPersons[index + 1];
                          return waitingListTile(person.getCustomers!,
                              person.waitTime ?? 0, person,
                              controller: controller);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget waitingListTile(
      GetCustomers waitingCustomer, int waitTime, WaitingListQueueData person,
      {WaitListUIController? controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          CachedNetworkPhoto(
            url:
                "${controller!.preference.getBaseImageURL()!}/${waitingCustomer.avatar ?? ""}",
            height: 50,
            width: 50,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              waitingCustomer.name ?? "",
              style: AppTextStyle.textStyle16(fontColor: appColors.darkBlue),
            ),
          ),
          InkWell(
            onTap: () async {
              if (chatSwitch.value == false &&
                  callSwitch.value == false &&
                  videoSwitch.value == false) {
                controller.acceptChatButtonApi(
                    queueId: person.id.toString(), orderId: person.orderId);
              } else {
                Fluttertoast.showToast(
                  msg: "Please turn off all session types.",
                );
              }
            },
            child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: appColors.guideColor,
                ),
                child: Text(
                  "Accept",
                  style: TextStyle(fontSize: 13, color: appColors.black),
                )),
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              ImageBasedOnResponse(customer: person),
              SizedBox(
                width: 8.w,
              ),
              // Text(
              //   "$waitTime minutes",
              //   style: AppTextStyle.textStyle16(
              //       fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageBasedOnResponse extends StatelessWidget {
  const ImageBasedOnResponse({Key? key, required this.customer})
      : super(key: key);

  final WaitingListQueueData customer;

  @override
  Widget build(BuildContext context) {
    if (customer.isCall == 1) {
      return Assets.images.icChating.svg();
    }
    if (customer.isCall == 2) {
      return Assets.svg.icCall1.svg();
    }
    return const SizedBox.shrink();
  }
}
