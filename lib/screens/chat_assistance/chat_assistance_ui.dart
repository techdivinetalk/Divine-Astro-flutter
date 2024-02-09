import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/SvgIconButton.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../common/custom_text_field.dart';
import '../../common/custom_widgets.dart';
import '../../common/generic_loading_widget.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../model/chat_assistant/CustomerDetailsResponse.dart';
import '../../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../../utils/enum.dart';
import '../../utils/load_image.dart';
import 'chat_assistance_controller.dart';

class ChatAssistancePage extends GetView<ChatAssistanceController> {
  ChatAssistancePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Rx<bool> isUSerTabSelected = true.obs;

  @override
  Widget build(BuildContext context) {
    Get.put(ChatAssistanceController());
    return GetBuilder<ChatAssistanceController>(builder: (controller) {
      if (controller.loading == Loading.loading) {
        return const Scaffold(body: Center(child: GenericLoadingWidget()));
      }
      if (controller.loading == Loading.loaded) {
        return Scaffold(
            appBar: appBar(),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: SizedBox(
                    child: Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                isUSerTabSelected.value = true;
                                controller.getAssistantAstrologerList();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                // Adjust padding as needed
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.blue,
                                      // Color of the underline
                                      width: isUSerTabSelected.value
                                          ? 3.0
                                          : 00, // Thickness of the underline
                                    ),
                                  ),
                                ),
                                child: const Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.person, // User icon
                                        size: 30,
                                      ),
                                      SizedBox(width: 8),
                                      // Provides a space between the icon and the text
                                      Text(
                                        "Users",
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                isUSerTabSelected.value = false;
                                controller.getConsulation();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                // Adjust padding as needed
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black,
                                      // Color of the underline
                                      width: !isUSerTabSelected.value
                                          ? 3.0
                                          : 00, // Thickness of the underline
                                    ),
                                  ),
                                ),
                                child: const Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.folder, // User icon
                                        size: 30,
                                      ),
                                      SizedBox(width: 8),
                                      // Provides a space between the icon and the text
                                      Text(
                                        "User's Data",
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (isUSerTabSelected.value) {
                      if (controller.chatAssistantAstrologerListResponse ==
                              null ||
                          controller
                                  .chatAssistantAstrologerListResponse!.data ==
                              null ||
                          controller.chatAssistantAstrologerListResponse!.data!
                              .data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Data found',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                              fontFamily: FontFamily.metropolis,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          itemCount: controller
                              .chatAssistantAstrologerListResponse!
                              .data!
                              .data!
                              .length,
                          itemBuilder: (context, index) {
                            return ChatAssistanceTile(
                              data: controller
                                  .chatAssistantAstrologerListResponse!
                                  .data!
                                  .data![index],
                            );
                          },
                        );
                      }
                    } else {
                      if (controller.customerDetailsResponse == null ||
                          controller.customerDetailsResponse!.data == null ||
                          controller.customerDetailsResponse!.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Data found',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                              fontFamily: FontFamily.metropolis,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          itemCount:
                              controller.customerDetailsResponse!.data!.length,
                          itemBuilder: (context, index) {
                            return ChatAssistanceDataTile(
                              data: controller
                                  .customerDetailsResponse!.data![index],
                            );
                          },
                        );
                        ;
                      }
                    }
                  }),
                )
              ],
            ));
      }
      return const SizedBox.shrink();
    });
  }

  PreferredSize appBar({Color backgroundColor = AppColors.yellow}) {
    return PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: AppBar(
          surfaceTintColor: AppColors.yellow,
          title: Text(
            "chatAssistance".tr,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          leading: IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: Icon(
              Icons.arrow_back_ios,
              size: 32.sp,
              color: AppColors.blackColor,
            ),
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
        ));
  }
}

class ChatAssistanceTile extends StatelessWidget {
  final DataList data;

  const ChatAssistanceTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.toNamed(RouteName.chatMessageSupportUI, arguments: data);
      },
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.yellow),
            height: 50.w,
            width: 50.w,
            child: LoadImage(
                imageModel: ImageModel(
                    assetImage: false,
                    placeHolderPath: Assets.images.defaultProfile.path,
                    imagePath:
                        "${preferenceService.getAmazonUrl()}${data.image ?? ''}",
                    loadingIndicator: SizedBox(
                        height: 25.h,
                        width: 25.w,
                        child:  CircularProgressIndicator(
                            color: AppColors.yellow, strokeWidth: 2)))),
          )),
      title: CustomText(
        data.name ?? '',
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: CustomText(
              data.lastMessage ?? '',
              fontColor:
                  // (index == 0) ? AppColors.darkBlue:
                  AppColors.grey,
              fontSize: 12.sp,
              fontWeight:
                  //(index == 0) ? FontWeight.w600 :
                  FontWeight.normal,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // CustomText(
          //   '11:35 PM',
          //   fontSize: 12.sp,
          //   fontWeight: FontWeight.w600,
          // ),
          //  SizedBox(height: 5.h),
          // if (index == 0)
          CircleAvatar(
            radius: 10.r,
            backgroundColor: AppColors.yellow,
            child: CustomText(
              '2',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              fontColor: AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatAssistanceDataTile extends StatelessWidget {
  final ConsultationData data;

  const ChatAssistanceDataTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DataList dataList = DataList();
        dataList.name = data.customerName;
        dataList.id = data.customerId;
        Get.toNamed(RouteName.chatMessageSupportUI, arguments: dataList);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.yellow),
                  height: 50.w,
                  width: 50.w,
                  child: LoadImage(
                      imageModel: ImageModel(
                          assetImage: false,
                          placeHolderPath: Assets.images.defaultProfile.path,
                          imagePath:
                              "${preferenceService.getAmazonUrl()}${data.customerImage ?? ''}",
                          loadingIndicator: SizedBox(
                              height: 25.h,
                              width: 25.w,
                              child: const CircularProgressIndicator(
                                  color: AppColors.yellow, strokeWidth: 2)))),
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          data.customerName ?? '',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.white, width: 1.5),
                            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                            color: AppColors.darkGreen),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8,4,8,4),
                          child:  CustomText("Connect",fontColor: Colors.white,fontSize: 12.sp),
                        ),
                      )
                    ],
                  ),
                  CustomText(
                    "Total Consultation : ${data.totalConsultation}",
                    fontColor:
                    // (index == 0) ? AppColors.darkBlue:
                    AppColors.grey,
                    fontSize: 12.sp,
                    fontWeight:
                    //(index == 0) ? FontWeight.w600 :
                    FontWeight.normal,
                  ),
                  CustomText(
                    "Last Consulted : ${data.lastConsulted}",
                    fontColor:
                    // (index == 0) ? AppColors.darkBlue:
                    AppColors.grey,
                    fontSize: 12.sp,
                    fontWeight:
                    //(index == 0) ? FontWeight.w600 :
                    FontWeight.normal,
                  ),
                  CustomText(
                    "Days Since Last Consulted : ${data.daySinceLastConsulted}",
                    fontColor:
                    // (index == 0) ? AppColors.darkBlue:
                    AppColors.grey,
                    fontSize: 12.sp,
                    fontWeight:
                    //(index == 0) ? FontWeight.w600 :
                    FontWeight.normal,
                  )
                ],
              ),
            ),
            const Center(child: Icon(Icons.keyboard_arrow_right_outlined))
          ],
        ),
      ),
    );
  }
}
