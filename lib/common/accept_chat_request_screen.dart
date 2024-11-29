import "package:audioplayers/audioplayers.dart";
import "package:divine_astrologer/app_socket/app_socket.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/common_elevated_button.dart";
import "package:divine_astrologer/common/common_functions.dart";

import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/firebase_service/firebase_service.dart";
import "package:divine_astrologer/gen/assets.gen.dart";
import "package:divine_astrologer/gen/fonts.gen.dart";
import "package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:lottie/lottie.dart";

import "MiddleWare.dart";

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
  // BroadcastReceiver broadcastReceiver =
  //     BroadcastReceiver(names: <String>["EndChat", "backReq"]);
  bool isLoader = false;
  final SharedPreferenceService pref = Get.put(SharedPreferenceService());
  BroadcastReceiver broadcastReceiver =
      BroadcastReceiver(names: <String>["orderEnd"]);
  AudioPlayer? _player;

  @override
  void initState() {
    super.initState();

    print(MiddleWare.instance.currentPage);
    broadcastReceiver.start();
    broadcastReceiver.messages.listen((BroadcastMessage event) {
      if (event.name == "orderEnd") {
        print("orderEnd called going back");
        WidgetsBinding.instance.endOfFrame.then(
          (_) async {
            if (mounted) {
              bool canPop = Navigator.canPop(context);
              if (canPop) {
                Navigator.pop(context);
                broadcastReceiver.stop();
              } else {}
            } else {}
          },
        );
      }
    });
    AppFirebaseService().orderData.listen((p0) {
      if ((p0["status"] ?? "-1") == "0") {
        // print("play the sound");
        playAudio();
      } else {
        // print("stop the sound");
      }
    });
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  playAudio() async {
    if (_player != null) {
      _player?.dispose();
      _player = null;
    }

    _player = AudioPlayer();
    await _player!.setSourceAsset("accept.mp3");

    _player!.play(AssetSource("accept.mp3"));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.white,
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
                              // SizedBox(
                              //     height: 90.w,
                              //     width: 90.w,
                              //     child: CircleAvatar(
                              //         child: Assets.images.avatar
                              //             .svg(height: 60.w, width: 60.w))),

                              Obx(
                                () {
                                  Map<String, dynamic> order = {};
                                  order = AppFirebaseService().orderData.value;
                                  String imageURL =
                                      order["customerImage"] ?? "";
                                  String appended =
                                      "${pref.getAmazonUrl()}/$imageURL";
                                  print("img:: $appended");
                                  return SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: CustomImageWidget(
                                      imageUrl: appended,
                                      rounded: true,
                                      typeEnum: TypeEnum.user,
                                    ),
                                  );
                                },
                              ),

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
                                      color: appColors.textColor)),
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
                                              Text(
                                                  AppFirebaseService()
                                                              .orderData
                                                              .value[
                                                                  "chatAmount"]
                                                              .toString() ==
                                                          "0"
                                                      ? "Free"
                                                      : "PAID",
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
                                            formatMinutesToHoursMinutesSeconds(
                                                (AppFirebaseService()
                                                            .orderData
                                                            .value[
                                                        "max_order_time"]) ??
                                                    0),
                                            softWrap: true,
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
                                              // onPressed: () async {
                                              //   await onPressed();

                                              //   // setState(() {});
                                              // },
                                              onPressed: () async {
                                                await acceptOrRejectChat(
                                                  orderId: AppFirebaseService()
                                                          .orderData
                                                          .value["orderId"] ??
                                                      0,
                                                  queueId: AppFirebaseService()
                                                          .orderData
                                                          .value["queue_id"] ??
                                                      0,
                                                );
                                                AppFirebaseService()
                                                    .database
                                                    .child(
                                                        "order/${AppFirebaseService().orderData.value["orderId"]}")
                                                    .update({"status": "1"});
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
                        child: CircularProgressIndicator(
                            color: appColors.guideColor))
                ],
              );
            })),
      ),
    );
  }

  // Future<void> onPressed() async {
  //   isLoader = true;
  //   try {
  //     await onPressedFunction();
  //     print("onPressed(): onPressedFunction: completed");
  //   } on Exception catch (e) {
  //     print("onPressed(): on Exception catch: $e");
  //   } finally {}
  //   isLoader = false;
  //   return Future<void>.value();
  // }

  // Future<void> onPressedFunction() async {
  //
  // }

  String formatMinutesToHoursMinutesSeconds(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    final remainingSeconds = ((minutes % 60) * 60) % 60;

    // Handle edge cases for negative or zero minutes
    if (minutes < 0) {
      return "${formatMinutesToHoursMinutesSeconds(-minutes)} (negative)";
    } else if (minutes == 0) {
      return "0:00:00";
    }

    // Ensure consistent two-digit format for minutes and seconds
    final formattedMinutes = remainingMinutes.toString().padLeft(2, '0');
    final formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    return '$hours:$formattedMinutes:$formattedSeconds';
  }
}
