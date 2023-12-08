import 'package:divine_astrologer/model/waiting_list_queue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        backgroundColor: AppColors.white,
        title: Text("waitlist".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: AppColors.darkBlue,
            )),
      ),
      body: GetBuilder<WaitListUIController>(builder: (controller) {
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
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "nextInLine".tr,
                    style:
                        AppTextStyle.textStyle20(fontColor: AppColors.darkBlue),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  waitingListTile(
                      controller.waitingPersons[0].getCustomers!,
                      controller.waitingPersons[0].waitTime ?? 0,
                      controller.waitingPersons[0]),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: const Divider(),
                  ),
                  Text(
                    "waitingQueue".tr,
                    style:
                        AppTextStyle.textStyle20(fontColor: AppColors.darkBlue),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ListView.builder(
                    itemCount: controller.waitingPersons.length - 1,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      WaitingPerson person =
                          controller.waitingPersons[index + 1];
                      return waitingListTile(
                          person.getCustomers!, person.waitTime ?? 0, person);
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
      GetCustomers waitingCustomer, int waitTime, WaitingPerson person) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          CachedNetworkPhoto(
            url:
                "${controller.preference.getBaseImageURL()}/${waitingCustomer.avatar ?? ""}",height: 50,width: 50,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              waitingCustomer.name ?? "",
              style: AppTextStyle.textStyle16(fontColor: AppColors.darkBlue),
            ),
          ),
          Row(
            children: [
              ImageBasedOnResponse(customer: person),
              SizedBox(
                width: 8.w,
              ),
              Text(
                "$waitTime minutes",
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              ),
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

  final WaitingPerson customer;
  @override
  Widget build(BuildContext context) {
    if (customer.callType == 1) {
      return Assets.images.icChating.svg();
    }
    if (customer.callType == 2) {
      return Assets.svg.icCall1.svg();
    }
    return const SizedBox.shrink();
  }
}
