import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/model/home_model/astrologer_live_log_response.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import 'live_logs_controller.dart';

class LiveLogsUI extends GetView<LiveLogsController> {
  const LiveLogsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: appColors.white,
        title: Text("liveLogs".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: appColors.darkBlue,
            )),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 50.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Container(
                  width: double.infinity,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: appColors.greyColor3,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: appColors.greyColor2,
                      width: 1.5.h,
                    ),
                  ),
                  child: Text(
                    "liveDate".tr,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle15(
                      fontColor: appColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  width: double.infinity,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: appColors.greyColor3,
                    border: Border.all(
                      color: appColors.greyColor2,
                      width: 1.5.h,
                    ),
                  ),
                  child: Text(
                    "totalLiveTime".tr,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle15(
                      fontColor: appColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  width: double.infinity,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: appColors.greyColor3,
                    border: Border.all(
                      color: appColors.greyColor2,
                      width: 1.5.h,
                    ),
                  ),
                  child: Text(
                    "liveStartTime".tr,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle15(
                      fontColor: appColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  width: double.infinity,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: appColors.greyColor3,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: appColors.greyColor2,
                      width: 1.5.h,
                    ),
                  ),
                  child: Text(
                    "liveEndTime".tr,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle15(
                      fontColor: appColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
              ],
            ),
          ),
          Expanded(
              child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollEndNotification &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    controller.astrologerLiveLog();
                  }
                  return true;
                },
                child: Obx(
                  () {
                    return controller.liveLogsLst.isEmpty
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              "noAnyDataFound".tr,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: appColors.grey,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: controller.liveLogsLst.length,
                            itemBuilder: (context, index) {
                              LiveLogModel model =
                                  controller.liveLogsLst[index];

                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                height: 50.h,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      width: double.infinity,
                                      alignment: AlignmentDirectional.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular((index ==
                                                  controller
                                                          .liveLogsLst.length -
                                                      1)
                                              ? 8
                                              : 0),
                                        ),
                                        border: Border.all(
                                          color: appColors.greyColor2,
                                          width: 1.5.h,
                                        ),
                                      ),
                                      child: Text(
                                        controller.convertUtcToLocal(
                                            model.createdAt!, 'dd-MM-yy'),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.textStyle14(
                                          fontColor: appColors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      width: double.infinity,
                                      alignment: AlignmentDirectional.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: appColors.greyColor2,
                                          width: 1.5.h,
                                        ),
                                      ),
                                      child: Text(
                                        controller
                                            .convertDurationToFormattedMinutes(
                                                model.hours),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.textStyle14(
                                          fontColor: appColors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      width: double.infinity,
                                      alignment: AlignmentDirectional.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: appColors.greyColor2,
                                          width: 1.5.h,
                                        ),
                                      ),
                                      child: Text(
                                        controller.convertFormat(
                                            model.checkIn, "hh:mm aa"),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.textStyle14(
                                          fontColor: appColors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      width: double.infinity,
                                      alignment: AlignmentDirectional.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular((index ==
                                                  controller
                                                          .liveLogsLst.length -
                                                      1)
                                              ? 8
                                              : 0),
                                        ),
                                        border: Border.all(
                                          color: appColors.greyColor2,
                                          width: 1.5.h,
                                        ),
                                      ),
                                      child: Text(
                                        controller.convertFormat(
                                            model.checkOut, "hh:mm aa"),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.textStyle14(
                                          fontColor: appColors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.loading.value == Loading.loading,
                  child: const GenericLoadingWidget(),
                );
              }),
            ],
          )),
        ],
      ),
    );
  }
}
