import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/add_ons_new_sheet.dart';
import '../../../../../common/appbar.dart';
import '../../../../../common/colors.dart';
import '../../../../../common/generic_loading_widget.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../utils/load_image.dart';
import '../../../../bank_details/widgets.dart';
import 'poojaDetailController.dart';

class PoojaDetailUI extends GetView<PoojaDetailController> {
  const PoojaDetailUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PoojaDetailController>(
        init: PoojaDetailController(),
        builder: (controller) {
          return Obx(
                () => Stack(
              children: [
                Scaffold(
                  appBar: commonDetailAppbar(title: "poojaDetails".tr),
                  body: GetBuilder<PoojaDetailController>(
                      init: PoojaDetailController(),
                      builder: (controller) {
                        return SingleChildScrollView(
                          child: poojaDetailUi(context),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Assets.images.icKalashDetail.image(
                          //         width: double.infinity,
                          //         height: 224.h,
                          //         fit: BoxFit.fill,
                          //       ),
                          //       SizedBox(height: 20.h),
                          //       Text(
                          //         "Icchapurti Group Puja - By Pushpak",
                          //         style:
                          //             AppTextStyle.textStyle20(fontWeight: FontWeight.w500),
                          //       ),
                          //       SizedBox(
                          //         height: 15.h,
                          //       ),
                          //       Row(
                          //         children: [
                          //           Text("₹15000",
                          //               style: AppTextStyle.textStyle20lineThrough()),
                          //           const SizedBox(width: 15),
                          //           Text(
                          //             "₹1500",
                          //             style: AppTextStyle.textStyle20(
                          //               fontWeight: FontWeight.w600,
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             width: 15.w,
                          //           ),
                          //           Container(
                          //             decoration: BoxDecoration(
                          //                 color: appColors.brown,
                          //                 borderRadius: BorderRadius.circular(20)),
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(10.0),
                          //               child: Center(
                          //                 child: Text(
                          //                   "50% Cashback",
                          //                   textAlign: TextAlign.center,
                          //                   style: TextStyle(
                          //                     fontWeight: FontWeight.w600,
                          //                     fontSize: 12.sp,
                          //                     color: appColors.white,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(height: 20.h),
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             "aboutPooja".tr,
                          //             style: AppTextStyle.textStyle16(
                          //               fontWeight: FontWeight.w500,
                          //               fontColor: appColors.appColorDark,
                          //             ),
                          //           ),
                          //           SizedBox(height: 10.h),
                          //           ReadMoreText(
                          //             "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and",
                          //             trimLines: 4,
                          //             colorClickableText: appColors.black,
                          //             trimMode: TrimMode.Line,
                          //             trimCollapsedText: "readMore".tr,
                          //             trimExpandedText: " ${"readMore".tr}",
                          //             moreStyle: TextStyle(
                          //               fontSize: 14.sp,
                          //               fontWeight: FontWeight.w600,
                          //               color: appColors.appColorDark,
                          //             ),
                          //             lessStyle: TextStyle(
                          //               fontSize: 14.sp,
                          //               fontWeight: FontWeight.w600,
                          //               color: appColors.appColorDark,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(height: 10.h),
                          //       GetBuilder<PoojaDetailController>(
                          //         builder: (controller) {
                          //           if (controller.selectedData.isEmpty) {
                          //             return Column(
                          //               mainAxisSize: MainAxisSize.min,
                          //               crossAxisAlignment: CrossAxisAlignment.start,
                          //               children: [
                          //                 Text(
                          //                   "addonsMsg".tr,
                          //                   style: AppTextStyle.textStyle16(
                          //                     fontWeight: FontWeight.w500,
                          //                     fontColor: appColors.appColorDark,
                          //                   ),
                          //                 ),
                          //                 CustomMaterialButton(
                          //                   textColor: appColors.white,
                          //                   onPressed: () {
                          //                     addOnsSheet(context, (value) {});
                          //                   },
                          //                   height: 56.h,
                          //                   color: appColors.green,
                          //                   buttonName: "selectAddOns".tr,
                          //                 )
                          //               ],
                          //             );
                          //           }
                          //           return ListView(
                          //             shrinkWrap: true,
                          //             physics: const NeverScrollableScrollPhysics(),
                          //             padding: EdgeInsets.zero,
                          //             children: controller.selectedData
                          //                 .map<Widget>(
                          //                   (element) => ProductWidget(
                          //                     model: element,
                          //                     key: Key("${element.id}"),
                          //                     onValueChange: (value) {
                          //                       if (value) {
                          //                         controller.addItem(element);
                          //                       } else {
                          //                         controller.removeItem(element);
                          //                       }
                          //                     },
                          //                   ),
                          //                 )
                          //                 .toList()
                          //               ..add(
                          //                 CustomMaterialButton(
                          //                   textColor: appColors.white,
                          //                   onPressed: () {
                          //                     addOnsSheet(context, (value) {});
                          //                   },
                          //                   height: 56.h,
                          //                   color: appColors.green,
                          //                   buttonName: "addMore".tr,
                          //                 ),
                          //               ),
                          //           );
                          //         },
                          //       )
                          //     ],
                          //   ),
                          // ),
                        );
                      }),
                  bottomNavigationBar: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CustomMaterialButton(
                        height: 70.h,
                        radius: 10.r,
                        onPressed: () {
                          addOnsNewSheet(context, (value) {});
                          //  Get.toNamed(RouteName.detailsNeededForPoojaPage);
                        },
                        buttonName: "bookNow".tr,
                      ),
                    ),
                  ),
                ),
                if (controller.isLoading.value) const Scaffold(body: Center(child: GenericLoadingWidget()))
              ],
            ),
          );
        });
  }

  Widget poojaDetailUi(BuildContext context) {
    final data = controller.poojaModuleDetailResponse;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).width,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LoadImage(
                boxFit: BoxFit.cover,
                imageModel: ImageModel(
                    placeHolderPath: Assets.images.icKalashDetail.path,
                    imagePath: data!.poojaDetails!.imageUrl ?? '',
                    loadingIndicator: const SizedBox(
                        child: CircularProgressIndicator(color: Color(0XFFFDD48E), strokeWidth: 2))),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  color: appColors.timeBackgroundColor,
                  child: Row(
                    children: [
                      Text('19 hours left',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: appColors.white,
                              fontFamily: FontFamily.metropolis)),
                      const Spacer(),
                      Text(controller.formatDuration(controller.remainingTime),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: appColors.white,
                              fontFamily: FontFamily.metropolis)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(data.poojaDetails!.name ?? '',
                    style:  TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.metropolis,
                        fontSize: 16,
                        color: appColors.textColor)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(data.poojaDetails!.description ?? '',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: FontFamily.metropolis,
                        fontSize: 14,
                        color: appColors.textColor.withOpacity(0.5))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: appColors.textColor.withOpacity(0.1)),
              ),
              Row(
                children: [
                  SizedBox(
                    height: 48.w,
                    width: 48.w,
                    child: LoadImage(
                      boxFit: BoxFit.cover,
                      imageModel: ImageModel(
                          imagePath: data.poojaDetails!.astrologer!.profileImageUrl ?? '',
                          loadingIndicator: const SizedBox(
                              child: CircularProgressIndicator(color: Color(0XFFFDD48E), strokeWidth: 2))),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(data.poojaDetails!.astrologer!.name ?? '',
                      style:  TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: FontFamily.metropolis,
                          fontSize: 16,
                          color: appColors.textColor))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: appColors.textColor.withOpacity(0.1)),
              ),
              if (data.poojaDetails!.benefits!.isNotEmpty)
                Text("What are the benefits?",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.metropolis,
                        fontSize: 16,
                        color: appColors.textColor)),
              if (data.poojaDetails!.benefits!.isNotEmpty)
                ListView.builder(
                  itemCount: data.poojaDetails!.benefits!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: FontFamily.metropolis,
                              color: appColors.textColor.withOpacity(0.5),
                              fontWeight: FontWeight.w400),
                        ),
                        Expanded(
                          child: Text(
                            data.poojaDetails!.benefits![index],
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: FontFamily.metropolis,
                                color: appColors.textColor.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: appColors.textColor.withOpacity(0.1))),
              if (data.poojaDetails!.process!.steps!.isNotEmpty)
                Text("How will it happen?",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.metropolis,
                        fontSize: 16,
                        color: appColors.textColor)),
              if (data.poojaDetails!.process!.steps!.isNotEmpty)
                ListView.builder(
                  itemCount: data.poojaDetails!.process!.steps!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: FontFamily.metropolis,
                              color: appColors.textColor.withOpacity(0.5),
                              fontWeight: FontWeight.w400),
                        ),
                        Expanded(
                          child: Text(
                            data.poojaDetails!.process!.steps![index],
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: FontFamily.metropolis,
                                color: appColors.textColor.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: appColors.textColor.withOpacity(0.1))),
              if (data.poojaDetails!.process!.arrangements!.isNotEmpty)
                Text("Do you need to arrange anything?",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.metropolis,
                        fontSize: 16,
                        color: appColors.textColor)),
              if (data.poojaDetails!.process!.arrangements!.isNotEmpty)
                ListView.builder(
                  itemCount: data.poojaDetails!.process!.arrangements!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: FontFamily.metropolis,
                              color: appColors.textColor.withOpacity(0.5),
                              fontWeight: FontWeight.w400),
                        ),
                        Expanded(
                          child: Text(
                            data.poojaDetails!.process!.arrangements![index],
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: FontFamily.metropolis,
                                color: appColors.textColor.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        )
      ],
    );
  }
}
