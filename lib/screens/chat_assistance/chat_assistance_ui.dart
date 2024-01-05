import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/SvgIconButton.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../common/custom_text_field.dart';
import '../../common/custom_widgets.dart';
import '../../common/generic_loading_widget.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../../utils/enum.dart';
import '../../utils/load_image.dart';
import 'chat_assistance_controller.dart';

class ChatAssistancePage extends GetView<ChatAssistanceController> {
  ChatAssistancePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          body: (controller.chatAssistantAstrologerListResponse == null ||
                  controller.chatAssistantAstrologerListResponse!.data == null ||
                  controller.chatAssistantAstrologerListResponse!.data!.data!.isEmpty)
              ? const Center(
                  child: Text('No Data found',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                          fontFamily: FontFamily.metropolis)))
              : Obx(
                  () => ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    itemCount: (controller.searchData).isNotEmpty
                        ? controller.searchData.length
                        : controller.chatAssistantAstrologerListResponse!.data!.data!.length,
                    itemBuilder: (context, index) => ChatAssistanceTile(
                        data: (controller.searchData).isNotEmpty
                            ? controller.searchData[index]
                            : controller.chatAssistantAstrologerListResponse!.data!.data![index]),
                  ),
                ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  PreferredSize appBar({Color backgroundColor = const Color(0XFFFDD48E)}) {
    return PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: Obx(
          () => Container(
            color: AppColors.yellow,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              child: controller.isSearchEnable.value
                  ? searchWidget(backgroundColor)
                  : AppBar(
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
                          Icons.menu_rounded,
                          size: 32.sp,
                          color: AppColors.blackColor,
                        ),
                      ),
                      backgroundColor: backgroundColor,
                      elevation: 0,
                      actions: [
                        SvgIconButton(
                            onPressed: () {
                              controller.isSearchEnable.value = true;
                            },
                            svg: Assets.images.searchIcon.svg()),
                        SizedBox(width: 10.w)
                      ],
                    ),
            ),
          ),
        ));
  }

  Widget searchWidget(Color backgroundColor) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: SizedBox(
          height: AppBar().preferredSize.height,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  controller.isSearchEnable.value = false;
                  controller.searchController.clear();
                  controller.searchData.clear();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              Expanded(
                child: Card(
                  child: CustomTextField(
                    autoFocus: true,
                    align: TextAlignVertical.center,
                    height: 40,
                    onChanged: (value) {
                      controller.searchCall(value);
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                    controller: controller.searchController,
                    inputBorder: OutlineInputBorder(
                        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10.sp)),
                    prefixIcon: null,
                    suffixIcon: InkWell(onTap: () {}, child: Assets.images.searchIcon.svg()),
                    hintText: '${'search'.tr}...', suffixIconPadding: 0,
                  ),
                ),
              ),
              SizedBox(width: 20.w)
            ],
          ),
        ),
      ),
    );
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
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.yellow),
            height: 50.w,
            width: 50.w,
            child: LoadImage(
                imageModel: ImageModel(
                    assetImage: false,
                    placeHolderPath: Assets.images.defaultProfile.path,
                    imagePath: "${preferenceService.getAmazonUrl()}${data.image ?? ''}",
                    loadingIndicator: SizedBox(
                        height: 25.h,
                        width: 25.w,
                        child: const CircularProgressIndicator(color: Color(0XFFFDD48E), strokeWidth: 2)))),
          )),
      title: CustomText(
        data.name ?? '',
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      subtitle: Row(
        children: [
          // index % 2 == 0
          //     ? Assets.images.chatSingleTick.svg()
          //     : index % 3 == 0
          //     ? Assets.images.chatDoubleTick.svg()
          //     : const SizedBox(),
          // if (index % 2 == 0 || index % 3 == 0) const SizedBox(width: 4),
          // index % 2 != 0
          //     ? Assets.images.chatImage.svg(
          //     height: 16, width: 16, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn))
          //     : index % 3 != 0
          //     ? Assets.images.chatDoc.svg(
          //     height: 16,
          //     width: 16,
          //     colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn))
          //     : const SizedBox(),
          // if (index % 2 != 0 || index % 3 != 0) const SizedBox(width: 4),
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
