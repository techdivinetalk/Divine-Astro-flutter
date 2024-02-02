// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../gen/assets.gen.dart';
// import '../model/leader_board/gift_list_model.dart';
// import '../screens/live_page/live_controller.dart';
// import 'cached_network_image.dart';
// import 'colors.dart';

// class GiftSheet extends StatelessWidget {
//   final String? url, name;

//   const GiftSheet({Key? key, this.url, this.name}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LiveController>(builder: (controller) {
//       return Material(
//         color: AppColors.transparent,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(15.0),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: AppColors.white),
//                   borderRadius: const BorderRadius.all(
//                     Radius.circular(50.0),
//                   ),
//                   color: AppColors.white.withOpacity(0.2),
//                 ),
//                 child: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Stack(
//               children: [
//                 Container(
//                   width: Get.width,
//                   margin: EdgeInsets.only(top: 45.h),
//                   decoration: const BoxDecoration(
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(50.0)),
//                     color: AppColors.white,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(height: 55.h),
//                       Text(name ?? "",
//                           style: TextStyle(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.darkBlue)),
//                       SizedBox(height: 8.h),
//                       Text("Congratulations!",
//                           style: TextStyle(
//                               fontSize: 20.sp,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.darkBlue)),
//                       SizedBox(height: 4.h),
//                       Text(
//                           "You've Have Received ${controller.allGiftList.value.giftDetails?.length.toString()} Gifts",
//                           style: TextStyle(
//                               fontSize: 14.sp, color: AppColors.darkBlue)),
//                       SizedBox(height: 25.h),
//                       Obx(
//                         ()=> MediaQuery.removePadding(
//                           context: context,
//                           removeTop: true,
//                           removeRight: true,
//                           removeLeft: true,
//                           removeBottom: true,
//                           child: ListView.separated(
//                             primary: false,
//                             shrinkWrap: true,
//                             itemCount: controller.allGiftList.value.giftDetails?.length ?? 0,
//                             itemBuilder: (context, index) {
//                               GiftDetail? model = controller.allGiftList.value.giftDetails?[index];

//                               return Row(
//                                 children: [
//                                   SizedBox(width: 32.w),
//                                   // Container(
//                                   //   width: 34.w,
//                                   //   height: 34.h,
//                                   //   clipBehavior: Clip.antiAlias,
//                                   //   decoration: const BoxDecoration(
//                                   //       shape: BoxShape.circle),
//                                   //   child: Assets.images.avatar.svg(),
//                                   // ),
//                                   Container(
//                                     clipBehavior: Clip.antiAlias,
//                                     decoration: const BoxDecoration(
//                                         shape: BoxShape.circle),
//                                     child: CachedNetworkPhoto(
//                                       fit: BoxFit.cover,
//                                       width: 34.h,
//                                       height: 34.h,
//                                       url: (controller.pref.getAmazonUrl() ??
//                                           '') +
//                                           (model?.avatar ?? ''),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10.w),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                           // 's',
//                                           '${model?.userName}',
//                                           style: TextStyle(
//                                               fontSize: 20.sp,
//                                               fontWeight: FontWeight.w600,
//                                               color: AppColors.darkBlue)),
//                                       // Text("Has given 3 hears",
//                                       //     style: TextStyle(
//                                       //         fontSize: 16.sp,
//                                       //         color: AppColors.darkBlue)),
//                                     ],
//                                   ),
//                                   const Spacer(),
//                                   Text(
//                                       // 'as',
//                                       "₹"
//                                       '${model?.price}',
//                                       style: TextStyle(
//                                           fontSize: 20.sp,
//                                           fontWeight: FontWeight.bold,
//                                           color: AppColors.darkBlue)),
//                                   SizedBox(width: 10.w),
//                                   SizedBox(
//                                     width: 34.w,
//                                     height: 34.h,
//                                     child: Assets.images.giftTotal.svg(),
//                                   ),
//                                   SizedBox(width: 32.w),
//                                 ],
//                               );
//                             },
//                             separatorBuilder: (context, index) {
//                               return SizedBox(height: 20.h);
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       Divider(height: 1.h, endIndent: 20.w, indent: 20.w),
//                       SizedBox(height: 20.h),
//                       Obx(
//                         ()=> Row(
//                           children: [
//                             SizedBox(width: 32.w),
//                             Text("Total Recieved",
//                                 style: TextStyle(
//                                     fontSize: 20.sp, color: AppColors.darkBlue)),
//                             const Spacer(),
//                             Text("₹${controller.getTotalGiftPrice()}",
//                                 style: TextStyle(
//                                     fontSize: 20.sp,
//                                     fontWeight: FontWeight.bold,
//                                     color: AppColors.darkBlue)),
//                             SizedBox(width: 10.w),
//                             SizedBox(
//                               width: 34.w,
//                               height: 34.h,
//                               child: Assets.images.giftTotal.svg(),
//                             ),
//                             SizedBox(width: 32.w),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                     ],
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: SizedBox(
//                     width: 90.w,
//                     height: 90.h,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Container(
//                           width: 90.w,
//                           height: 90.h,
//                           clipBehavior: Clip.antiAlias,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                           ),
//                           child: CachedNetworkPhoto(
//                             width: 90.w,
//                             height: 90.h,
//                             url: url ?? "",
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                         Container(
//                           width: 90.w,
//                           height: 90.h,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                                 color: AppColors.appYellowColour, width: 2),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
