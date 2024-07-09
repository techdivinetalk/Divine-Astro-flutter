import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/support/chat_support/widgets/chat_support_popup.dart';
import 'package:divine_astrologer/screens/support/chat_support/widgets/message_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/helper_widgets.dart';
import '../../../model/chat_assistant/chat_assistant_chats_response.dart';
import 'chat_support_controller.dart';

class ChatSupportScreen extends GetView<ChatSupportController> {
  ChatSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatSupportController>(
      init: ChatSupportController(UserRepository()),
      builder: (_) {
        return Scaffold(
          appBar: appbarSmall1(
              context, "Customer Support", "You are Talking to Paras Shah"),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  child: controller.loading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.chatMessageList.isEmpty
                          ? SizedBox(
                              height: 100,
                              child: HelpersWidget().emptyChatWidget())
                          : Align(
                              alignment: Alignment.topCenter,
                              child: ListView.builder(
                                itemCount: controller.chatMessageList.length,
                                reverse: true,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final reversedChatList = controller
                                      .chatMessageList.value.reversed
                                      .toList();

                                  final currentMsg = reversedChatList[index];
                                  final nextIndex =
                                      reversedChatList.length - 1 == index
                                          ? index
                                          : index + 1;
                                  return SupportMessagView(
                                    index: index,
                                    length: reversedChatList.length,
                                    chatMessage:
                                        controller.chatMessageList[index],
                                    nextMessage:
                                        controller.chatMessageList[nextIndex],
                                    yourMessage: currentMsg['sendBy'] ==
                                        SendBy.astrologer,
                                    // argumentId: controller.args?.id.toString(),
                                    pref: controller.pref.getUserDetail()?.id,
                                    engageType: controller.engageType,
                                    controller: controller,
                                  );
                                },
                              )),
                ),
              ),
              SizedBox(width: 15.w),
              controller.isReview.value == true
                  ? controller.ratedData == null
                      ? RatingWidget(context)
                      : RatedWidget(context)
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              // height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: Color.fromRGBO(243, 243, 243, 1),
                              ),
                              child: TextFormField(
                                controller: controller.textEditingController,
                                onChanged: (value) {
                                  controller.update();
                                },
                                maxLines: null,
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                style: AppTextStyle.textStyle16(
                                  fontWeight: FontWeight.w400,
                                  fontColor: AppColors().grey,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Type Something...",
                                  hintStyle: AppTextStyle.textStyle16(
                                    fontWeight: FontWeight.w400,
                                    fontColor: AppColors().grey,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        context: context,
                                        builder: (context) => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                    border: Border.all(
                                                        color:
                                                            AppColors().white),
                                                    color: Colors.transparent),
                                                child: Icon(
                                                  Icons.close_rounded,
                                                  color: appColors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            selectAttachFileType(context),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.attach_file),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  fillColor: AppColors().lightGrey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(22),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(22),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(22),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          controller.textEditingController.text.isEmpty
                              ? SizedBox()
                              : SizedBox(
                                  width: 10,
                                ),
                          controller.textEditingController.text.isEmpty
                              ? SizedBox()
                              : IconButton(
                                  onPressed: () {
                                    controller.sendMessage();
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: AppColors().appRedColour,
                                  ),
                                ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  RatedWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color.fromRGBO(255, 249, 250, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Your Reviews",
            style: AppTextStyle.textStyle20(
                fontWeight: FontWeight.w600, fontColor: AppColors().black),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors().appRedColour,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: AppColors().appRedColour,
                      size: 45,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        controller.ratedData['username'].toString(),
                        style: AppTextStyle.textStyle14(
                            fontWeight: FontWeight.w600,
                            fontColor: AppColors().black),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Align(
                        alignment: Alignment.center,
                        child: AbsorbPointer(
                          absorbing: true,
                          child: RatingBar(
                            size: 20,
                            filledColor: AppColors().appRedColour,
                            initialRating: controller.ratedData['rating'],
                            alignment: Alignment.centerLeft,
                            filledIcon: CupertinoIcons.star_fill,
                            emptyIcon: CupertinoIcons.star,
                            onRatingChanged: (rating) {},
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, bottom: 10, right: 14),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      controller.ratedData['description'].toString(),
                      textAlign: TextAlign.start,
                      // maxLines: 3,
                      overflow: TextOverflow.clip,
                      style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors().black, width: 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      "Edit Review".tr,
                      style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w600,
                        fontColor: appColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  RatingWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color.fromRGBO(255, 249, 250, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Your Reviews",
            style: AppTextStyle.textStyle20(
                fontWeight: FontWeight.w600, fontColor: AppColors().black),
          ),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: RatingBar(
              filledColor: AppColors().appRedColour,
              initialRating: controller.rating.value,
              alignment: Alignment.center,
              filledIcon: CupertinoIcons.star_fill,
              emptyIcon: CupertinoIcons.star,
              onRatingChanged: (rating) {
                controller.rating.value = rating;
                controller.updateRating(rating);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors().white,
              ),
              child: TextFormField(
                controller: controller.ratingTextController,
                onChanged: (value) {
                  controller.update();
                },
                style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                  fontColor: AppColors().black,
                ),
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.text,
                maxLength: 160,
                onFieldSubmitted: (value) {},
                decoration: InputDecoration(
                  hintText: "Write your review here...",
                  hintStyle: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w400,
                    fontColor: AppColors().grey,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  fillColor: AppColors().lightGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          controller.rating.value == 0.0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: appColors.extraLightGrey,
                        border: Border.all(
                            color: AppColors().extraLightGrey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            "Submit".tr,
                            style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w600,
                              fontColor: appColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      controller.submitRating();
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: appColors.appRedColour,
                        border: Border.all(
                            color: AppColors().appRedColour, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            "Submit".tr,
                            style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w600,
                              fontColor: appColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  selectAttachFileType(context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50.0)),
        border: Border.all(color: Colors.white, width: 2),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 14,
          ),
          Text(
            "Choose Options",
            style: AppTextStyle.textStyle20(
                fontWeight: FontWeight.w600, fontColor: AppColors().black),
          ),
          Text(
            "Only photos can be shared",
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w400, fontColor: AppColors().grey),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: CommonImageView(
                        imagePath: "assets/images/camera.png",
                        height: 80,
                        width: 80,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Camera",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle16(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors().black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Capture an image from your camera",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors().lightGrey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: CommonImageView(
                        imagePath: "assets/images/gallery.png",
                        height: 80,
                        width: 80,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Gallery",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle16(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors().black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Select an image from your gallery",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors().lightGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

appbarSmall1(BuildContext context, String title, String subTitle,
    {PreferredSizeWidget? bottom, Color? backgroundColor}) {
  return AppBar(
    backgroundColor: backgroundColor ?? AppColors().white,
    bottom: bottom,
    forceMaterialTransparency: true,
    automaticallyImplyLeading: false,
    centerTitle: true,
    leading: Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: IconButton(
        visualDensity: const VisualDensity(horizontal: -4),
        constraints: BoxConstraints.loose(Size.zero),
        icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
        onPressed: () {
          Get.dialog(
            barrierDismissible: false,
            Theme(
              data: ThemeData(canvasColor: AppColors().transparent),
              child: WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  backgroundColor: AppColors().white,
                  insetPadding: EdgeInsets.all(16),
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 0,
                  content: WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: ChatSupportPopup(),
                  ),
                ),
              ),
            ),
          );

          // Navigator.pop(context);
        },
      ),
    ),
    titleSpacing: 0,
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyle.textStyle14(
              fontWeight: FontWeight.w600, fontColor: AppColors().black),
        ),
        Text(
          subTitle,
          style: AppTextStyle.textStyle12(
              fontWeight: FontWeight.w400, fontColor: AppColors().black),
        ),
      ],
    ),
    // centerTitle: true,
  );
}
