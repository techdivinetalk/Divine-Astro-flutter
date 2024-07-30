import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
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
  const NoticeBoardUi({super.key});

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
              border: Border.all(color: appColors.guideColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: CustomText(
                      title ?? "",
                      fontWeight: FontWeight.w500,
                      fontColor: appColors.darkBlue,
                      maxLines: 2,
                      fontSize: 16.sp,
                    ),
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
  final bool? isExpanded;

  const ExpandableHtml({
    Key? key,
    required this.htmlData,
    this.trimLength = 100,
    this.isExpanded,
  }) : super(key: key);

  @override
  State<ExpandableHtml> createState() => _ExpandableHtmlState();
}

class _ExpandableHtmlState extends State<ExpandableHtml>
    with AutomaticKeepAliveClientMixin {
  bool _isExpanded = false;

  String get trimmedText =>
      _isExpanded || widget.htmlData.length <= widget.trimLength
          ? widget.htmlData
          : '${widget.htmlData.substring(0, widget.trimLength)}...';

  @override
  void initState() {
    if (widget.isExpanded != null) {
      _isExpanded = widget.isExpanded ?? false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        Html(
          shrinkWrap: true,
          data: trimmedText,
          onLinkTap: (url, attributes, element) {
            launchUrl(Uri.parse(url ?? ''));
          },
        ),
        if (widget.htmlData.length > widget.trimLength)
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? "Read Less" : "Read More",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: appColors.blackColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ExpandableHtmlView extends StatelessWidget {
  final String htmlData;
  final Color? color;
  final String prodDesc;

  const ExpandableHtmlView({
    Key? key,
    required this.htmlData,
    this.color,
    required this.prodDesc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Html(
          data: htmlData,
          onLinkTap: (url, attributes, element) {
            launchUrl(Uri.parse(url ?? ''));
          },
        ),
      ],
    );
  }
}
