import "package:divine_astrologer/app_socket/app_socket.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/common_elevated_button.dart";
import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/common/routes.dart";
import "package:divine_astrologer/firebase_service/firebase_service.dart";
import "package:divine_astrologer/gen/assets.gen.dart";
import "package:divine_astrologer/gen/fonts.gen.dart";
import "package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart";
import "package:flutter/material.dart";
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:lottie/lottie.dart";

// acceptChatRequestBottomSheet(BuildContext context,
//     {required void Function() onPressed,
//     required orderStatus,
//     required customerName,
//     required dob,
//     required placeOfBirth,
//     required timeOfBirth,
//     required maritalStatus,
//     required problemArea,
//     required walletBalance,
//     required Map<String, dynamic> orderData}) {
//   showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       context: context,
//       isScrollControlled: true,
//       enableDrag: false,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//       constraints:
//           BoxConstraints(minHeight: context.mediaQuerySize.height, maxHeight: context.mediaQuerySize.height),
//       isDismissible: true,
//       builder: (BuildContext context) {
//         return FractionallySizedBox(
//             widthFactor: 1.0,
//             heightFactor: 1.0,
//             child: AcceptChatRequestScreen(
//                 onPressed: onPressed,
//                 orderStatus: orderStatus,
//                 customerName: customerName,
//                 dob: dob,
//                 placeOfBirth: placeOfBirth,
//                 timeOfBirth: timeOfBirth,
//                 maritalStatus: maritalStatus,
//                 problemArea: problemArea,
//                 orderData: orderData,
//                 walletBalance: walletBalance));
//       });
// }

class AcceptChatRequestScreen extends StatefulWidget {
  // final void Function() onPressed;
  // final String orderStatus;
  // final String customerName;
  // final String dob;
  // final String placeOfBirth;
  // final String timeOfBirth;
  // final String maritalStatus;
  // final String problemArea;
  // final String walletBalance;
  // final Map<String, dynamic> orderData;

  const AcceptChatRequestScreen({
    super.key,
    // required this.onPressed,
    // required this.orderStatus,
    // required this.customerName,
    // required this.dob,
    // required this.placeOfBirth,
    // required this.timeOfBirth,
    // required this.maritalStatus,
    // required this.problemArea,
    // required this.walletBalance,
    // required this.orderData
  });

  @override
  State<AcceptChatRequestScreen> createState() =>
      _AcceptChatRequestScreenState();
}

class _AcceptChatRequestScreenState extends State<AcceptChatRequestScreen> {
  final appFirebaseService = AppFirebaseService();
  final appSocket = AppSocket();
  // bool isBottomSheetOpen = false;
  BroadcastReceiver broadcastReceiver =
      BroadcastReceiver(names: <String>["EndChat", "backReq"]);
  bool isLoader = false;

  @override
  void initState() {
    broadcastReceiver.start();
    broadcastReceiver.messages.listen((event) {
      if (event.name == "backReq") {
        // Navigator.pop(context);
        WidgetsBinding.instance.endOfFrame.then(
          (_) async {
            if (mounted) {
              Navigator.pop(context);
            } else {}
          },
        );
      } else if (event.name == "EndChat") {
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   Get.offAllNamed(RouteName.dashboard);
        // });
        WidgetsBinding.instance.endOfFrame.then(
          (_) async {
            if (mounted) {
              broadcastReceiver.stop();
              Navigator.pop(context);
            } else {}
          },
        );
        
      }
    });

    // appFirebaseService.acceptBottomWatcher.nameStream.listen((event) {
    //   debugPrint('event .... $event');
    //   // isBottomSheetOpen = event == "1";
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: [0.7, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [appColors.white, appColors.appYellowColour]),
        ),
        child: Scaffold(
            backgroundColor: appColors.transparent,
            body: StatefulBuilder(builder: (context, setState) {
              return Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(height: 50.w),
                              SizedBox(
                                  height: 90.w,
                                  width: 90.w,
                                  child: CircleAvatar(
                                      child: Assets.images.avatar
                                          .svg(height: 60.w, width: 60.w))),
                              SizedBox(height: 10.w),
                              Text(
                                  AppFirebaseService()
                                          .orderData
                                          .value["customerName"] ??
                                      "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontFamily.metropolis,
                                      fontSize: 20.sp,
                                      color: appColors.appYellowColour)),
                              Text("Ready to chat with you!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontFamily.metropolis,
                                      fontSize: 20.sp,
                                      color: appColors.darkBlue)),
                              SizedBox(height: 10.w),
                              Divider(
                                  color: appColors.darkBlue.withOpacity(0.1)),
                              SizedBox(height: 2.w),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Text("name".tr,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: appColors.darkBlue)),
                                        ),
                                        Text("-".tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: appColors.darkBlue)),
                                        Expanded(
                                          flex: 4,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                AppFirebaseService()
                                                            .orderData
                                                            .value[
                                                        "customerName"] ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        FontFamily.metropolis,
                                                    fontSize: 16.sp,
                                                    color: appColors.darkBlue)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Text("Date of Birth",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: appColors.darkBlue)),
                                        ),
                                        Text("-".tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: appColors.darkBlue)),
                                        Expanded(
                                          flex: 4,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                AppFirebaseService()
                                                        .orderData
                                                        .value["dob"] ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        FontFamily.metropolis,
                                                    fontSize: 16.sp,
                                                    color: appColors.darkBlue)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Text("Place of Birth",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: appColors.darkBlue)),
                                        ),
                                        Text("-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: appColors.darkBlue)),
                                        Expanded(
                                          flex: 4,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                AppFirebaseService()
                                                            .orderData
                                                            .value[
                                                        "placeOfBirth"] ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        FontFamily.metropolis,
                                                    fontSize: 16.sp,
                                                    color: appColors.darkBlue)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Text("Time of Birth",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: appColors.darkBlue)),
                                        ),
                                        Text("-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: appColors.darkBlue)),
                                        Expanded(
                                          flex: 4,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                AppFirebaseService()
                                                        .orderData
                                                        .value["timeOfBirth"] ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        FontFamily.metropolis,
                                                    fontSize: 16.sp,
                                                    color: appColors.darkBlue)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Text("Marital Status",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: appColors.darkBlue)),
                                        ),
                                        Text("-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: appColors.darkBlue)),
                                        Expanded(
                                          flex: 4,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                AppFirebaseService()
                                                            .orderData
                                                            .value[
                                                        "maritalStatus"] ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        FontFamily.metropolis,
                                                    fontSize: 16.sp,
                                                    color: appColors.darkBlue)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Text("Problem Area",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: appColors.darkBlue)),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text("-",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        FontFamily.metropolis,
                                                    fontSize: 16.sp,
                                                    color:
                                                        appColors.darkBlue))),
                                        Expanded(
                                            flex: 3,
                                            child: Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                    AppFirebaseService()
                                                                .orderData
                                                                .value[
                                                            "problemArea"] ??
                                                        "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: FontFamily
                                                            .metropolis,
                                                        fontSize: 16.sp,
                                                        color: appColors
                                                            .darkBlue))))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.w),
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                          child: Column(
                            children: [
                              Divider(
                                  thickness: 1,
                                  color: appColors.darkBlue.withOpacity(0.1)),
                              SizedBox(height: 5.w),
                              Text("orderDetails".tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontFamily.metropolis,
                                      fontSize: 17.sp,
                                      color: appColors.brownColour)),
                              SizedBox(height: 15.w),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Assets.svg.orderTypeIcon
                                            .svg(height: 30.w, width: 30.w),
                                        SizedBox(width: 8.w),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("orderType".tr,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          FontFamily.metropolis,
                                                      fontSize: 16.sp,
                                                      color:
                                                          appColors.darkBlue)),
                                              Text("PAID",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily:
                                                          FontFamily.metropolis,
                                                      fontSize: 16.sp,
                                                      color:
                                                          appColors.redColor))
                                            ])
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Assets.svg.walletBalanceIcon
                                            .svg(height: 30.w, width: 30.w),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("walletBalance".tr,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          FontFamily.metropolis,
                                                      fontSize: 16.sp,
                                                      color:
                                                          appColors.darkBlue)),
                                              Text(
                                                  AppFirebaseService()
                                                              .orderData
                                                              .value[
                                                          "walletBalance"] ??
                                                      "",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily:
                                                          FontFamily.metropolis,
                                                      fontSize: 16.sp,
                                                      color: appColors
                                                          .brownColour)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25.w),
                              Row(
                                children: [
                                  Assets.svg.maximumOrderTimeIcon
                                      .svg(height: 30.w, width: 30.w),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("maximumOrderTime".tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: appColors.darkBlue)),
                                        Text(
                                            formatMinutesToHoursMinutes(
                                                (AppFirebaseService()
                                                            .orderData
                                                            .value[
                                                        "max_order_time"]) ??
                                                    0),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: appColors.brownColour)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25.w),
                              Obx(
                                () {
                                  return (AppFirebaseService()
                                                  .orderData
                                                  .value["status"] ??
                                              "-1") ==
                                          "1"
                                      ? Container(
                                          height: kToolbarHeight,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: appColors.brown),
                                              borderRadius:
                                                  BorderRadius.circular(5.r)),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    "Waiting for user to connect",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: FontFamily
                                                            .metropolis,
                                                        fontSize: 16.sp,
                                                        color: appColors
                                                            .brownColour)),
                                                Assets.lottie.loadingDots
                                                    .lottie(
                                                        width: 45,
                                                        height: 30,
                                                        repeat: true,
                                                        frameRate:
                                                            FrameRate(120),
                                                        animate: true)
                                              ]))
                                      : (AppFirebaseService()
                                                      .orderData
                                                      .value["status"] ??
                                                  "-1") ==
                                              "0"
                                          ? CommonElevatedButton(
                                              showBorder: false,
                                              width: double.infinity,
                                              borderRadius: 5.r,
                                              backgroundColor:
                                                  appColors.brownColour,
                                              text: "acceptChatRequest".tr,
                                              onPressed: () async {
                                                await onPressed();

                                                setState(() {});
                                              },
                                              // widget.onPressed
                                            )
                                          : const SizedBox();
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoader)
                    Center(
                        child:
                            CircularProgressIndicator(color: appColors.yellow))
                ],
              );
            })),
      ),
    );
  }

  Future<void> onPressed() async {
    isLoader = true;
    try {
      await onPressedFunction();
      print("onPressed(): onPressedFunction: completed");
    } on Exception catch (e) {
      print("onPressed(): on Exception catch: $e");
    } finally {}
    isLoader = false;
    return Future<void>.value();
  }

  Future<void> onPressedFunction() async {
    final bool isAccepted = await acceptOrRejectChat(
      orderId: AppFirebaseService().orderData.value["orderId"] ?? 0,
      queueId: AppFirebaseService().orderData.value["queue_id"] ?? 0,
    );
    print("onPressedFunction() isAccepted: $isAccepted");

    appFirebaseService.acceptBottomWatcher.strValue = "1";
    print(
        "onPressedFunction() acceptBottomWatcher: ${appFirebaseService.acceptBottomWatcher.currentName}");

    final bool perm = await AppPermissionService.instance.hasAllPermissions();
    print("onPressedFunction() perm: ${perm}");

    await appFirebaseService.writeData(
      "order/${AppFirebaseService().orderData.value["orderId"] ?? 0}",
      {"status": "1", "astrologer_permission": perm},
    );
    print("onPressedFunction() writeData: Done");

    appSocket.sendConnectRequest(
      astroId: AppFirebaseService().orderData.value["astroId"] ?? "",
      custId: AppFirebaseService().orderData.value["userId"] ?? "",
    );
    print("onPressedFunction() sendConnectRequest: Done");
    return Future<void>.value();
  }

  String formatMinutesToHoursMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    // Handle edge cases for negative or zero minutes
    if (minutes < 0) {
      return "${formatMinutesToHoursMinutes(-minutes)} (negative)";
    } else if (minutes == 0) {
      return "0:00";
    }

    // Ensure consistent two-digit format for minutes
    final formattedMinutes = remainingMinutes.toString().padLeft(2, '0');

    return '$hours:$formattedMinutes';
  }
}
