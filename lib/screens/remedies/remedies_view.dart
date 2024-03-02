import 'package:cached_network_image/cached_network_image.dart';
import 'package:divine_astrologer/common/SvgIconButton.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/remedies/remedies_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Remedies extends GetView<RemediesController> {
  const Remedies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appColors.white,
          surfaceTintColor: appColors.white,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const CustomText('Pooja')),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: appColors.guideColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  int idToPass = 0;
                  Get.toNamed(
                    RouteName.addRemedies,
                    arguments: {'edit': idToPass != 0, 'id': idToPass},
                  );
                },
                child: Text(
                  'Add New Pooja',
                  style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w600,
                    fontColor: appColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        controller: controller.orderScrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: controller.orderList.value,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 2)
                orderDetailView(
                  onDeletePressed: () {},
                  onEditPressed: () {
                    int idToPass = 1;
                    Get.toNamed(
                      RouteName.addRemedies,
                      arguments: {'edit': idToPass != 1, 'id': idToPass},
                    );
                  },
                  onSelectPressed: () {},
                  orderId: 785421,
                  name: "Gemstone",
                  amount: "₹10000",
                  status: "Under Review",
                  details:
                      "Lorem Ipsum is simply dummy text of the printing and ...",
                ),
              if (index % 2 == 0 && index != 2)
                orderDetailView(
                  onDeletePressed: () {},
                  onEditPressed: () {
                    int idToPass = 1;
                    Get.toNamed(
                      RouteName.addRemedies,
                      arguments: {'edit': idToPass != 1, 'id': idToPass},
                    );
                  },
                  onSelectPressed: () {},
                  orderId: 785421,
                  name: "Shani Dev Puja",
                  amount: "₹10000",
                  status: "approved",
                  details:
                      "Lorem Ipsum is simply dummy text of the printing and ...",
                ),
              if (index % 2 == 1)
                orderDetailView(
                  onDeletePressed: () {},
                  onEditPressed: () {},
                  onSelectPressed: () {},
                  showDeleteSelectButton: false,
                  orderId: 785421,
                  name: "Gemstone",
                  amount: "₹1000",
                  status: "rejected",
                  details:
                      "Lorem Ipsum is simply dummy text of the printing and ...",
                ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 15),
      ),
    );
  }

  Widget orderDetailView({
    required int orderId,
    required String? name,
    required String? amount,
    required String? details,
    required String? status,
    required Function() onDeletePressed,
    required Function() onSelectPressed,
    required Function() onEditPressed,
    bool showDeleteSelectButton = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appColors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 3.0,
                offset: const Offset(0.3, 3.0)),
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 65,
              width: 65,
              child: CachedNetworkImage(
                imageUrl: "",
                errorWidget: (context, s, d) =>
                    Assets.images.defaultProfiles.svg(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                name!,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontColor: appColors.guideColor,
              ),
              CustomText(
                amount!,
                fontSize: 14.sp,
              ),
              SizedBox(
                width: 100,
                child: CustomText(
                  details!,
                  fontSize: 12.sp,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  showDeleteSelectButton != false
                      ? SvgIconButton(
                          height: 22.h,
                          width: 20.w,
                          svg: Assets.svg.deleteAccout.svg(),
                          onPressed: onDeletePressed)
                      : SizedBox(
                          height: 50.h,
                        ),
                  showDeleteSelectButton != false
                      ? SvgIconButton(
                          height: 22.h,
                          width: 20.w,
                          svg: Assets.svg.icPoojaAddress.svg(),
                          onPressed: onEditPressed)
                      : SizedBox(
                          height: 50.h,
                        ),
                ],
              ),
              IntrinsicWidth(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: getStatusColor("$status"), width: 1.0),
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$status",
                        style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w500,
                          fontColor: getStatusColor("$status"),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 9, vertical: 6),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'Under Review':
        return appColors.initiateColor;
      case 'rejected':
        return appColors.pendingColor;
      case 'approved':
        return appColors.completeColor;
      default:
        return Colors.black;
    }
  }
}
