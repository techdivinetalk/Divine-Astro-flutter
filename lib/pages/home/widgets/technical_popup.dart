import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/colors.dart';
import '../../../common/common_elevated_button.dart';
import '../../../common/routes.dart';
import '../../../firebase_service/firebase_service.dart';
import '../../../screens/live_page/constant.dart';
import '../home_controller.dart';

Future<void> showTechnicalPopupAlert() async {
  // Ensure the HomeController is available
  if (!Get.isRegistered<HomeController>()) {
    Get.put<HomeController>(HomeController(), permanent: true);
  }

  return Get.dialog(
    barrierDismissible: true,
    Theme(
      data: ThemeData(canvasColor: AppColors().white),
      child: AlertDialog(
        backgroundColor: AppColors().white,
        insetPadding: EdgeInsets.all(16),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
        content: TechnicalPopup(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CommonElevatedButton(
              text: "okay".tr,
              onPressed: () {
                Get.put(HomeController()).changePreviewCode(true);
                previewed.value = 0;
                if (Navigator.of(Get.put(HomeController()).contexts)
                            .overlay
                            ?.context !=
                        null &&
                    previewed.value == 0 &&
                    showCasePreview.value.toString() == "1") {
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                      ShowCaseWidget.of(Get.put(HomeController()).contexts)
                          .startShowCase([Get.put(HomeController()).one]));
                }
                Get.back();
              },
              backgroundColor: AppColors().red,
              borderColor: AppColors().red,
            ),
          ),
        ],
      ),
    ),
  );
}

class TechnicalPopup extends GetView<HomeController> {
  TechnicalPopup({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return controller.homeData?.technical_support == null ||
            controller.homeData?.technical_support == [] ||
            controller.homeData?.technical_support!.isEmpty
        ? SizedBox()
        : Container(
            width: size.width * 0.9,
            decoration: BoxDecoration(
                color: AppColors().white,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListView.builder(
                itemCount: controller.homeData?.technical_support == null ||
                        controller.homeData?.technical_support == [] ||
                        controller.homeData?.technical_support!.isEmpty
                    ? 0
                    : controller.homeData!.technical_support!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var data = controller.homeData!.technical_support![index];
                  var date = DateTime.parse(data['created_at'].toString());
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        if (data['support_type'].toString() == "1") {
                          Get.toNamed(RouteName.allTechnicalIssues);
                        } else if (data['support_type'].toString() == "2") {
                          Get.toNamed(RouteName.allFinancialSupportIssues);
                        } else {
                          Get.toNamed(RouteName.allSupportIssuesScreen);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors().white,
                          border: Border.all(color: AppColors().red),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      // "Ticket No. :  DJF4389483",
                                      "${"ticket_no".tr}. :  ${data['ticket_number'].toString()}",
                                      style: TextStyle(
                                        color: AppColors().grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10, top: 10),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      // "Created : 10-02-2022",
                                      "${"created".tr} : ${date.day}-${date.month}-${date.year}",
                                      style: TextStyle(
                                        color: AppColors().red,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(
                                  bottom: 0, left: 16, top: 0, right: 16),
                              title: Text(
                                // "Ticket Type : Issues (Pending)",
                                "${"ticket_type".tr} : ${data['ticket_type'] ?? ""} ${"( ${data['status_text'] ?? ""} )"}",
                                style: TextStyle(
                                  color: AppColors().black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "${"descriptions".tr} : ${data['description'] ?? ""}",
                                style: TextStyle(
                                  color: AppColors().grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            data['suggestion'] == null
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, bottom: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "${"how_to_solve".tr} :",
                                        style: TextStyle(
                                          color: AppColors().green,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                            data['suggestion'] == null
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 5, right: 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Html(
                                        shrinkWrap: true,
                                        data: data['suggestion'].toString(),
                                        onLinkTap: (url, attributes, element) {
                                          launchUrl(Uri.parse(url ?? ''));
                                        },
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
