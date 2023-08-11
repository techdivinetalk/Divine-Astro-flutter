import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/app_textstyle.dart';
import '../../gen/assets.gen.dart';
import 'chat_message_controller.dart';

class ChatMessageUI extends GetView<ChatMessageController> {
  const ChatMessageUI({super.key});

  @override
  Widget build(BuildContext context) {
    // final messages = [
    //   'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    //   'This is a short message.',
    //   'This is a relatively longer line of text.',
    //   'Hi!'
    // ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightYellow,
        centerTitle: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: Assets.images.bgChatUserPro.image(
                fit: BoxFit.cover,
                height: 32.r,
                width: 32.r,
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            Text(
              "Customer Name",
              style: AppTextStyle.textStyle16(
                  fontWeight: FontWeight.w500,
                  fontColor: AppColors.brownColour),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Assets.images.bgChatWallpaper.image(
              width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
          Column(
            children: [
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(12.h),
                        child: Column(
                          children: [
                            //right view
                            rightView(context),
                            SizedBox(
                              height: 10.h,
                            ),
                            leftView(context),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              chatBottomBar()
            ],
          ),
        ],
      ),
    );
  }

  Widget leftView(BuildContext context) {
    return SizedBox(
      // width: MediaQuery.of(context).size.width * 75,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3.0,
                  offset: const Offset(0.0, 3.0)),
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lorem Ipsum is simply dummy text of the printing.",
                  style: AppTextStyle.textStyle14(
                      fontColor: AppColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "06:41 PM",
                      style: AppTextStyle.textStyle10(
                          fontColor: AppColors.darkBlue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rightView(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 75,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3.0,
                  offset: const Offset(0.0, 3.0)),
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              children: [
                Text(
                  "This is an automated message to confirm that chat has started.",
                  style: AppTextStyle.textStyle14(
                      fontColor: AppColors.appRedColour),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "06:41 PM",
                      style: AppTextStyle.textStyle10(
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Assets.images.icSingleTick.svg()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chatBottomBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    // height: 50.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 3.0,
                              offset: const Offset(0.3, 3.0)),
                        ]),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: "viewAll".tr,
                        helperStyle: AppTextStyle.textStyle16(),
                        fillColor: AppColors.white,
                        hintStyle: AppTextStyle.textStyle16(
                            fontColor: AppColors.greyColor),
                        hoverColor: AppColors.white,
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(6.w, 5.h, 6.w, 8.h),
                          child: Assets.images.icEmoji.svg(),
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(0.w, 9.h, 10.w, 10.h),
                          child: Assets.images.icAttechment.svg(),
                        ),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              color: AppColors.white,
                              width: 1.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              color: AppColors.appYellowColour,
                              width: 1.0,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Assets.images.icSendMsg.svg(height: 48.h)
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }
}
