import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_button.dart';
import 'package:divine_astrologer/common/custom_text.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/video_call_page/video_call_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallPage extends GetView<VideoCallPageController> {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.blackColor.withOpacity(0.7),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // assistUI(),
              // closeButton(),
              acceptUI(),
              closeButton(color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget acceptUI() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 80.h),
                  Assets.images.icBoyKundli.svg(width: 128.w),
                  SizedBox(height: 20.h),
                  CustomText(
                    'Customer Name',
                    fontSize: 20.sp,
                    fontColor: AppColors.appYellowColour,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 5.h),
                  CustomText(
                    'wants to do video call with you!',
                    fontSize: 20.sp,
                    fontColor: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 24.h),
                  const Divider(color: AppColors.lightGrey),
                  SizedBox(height: 24.h),
                  detailRow('Name', 'Vimal Gosain'),
                  detailRow('Gender', 'Male'),
                  detailRow('DOB', '16-April-1998'),
                  detailRow('POB', 'New Delhi, New Delhi, Delhi, India'),
                  detailRow('TOB', '9:30 PM'),
                  detailRow('Marital Status', 'Single'),
                  detailRow('Problem Area', 'Love and Relationship'),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => Get.toNamed(RouteName.videoCall),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.lightYellow,
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                  ),
                  child: CustomText(
                    'Accept',
                    fontSize: 20.sp,
                    fontColor: AppColors.brownColour,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detailRow(String title, String data, {bool isLast = false}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomText(
                title,
                fontSize: 16.sp,
                fontColor: AppColors.white,
              ),
            ),
            SizedBox(width: 14.w),
            CustomText(
              '-',
              fontSize: 16.sp,
              fontColor: AppColors.white,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: CustomText(
                data,
                fontSize: 16.sp,
                fontColor: AppColors.white,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        if (!isLast) SizedBox(height: 20.h),
      ],
    );
  }

  Widget closeButton({Color color = AppColors.blackColor}) {
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: double.maxFinite,
      child: Row(
        children: [
          SizedBox(width: 8.w),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: color),
          ),
        ],
      ),
    );
  }

  Widget assistUI() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 80.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Assets.images.bgChatUserPro
                        .image(width: 96, fit: BoxFit.cover),
                  ),
                  SizedBox(height: 20.h),
                  CustomText(
                    'Astrologer Name',
                    fontSize: 20.sp,
                    fontColor: AppColors.appYellowColour,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 5.h),
                  CustomText(
                    'is ready to assist you!',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 24.h),
                  const Divider(color: AppColors.lightGrey),
                  SizedBox(height: 24.h),
                  CustomText(
                    'Specialty',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: AppColors.appYellowColour,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    'Vedic, Numerology, Vastu, Tarot and Prashana.',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.grey,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  CustomText(
                    'Language',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: AppColors.appYellowColour,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    'Hindi, English, Tamil and Telugu',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.grey,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  CustomText(
                    'Experience',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: AppColors.appYellowColour,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    '10 years of experience',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.grey,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => CustomButton(
                      onTap: () {
                        controller.muteValue.value =
                            !controller.muteValue.value;
                      },
                      padding: EdgeInsets.all(17.h),
                      radius: 50.r,
                      border: Border.all(color: AppColors.darkBlue, width: 4),
                      color: controller.muteValue.value
                          ? AppColors.darkBlue
                          : AppColors.white,
                      child: Assets.svg.mute.svg(
                          width: 30,
                          colorFilter: ColorFilter.mode(
                              controller.muteValue.value
                                  ? AppColors.white
                                  : AppColors.darkBlue,
                              BlendMode.srcIn)),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Obx(
                    () => CustomButton(
                      onTap: () {
                        controller.videoValue.value =
                            !controller.videoValue.value;
                      },
                      padding: EdgeInsets.all(17.h),
                      radius: 50.r,
                      border: Border.all(color: AppColors.darkBlue, width: 4),
                      color: controller.videoValue.value
                          ? AppColors.darkBlue
                          : AppColors.white,
                      child: Assets.svg.videoMute.svg(
                          width: 30,
                          colorFilter: ColorFilter.mode(
                              controller.videoValue.value
                                  ? AppColors.white
                                  : AppColors.darkBlue,
                              BlendMode.srcIn)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Get.toNamed(RouteName.videoCall);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.lightYellow,
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                      ),
                      child: CustomText(
                        'Start Video Call',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.brownColour,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ZegoInviteButton extends StatelessWidget {
  final bool isVideoCall;

  const ZegoInviteButton({super.key, required this.isVideoCall});

  @override
  Widget build(BuildContext context) {
    return ZegoSendCallInvitationButton(
      onPressed: (String code, String message, List<String> list) {},
      isVideoCall: isVideoCall,
      resourceID: "zegouikit_call", // For offline call notification
      invitees: [
        ZegoUIKitUser(
          id: '2',
          name: 'Astrologer',
        ),
        ZegoUIKitUser(
          id: '1',
          name: 'Customer',
        ),
      ],
    );
  }
}
