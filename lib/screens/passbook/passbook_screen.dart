import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/screens/passbook/passbook_controller.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassbookScreen extends GetView<PassbookController> {
  const PassbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PassbookController>(
      assignId: true,
      init: PassbookController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              leadingWidth: 30,
              backgroundColor: appColors.white,
              surfaceTintColor: appColors.white,
              leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              title: CustomText('Passbook'.tr)),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        String startDate = await Utils()
                            .flutterDatePicker(firstDate: DateTime(1950));
                        if (startDate.isNotEmpty) {}
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: appColors.greyColor2,
                            )),
                        alignment: Alignment.center,
                        child: const Text(
                          "Start Date",
                          style: TextStyle(
                            fontFamily: FontFamily.metropolis,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        String endDate = await Utils()
                            .flutterDatePicker(firstDate: DateTime(1950));
                        if (endDate.isNotEmpty) {}
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: appColors.greyColor2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "End Date",
                          style: TextStyle(
                            fontFamily: FontFamily.metropolis,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
/*Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: appColors.greyColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "LifeTime",
                        style: TextStyle(
                          fontFamily: FontFamily.metropolis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: appColors.greyColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Monthly",
                        style: TextStyle(
                          fontFamily: FontFamily.metropolis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: appColors.greyColor2,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Weekly",
                  style: TextStyle(
                    fontFamily: FontFamily.metropolis,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: appColors.greyColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Bonus",
                        style: TextStyle(
                          fontFamily: FontFamily.metropolis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: appColors.greyColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Paid",
                        style: TextStyle(
                          fontFamily: FontFamily.metropolis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: appColors.greyColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Ecom",
                        style: TextStyle(
                          fontFamily: FontFamily.metropolis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: appColors.greyColor2,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Daily",
                  style: TextStyle(
                    fontFamily: FontFamily.metropolis,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: appColors.greyColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Bonus",
                        style: TextStyle(
                          fontFamily: FontFamily.metropolis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: appColors.greyColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Paid",
                        style: TextStyle(
                          fontFamily: FontFamily.metropolis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: appColors.greyColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Ecom",
                        style: TextStyle(
                          fontFamily: FontFamily.metropolis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),*/
}
