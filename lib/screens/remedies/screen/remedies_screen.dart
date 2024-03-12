import 'package:divine_astrologer/common/SvgIconButton.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/puja/model/pooja_listing_model.dart';
import 'package:divine_astrologer/screens/puja/widget/pooja_delete_bottom_sheet.dart';
import 'package:divine_astrologer/tarotCard/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/remedies_controller.dart';
import '../model/remedies_model.dart';

class RemediesScreen extends GetView<RemediesController> {
  const RemediesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RemediesController>(
      assignId: true,
      init: RemediesController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: appColors.white,
              surfaceTintColor: appColors.white,
              leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              title: const CustomText('Remedies')),
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
                        arguments: {
                          'edit': false,
                          'id': idToPass,
                        },
                      );
                    },
                    child: Text(
                      'Add New Remedies',
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
          body: controller.isRemdiesLoading
              ? const GenericLoadingWidget()
              : controller.noRemediesFound.isNotEmpty
              ? Text(
            controller.noRemediesFound,
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w600,
                fontColor: appColors.textColor),
          )
              : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            // controller: controller.orderScrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: controller.remdiesData.length,
            itemBuilder: (context, index) {
              Remedy data = controller.remdiesData[index];
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
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      height: 65,
                      width: 65,
                      imagePath:controller.pref.getAmazonUrl()! + data.image!,
                      radius: BorderRadius.circular(10),
                      placeHolder:
                      "assets/images/default_profiles.svg",
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            data.name ?? "",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontColor: appColors.guideColor,
                          ),
                          CustomText(
                            "${ "0"}",
                            fontSize: 14.sp,
                          ),
                          SizedBox(
                            width: 100,
                            child: CustomText(
                              data.content ?? "",
                              fontSize: 12.sp,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            data.isApprove != 0
                                ? SvgIconButton(
                              height: 22.h,
                              width: 20.w,
                              svg:
                              Assets.svg.deleteAccout.svg(),
                              onPressed: () {
                                Get.bottomSheet(
                                    PoojaDeleteBottomSheet(
                                      pujaData: data,
                                      onTap: () {
                                        // controller.deletePujaApi(
                                        //     deleteId:
                                        //     data.id.toString());
                                      },
                                    )).then((value) {
                                  if (value == 1) {
                                    // controller.getPujaList();
                                  }
                                });
                              },
                            )
                                : SizedBox(height: 50.h),
                            data.isApprove == 0
                                ? SvgIconButton(
                              height: 22.h,
                              width: 20.w,
                              svg: Assets.svg.icPoojaAddress
                                  .svg(),
                              onPressed: () {
                                Get.toNamed(
                                  RouteName.addPuja,
                                  arguments: {
                                    'edit': true,
                                    'pujaData': data,
                                  },
                                );
                              },
                            )
                                : SizedBox(
                              height: 50.h,
                            ),
                          ],
                        ),
                        IntrinsicWidth(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: getStatusColor(
                                      data.isApprove ?? 0),
                                  width: 1.0),
                              borderRadius:
                              BorderRadius.circular(22.0),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  getStatus(data.isApprove ?? 0),
                                  style: AppTextStyle.textStyle9(
                                    fontWeight: FontWeight.w500,
                                    fontColor: getStatusColor(
                                        data.isApprove ?? 0),
                                  ),
                                ),
                              ],
                            ).paddingSymmetric(
                                horizontal: 9, vertical: 6),
                          ),
                        )
                      ],
                    )*/
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) =>
            const SizedBox(height: 15),
          ),
        );
      },
    );
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return appColors.initiateColor;
      case 2:
        return appColors.pendingColor;
      case 1:
        return appColors.completeColor;
      default:
        return Colors.black;
    }
  }

  String getStatus(int status) {
    switch (status) {
      case 0:
        return "Under Review";
      case 2:
        return "Rejected";
      case 1:
        return "Approved";
      default:
        return "";
    }
  }
}
