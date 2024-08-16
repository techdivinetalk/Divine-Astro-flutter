import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/screens/signature_module/controller/agreement_controller.dart';
import 'package:divine_astrologer/screens/signature_module/view/face_verification_screen.dart';
import 'package:divine_astrologer/screens/signature_module/view/signature_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../pages/home/passbook/htmlWidget.dart';
import '../../live_dharam/widgets/common_button.dart';

class AgreementScreen extends GetView<AgreementController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AgreementController>(
      assignId: true,
      init: AgreementController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            forceMaterialTransparency: true,
            backgroundColor: appColors.white,
            title: Text("Agreement",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                )),
          ),
          body: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  controller.stageMessage,
                  style: const TextStyle(
                    fontFamily: FontFamily.metropolis,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: controller.pdfPath != null
                    ? FutureBuilder<String>(
                        future: controller.pdfPath,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error loading PDF'));
                          } else {
                            return SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: PDFView(
                                filePath: snapshot.data!,
                                fitEachPage: false,
                                fitPolicy: FitPolicy.BOTH,
                                autoSpacing: false,
                                onError: (error) {
                                  print(
                                      "objectobjectobjectobjectobject--${error}");
                                },
                                onPageChanged: (page, total) {
                                  print("totalpage---$total");
                                  print("page---$page");
                                  if (total == (page! + 1)) {
                                    controller.isLastPage = true;
                                  } else {
                                    controller.isLastPage = false;
                                  }
                                  controller.update();
                                },

                                // pageFling: true,
                                // pageSnap: true,
                              ),
                            );
                          }
                        },
                      )
                    : SizedBox(),
              ),
              (controller.pdfPath != null &&
                          controller.exclusiveAgreementStages == 0) ||
                      controller.exclusiveAgreementStages == 1 ||
                      controller.exclusiveAgreementStages == 4
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: CommonButton(
                          backgroundColor: !controller.isLastPage
                              ? appColors.greyColor.withOpacity(0.4)
                              : appColors.guideColor,
                          buttonText: "Sign Your Agreement",
                          buttonCallback: () {
                            if (controller.isLastPage) {
                              Get.to(() => const FaceVerificationScreen());
                            } else {
                              divineSnackBar(
                                  data: "Please read full agreement");
                            }
                          }),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
