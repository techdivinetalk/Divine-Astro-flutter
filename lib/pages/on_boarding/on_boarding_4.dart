import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/routes.dart';
import '../../gen/fonts.gen.dart';
import 'on_boarding_controller.dart';

class OnBoarding4Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingController());
  }
}

class OnBoarding4 extends GetView<OnBoardingController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      builder: (OnBoardingController controller) {
        return Scaffold(
          backgroundColor: appColors.white,
          appBar: AppBar(
            backgroundColor: AppColors().white,
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: IconButton(
                visualDensity: const VisualDensity(horizontal: -4),
                constraints: BoxConstraints.loose(Size.zero),
                icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            titleSpacing: 0,
            title: Text(
              "Onboarding Process",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: appColors.darkBlue,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: pageWidget("3"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Basic\nDetails",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.black.withOpacity(0.7),
                        ),
                      ),
                      buildSpace(),
                      Text(
                        "Upload\nDocuments",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.black.withOpacity(0.7),
                        ),
                      ),
                      buildSpace(),
                      Text(
                        "Upload\nPictures",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.black.withOpacity(0.7),
                        ),
                      ),
                      buildSpace(),
                      Text(
                        "Signing\nAgreement",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.black.withOpacity(0.7),
                        ),
                      ),
                      buildSpace(),
                      Text(
                        "Awaiting\nApproval",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Astrologer’s Agreement",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.black,
                      ),
                    ),
                  ),
                ),
                Text("""
                This Agreement is made on this [Date] by and between:
            Party 1: [Name of First Party/Company], having its registered office at [Address] (hereinafter referred to as “First Party”),
            AND
            Party 2: [Name of Second Party/Company], having its registered office at [Address] (hereinafter referred to as “Second Party”).
            WHEREAS:
            The First Party is engaged in [brief description of the business or purpose of the agreement].
            The Second Party agrees to provide [brief description of the service/product/partnership].
            NOW, THEREFORE, the parties agree as follows:
            1. Scope of Work:
            The Second Party shall provide [details of services/products to be delivered] as per the specifications set forth in Annexure A (if applicable).
            2. Term:
            This Agreement shall commence on [Start Date] and shall continue until [End Date/Completion of the project], unless terminated earlier in accordance with this Agreement.
            3. Payment Terms:
            The First Party shall pay the Second Party [Amount] for the services/products provided as per the payment schedule in Annexure B (if applicable).
            4. Confidentiality:
            Both parties agree to keep all confidential information exchanged during this Agreement private and not to disclose it to any third party.
            5. Termination:
            Either party may terminate this Agreement by giving [Notice Period] days’ written notice to the other party.
            6. Governing Law:
            This Agreement shall be governed by and construed in accordance with the laws of [Jurisdiction/State/Country].
            7. Dispute Resolution:
            Any dispute arising from this Agreement shall be resolved through [Arbitration/Court Proceedings] in [Jurisdiction].
            8. Miscellaneous:
            Any amendments to this Agreement must be in writing and signed by both parties.
            This Agreement constitutes the entire understanding between the parties.
            IN WITNESS WHEREOF, the parties have executed this Agreement as of the day and year first above writte[Title]
            
            This Agreement is made on this [Date] by and between:
            Party 1: [Name of First Party/Company], having its registered office at [Address] (hereinafter referred to as “First Party”),
            AND
            Party 2: [Name of Second Party/Company], having its registered office at [Address] (hereinafter referred to as “Second Party”).
            WHEREAS:
            The First Party is engaged in [brief description of the business or purpose of the agreement].
            The Second Party agrees to provide [brief description of the service/product/partnership].
            NOW, THEREFORE, the parties agree as follows:
            1. Scope of Work:
            The Second Party shall provide [details of services/products to be delivered] as per the specifications set forth in Annexure A (if applicable).
            2. Term:
            This Agreement shall commence on [Start Date] and shall continue until [End Date/Completion of the project], unless terminated earlier in accordance with this Agreement.
            3. Payment Terms:
            The First Party shall pay the Second Party [Amount] for the services/products provided as per the payment schedule in Annexure B (if applicable).
            4. Confidentiality:
            Both parties agree to keep all confidential information exchanged during this Agreement private and not to disclose it to any third party.
            5. Termination:
            Either party may terminate this Agreement by giving [Notice Period] days’ written notice to the other party.
            6. Governing Law:
            This Agreement shall be governed by and construed in accordance with the laws of [Jurisdiction/State/Country].
            7. Dispute Resolution:
            Any dispute arising from this Agreement shall be resolved through [Arbitration/Court Proceedings] in [Jurisdiction].
            8. Miscellaneous:
            Any amendments to this Agreement must be in writing and signed by both parties.
            This Agreement constitutes the entire understanding between the parties.
            IN WITNESS WHEREOF, the parties have executed this Agreement as of the day and year first above writte[Title]
                """),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 110,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: RichText(
                      text: TextSpan(
                        text:
                            '* Confused? Don’t worry, We are here to help you! ',
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: appColors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: 'Click here for a tutorial video.',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.poppins,
                              fontWeight: FontWeight.w400,
                              color: appColors.red,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle tap
                                print('Link tapped');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.submittingDetails();
                          Get.toNamed(
                            RouteName.onBoardingScreen5,
                          );
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: appColors.red,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "I Accept",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                                color: AppColors().white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget pageWidget(page) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
            color: AppColors().red,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors().red,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "1",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.white,
          ),
        ),
      ),
      buildLine(isActive: true),
      Container(
        decoration: BoxDecoration(
            color: AppColors().red,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors().red,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "2",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: AppColors().white,
          ),
        ),
      ),
      buildLine(isActive: true),
      Container(
        decoration: BoxDecoration(
            color: AppColors().red,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors().red,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "3",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.white,
          ),
        ),
      ),
      buildLine(isActive: true),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.red,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "4",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.red,
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "5",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey,
          ),
        ),
      ),
    ],
  );
}

Widget buildLine({required bool isActive}) {
  return Expanded(
    child: Container(
      height: 2,
      color: isActive ? Colors.red : Colors.grey,
    ),
  );
}

Widget buildSpace() {
  return Expanded(
    child: Container(
      height: 2,
    ),
  );
}
