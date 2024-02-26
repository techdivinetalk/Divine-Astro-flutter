import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/appbar.dart';
import '../../../../../common/colors.dart';
import '../../../../../common/common_functions.dart';
import '../../../../../common/custom_widgets.dart';
import '../../../../../common/routes.dart';
import '../../../../../di/shared_preference_service.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../live_dharam/widgets/custom_image_widget.dart';
import '../../../../live_page/constant.dart';
import 'poojaDetailController.dart';
import 'pooja_dharam/get_booked_pooja_response.dart';
import 'pooja_dharam/get_pooja_response.dart';
import 'widgets/custom_widget/pooja_loader.dart';

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this.widget);

  final Widget widget;

  @override
  double get minExtent => kToolbarHeight + 16;
  @override
  double get maxExtent => kToolbarHeight + 16;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(child: widget);
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class PoojaDharamMainScreen extends StatefulWidget {
  const PoojaDharamMainScreen({super.key});

  @override
  State<PoojaDharamMainScreen> createState() => _PoojaDharamMainScreenState();
}

class _PoojaDharamMainScreenState extends State<PoojaDharamMainScreen>
    with AfterLayoutMixin<PoojaDharamMainScreen>, TickerProviderStateMixin {
  final PoojaDharamMainController _controller = Get.find();
  final SharedPreferenceService pref = Get.put(SharedPreferenceService());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(
      () async {
        if (_tabController.index == 0) {
        } else if (_tabController.index == 1) {
          if ((_controller.getBookedPooja.data?.poojaHistory ?? []).isEmpty) {
            await getBookedPoojaCall();
          } else {}
        } else {}
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        title: "Pooja",
        trailingWidget: Row(
          children: [
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Assets.images.icSearch.svg(
                  colorFilter: ColorFilter.mode(
                    appColors.textColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (
            BuildContext context,
            bool innerBoxIsScrolled,
          ) {
            return <Widget>[];
          },
          body: Obx(
            () {
              return _controller.isLoading ? const PoojaLoader() : gridWidget();
            },
          ),
        ),
      ),
    );
  }

  Widget tabBarText({required String text}) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: appColors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget listWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _controller.getBookedPooja.data?.poojaHistory?.length,
        itemBuilder: (BuildContext context, int index) {
          final PoojaHistory poojaHistory =
              _controller.getBookedPooja.data?.poojaHistory?[index] ??
                  PoojaHistory();
          final startPoint = pref.getAmazonUrl() ?? "";
          final endPoint = poojaHistory.getPooja?.poojaImg ?? "";
          final String poojaImg = "$startPoint$endPoint";
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: Get.height / 5,
              width: double.infinity,
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () async {
                    await Get.toNamed(
                      RouteName.poojaDharamDetailsScreen,
                      arguments: {'detailOnly':false,'data': poojaHistory.getPooja?.id ?? 0,}
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 64,
                              width: 64,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CustomImageWidget(
                                  imageUrl: poojaImg,
                                  rounded: false,
                                  typeEnum: TypeEnum.pooja,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                poojaHistory.getPooja?.poojaName ?? "",
                                style: TextStyle(
                                  color: appColors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                              ),
                              Text(
                                poojaHistory.createdAt ?? "",
                                style: TextStyle(
                                  color: appColors.black,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                "Pooja Timing: ${getPoojaDateAndTime(poojaHistory)}",
                                style: TextStyle(
                                  color: appColors.black,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                "Pooja Status: ${getPoojaType(poojaHistory)}",
                                style: TextStyle(
                                  color: appColors.black,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                "Price: ₹${poojaHistory.getPooja?.poojaStartingPriceInr ?? ""}",
                                style: TextStyle(
                                  color: appColors.black,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "#${poojaHistory.orderId ?? ""}",
                                    style: TextStyle(
                                      color: appColors.black,
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: IconButton(
                                      style: IconButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      icon: Icon(
                                        Icons.download_outlined,
                                        size: 16,
                                        color: appColors.black,
                                      ),
                                      onPressed: () async {
                                        await clipboardFunc(poojaHistory);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 84,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 32,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    side: BorderSide(
                                      width: 1.0,
                                      color: appColors.red,
                                    ),
                                  ),
                                  onPressed: navigateToWhatsapp,
                                  child: Text(
                                    "Help?",
                                    style: TextStyle(
                                      color: appColors.red,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 32,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    side: BorderSide(
                                      width: 1.0,
                                      color: appColors.black,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.download_outlined,
                                        size: 16,
                                        color: appColors.black,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Invoice",
                                        style: TextStyle(
                                          color: appColors.black,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: appColors.guideColor,
                                ),
                                onPressed: () async {
                                  await Get.toNamed(
                                    RouteName.poojaDharamDetailsScreen,
                                    arguments:{'detailOnly':false,'data': poojaHistory.getPooja?.id ?? 0,}
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 4),
                                    Text(
                                      "View Order",
                                      style: TextStyle(
                                        color: appColors.black,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String getPoojaType(PoojaHistory history) {
    String temp = "";
    switch (history.type ?? "") {
      case "completed_pooja":
        temp = "Completed";
        break;
      case "pending_pooja":
        temp = "Pending";
        break;
      default:
        temp = "";
        break;
    }
    return temp;
  }

  String getPoojaDateAndTime(PoojaHistory history) {
    final String appointmentDate = history.appointmentDate ?? "";
    final String appointmentTime = history.appointmentTime ?? "";
    return "$appointmentDate $appointmentTime";
  }

  Future<void> clipboardFunc(PoojaHistory history) async {
    await Clipboard.setData(ClipboardData(text: "#${history.orderId ?? ""}"));

    if (mounted) {
      String msg = "Copied to clipboard";
      SnackBar snackBar = SnackBar(content: Text(msg));
      ScaffoldMessengerState state = ScaffoldMessenger.of(context);
      state.showSnackBar(snackBar);
    } else {}
    return Future<void>.value();
  }

  Widget gridWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DynamicHeightGridView(
        shrinkWrap: true,
        itemCount: _controller.getPooja.data?.pooja?.length ?? 0,
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        rowCrossAxisAlignment: CrossAxisAlignment.center,
        builder: (BuildContext context, int index) {
          final GetPoojaResponse resp = _controller.getPooja;
          final GetPoojaResponseData data = resp.data ?? GetPoojaResponseData();
          final Pooja pooja = data.pooja?[index] ?? Pooja();
          final startPoint = pref.getAmazonUrl() ?? "";
          final endPoint = pooja.poojaImg ?? "";
          final String poojaImg = "$startPoint$endPoint";
          return SizedBox(
            height: Get.height / 2.5,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () async {

                    var route = RouteName.poojaDharamDetailsScreen;
                    var arguments = pooja.id ?? 0;
                    await Get.toNamed(route, arguments: {'detailOnly':false,'data':arguments});
                    await getPoojaCall();
                    await getBookedPoojaCall();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        // height: Get.height / 6,
                        width: double.infinity,
                        child: CustomImageWidget(
                          imageUrl: poojaImg,
                          rounded: false,
                          typeEnum: TypeEnum.pooja,
                        ),
                      ),
                      Text(
                        pooja.poojaName ?? "",
                        style: TextStyle(
                          color: appColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Starting from ₹${pooja.poojaStartingPriceInr ?? ""}",
                        style: TextStyle(
                          color: appColors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: const Color(0xff5F3C08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ((pooja.cashbackType ?? 0) == 1)
                                  ? "Upto ${pooja.cashbackValue}% Cashback"
                                  : ((pooja.cashbackType ?? 0) == 2)
                                      ? "Upto ${pooja.cashbackValue}₹ Cashback"
                                      : "",
                              style: TextStyle(
                                color: appColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> navigateToWhatsapp() async {
    var data = pref.getConstantDetails();
    var contact = data.data?.whatsappNo ?? '';
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      debugPrint('WhatsApp is not installed.');
      Fluttertoast.showToast(msg: "WhatsApp is not installed.");
    }
    return Future<void>.value();
  }

  Future<void> getPoojaCall() async {
    await _controller.getPoojaCall(
      successCallBack: (message) {},
      failureCallBack: (message) => divineSnackBar(data: message),
    );
    return Future<void>.value();
  }

  Future<void> getBookedPoojaCall() async {
    await _controller.getBookedPoojaCall(
      successCallBack: (message) => divineSnackBar(data: message),
      failureCallBack: (message) => divineSnackBar(data: message),
    );
    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    if (_controller.getPooja.data?.pooja?.isEmpty ?? true) {
      await getPoojaCall();
    } else {}
    return Future<void>.value();
  }
}
