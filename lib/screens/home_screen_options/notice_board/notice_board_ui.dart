import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/common_bottomsheet.dart';
import '../../../model/notice_response.dart';
import 'notice_board_controller.dart';

class NoticeBoardUi extends GetView<NoticeBoardController> {
  const NoticeBoardUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(title: "noticeBoard".tr),
      body: Padding(
        padding: EdgeInsets.only(
          left: 20.sp,
          right: 20.sp,
          top: 10.sp,
        ),
        child: GetBuilder<NoticeBoardController>(
          builder: (controller) {
            if (controller.loading == Loading.loading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(Colors.yellow),
                ),
              );
            }

            if (controller.loading == Loading.loaded) {
              return ListView.separated(
                controller: controller.earningScrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controller.noticeList.length,
                itemBuilder: (context, index) {
                  final data = controller.noticeList[index];
                  return noticeBoardDetail(
                    onTap: () {
                      Get.toNamed(RouteName.noticeDetail,
                          arguments: data, parameters: {"from_list": "1"});
                    },
                    title: data.title.toString(),
                    date: data.createdAt,
                    description: data.description.toString(),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15.sp),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget noticeBoardDetail({
    required String? title,
    required DateTime? date,
    required String? description,
    required VoidCallback? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 12.h),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3.0,
                  offset: Offset(0.0, 3.0),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              border: Border.all(color: appColors.lightYellow)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title ?? "",
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.darkBlue),
                  ),
                  Text(
                    '${dateToString(date ?? DateTime.now(), format: "h:mm a")}  '
                    '${formatDateTime(date ?? DateTime.now())} ',
                    style: AppTextStyle.textStyle10(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue),
                  ),
                ],
              ),
              ExpandableHtml(
                htmlData: description ?? "",
                trimLength: 100,
              ),
            ],
          ),
        ),
      );
}

class ExpandableHtml extends StatefulWidget {
  final String htmlData;
  final int trimLength;

  const ExpandableHtml({
    Key? key,
    required this.htmlData,
    this.trimLength = 100,
  }) : super(key: key);

  @override
  _ExpandableHtmlState createState() => _ExpandableHtmlState();
}

class _ExpandableHtmlState extends State<ExpandableHtml> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String trimmedText =
        widget.htmlData.length > widget.trimLength && !_isExpanded
            ? widget.htmlData.substring(0, widget.trimLength) + '...'
            : widget.htmlData;

    return Column(
      children: [
        Html(
          data: trimmedText,
          onLinkTap: (url, attributes, element) {
            launchUrl(Uri.parse(url ?? ''));
          },
        ),
        widget.htmlData.length > widget.trimLength
            ? Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? "Show Less" : "Show More",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: appColors.blackColor,
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
