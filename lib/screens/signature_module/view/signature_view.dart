import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/common_button.dart';
import 'package:divine_astrologer/screens/signature_module/controller/agreement_controller.dart';
import 'package:divine_astrologer/screens/signature_module/controller/signature_controller.dart';
import 'package:divine_astrologer/screens/signature_module/widget/siganture_textfiled.dart';
import 'package:divine_astrologer/screens/signature_module/widget/signature_draw_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';

class SignatureView extends GetView<SignatureController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignatureController>(
      assignId: true,
      init: SignatureController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            forceMaterialTransparency: true,
            backgroundColor: appColors.white,
            title: Text("Your Signature",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                )),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: SignatureTextFiled(
                  //           onChanged: (value) {
                  //             if(value.isEmpty){
                  //               // controller.isRegenerate = false;
                  //               controller.update();
                  //             }
                  //           },
                  //           controller: controller.signature,
                  //           onTap: (){
                  //             // controller.resetScreen();
                  //           },
                  //         ),
                  //       ),
                  //       SizedBox(width: 10),
                  //       GestureDetector(
                  //         onTap: () async {
                  //
                  //         },
                  //         child: Container(
                  //           height: 45,
                  //           width: 45,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10.0),
                  //             color: appColors.guideColor,
                  //           ),
                  //           child: Icon(
                  //             Icons.send_outlined,
                  //             color: appColors.white,
                  //             // size: controller.isAILoading ? 30.0 : 25.0,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SignatureDrawContainer(
                    isRadius: controller.isRadius,
                    screenshotController: controller.screenshotController,
                    signatureKey: controller.signaturePadKey,
                    minimumStrokeWidth: controller.minimumStrokeWidth,
                    maximumStrokeWidth: controller.minimumStrokeWidth,
                    strokeColor: controller.selectedStrokeColor,
                    backgroundColor: controller.selectedBackgroundColor,
                    ContainerColor: controller.containerColor,
                    backgroundImage: controller.selectedBackgroundImage,
                    onDraw: (o, d) {
                      // controller.resetScreen();
                      controller.update();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CommonButton(
                        buttonText: "Submit",
                        buttonCallback: () {
                          controller.saveDrawSignature();
                        }),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
