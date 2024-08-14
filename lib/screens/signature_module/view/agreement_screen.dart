import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/screens/signature_module/controller/agreement_controller.dart';
import 'package:divine_astrologer/screens/signature_module/view/signature_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
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
              Expanded(
                child: FutureBuilder<String>(
                  future: controller.pdfPath,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading PDF'));
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: PDFView(
                          filePath: snapshot.data!,
                          fitEachPage: false,
                          fitPolicy: FitPolicy.BOTH,
                          autoSpacing: false,
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: CommonButton(
                    backgroundColor: !controller.isLastPage
                        ? appColors.greyColor.withOpacity(0.4)
                        : appColors.guideColor,
                    buttonText: "Sign Your Agreement",
                    buttonCallback: () {
                      if (controller.isLastPage) {
                        Get.to(() => SignatureView());
                      } else {
                        divineSnackBar(data: "Please read full agreement");
                      }
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
