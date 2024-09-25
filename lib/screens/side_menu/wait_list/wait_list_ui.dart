import 'package:divine_astrologer/model/waiting_list_queue.dart';
import 'package:divine_astrologer/repository/waiting_list_queue_repository.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/cached_network_image.dart';
import '../../../common/colors.dart';
import '../../../common/custom_widgets.dart';
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
        builder: (controller) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await controller.getWaitingList();
                },
              ),
              SliverToBoxAdapter(
                child: _buildBody(controller, context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget waitingListTile(
    GetCustomers waitingCustomer,
    int waitTime,
    WaitingListQueueData person, {
    WaitListUIController? controller,
    int? index,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          CachedNetworkPhoto(
            url: "${waitingCustomer.avatar ?? ""}",
            height: 50,
            width: 50,
          ),
          SizedBox(width: 10.w),
          Text(
            waitingCustomer.name ?? "",
            style: AppTextStyle.textStyle16(fontColor: appColors.darkBlue),
          ),
          if (waitingCustomer.level != null && waitingCustomer.level != "")
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: LevelWidget(level: waitingCustomer.level ?? ""),
            ),
          const Spacer(),
          InkWell(
            onTap: () async {
              if (chatSwitch.value == false &&
                  callSwitch.value == false &&
                  videoSwitch.value == false) {
                controller!.acceptChatButtonApi(
                  queueId: person.id.toString(),
                  orderId: person.orderId,
                  index: index,
                );
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

  Widget _buildBody(WaitListUIController controller, context) {
    if (controller.loading == Loading.loading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: const Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation(Colors.yellow),
          ),
        ),
      );
    } else if (controller.waitingPersons.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Text("jobTitle".tr),
        ),
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
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 15.h),
              waitingListTile(
                controller.waitingPersons[0].getCustomers!,
                controller.waitingPersons[0].waitTime ?? 0,
                controller.waitingPersons[0],
                controller: controller,
                index: 0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: const Divider(),
              ),
              Text(
                "waitingQueue".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 15.h),
              ListView.builder(
                itemCount: controller.waitingPersons.length - 1,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  WaitingListQueueData person =
                      controller.waitingPersons[index + 1];
                  return waitingListTile(
                    person.getCustomers!,
                    person.waitTime ?? 0,
                    person,
                    index: index + 1,
                    controller: controller,
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
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

// class WaitListUI extends GetView<WaitListUIController> {
//   const WaitListUI({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<WaitListUIController>(
//         init: WaitListUIController(WaitingListQueueRepo()),
//         builder: (controller) {
//           if (controller.tabbarController!.index == 1) {
//             controller.chatScrollView.addListener(() async {
//               // Check if the user is at the bottom
//               if (controller.chatScrollView.hasClients) {
//                 final double maxScrollExtent =
//                     controller.chatScrollView.position.maxScrollExtent;
//                 final double currentScrollPosition =
//                     controller.chatScrollView.position.pixels;
//                 if (currentScrollPosition >= maxScrollExtent //- 50
//                     ) {
//                   controller.chatScrollView.jumpToBottom();
//                   if (controller.tabbarController!.index == 0) {
//                   } else if (controller.tabbarController!.index == 1) {
//                     if (!controller.chatApiCalling.value) {
//                       controller.getChatOrderHistory(
//                           page: controller.chatPageCount);
//                     }
//                   } else if (controller.tabbarController!.index == 2) {
//                     if (!controller.callApiCalling.value) {
//                       controller.getCallOrderHistory(
//                           page: controller.callPageCount);
//                     }
//                   }
//                 }
//               }
//             });
//           } else if (controller.tabbarController!.index == 2) {
//             controller.callScrollView.addListener(() async {
//               // Check if the user is at the bottom
//               if (controller.callScrollView.hasClients) {
//                 final double maxScrollExtent =
//                     controller.callScrollView.position.maxScrollExtent;
//                 final double currentScrollPosition =
//                     controller.callScrollView.position.pixels;
//                 if (currentScrollPosition >= maxScrollExtent // - 50
//                     ) {
//                   controller.callScrollView.jumpToBottom();
//                   if (!controller.callApiCalling.value) {
//                     controller.getCallOrderHistory(
//                         page: controller.callPageCount);
//                   }
//                 }
//               }
//             });
//           }
//
//           return Scaffold(
//             appBar: AppBar(
//               centerTitle: false,
//               forceMaterialTransparency: true,
//               backgroundColor: appColors.white,
//               title: Text("Orders".tr,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 16.sp,
//                     color: appColors.darkBlue,
//                   )),
//             ),
//             body: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 12, right: 12),
//                   child: TabBar(
//                     isScrollable: true,
//                     controller: controller.tabbarController,
//                     labelColor: appColors.textColor,
//                     tabAlignment: TabAlignment.start,
//                     unselectedLabelColor: appColors.textColor,
//                     labelStyle: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14.sp,
//                       color: appColors.darkBlue,
//                       fontFamily: FontFamily.poppins,
//                     ),
//                     enableFeedback: true,
//                     onTap: (value) {
//                       controller.update();
//                       if (value == 1) {
//                         if (controller.chatHistoryList.isEmpty) {
//                           controller.getChatOrderHistory(
//                               page: controller.chatPageCount);
//                         }
//                       } else if (value == 2) {
//                         if (controller.callHistoryList.isEmpty) {
//                           controller.getCallOrderHistory(
//                               page: controller.callPageCount);
//                         }
//                       }
//                     },
//                     indicatorColor: appColors.textColor,
//                     indicatorSize: TabBarIndicatorSize.tab,
//                     indicatorWeight: 3,
//                     dividerColor: appColors.darkBlue.withOpacity(0.2),
//                     unselectedLabelStyle: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 14.sp,
//                       color: appColors.darkBlue,
//                       fontFamily: FontFamily.poppins,
//                     ),
//                     tabs: [
//                       'Waitlist'.tr,
//                       'Chat'.tr,
//                       'Call'.tr,
//                       'Remedies'.tr,
//                     ].map((e) => Tab(text: e)).toList(),
//                   ),
//                 ),
//                 SizedBox(height: 1.sp),
//                 Expanded(
//                   child: TabBarView(
//                     controller: controller.tabbarController,
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: [
//                       _buildTabContent(
//                         "Waitlist",
//                         context,
//                         controller: controller,
//                       ),
//                       _buildTabContent(
//                         "Chat",
//                         context,
//                         controller: controller,
//                       ),
//                       _buildTabContent(
//                         "Call",
//                         context,
//                         controller: controller,
//                       ),
//                       _buildTabContent(
//                         "Remedies",
//                         context,
//                         controller: controller,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
//
//   Widget _buildTabContent(type, context, {WaitListUIController? controller}) {
//     return type == "Waitlist"
//         ? RefreshIndicator(
//             onRefresh: () async {
//               controller.waitingPersons.clear();
//               controller.update();
//               controller.getWaitingList();
//             },
//             color: appColors.red,
//             child: controller!.loading == Loading.loading
//                 ? SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.7,
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: appColors.redColor,
//                       ),
//                     ),
//                   )
//                 : controller.waitingPersons.isEmpty
//                     ? SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.7,
//                         child: Center(
//                           child: Text("jobTitle".tr),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: controller.waitingPersons.length,
//                         primary: false,
//                         shrinkWrap: true,
//                         controller: controller.scrollController,
//                         padding: EdgeInsets.only(left: 5, right: 5),
//                         itemBuilder: (context, index) {
//                           WaitingListQueueData person =
//                               controller.waitingPersons[index];
//                           return Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 8, right: 8, top: 6, bottom: 6),
//                             child: waitList(
//                               context,
//                               person.getCustomers ?? GetCustomers(),
//                               person.waitTime ?? 0,
//                               person,
//                               index: index + 1,
//                               controller: controller,
//                             ),
//                           );
//                         },
//                       ),
//           )
//         : type == "Chat"
//             ?
//             // controller!.chatApiCalling.value == true
//             //             ? SizedBox(
//             //                 height: MediaQuery.of(context).size.height * 0.7,
//             //                 child: Center(
//             //                   child: CircularProgressIndicator(
//             //                     color: appColors.redColor,
//             //                   ),
//             //                 ),
//             //               )
//             //             :
//             RefreshIndicator(
//                 onRefresh: () async {
//                   controller.chatHistoryList.clear();
//                   controller.getChatOrderHistory(page: 1);
//                   controller.update();
//                 },
//                 color: appColors.red,
//                 child: controller!.chatLoading.value == true
//                     ? Center(
//                         child: CircularProgressIndicator(
//                           color: appColors.redColor,
//                         ),
//                       )
//                     : controller.chatHistoryList.isEmpty
//                         ? SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.7,
//                             child: Center(
//                               child: Text("jobTitle".tr),
//                             ),
//                           )
//                         : ListView.builder(
//                             itemCount: controller.chatHistoryList.length,
//                             // primary: false,
//                             shrinkWrap: true,
//                             controller: controller.chatScrollView,
//                             padding: EdgeInsets.only(left: 5, right: 5),
//                             itemBuilder: (context, index) {
//                               var data = controller.chatHistoryList[index];
//                               return Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 8, right: 8, top: 6, bottom: 6),
//                                 child: chatList(
//                                   context,
//                                   data,
//                                   controller: controller,
//                                 ),
//                               );
//                             },
//                           ),
//               )
//             : type == "Call"
//                 ?
//                 // controller!.callApiCalling.value == true
//                 //                 ? SizedBox(
//                 //                     height: MediaQuery.of(context).size.height * 0.7,
//                 //                     child: Center(
//                 //                       child: CircularProgressIndicator(
//                 //                         color: appColors.redColor,
//                 //                       ),
//                 //                     ),
//                 //                   )
//                 //                 :
//                 RefreshIndicator(
//                     onRefresh: () async {
//                       controller.callHistoryList.clear();
//                       controller.getCallOrderHistory(page: 1);
//                       controller.update();
//                     },
//                     color: appColors.red,
//                     child: controller!.callLoading.value == true
//                         ? Center(
//                             child: CircularProgressIndicator(
//                               color: appColors.redColor,
//                             ),
//                           )
//                         : controller.callHistoryList.isEmpty
//                             ? SizedBox(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.7,
//                                 child: Center(
//                                   child: Text("jobTitle".tr),
//                                 ),
//                               )
//                             : ListView.builder(
//                                 itemCount: controller.callHistoryList.length,
//                                 // primary: false,
//                                 shrinkWrap: true,
//                                 controller: controller.callScrollView,
//                                 padding: EdgeInsets.only(left: 5, right: 5),
//                                 itemBuilder: (context, index) {
//                                   var data = controller.callHistoryList[index];
//                                   return Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 8, right: 8, top: 6, bottom: 6),
//                                     child: callList(
//                                       context,
//                                       data,
//                                       controller: controller,
//                                     ),
//                                   );
//                                 },
//                               ),
//                   )
//                 : RefreshIndicator(
//                     onRefresh: () async {},
//                     color: appColors.red,
//                     child: controller!.loading == Loading.loading
//                         ? SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.7,
//                             child: Center(
//                               child: CircularProgressIndicator(
//                                 color: appColors.redColor,
//                               ),
//                             ),
//                           )
//                         : controller.waitingPersons.isEmpty
//                             ? SizedBox(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.7,
//                                 child: Center(
//                                   child: Text("jobTitle".tr),
//                                 ),
//                               )
//                             : ListView.builder(
//                                 itemCount: controller.waitingPersons.length,
//                                 primary: false,
//                                 shrinkWrap: true,
//                                 controller: controller.scrollController,
//                                 padding: EdgeInsets.only(left: 5, right: 5),
//                                 itemBuilder: (context, index) {
//                                   WaitingListQueueData person =
//                                       controller.waitingPersons[index];
//                                   return Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 8, right: 8, top: 6, bottom: 6),
//                                     child: remediesList(
//                                       context,
//                                       person.getCustomers ?? GetCustomers(),
//                                       person.waitTime ?? 0,
//                                       person,
//                                       index: index + 1,
//                                       controller: controller,
//                                     ),
//                                   );
//                                 },
//                               ),
//                   );
//   }
//
//   Widget waitList(
//     context,
//     GetCustomers waitingCustomer,
//     int waitTime,
//     WaitingListQueueData person, {
//     WaitListUIController? controller,
//     int? index,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: appColors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: appColors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 8, bottom: 2),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: 15,
//                 ),
//                 Text(
//                   "Repeat",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: FontFamily.poppins,
//                     fontWeight: FontWeight.w400,
//                     color: appColors.red,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 SizedBox(
//                   height: 20,
//                   child: VerticalDivider(
//                     color: appColors.grey.withOpacity(0.4),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   person.status ?? "",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: FontFamily.poppins,
//                     fontWeight: FontWeight.w400,
//                     color: Color.fromRGBO(252, 183, 66, 1),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 8, right: 8),
//             child: Divider(
//               color: appColors.grey.withOpacity(0.4),
//             ),
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               CircleAvatar(
//                 radius: 25,
//                 backgroundColor: appColors.grey,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(80),
//                   child: CachedNetworkPhoto(
//                     url: "${waitingCustomer.avatar ?? ""}",
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         waitingCustomer.name ?? "",
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: FontFamily.poppins,
//                           color: appColors.black,
//                         ),
//                       ),
//                       if (waitingCustomer.level != null &&
//                           waitingCustomer.level != "")
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5.0),
//                           child:
//                               LevelWidget(level: waitingCustomer.level ?? ""),
//                         ),
//                     ],
//                   ),
//                   Text(
//                     "01 Aug 24, 05:01 PM",
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: FontFamily.poppins,
//                       color: appColors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 6,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Order Id",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           person.orderId.toString() ?? "",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Type",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           person.isCall == 1
//                               ? "CHAT"
//                               : person.isCall == 2
//                                   ? "CALL"
//                                   : "",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Offer",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           "",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Duration",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           "${person.talkMinute.toString()} minutes",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(5, 0, 10, 10),
//                 child: InkWell(
//                   onTap: () {
//                     if (chatSwitch.value == false &&
//                         callSwitch.value == false &&
//                         videoSwitch.value == false) {
//                       controller!.acceptChatButtonApi(
//                         queueId: person.id.toString(),
//                         orderId: person.orderId,
//                         index: index,
//                       );
//                     } else {
//                       Fluttertoast.showToast(
//                         msg: "Please turn off all session types.",
//                       );
//                     }
//                   },
//                   child: Container(
//                       height: 38.sp,
//                       width: MediaQuery.of(context).size.width * 0.4.sp,
//                       decoration: BoxDecoration(
//                         color: appColors.red,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: appColors.red,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Accept",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.white,
//                           ),
//                         ),
//                       )),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget chatList(
//     context,
//     ChatDataList data, {
//     WaitListUIController? controller,
//   }) {
//     // Parse the DateTime from the backend string
//     DateTime dateTime = DateTime.parse(data.createdAt.toString());
//
//     // Format the DateTime to "01 Aug 24, 05:01 PM"
//     String formattedDate = DateFormat('dd MMM yy, hh:mm a').format(dateTime);
//
//     return Container(
//       decoration: BoxDecoration(
//         color: appColors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: appColors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 8, bottom: 2),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: 15,
//                 ),
//                 Text(
//                   "Repeat",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: FontFamily.poppins,
//                     fontWeight: FontWeight.w400,
//                     color: appColors.red,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 SizedBox(
//                   height: 20,
//                   child: VerticalDivider(
//                     color: appColors.grey.withOpacity(0.4),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   data.status ?? "",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: FontFamily.poppins,
//                     fontWeight: FontWeight.w400,
//                     color: appColors.darkBlue,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 8, right: 8),
//             child: Divider(
//               color: appColors.grey.withOpacity(0.4),
//             ),
//           ),
//           // SizedBox(
//           //   height: 2,
//           // ),
//           Row(
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               CircleAvatar(
//                 radius: 25,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(80),
//                   child: CachedNetworkPhoto(
//                     url: "${data.getCustomers?.avatar ?? ""}",
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         data.getCustomers?.name ?? "",
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: FontFamily.poppins,
//                           color: appColors.black,
//                         ),
//                       ),
//                       if (data.getCustomers!.level != null &&
//                           data.getCustomers!.level != "")
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5.0),
//                           child: LevelWidget(
//                               level: data.getCustomers!.level ?? ""),
//                         ),
//                     ],
//                   ),
//                   Text(
//                     formattedDate ?? "",
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: FontFamily.poppins,
//                       color: appColors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 6,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Order Id",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           data.orderId.toString() ?? "",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Type",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           "CHAT",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Offer",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           "",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Duration",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           "${data.duration.toString()} minutes",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(5, 0, 10, 10),
//                 child: InkWell(
//                   onTap: () {
//                     DataList dataList = DataList();
//                     dataList.name = data.getCustomers!.name;
//                     dataList.id = data.getCustomers!.id;
//                     dataList.image = data.getCustomers!.avatar;
//                     Get.toNamed(RouteName.chatMessageUI, arguments: dataList);
//
//                     // if (chatSwitch.value == false &&
//                     //     callSwitch.value == false &&
//                     //     videoSwitch.value == false) {
//                     //   controller!.acceptChatButtonApi(
//                     //     queueId: person.id.toString(),
//                     //     orderId: person.orderId,
//                     //     index: index,
//                     //   );
//                     // } else {
//                     //   Fluttertoast.showToast(
//                     //     msg: "Please turn off all session types.",
//                     //   );
//                     // }
//                   },
//                   child: Container(
//                       height: 38.sp,
//                       width: MediaQuery.of(context).size.width * 0.4.sp,
//                       decoration: BoxDecoration(
//                         color: appColors.green,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: appColors.green,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Chat Assitance",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.white,
//                           ),
//                         ),
//                       )),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget callList(
//     context,
//     CallHistoryData data, {
//     WaitListUIController? controller,
//   }) {
//     // Parse the DateTime from the backend string
//     DateTime dateTime = DateTime.parse(data.createdAt.toString());
//
//     // Format the DateTime to "01 Aug 24, 05:01 PM"
//     String formattedDate = DateFormat('dd MMM yy, hh:mm a').format(dateTime);
//
//     return Container(
//       decoration: BoxDecoration(
//         color: appColors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: appColors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 8, bottom: 2),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: 15,
//                 ),
//                 Text(
//                   "Repeat",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: FontFamily.poppins,
//                     fontWeight: FontWeight.w400,
//                     color: appColors.red,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 SizedBox(
//                   height: 20,
//                   child: VerticalDivider(
//                     color: appColors.grey.withOpacity(0.4),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   data.status ?? "",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: FontFamily.poppins,
//                     fontWeight: FontWeight.w400,
//                     color: appColors.darkBlue,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 8, right: 8),
//             child: Divider(
//               color: appColors.grey.withOpacity(0.4),
//             ),
//           ),
//           SizedBox(
//             height: 2,
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               CircleAvatar(
//                 radius: 25,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(80),
//                   child: CachedNetworkPhoto(
//                     url: "${data.getCustomers!.avatar ?? ""}",
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         data.getCustomers!.name ?? "",
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: FontFamily.poppins,
//                           color: appColors.black,
//                         ),
//                       ),
//                       if (data.getCustomers!.level != null &&
//                           data.getCustomers!.level != "")
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5.0),
//                           child: LevelWidget(
//                               level: data.getCustomers!.level ?? ""),
//                         ),
//                     ],
//                   ),
//                   Text(
//                     formattedDate ?? "",
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: FontFamily.poppins,
//                       color: appColors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 6,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Order Id",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           data.orderId ?? "",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Type",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           "CALL",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Offer",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           "",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Duration",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           "${data.duration.toString()} minutes",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(5, 0, 10, 10),
//                 child: InkWell(
//                   onTap: () {
//                     DataList dataList = DataList();
//                     dataList.name = data.getCustomers!.name;
//                     dataList.id = data.getCustomers!.id;
//                     dataList.image = data.getCustomers!.avatar;
//                     Get.toNamed(RouteName.chatMessageUI, arguments: dataList);
//                   },
//                   child: Container(
//                       height: 38.sp,
//                       width: MediaQuery.of(context).size.width * 0.4.sp,
//                       decoration: BoxDecoration(
//                         color: appColors.green,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: appColors.green,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Chat Assitance",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.white,
//                           ),
//                         ),
//                       )),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget remediesList(
//     context,
//     GetCustomers waitingCustomer,
//     int waitTime,
//     WaitingListQueueData person, {
//     WaitListUIController? controller,
//     int? index,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: appColors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: appColors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 8, bottom: 2),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: 15,
//                 ),
//                 Text(
//                   "Repeat",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: FontFamily.poppins,
//                     fontWeight: FontWeight.w400,
//                     color: appColors.red,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 SizedBox(
//                   height: 20,
//                   child: VerticalDivider(
//                     color: appColors.grey.withOpacity(0.4),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   person.status ?? "",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: FontFamily.poppins,
//                     fontWeight: FontWeight.w400,
//                     color: Color.fromRGBO(252, 183, 66, 1),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 8, right: 8),
//             child: Divider(
//               color: appColors.grey.withOpacity(0.4),
//             ),
//           ),
//           SizedBox(
//             height: 2,
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               CircleAvatar(
//                 radius: 25,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(80),
//                   child: CachedNetworkPhoto(
//                     url: "${waitingCustomer.avatar ?? ""}",
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         waitingCustomer.name ?? "",
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: FontFamily.poppins,
//                           color: appColors.black,
//                         ),
//                       ),
//                       if (waitingCustomer.level != null &&
//                           waitingCustomer.level != "")
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5.0),
//                           child:
//                               LevelWidget(level: waitingCustomer.level ?? ""),
//                         ),
//                     ],
//                   ),
//                   Text(
//                     "01 Aug 24, 05:01 PM",
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: FontFamily.poppins,
//                       color: appColors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 6,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Order Id",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           person.orderId.toString() ?? "",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Product Name",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           "Job Healing",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.18,
//                         child: Text(
//                           "Quantity",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.01,
//                         child: Text(
//                           ":",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.22,
//                         child: Text(
//                           "1",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: FontFamily.poppins,
//                             color: appColors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                 ],
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(5, 0, 10, 10),
//                     child: Container(
//                         height: 38.sp,
//                         width: MediaQuery.of(context).size.width * 0.4.sp,
//                         decoration: BoxDecoration(
//                             color: appColors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: appColors.red,
//                             )),
//                         child: Center(
//                           child: Text(
//                             "Chat with us",
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: FontFamily.poppins,
//                               color: appColors.red,
//                             ),
//                           ),
//                         )),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(5, 5, 10, 10),
//                     child: InkWell(
//                       onTap: () {},
//                       child: Container(
//                           height: 38.sp,
//                           width: MediaQuery.of(context).size.width * 0.4.sp,
//                           decoration: BoxDecoration(
//                             color: appColors.red,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: appColors.red,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Accept",
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w400,
//                                 fontFamily: FontFamily.poppins,
//                                 color: appColors.white,
//                               ),
//                             ),
//                           )),
//                     ),
//                   ),
//                   // Padding(
//                   //   padding: const EdgeInsets.fromLTRB(5, 5, 10, 10),
//                   //   child: InkWell(
//                   //     onTap: () {},
//                   //     child: Container(
//                   //         height: 38,
//                   //         width: MediaQuery.of(context).size.width * 0.4,
//                   //         decoration: BoxDecoration(
//                   //           color: appColors.grey.withOpacity(0.5),
//                   //           borderRadius: BorderRadius.circular(10),
//                   //           border: Border.all(
//                   //             color: appColors.grey.withOpacity(0.5),
//                   //           ),
//                   //         ),
//                   //         child: Center(
//                   //           child: Text(
//                   //             "Requested to close",
//                   //             style: TextStyle(
//                   //               fontSize: 14.sp,
//                   //               fontWeight: FontWeight.w400,
//                   //               fontFamily: FontFamily.poppins,
//                   //               color: appColors.white,
//                   //             ),
//                   //           ),
//                   //         )),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget completedTile(
//   //   context,
//   //   GetCustomers waitingCustomer,
//   //   int waitTime,
//   //   WaitingListQueueData person, {
//   //   WaitListUIController? controller,
//   //   int? index,
//   // }) {
//   //   return Container(
//   //     decoration: BoxDecoration(
//   //       color: appColors.white,
//   //       borderRadius: BorderRadius.circular(10),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: appColors.grey.withOpacity(0.3),
//   //           spreadRadius: 2,
//   //           blurRadius: 2,
//   //         ),
//   //       ],
//   //     ),
//   //     child: Column(
//   //       children: [
//   //         Padding(
//   //           padding: const EdgeInsets.only(top: 8, bottom: 2),
//   //           child: Row(
//   //             children: [
//   //               SizedBox(
//   //                 width: 15,
//   //               ),
//   //               Text(
//   //                 "Repeat",
//   //                 style: TextStyle(
//   //                   fontSize: 16.sp,
//   //                   fontFamily: FontFamily.poppins,
//   //                   fontWeight: FontWeight.w400,
//   //                   color: appColors.red,
//   //                 ),
//   //               ),
//   //               SizedBox(
//   //                 width: 5,
//   //               ),
//   //               SizedBox(
//   //                 height: 20,
//   //                 child: VerticalDivider(
//   //                   color: appColors.grey.withOpacity(0.3),
//   //                 ),
//   //               ),
//   //               SizedBox(
//   //                 width: 5,
//   //               ),
//   //               Text(
//   //                 "Completed",
//   //                 style: TextStyle(
//   //                   fontSize: 16.sp,
//   //                   fontFamily: FontFamily.poppins,
//   //                   fontWeight: FontWeight.w400,
//   //                   color: appColors.black,
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //         Padding(
//   //           padding: const EdgeInsets.only(left: 8, right: 8),
//   //           child: Divider(
//   //             color: appColors.grey.withOpacity(0.3),
//   //           ),
//   //         ),
//   //         SizedBox(
//   //           height: 2,
//   //         ),
//   //         Row(
//   //           children: [
//   //             SizedBox(
//   //               width: 10,
//   //             ),
//   //             CircleAvatar(
//   //               radius: 25,
//   //               child: ClipRRect(
//   //                 borderRadius: BorderRadius.circular(80),
//   //                 child: CachedNetworkPhoto(
//   //                   url: "${waitingCustomer.avatar ?? ""}",
//   //                 ),
//   //               ),
//   //             ),
//   //             SizedBox(
//   //               width: 10,
//   //             ),
//   //             Column(
//   //               mainAxisAlignment: MainAxisAlignment.start,
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 Text(
//   //                   waitingCustomer.name ?? "",
//   //                   style: TextStyle(
//   //                     fontSize: 16.sp,
//   //                     fontWeight: FontWeight.w600,
//   //                     fontFamily: FontFamily.poppins,
//   //                     color: appColors.black,
//   //                   ),
//   //                 ),
//   //                 Text(
//   //                   "01 Aug 24, 05:01 PM",
//   //                   style: TextStyle(
//   //                     fontSize: 12.sp,
//   //                     fontWeight: FontWeight.w400,
//   //                     fontFamily: FontFamily.poppins,
//   //                     color: appColors.grey,
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //         SizedBox(
//   //           height: 12,
//   //         ),
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           crossAxisAlignment: CrossAxisAlignment.end,
//   //           children: [
//   //             Column(
//   //               mainAxisAlignment: MainAxisAlignment.start,
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 Row(
//   //                   children: [
//   //                     SizedBox(
//   //                       width: 10,
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.18,
//   //                       child: Text(
//   //                         "Order Id",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w600,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.black,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.01,
//   //                       child: Text(
//   //                         ":",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w600,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.black,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     SizedBox(
//   //                       width: 10,
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.22,
//   //                       child: Text(
//   //                         "#1234567890",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w400,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.grey,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //                 SizedBox(
//   //                   height: 8,
//   //                 ),
//   //                 Row(
//   //                   children: [
//   //                     SizedBox(
//   //                       width: 10,
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.18,
//   //                       child: Text(
//   //                         "Type",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w600,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.black,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.01,
//   //                       child: Text(
//   //                         ":",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w600,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.black,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     SizedBox(
//   //                       width: 10,
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.22,
//   //                       child: Text(
//   //                         "CHAT",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w400,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.grey,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //                 SizedBox(
//   //                   height: 8,
//   //                 ),
//   //                 Row(
//   //                   children: [
//   //                     SizedBox(
//   //                       width: 10,
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.18,
//   //                       child: Text(
//   //                         "Offer",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w600,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.black,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.01,
//   //                       child: Text(
//   //                         ":",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w600,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.black,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     SizedBox(
//   //                       width: 10,
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.22,
//   //                       child: Text(
//   //                         "Paid",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w400,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.grey,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //                 SizedBox(
//   //                   height: 8,
//   //                 ),
//   //                 Row(
//   //                   children: [
//   //                     SizedBox(
//   //                       width: 10,
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.18,
//   //                       child: Text(
//   //                         "Duration",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w600,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.black,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.01,
//   //                       child: Text(
//   //                         ":",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w600,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.black,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     SizedBox(
//   //                       width: 10,
//   //                     ),
//   //                     SizedBox(
//   //                       width: MediaQuery.of(context).size.width * 0.22,
//   //                       child: Text(
//   //                         "103 Minutes",
//   //                         style: TextStyle(
//   //                           fontSize: 12.sp,
//   //                           fontWeight: FontWeight.w400,
//   //                           fontFamily: FontFamily.poppins,
//   //                           color: appColors.grey,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //                 SizedBox(
//   //                   height: 8,
//   //                 ),
//   //               ],
//   //             ),
//   //             Column(
//   //               mainAxisAlignment: MainAxisAlignment.end,
//   //               crossAxisAlignment: CrossAxisAlignment.end,
//   //               children: [
//   //                 Padding(
//   //                   padding: const EdgeInsets.fromLTRB(5, 0, 10, 10),
//   //                   child: Container(
//   //                       height: 38,
//   //                       width: MediaQuery.of(context).size.width * 0.3,
//   //                       decoration: BoxDecoration(
//   //                           color: appColors.white,
//   //                           borderRadius: BorderRadius.circular(10),
//   //                           border: Border.all(
//   //                             color: appColors.black,
//   //                           )),
//   //                       child: Center(
//   //                         child: Text(
//   //                           "User Details",
//   //                           style: TextStyle(
//   //                             fontSize: 14.sp,
//   //                             fontWeight: FontWeight.w400,
//   //                             fontFamily: FontFamily.poppins,
//   //                             color: appColors.black,
//   //                           ),
//   //                         ),
//   //                       )),
//   //                 ),
//   //                 Padding(
//   //                   padding: const EdgeInsets.fromLTRB(5, 5, 10, 10),
//   //                   child: Container(
//   //                       height: 38,
//   //                       width: MediaQuery.of(context).size.width * 0.4,
//   //                       decoration: BoxDecoration(
//   //                           color: appColors.green,
//   //                           borderRadius: BorderRadius.circular(10),
//   //                           border: Border.all(
//   //                             color: appColors.green,
//   //                           )),
//   //                       child: Center(
//   //                         child: Text(
//   //                           "Chat Assitance",
//   //                           style: TextStyle(
//   //                             fontSize: 14.sp,
//   //                             fontWeight: FontWeight.w400,
//   //                             fontFamily: FontFamily.poppins,
//   //                             color: appColors.white,
//   //                           ),
//   //                         ),
//   //                       )),
//   //                 ),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
// }

//////////////////////////////////////////////
//   Widget waitingListTile(
//     GetCustomers waitingCustomer,
//     int waitTime,
//     WaitingListQueueData person, {
//     WaitListUIController? controller,
//     int? index,
//   }) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10.h),
//       child: Row(
//         children: [
//           CachedNetworkPhoto(
//             url: "${waitingCustomer.avatar ?? ""}",
//             height: 50,
//             width: 50,
//           ),
//           SizedBox(width: 10.w),
//           Text(
//             waitingCustomer.name ?? "",
//             style: AppTextStyle.textStyle16(fontColor: appColors.darkBlue),
//           ),
//           if (waitingCustomer.level != null && waitingCustomer.level != "")
//             Padding(
//               padding: const EdgeInsets.only(left: 5.0),
//               child: LevelWidget(level: waitingCustomer.level ?? ""),
//             ),
//           const Spacer(),
//           InkWell(
//             onTap: () async {
//               if (chatSwitch.value == false &&
//                   callSwitch.value == false &&
//                   videoSwitch.value == false) {
//                 controller!.acceptChatButtonApi(
//                   queueId: person.id.toString(),
//                   orderId: person.orderId,
//                   index: index,
//                 );
//               } else {
//                 Fluttertoast.showToast(
//                   msg: "Please turn off all session types.",
//                 );
//               }
//             },
//             child: Container(
//                 padding: EdgeInsets.all(7),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: appColors.guideColor,
//                 ),
//                 child: Text(
//                   "Accept",
//                   style: TextStyle(fontSize: 13, color: appColors.black),
//                 )),
//           ),
//           const SizedBox(width: 10),
//           Row(
//             children: [
//               ImageBasedOnResponse(customer: person),
//               SizedBox(
//                 width: 8.w,
//               ),
//               // Text(
//               //   "$waitTime minutes",
//               //   style: AppTextStyle.textStyle16(
//               //       fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
//               // ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBody(WaitListUIController controller, context) {
//     if (controller.loading == Loading.loading) {
//       return SizedBox(
//         height: MediaQuery.of(context).size.height * 0.7,
//         child: const Center(
//           child: CircularProgressIndicator.adaptive(
//             valueColor: AlwaysStoppedAnimation(Colors.yellow),
//           ),
//         ),
//       );
//     } else if (controller.waitingPersons.isEmpty) {
//       return SizedBox(
//         height: MediaQuery.of(context).size.height * 0.7,
//         child: Center(
//           child: Text("jobTitle".tr),
//         ),
//       );
//     } else {
//       // return SingleChildScrollView(
//       //   child: Padding(
//       //     padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
//       //     child: Column(
//       //       crossAxisAlignment: CrossAxisAlignment.start,
//       //       children: [
//       //         Text(
//       //           "nextInLine".tr,
//       //           style: TextStyle(
//       //             fontWeight: FontWeight.w500,
//       //             fontSize: 20.sp,
//       //             color: Colors.blue,
//       //           ),
//       //         ),
//       //         SizedBox(height: 15.h),
//       //         waitingListTile(
//       //           controller.waitingPersons[0].getCustomers!,
//       //           controller.waitingPersons[0].waitTime ?? 0,
//       //           controller.waitingPersons[0],
//       //           controller: controller,
//       //           index: 0,
//       //         ),
//       //         Padding(
//       //           padding: EdgeInsets.symmetric(vertical: 10.h),
//       //           child: const Divider(),
//       //         ),
//       //         Text(
//       //           "waitingQueue".tr,
//       //           style: TextStyle(
//       //             fontWeight: FontWeight.w500,
//       //             fontSize: 20.sp,
//       //             color: Colors.blue,
//       //           ),
//       //         ),
//       //         SizedBox(height: 15.h),
//       //         ListView.builder(
//       //           itemCount: controller.waitingPersons.length - 1,
//       //           primary: false,
//       //           shrinkWrap: true,
//       //           itemBuilder: (context, index) {
//       //             WaitingListQueueData person =
//       //                 controller.waitingPersons[index + 1];
//       //             return waitingListTile(
//       //               person.getCustomers!,
//       //               person.waitTime ?? 0,
//       //               person,
//       //               index: index + 1,
//       //               controller: controller,
//       //             );
//       //           },
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // );
//       return Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TabBar(
//             isScrollable: true,
//             controller: controller.tabbarController,
//             labelColor: appColors.textColor,
//             tabAlignment: TabAlignment.start,
//             unselectedLabelColor: appColors.textColor,
//             labelStyle: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 14.sp,
//               color: appColors.black,
//               fontFamily: FontFamily.poppins,
//             ),
//             enableFeedback: true,
//             onTap: (value) {
//               controller.update();
//             },
//             indicatorColor: appColors.textColor,
//             indicatorSize: TabBarIndicatorSize.tab,
//             dividerColor: appColors.textColor.withOpacity(0.2),
//             unselectedLabelStyle: TextStyle(
//               fontWeight: FontWeight.w400,
//               fontSize: 14.sp,
//               color: appColors.black,
//               fontFamily: FontFamily.poppins,
//             ),
//             tabs: [
//               'Pending'.tr,
//               'Completed'.tr,
//             ].map((e) => Tab(text: e)).toList(),
//           ),
//           SizedBox(height: 1.sp),
//           SingleChildScrollView(
//             controller: controller.scrollController,
//             child: Expanded(
//               child: TabBarView(
//                 controller: controller.tabbarController,
//                 physics: ScrollPhysics(),
//                 children: [
//                   Obx(
//                     () => ListView.builder(
//                       itemCount: controller.waitingPersons.length - 1,
//                       primary: false,
//                       shrinkWrap: true,
//                       controller: controller.scrollController,
//                       itemBuilder: (context, index) {
//                         WaitingListQueueData person =
//                             controller.waitingPersons[index + 1];
//                         return waitingListTile(
//                           person.getCustomers!,
//                           person.waitTime ?? 0,
//                           person,
//                           index: index + 1,
//                           controller: controller,
//                         );
//                       },
//                     ),
//                   ),
//                   Obx(
//                     () => ListView.builder(
//                       itemCount: controller.waitingPersons.length - 1,
//                       primary: false,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         WaitingListQueueData person =
//                             controller.waitingPersons[index + 1];
//                         return waitingListTile(
//                           person.getCustomers!,
//                           person.waitTime ?? 0,
//                           person,
//                           index: index + 1,
//                           controller: controller,
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }
//
// class ImageBasedOnResponse extends StatelessWidget {
//   const ImageBasedOnResponse({Key? key, required this.customer})
//       : super(key: key);
//
//   final WaitingListQueueData customer;
//
//   @override
//   Widget build(BuildContext context) {
//     if (customer.isCall == 1) {
//       return Assets.images.icChating.svg();
//     }
//     if (customer.isCall == 2) {
//       return Assets.svg.icCall1.svg();
//     }
//     return const SizedBox.shrink();
//   }
// }
// // import 'package:divine_astrologer/model/waiting_list_queue.dart';
// // import 'package:divine_astrologer/repository/waiting_list_queue_repository.dart';
// // import 'package:divine_astrologer/screens/live_page/constant.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:get/get.dart';
// //
// // import '../../../common/app_textstyle.dart';
// // import '../../../common/cached_network_image.dart';
// // import '../../../common/colors.dart';
// // import '../../../gen/assets.gen.dart';
// // import '../../../utils/enum.dart';
// // import 'wait_list_controller.dart';
// //
// // class WaitListUI extends GetView<WaitListUIController> {
// //   const WaitListUI({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         toolbarHeight: 50,
// //         centerTitle: false,
// //         forceMaterialTransparency: true,
// //         backgroundColor: appColors.white,
// //         title: Text(
// //           "Queue".tr,
// //           style: TextStyle(
// //             fontWeight: FontWeight.w400,
// //             fontSize: 16.sp,
// //             color: appColors.darkBlue,
// //           ),
// //         ),
// //       ),
// //       body: GetBuilder<WaitListUIController>(
// //         init: WaitListUIController(WaitingListQueueRepo()),
// //         builder: (controller) {
// //           return CustomScrollView(
// //             physics: const BouncingScrollPhysics(
// //                 parent: AlwaysScrollableScrollPhysics()),
// //             slivers: [
// //               CupertinoSliverRefreshControl(
// //                 onRefresh: () async {
// //                   await controller.getWaitingList();
// //                 },
// //               ),
// //               SliverToBoxAdapter(
// //                 child: _buildBody(controller, context),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget waitingListTile(
// //     GetCustomers waitingCustomer,
// //     int waitTime,
// //     WaitingListQueueData person, {
// //     WaitListUIController? controller,
// //     int? index,
// //   }) {
// //     return Container(
// //       margin: EdgeInsets.symmetric(vertical: 10.h),
// //       child: Row(
// //         children: [
// //           ClipRRect(
// //             borderRadius: BorderRadius.circular(100),
// //             child: CachedNetworkPhoto(
// //               url: waitingCustomer.avatar ?? "",
// //               height: 50,
// //               width: 50,
// //             ),
// //           ),
// //           SizedBox(width: 10.w),
// //           Expanded(
// //             child: Text(
// //               waitingCustomer.name ?? "",
// //               style: AppTextStyle.textStyle16(
// //                   fontColor: appColors.darkBlue, fontWeight: FontWeight.w400),
// //             ),
// //           ),
// //           InkWell(
// //             onTap: () async {
// //               if (chatSwitch.value == false &&
// //                   callSwitch.value == false &&
// //                   videoSwitch.value == false) {
// //                 controller!.acceptChatButtonApi(
// //                   queueId: person.id.toString(),
// //                   orderId: person.orderId,
// //                   index: index,
// //                 );
// //               } else {
// //                 Fluttertoast.showToast(
// //                   msg: "Please turn off all session types.",
// //                 );
// //               }
// //             },
// //             child: Container(
// //                 padding: EdgeInsets.all(7),
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(20),
// //                   color: appColors.guideColor,
// //                 ),
// //                 child: Padding(
// //                   padding: const EdgeInsets.only(left: 6, right: 6),
// //                   child: Text(
// //                     "Accept",
// //                     style: TextStyle(fontSize: 13, color: appColors.white),
// //                   ),
// //                 )),
// //           ),
// //           const SizedBox(width: 10),
// //           Row(
// //             children: [
// //               ImageBasedOnResponse(customer: person),
// //               SizedBox(
// //                 width: 8.w,
// //               ),
// //               // Text(
// //               //   "$waitTime minutes",
// //               //   style: AppTextStyle.textStyle16(
// //               //       fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
// //               // ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBody(WaitListUIController controller, context) {
// //     // log("data data data data data --- ${controller.waitingPersons.toString()}");
// //     if (controller.loading == Loading.loading) {
// //       return SizedBox(
// //         height: MediaQuery.of(context).size.height * 0.7,
// //         child: const Center(
// //           child: CircularProgressIndicator.adaptive(
// //             valueColor: AlwaysStoppedAnimation(Colors.yellow),
// //           ),
// //         ),
// //       );
// //     } else if (controller.waitingPersons.isEmpty) {
// //       return SizedBox(
// //         height: MediaQuery.of(context).size.height * 0.7,
// //         child: Center(
// //           child: Text("jobTitle".tr),
// //         ),
// //       );
// //     } else {
// //       return SingleChildScrollView(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(
// //             horizontal: 15.w,
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 "nextInLine".tr,
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 16.sp,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //               waitingListTile(
// //                 controller.waitingPersons[0].getCustomers!,
// //                 controller.waitingPersons[0].waitTime ?? 0,
// //                 controller.waitingPersons[0],
// //                 controller: controller,
// //                 index: 0,
// //               ),
// //               Padding(
// //                 padding: EdgeInsets.symmetric(vertical: 10.h),
// //                 child: Divider(
// //                   color: appColors.grey.withOpacity(0.4),
// //                 ),
// //               ),
// //               Text(
// //                 "waitingQueue".tr,
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 16.sp,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //               ListView.builder(
// //                 itemCount: controller.waitingPersons.length,
// //                 primary: false,
// //                 shrinkWrap: true,
// //                 itemBuilder: (context, index) {
// //                   WaitingListQueueData person =
// //                       controller.waitingPersons[index];
// //                   return waitingListTile(
// //                     person.getCustomers!,
// //                     person.waitTime ?? 0,
// //                     person,
// //                     index: index + 1,
// //                     controller: controller,
// //                   );
// //                 },
// //               ),
// //               Padding(
// //                 padding: EdgeInsets.symmetric(vertical: 10.h),
// //                 child: Divider(
// //                   color: appColors.grey.withOpacity(0.4),
// //                 ),
// //               ),
// //               Text(
// //                 "Completed".tr,
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 16.sp,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //               ListView.builder(
// //                 itemCount: controller.waitingPersons.length,
// //                 primary: false,
// //                 shrinkWrap: true,
// //                 itemBuilder: (context, index) {
// //                   WaitingListQueueData person =
// //                       controller.waitingPersons[index];
// //                   return waitingListTile(
// //                     person.getCustomers!,
// //                     person.waitTime ?? 0,
// //                     person,
// //                     index: index + 1,
// //                     controller: controller,
// //                   );
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     }
// //   }
// // }
// //
// // class ImageBasedOnResponse extends StatelessWidget {
// //   const ImageBasedOnResponse({Key? key, required this.customer})
// //       : super(key: key);
// //
// //   final WaitingListQueueData customer;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (customer.isCall == 1) {
// //       return Assets.images.icChating.svg();
// //     }
// //     if (customer.isCall == 2) {
// //       return Assets.svg.icCall1.svg();
// //     }
// //     return const SizedBox.shrink();
// //   }
// // }
