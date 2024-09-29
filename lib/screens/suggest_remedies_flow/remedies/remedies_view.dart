import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/screens/remedies/controller/remedies_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RemediesView extends GetView<RemediesController> {
  const RemediesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: appColors.white,
        title: Text("Remedies",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: appColors.darkBlue,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            5.verticalSpace,
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: appColors.white,
                      // border: Border.all(color: appColors.guideColor),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x260E2339),
                          blurRadius: 6,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 96.0,
                          width: 96.0,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                        ),
                        12.horizontalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                "Mritunjay Puja",
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              fontColor: appColors.black,
                            ),
                            4.verticalSpace,
                            CustomText(
                              "Listed Price : ₹6000",
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              fontColor: appColors.black,
                            ),
                            16.verticalSpace,
                            CustomText(
                              "Approved",
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              fontColor: appColors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
              },),
            ),
            5.verticalSpace,
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12.0),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: appColors.guideColor,
              ),
              child: CustomText(
                  "Suggest",
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                fontColor: appColors.white,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 10.0),
          ],
        ),
      ),
    );
  }
}
