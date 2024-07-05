import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../common/colors.dart';
import '../../gen/assets.gen.dart';

class TypingWidget extends StatelessWidget {
  final NewChatController? controller;
  final bool? yourMessage;

  const TypingWidget({super.key, this.controller, this.yourMessage});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Map<String, dynamic> order = {};
      order = AppFirebaseService().orderData.value;
      String imageURL = order["customerImage"] ?? "";
      String appended = "$preferenceService/$imageURL";
      print("img:: $appended");
      return controller!.isTyping.value
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3, right: 5),
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: CustomImageWidget(
                      imageUrl: appended,
                      rounded: true,
                      typeEnum: TypeEnum.user,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffDCDCDC)),
                      color: appColors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "Typing",
                          style: TextStyle(
                            fontFamily: FontFamily.metropolis,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // SizedBox(width: 5),
                        Assets.lottie.loadingDots.lottie(
                            width: 45,
                            height: 30,
                            repeat: true,
                            frameRate:  FrameRate(120),
                            animate: true),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : SizedBox();
    });
  }
}
