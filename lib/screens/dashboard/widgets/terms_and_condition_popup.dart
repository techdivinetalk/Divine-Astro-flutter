import 'package:divine_astrologer/common/custom_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/colors.dart';
import '../../../common/common_elevated_button.dart';
import '../../../common/common_functions.dart';
import '../../../common/custom_widgets.dart';
import '../../../repository/pre_defind_repository.dart';
import '../dashboard_controller.dart';

Future<void> showRecommendedPopupAlert() async {
  return Get.dialog(
    barrierDismissible: false,
    Theme(
      data: ThemeData(canvasColor: AppColors().transparent),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          backgroundColor: AppColors().transparent,
          insetPadding: EdgeInsets.all(16),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          elevation: 0,
          content: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: StartPopUp()),
        ),
      ),
    ),
  );
}

class StartPopUp extends GetView<DashboardController> {
  StartPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<DashboardController>(
        init: DashboardController(PreDefineRepository()),
        initState: (_) {},
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  color: AppColors().white,
                  child: Container(
                    // height: size.height * 0.45,
                    width: size.width * 0.8,
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 200,
                            width: size.width * 0.8,
                            child: Center(
                              child: Html(
                                shrinkWrap: true,
                                data: controller.commonConstants.data
                                        .notice['message'] ??
                                    "",
                                onLinkTap: (url, attributes, element) {
                                  launchUrl(Uri.parse(url ?? ''));
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(() {
                            return CheckboxListTile(
                              checkColor: AppColors().white,
                              activeColor: AppColors().appRedColour,
                              title: CustomText(
                                  controller.commonConstants.data
                                      .notice['check_box_text']
                                      .toString(),
                                  fontSize: 18,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.clip),
                              value: controller.isChecked.value,
                              onChanged: (bool? value) {
                                controller.toggleCheckbox();
                              },
                            );
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                          controller.isLoading.value == true
                              ? const Center(
                                  child: LoadingWidget(),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 20),
                                  child: CommonElevatedButton(
                                    text: controller.commonConstants.data
                                        .notice['button_name']
                                        .toString(),
                                    onPressed: () {
                                      if (controller.isChecked.value == true) {
                                        controller.postAcceptTerms(controller
                                            .commonConstants.data.notice['id']);
                                      } else {
                                        divineSnackBar(
                                            data: "Accept the condition");
                                      }
                                    },
                                    backgroundColor: AppColors().red,
                                    borderColor: AppColors().red,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
