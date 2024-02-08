import "package:divine_astrologer/app_socket/app_socket.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/common_elevated_button.dart";
import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/common/routes.dart";
import "package:divine_astrologer/firebase_service/firebase_service.dart";
import "package:divine_astrologer/gen/assets.gen.dart";
import "package:divine_astrologer/gen/fonts.gen.dart";
import "package:flutter/material.dart";
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:lottie/lottie.dart";

acceptChatRequestBottomSheet(BuildContext context,
    {required void Function() onPressed,
    required orderStatus,
    required customerName,
    required dob,
    required placeOfBirth,
    required timeOfBirth,
    required maritalStatus,
    required problemArea,
    required walletBalance,
    required Map<String, dynamic> orderData}) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      constraints:
          BoxConstraints(minHeight: context.mediaQuerySize.height, maxHeight: context.mediaQuerySize.height),
      isDismissible: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: AcceptChatRequestScreen(
                onPressed: onPressed,
                orderStatus: orderStatus,
                customerName: customerName,
                dob: dob,
                placeOfBirth: placeOfBirth,
                timeOfBirth: timeOfBirth,
                maritalStatus: maritalStatus,
                problemArea: problemArea,
                orderData: orderData,
                walletBalance: walletBalance));
      });
}

class AcceptChatRequestScreen extends StatefulWidget {
  final void Function() onPressed;
  final String orderStatus;
  final String customerName;
  final String dob;
  final String placeOfBirth;
  final String timeOfBirth;
  final String maritalStatus;
  final String problemArea;
  final String walletBalance;
  final Map<String, dynamic> orderData;

  const AcceptChatRequestScreen(
      {super.key,
      required this.onPressed,
      required this.orderStatus,
      required this.customerName,
      required this.dob,
      required this.placeOfBirth,
      required this.timeOfBirth,
      required this.maritalStatus,
      required this.problemArea,
      required this.walletBalance,
      required this.orderData});

  @override
  State<AcceptChatRequestScreen> createState() => _AcceptChatRequestScreenState();
}

class _AcceptChatRequestScreenState extends State<AcceptChatRequestScreen> {
  final appFirebaseService = AppFirebaseService();
  final appSocket = AppSocket();
  bool isBottomSheetOpen = false;
  BroadcastReceiver broadcastReceiver = BroadcastReceiver(names: <String>["EndChat","backReq"]);
  bool isLoader = false;

  @override
  void initState() {
    broadcastReceiver.start();
    broadcastReceiver.messages.listen((event) {
      if (event.name == "backReq") {
        Navigator.pop(context);
      }else if (event.name == "EndChat") {
        Get.offAllNamed(RouteName.dashboard);
        broadcastReceiver.stop();
      }
    });

    appFirebaseService.acceptBottomWatcher.nameStream.listen((event) {
      debugPrint('event .... $event');
      isBottomSheetOpen = event == "1";
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            stops: [0.7, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.white, AppColors.appYellowColour]),
      ),
      child: Scaffold(
          backgroundColor: AppColors.transparent,
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
                                child:
                                    CircleAvatar(child: Assets.images.avatar.svg(height: 60.w, width: 60.w))),
                            SizedBox(height: 10.w),
                            Text(widget.customerName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontFamily.metropolis,
                                    fontSize: 20.sp,
                                    color: AppColors.appYellowColour)),
                            Text("Ready to chat with you!",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontFamily.metropolis,
                                    fontSize: 20.sp,
                                    color: AppColors.darkBlue)),
                            SizedBox(height: 10.w),
                            Divider(color: AppColors.darkBlue.withOpacity(0.1)),
                            SizedBox(height: 2.w),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text("name".tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily: FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: AppColors.darkBlue)),
                                      ),
                                      Text("-".tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: FontFamily.metropolis,
                                              fontSize: 16.sp,
                                              color: AppColors.darkBlue)),
                                      Expanded(
                                        flex: 4,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(widget.customerName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: AppColors.darkBlue)),
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
                                                fontFamily: FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: AppColors.darkBlue)),
                                      ),
                                      Text("-".tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: FontFamily.metropolis,
                                              fontSize: 16.sp,
                                              color: AppColors.darkBlue)),
                                      Expanded(
                                        flex: 4,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(widget.dob,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: AppColors.darkBlue)),
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
                                                fontFamily: FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: AppColors.darkBlue)),
                                      ),
                                      Text("-",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: FontFamily.metropolis,
                                              fontSize: 16.sp,
                                              color: AppColors.darkBlue)),
                                      Expanded(
                                        flex: 4,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(widget.placeOfBirth,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: AppColors.darkBlue)),
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
                                                fontFamily: FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: AppColors.darkBlue)),
                                      ),
                                      Text("-",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: FontFamily.metropolis,
                                              fontSize: 16.sp,
                                              color: AppColors.darkBlue)),
                                      Expanded(
                                        flex: 4,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(widget.timeOfBirth,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: AppColors.darkBlue)),
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
                                                fontFamily: FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: AppColors.darkBlue)),
                                      ),
                                      Text("-",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: FontFamily.metropolis,
                                              fontSize: 16.sp,
                                              color: AppColors.darkBlue)),
                                      Expanded(
                                        flex: 4,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(widget.maritalStatus,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: AppColors.darkBlue)),
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
                                                fontFamily: FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: AppColors.darkBlue)),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Text("-",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: AppColors.darkBlue))),
                                      Expanded(
                                          flex: 3,
                                          child: Align(
                                              alignment: Alignment.topRight,
                                              child: Text(widget.problemArea,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: FontFamily.metropolis,
                                                      fontSize: 16.sp,
                                                      color: AppColors.darkBlue))))
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
                        decoration: const BoxDecoration(color: Colors.transparent),
                        child: Column(
                          children: [
                            Divider(thickness: 1, color: AppColors.darkBlue.withOpacity(0.1)),
                            SizedBox(height: 5.w),
                            Text("orderDetails".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontFamily.metropolis,
                                    fontSize: 17.sp,
                                    color: AppColors.brownColour)),
                            SizedBox(height: 15.w),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Assets.svg.orderTypeIcon.svg(height: 30.w, width: 30.w),
                                      SizedBox(width: 8.w),
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text("orderType".tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily: FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: AppColors.darkBlue)),
                                        Text("PAID",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: AppColors.redColor))
                                      ])
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Assets.svg.walletBalanceIcon.svg(height: 30.w, width: 30.w),
                                      SizedBox(width: 8.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("walletBalance".tr,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: AppColors.darkBlue)),
                                          Text("₹${widget.walletBalance}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: FontFamily.metropolis,
                                                  fontSize: 16.sp,
                                                  color: AppColors.brownColour)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25.w),
                            Row(
                              children: [
                                Assets.svg.maximumOrderTimeIcon.svg(height: 30.w, width: 30.w),
                                SizedBox(width: 8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("maximumOrderTime".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: FontFamily.metropolis,
                                            fontSize: 16.sp,
                                            color: AppColors.darkBlue)),
                                    Text(formatTime((AppFirebaseService().orderData.value["max_order_time"] * 1000 * 60) ?? 0),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: FontFamily.metropolis,
                                            fontSize: 16.sp,
                                            color: AppColors.brownColour)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 25.w),
                            isBottomSheetOpen
                                ? Container(
                                    height: kToolbarHeight,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.brown),
                                        borderRadius: BorderRadius.circular(5.r)),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Text("Waiting for user to connect",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFamily: FontFamily.metropolis,
                                              fontSize: 16.sp,
                                              color: AppColors.brownColour)),
                                      Assets.lottie.loadingDots.lottie(
                                          width: 45,
                                          height: 30,
                                          repeat: true,
                                          frameRate: FrameRate(120),
                                          animate: true)
                                    ]))
                                : !isBottomSheetOpen
                                    ? CommonElevatedButton(
                                        showBorder: false,
                                        width: double.infinity,
                                        borderRadius: 5.r,
                                        backgroundColor: AppColors.brownColour,
                                        text: "acceptChatRequest".tr,
                                        onPressed: () async {
                                          try {
                                            isLoader = true;
                                            if (await acceptOrRejectChat(
                                                orderId: int.parse(widget.orderData["orderId"].toString()),
                                                queueId: widget.orderData["queue_id"])) {
                                              isLoader = false;
                                              appFirebaseService.acceptBottomWatcher.strValue = "1";
                                              appFirebaseService.writeData(
                                                  "order/${widget.orderData["orderId"]}", {"status": "1"});
                                              appSocket.sendConnectRequest(
                                                  astroId: widget.orderData["astroId"],
                                                  custId: widget.orderData["userId"]);
                                            }
                                          } on Exception catch (e) {
                                            isLoader = false;
                                            debugPrint(e.toString());
                                          }
                                          setState(() {});
                                        },
                                        // widget.onPressed
                                      )
                                    : const SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoader) const Center(child: CircularProgressIndicator(color: AppColors.yellow))
              ],
            );
          })),
    );
  }
  String formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedTime = "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    return formattedTime;
  }
}
