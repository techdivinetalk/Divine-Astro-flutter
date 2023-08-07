import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/colors.dart';
import '../../common/common_bottomsheet.dart';

class HomeController extends GetxController {
  RxBool chatSwitch = false.obs;
  RxBool callSwitch = false.obs;
  RxBool consultantOfferSwitch = false.obs;
  RxBool promotionOfferSwitch = false.obs;
  RxString appbarTitle = "Astrologer Name  ".obs;
  RxBool isShowTitle = true.obs;
  ExpandedTileController? expandedTileController = ExpandedTileController();
  ExpandedTileController? expandedTile2Controller = ExpandedTileController();

  earningDetailPopup(BuildContext context) async {
    await openBottomSheet(context,
        functionalityWidget: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Actual Payment:",
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.appRedColour),
                  ),
                  Text(
                    "₹1000000000",
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.appRedColour),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            ExpandedTile(
              theme: const ExpandedTileThemeData(
                headerPadding: EdgeInsets.only(left: 8.0, right: 0.0),
                contentPadding: EdgeInsets.only(left: 25.0, right: 25.0),
                contentBackgroundColor: AppColors.white,
              ),
              controller: expandedTileController!,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Actual Payment:",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.darkBlue),
                  ),
                  Text(
                    "₹1000000000",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.darkBlue),
                  ),
                ],
              ),
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "-Amount:",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.darkBlue.withOpacity(0.5)),
                      ),
                      Text(
                        "₹1000000000",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "-Last Billing Cycle",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 12.h),
                          Text(
                            "Refund:",
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.darkBlue.withOpacity(0.5)),
                          ),
                        ],
                      ),
                      Text(
                        "₹1000000000",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 12.h),
                            Text(
                              "Supplement:",
                              style: AppTextStyle.textStyle12(
                                  fontWeight: FontWeight.w500,
                                  fontColor:
                                      AppColors.darkBlue.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "₹1000000000",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            ExpandedTile(
                controller: expandedTile2Controller!,
                theme: const ExpandedTileThemeData(
                  headerPadding: EdgeInsets.only(left: 8.0, right: 0.0),
                  contentPadding: EdgeInsets.only(left: 25.0, right: 25.0),
                  contentBackgroundColor: AppColors.white,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Tax:",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                    Text(
                      "₹1000000000",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ],
                ),
                content: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "-TDS:",
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.darkBlue.withOpacity(0.5)),
                          ),
                        ),
                        Text(
                          "₹1000000000",
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.darkBlue.withOpacity(0.5)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "-Payment Gateway:",
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.darkBlue.withOpacity(0.5)),
                          ),
                        ),
                        Text(
                          "₹1000000000",
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.darkBlue.withOpacity(0.5)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Status:",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Text(
                    "to be settled",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.darkBlue),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Time Period",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Text(
                    "16th May 2023 - 23rd May 2023",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.darkBlue),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ));
  }
}
