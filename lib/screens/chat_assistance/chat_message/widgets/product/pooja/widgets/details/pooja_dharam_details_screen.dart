import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../../../../../../common/appbar.dart';
import '../../../../../../../../common/colors.dart';
import '../../../../../../../../common/common_functions.dart';
import '../../../../../../../../di/shared_preference_service.dart';
import '../../../../../../../../repository/shop_repository.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../home_screen_options/notice_board/notice_board_ui.dart';
import '../../../../../../../live_dharam/widgets/custom_image_widget.dart';
import '../../pooja_dharam/get_single_pooja_response.dart';
import '../custom_widget/pooja_add_one_widget.dart';
import '../custom_widget/pooja_common_list.dart';
import '../custom_widget/pooja_custom_button.dart';
import '../custom_widget/pooja_loader.dart';
import 'pooja_dharam_details_controller.dart';

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this._tabBar);

  final Widget _tabBar;

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(child: _tabBar);
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class PoojaDharamDetailsScreen extends StatefulWidget {
  const PoojaDharamDetailsScreen({super.key});

  @override
  State<PoojaDharamDetailsScreen> createState() =>
      _PoojaDharamDetailsScreenState();
}

class _PoojaDharamDetailsScreenState extends State<PoojaDharamDetailsScreen>
    with AfterLayoutMixin<PoojaDharamDetailsScreen>, TickerProviderStateMixin {
  final PoojaDharamDetailsController _controller = Get.find();
  final SharedPreferenceService pref = Get.put(SharedPreferenceService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        title: "Pooja Details",
        trailingWidget: SizedBox(width: 16),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (
            BuildContext context,
            bool innerBoxIsScrolled,
          ) {
            return <Widget>[
              SliverAppBar(
                leading: const SizedBox(),
                pinned: false,
                // collapsedHeight: Get.height / 4,
                expandedHeight: Get.height / 4,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(
                      () {
                        final GetSinglePoojaResponseData getSinglePooja =
                            _controller.getSinglePooja.data ??
                                GetSinglePoojaResponseData();
                        final List<Pooja> poojaList =
                            getSinglePooja.pooja ?? [];

                        String image = "";

                        if (poojaList.isNotEmpty) {
                          final firstPooja = poojaList.first;
                          final startPoint = pref.getAmazonUrl() ?? "";
                          final endPoint = firstPooja.poojaBannerImage ?? "";
                          final String poojaImg = "$startPoint$endPoint";
                          image = poojaImg;
                        } else {}

                        return _controller.isLoading
                            ? const PoojaLoader()
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: image == ""
                                    ? Image.asset(
                                        'assets/images/pooja_banner.png',
                                        fit: BoxFit.fill,
                                      )
                                    : CustomImageWidget(
                                        imageUrl: image,
                                        rounded: false,
                                        typeEnum: TypeEnum.pooja,
                                      ),
                              );
                      },
                    ),
                  ),
                  stretchModes: const [StretchMode.zoomBackground],
                ),
              ),
              SliverPersistentHeader(
                delegate: MySliverPersistentHeaderDelegate(const SizedBox()),
                pinned: true,
              ),
            ];
          },
          body: Obx(
                () {
              if (_controller.isLoading) {
                return const PoojaLoader();
              } else {
                return mainWidget();
              }
            },
          ),

        ),
      ),
    );
  }

  Widget mainWidget() {
    final Pooja pooja =
    _controller.getSinglePooja.data?.pooja?.isNotEmpty == true ? _controller.getSinglePooja.data!.pooja!.first : Pooja();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    pooja.poojaName ?? "",
                    style: TextStyle(
                      color: appColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "₹${pooja.poojaStartingPriceInr ?? ""}",
                        style: TextStyle(
                          color: appColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 16),
                      (pooja.cashbackType ?? 0) != 0
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: const Color(0xff5F3C08),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ((pooja.cashbackType ?? 0) == 1)
                                      ? "${pooja.cashbackValue}% Cashback"
                                      : ((pooja.cashbackType ?? 0) == 2)
                                          ? "${pooja.cashbackValue}₹ Cashback"
                                          : "",
                                  style: TextStyle(
                                    color: appColors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "About Pooja",
                    style: TextStyle(
                      color: appColors.guideColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ExpandableHtml(
                    htmlData: pooja.poojaDesc ?? "",
                    trimLength: 500,
                    // color: appColors.guideColor,
                  ),
                  const SizedBox(height: 16),
                  // Text(
                  //   "Select Pooja Date and Timing.",
                  //   style: TextStyle(
                  //     color: appColors.guideColor,
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: pickerWidget(
                  //         image: "assets/images/pooja_new_date.png",
                  //         string: _controller.selectedDate.isNotEmpty
                  //             ? _controller.selectedDate
                  //             : "Date",
                  //         dialogTitleText: "Select Pooja Date",
                  //         dialogButtonText: "Select",
                  //         pickerStyle: "DateCalendar",
                  //         onConfirm: (String value) {
                  //           _controller.selectedDate = value;
                  //           setState(() {});
                  //         },
                  //       ),
                  //     ),
                  //     // const SizedBox(width: 16),
                  //     Expanded(
                  //       child: pickerWidget(
                  //         image: "assets/images/pooja_new_time.png",
                  //         string: _controller.selectedTime.isNotEmpty
                  //             ? _controller.selectedTime
                  //             : "Time",
                  //         dialogTitleText: "Select Pooja Time",
                  //         dialogButtonText: "Select",
                  //         pickerStyle: "TimeCalendar",
                  //         onConfirm: (String value) {
                  //           _controller.selectedTime = value;
                  //           setState(() {});
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 16),
                  // Text(
                  //   _controller.getSelectedAddOnesList().isEmpty
                  //       ? "Do you want any add-ons?"
                  //       : "Selected Add-Ons",
                  //   style: TextStyle(
                  //     color: appColors.guideColor,
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // PoojaCommonList(
                  //   list: _controller.getSelectedAddOnesList(),
                  //   scrollPhysics: const NeverScrollableScrollPhysics(),
                  //   onTap: () {
                  //     setState(() {});
                  //   },
                  // ),
                  // const SizedBox(height: 16),
                  // PoojaCustomButton(
                  //   height: 48,
                  //   text: _controller.getSelectedAddOnesList().isEmpty
                  //       ? "Select Add-Ons"
                  //       : "Add More",
                  //   backgroundColor: appColors.green,
                  //   fontColor: appColors.white,
                  //   needCircularBorder: true,
                  //   onPressed: () async {
                  //     await poojaAddOnePopup();
                  //     setState(() {});
                  //   },
                  // ),
                  // const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_controller.isSentMessage.value == false)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PoojaCustomButton(
              height: 64,
              text: "Recommended Pooja",
              backgroundColor: appColors.guideColor,
              fontColor: appColors.whiteGuidedColor,
              needCircularBorder: false,
              onPressed: () async {
                Map<String, dynamic> params = {
                  "product_id": pooja.id,
                  "shop_id": 0,
                  "customer_id":AppFirebaseService().orderData.value["userId"] != null ? int.parse(AppFirebaseService().orderData.value["userId"]):_controller.customerId.value,
                  "order_id":AppFirebaseService().orderData.value["orderId"]
                };
                var response =
                    await ShopRepository().saveRemediesForChatAssist(params);
                Get.back();
                Get.back();
                Get.back(result: {
                  'isPooja': true,
                  'poojaData': pooja,
                  'saveRemediesData': response
                });
                // if (_controller.selectedDate.isEmpty) {
                //   divineSnackBar(data: "Please Select Pooja Date");
                // } else if (_controller.selectedTime.isEmpty) {
                //   divineSnackBar(data: "Please Select Pooja Time");
                // } else {
                //   _controller.assignGlobalSelectedPooja();
                //   _controller.assignGlobalSelectedAddOnesList();
                //   _controller.assignGlobalPoojaDateTimeModel();
                //   await Get.toNamed(RouteName.addressViewScreen);
                // }
              },
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget pickerWidget({
    required String image,
    required String string,
    required String dialogTitleText,
    required String dialogButtonText,
    required String pickerStyle,
    required Function(String value) onConfirm,
  }) {
    return Expanded(
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          side: BorderSide(color: appColors.grey, width: 1.0),
        ),
        child: InkWell(
          onTap: () async {
            await Utils.selectDateOrTime(
              title: dialogTitleText,
              btnTitle: dialogButtonText,
              pickerStyle: pickerStyle,
              onChange: (String value) {},
              onConfirm: onConfirm,
              looping: true,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(
                  image,
                  height: 16,
                  width: 16,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 4),
                Text(
                  string,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> poojaAddOnePopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return PoojaAddOneWidget(
          onClose: Get.back,
          addOnesList: (_controller.getPoojaAddOnes.data ?? []),
        );
      },
    );
    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    if (_controller.getSinglePooja.data?.pooja?.isEmpty ?? true) {
      _controller.getSinglePoojaCall(
        successCallBack: (message) => {},
        failureCallBack: (message) => divineSnackBar(data: message),
      );
    } else {}
    if (_controller.getPoojaAddOnes.data?.isEmpty ?? true) {
      _controller.getPoojaAddOnesCall(
        successCallBack: (message) => {},
        failureCallBack: (message) => divineSnackBar(data: message),
      );
    } else {}
    return Future<void>.value();
  }
}
