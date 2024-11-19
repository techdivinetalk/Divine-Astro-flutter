import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/screens/support_issue/support_all_issues/support_all_issue_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/app_textstyle.dart';
import '../../../repository/user_repository.dart';

class AllSupportIssuesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportIssuesListController>(
        () => SupportIssuesListController(UserRepository()));
  }
}

class AllSupportIssuesScreen extends GetView<SupportIssuesListController> {
  AllSupportIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportIssuesListController>(
      init: SupportIssuesListController(UserRepository()),
      builder: (_) {
        return Scaffold(
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
              "all_issues".tr,
              style: AppTextStyle.textStyle16(),
            ),
            // centerTitle: true,
          ),
          body: controller.isTechnicalLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : controller.technicalIssuesList == null ||
                      controller.technicalIssuesList!.data!.isEmpty
                  ? Center()
                  : Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ListView.builder(
                        itemCount: controller.technicalIssuesList!.data!.length,
                        itemBuilder: (context, index) {
                          var data =
                              controller.technicalIssuesList!.data![index];
                          var date = DateTime.parse(data.createdAt.toString());
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors().white,
                                  border: Border.all(color: AppColors().red),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              "${"ticket_no".tr}. :  ${data.ticketNumber.toString()}",
                                              style: TextStyle(
                                                color: AppColors().grey,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, top: 10),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
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
                                          bottom: 0,
                                          left: 16,
                                          top: 0,
                                          right: 16),
                                      title: Text(
                                        "${"ticket_type".tr} : ${data.ticketType} ${"( ${data.statusText.toString()} )"}",
                                        style: TextStyle(
                                          color: AppColors().black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${"descriptions".tr} : ${data.description}",
                                        style: TextStyle(
                                          color: AppColors().grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      // trailing: Icon(
                                      //   Icons.arrow_forward_ios_sharp,
                                      //   color: AppColors().grey,
                                      //   size: 14,
                                      // ),
                                    ),
                                    data.supportImages!.isEmpty
                                        ? SizedBox()
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "${"image_added".tr} :",
                                                style: TextStyle(
                                                  color: AppColors().grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                    data.supportImages!.isEmpty
                                        ? SizedBox()
                                        : Align(
                                            alignment: Alignment.topLeft,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ...data.supportImages!.map(
                                                      (e) => CommonImageView(
                                                        height: 60,
                                                        width: 50,
                                                        imagePath:
                                                            "${controller.preference.getAmazonUrl()}/${e.image.toString()}",
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                    data.suggestion == null
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
                                    data.suggestion == null
                                        ? SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, bottom: 5, right: 10),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Html(
                                                shrinkWrap: true,
                                                data:
                                                    data.suggestion.toString(),
                                                onLinkTap:
                                                    (url, attributes, element) {
                                                  launchUrl(
                                                      Uri.parse(url ?? ''));
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
      },
    );
  }
}
