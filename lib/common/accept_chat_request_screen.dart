import "dart:convert";
import "dart:developer";

import "package:audioplayers/audioplayers.dart";
import "package:camera/camera.dart";
import "package:divine_astrologer/app_socket/app_socket.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/common_elevated_button.dart";
import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/common/custom_widgets.dart";
import "package:divine_astrologer/di/api_provider.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/firebase_service/firebase_service.dart";
import "package:divine_astrologer/gen/assets.gen.dart";
import "package:divine_astrologer/gen/fonts.gen.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import "package:lottie/lottie.dart";
import "package:permission_handler/permission_handler.dart";

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

class _AcceptChatRequestScreenState extends State<AcceptChatRequestScreen>
    with WidgetsBindingObserver {
  final appFirebaseService = AppFirebaseService();
  final appSocket = AppSocket();
  bool isLoader = false;
  final SharedPreferenceService pref = Get.put(SharedPreferenceService());
  AudioPlayer? _player;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initCamera();
    print(MiddleWare.instance.currentPage);

    AppFirebaseService().orderData.listen((p0) {
      if ((p0["status"] ?? "-1") == "0") {
        // print("play the sound");
        playAudio();
      } else {
        // print("stop the sound");
      }
    });
  }

  bool isCheckPermission = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (isAstrologerPhotoChatCall.value == 1) {
      setState(() {
        if (state == AppLifecycleState.paused) {
          if ((cameraController == null ||
                  !cameraController!.value.isInitialized) &&
              !isCheckPermission) {
            isCheckPermission = true;
          }
        } else {
          if (isCheckPermission) {
            isCheckPermission = false;
            initCamera(isOpenSetting: false);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player?.dispose();
    cameraController?.dispose();
    super.dispose();
  }

  Future<bool> requestCameraAndMicPermissions(
      {bool isOpenSetting = true}) async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted) {
      return true;
    } else if (statuses[Permission.camera]!.isPermanentlyDenied ||
        statuses[Permission.microphone]!.isPermanentlyDenied) {
      if (isOpenSetting) {
        Get.bottomSheet(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(40.0)),
                color: appColors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                20.verticalSpace,
                Icon(
                  Icons.query_builder_rounded,
                  color: appColors.red,
                  size: 60.h,
                ),
                10.verticalSpace,
                const CustomText(
                  "please allow camera and microphone permissions for accept chat request",
                  fontSize: 16.0,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
                10.verticalSpace,
                CommonButton(
                    buttonText: "Open setting",
                    buttonCallback: () {
                      Get.back();
                      openAppSettings();
                    }),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 20.0),
              ],
            ),
          ),
        );
      }
      return false;
    } else {
      return false;
    }
  }

  CameraController? cameraController;
  Future initCamera({bool isOpenSetting = true}) async {
    if (isAstrologerPhotoChatCall.value == 1) {
      bool isPermission =
          await requestCameraAndMicPermissions(isOpenSetting: isOpenSetting);
      if (isPermission) {
        List<CameraDescription> cameras = await availableCameras();
        cameraController = CameraController(cameras[1], ResolutionPreset.high);
        try {
          await cameraController?.initialize().then((_) {
            if (!mounted) return;
            setState(() {});
          });
        } on CameraException catch (e) {
          debugPrint("camera error $e");
        }
      }
    }
  }

  playAudio() async {
    if (_player != null) {
      _player?.dispose();
      _player = null;
    }
    //
    // _player = AudioPlayer();
    // await _player!.setSourceAsset("accept.mp3");
    //
    // _player!.play(AssetSource("accept.mp3"));
    // if (mounted) {
    //   setState(() {});
    // }
  }

  String? imageLink;
  bool isLoading = false;
  uploadImage(imageFile) async {
    isLoading = true;
    setState(() {});
    var token = preferenceService.getToken();
    log("image length - ${imageFile.path}");

    var uri = Uri.parse("${ApiProvider.imageBaseUrl}uploadImage");

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));
    request.fields.addAll({"module_name": "astrologer_call_chat_image"});

    print("request : ${request.fields}");
    var response = await request.send();

    // Listen for the response
    log(response.toString());
    // Listen for the response
    response.stream.transform(utf8.decoder).listen((value) async {
      print("value ----> $value");
      if (value.isEmpty) {
        // isLoading(false);
        isLoading = false;
      }
      log("Astrologer image : ${jsonDecode(value)["data"]["full_path"].toString()}");
      imageLink = jsonDecode(value)["data"]["full_path"].toString();
      await acceptOrRejectChat(
        orderId: AppFirebaseService().orderData.value["orderId"] ?? 0,
        queueId: AppFirebaseService().orderData.value["queue_id"] ?? 0,
        astrologerImageLink: imageLink,
      );
    });

    if (response.statusCode == 200) {
      print("Image uploaded successfully.");
      // uploadStory(uploadedStory.toString());
    } else {
      print("Failed to upload image.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
            // color: appColors.white,
            ),
        child: Scaffold(
            backgroundColor: appColors.transparent,
            body: StatefulBuilder(builder: (context, setState) {
              return Stack(
                children: [
                  (cameraController != null &&
                          cameraController!.value.isInitialized)
                      ? LayoutBuilder(builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            child: CameraPreview(cameraController!),
                          );
                        })
                      : Container(
                          color: Colors.white,
                        ),
                  Container(
                    color: (cameraController != null &&
                            cameraController!.value.isInitialized)
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white,
                  ),
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
                                      color: cameraController != null
                                          ? appColors.white
                                          : appColors.darkBlue)),
                              Text("Ready to chat with you!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontFamily.metropolis,
                                      fontSize: 20.sp,
                                      color: cameraController != null
                                          ? appColors.white
                                          : appColors.darkBlue)),
                              SizedBox(height: 10.w),
                              Divider(
                                  color: cameraController != null
                                      ? appColors.white
                                      : appColors.darkBlue.withOpacity(0.1)),
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
                                                  color: cameraController !=
                                                          null
                                                      ? appColors.white
                                                      : appColors.darkBlue)),
                                        ),
                                        Text("-".tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: cameraController != null
                                                    ? appColors.white
                                                    : appColors.darkBlue)),
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
                                                    color: cameraController !=
                                                            null
                                                        ? appColors.white
                                                        : appColors.darkBlue)),
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
                                                  color: cameraController !=
                                                          null
                                                      ? appColors.white
                                                      : appColors.darkBlue)),
                                        ),
                                        Text("-".tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: cameraController != null
                                                    ? appColors.white
                                                    : appColors.darkBlue)),
                                        Expanded(
                                          flex: 4,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                AppFirebaseService()
                                                        .orderData
                                                        .value["dob"] ??
                                                    "",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        FontFamily.metropolis,
                                                    fontSize: 16.sp,
                                                    color: cameraController !=
                                                            null
                                                        ? appColors.white
                                                        : appColors.darkBlue)),
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
                                                  color: cameraController !=
                                                          null
                                                      ? appColors.white
                                                      : appColors.darkBlue)),
                                        ),
                                        Text("-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: cameraController != null
                                                    ? appColors.white
                                                    : appColors.darkBlue)),
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
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        FontFamily.metropolis,
                                                    fontSize: 16.sp,
                                                    color: cameraController !=
                                                            null
                                                        ? appColors.white
                                                        : appColors.darkBlue)),
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
                                                  color: cameraController !=
                                                          null
                                                      ? appColors.white
                                                      : appColors.darkBlue)),
                                        ),
                                        Text("-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: cameraController != null
                                                    ? appColors.white
                                                    : appColors.darkBlue)),
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
                                                    color: cameraController !=
                                                            null
                                                        ? appColors.white
                                                        : appColors.darkBlue)),
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
                                                  color: cameraController !=
                                                          null
                                                      ? appColors.white
                                                      : appColors.darkBlue)),
                                        ),
                                        Text("-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16.sp,
                                                color: cameraController != null
                                                    ? appColors.white
                                                    : appColors.darkBlue)),
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
                                                    color: cameraController !=
                                                            null
                                                        ? appColors.white
                                                        : appColors.darkBlue)),
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
                                                  color: cameraController !=
                                                          null
                                                      ? appColors.white
                                                      : appColors.darkBlue)),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text("-",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        FontFamily.metropolis,
                                                    fontSize: 16.sp,
                                                    color: cameraController !=
                                                            null
                                                        ? appColors.white
                                                        : appColors.darkBlue))),
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
                                                        color:
                                                            cameraController !=
                                                                    null
                                                                ? appColors
                                                                    .white
                                                                : appColors
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
                                  color: cameraController != null
                                      ? appColors.white
                                      : appColors.darkBlue.withOpacity(0.1)),
                              SizedBox(height: 5.w),
                              Text("orderDetails".tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontFamily.metropolis,
                                      fontSize: 17.sp,
                                      color: cameraController != null
                                          ? appColors.white
                                          : appColors.brownColour)),
                              SizedBox(height: 15.w),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Assets.svg.orderTypeIcon.svg(
                                            height: 30.w,
                                            width: 30.w,
                                            color: cameraController != null
                                                ? appColors.white
                                                : null),
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
                                                      color: cameraController !=
                                                              null
                                                          ? appColors.white
                                                          : appColors
                                                              .darkBlue)),
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
                                        Assets.svg.walletBalanceIcon.svg(
                                            height: 30.w,
                                            width: 30.w,
                                            color: cameraController != null
                                                ? appColors.white
                                                : null),
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
                                                      color: cameraController !=
                                                              null
                                                          ? appColors.white
                                                          : appColors
                                                              .darkBlue)),
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
                                                      color: cameraController !=
                                                              null
                                                          ? appColors.white
                                                          : appColors
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
                                  Assets.svg.maximumOrderTimeIcon.svg(
                                      height: 30.w,
                                      width: 30.w,
                                      color: cameraController != null
                                          ? appColors.white
                                          : null),
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
                                                color: cameraController != null
                                                    ? appColors.white
                                                    : appColors.darkBlue)),
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
                                                color: cameraController != null
                                                    ? appColors.white
                                                    : appColors.brownColour)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25.w),
                              (cameraController != null &&
                                      cameraController!.value.isInitialized)
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: CustomText(
                                          "Note* : Make sure your image clearly visible",
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          fontColor: appColors.red,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              Obx(
                                () {
                                  return /*(AppFirebaseService()
                                                  .orderData
                                                  .value["status"] ??
                                              "-1") ==
                                          "1"*/
                                      isLoading
                                          ? Container(
                                              height: kToolbarHeight,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: appColors.brown),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r)),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        "Waiting for user to connect",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                FontFamily
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
                                                    if (isAstrologerPhotoChatCall
                                                            .value ==
                                                        1) {
                                                      if (await Permission
                                                              .camera
                                                              .isGranted &&
                                                          await Permission
                                                              .microphone
                                                              .isGranted) {
                                                        await cameraController
                                                            ?.setFlashMode(
                                                                FlashMode.off);
                                                        XFile picture =
                                                            await cameraController!
                                                                .takePicture();
                                                        await uploadImage(
                                                            picture);
                                                      } else {
                                                        initCamera();
                                                      }
                                                    } else {
                                                      isLoading = true;

                                                      await acceptOrRejectChat(
                                                        orderId:
                                                            AppFirebaseService()
                                                                        .orderData
                                                                        .value[
                                                                    "orderId"] ??
                                                                0,
                                                        queueId:
                                                            AppFirebaseService()
                                                                        .orderData
                                                                        .value[
                                                                    "queue_id"] ??
                                                                0,
                                                      );
                                                      if (disableAstroEvent
                                                              .toString() ==
                                                          "1") {
                                                        FirebaseAnalytics
                                                            .instance
                                                            .logEvent(
                                                                name:
                                                                    "astrologer_accept_chat",
                                                                parameters: {
                                                              "Name": AppFirebaseService()
                                                                          .orderData
                                                                          .value[
                                                                      "customerName"] ??
                                                                  "",
                                                              "order_status":
                                                                  "Accepted",
                                                              "orderId": AppFirebaseService()
                                                                          .orderData
                                                                          .value[
                                                                      "orderId"] ??
                                                                  "",
                                                              "queueId": AppFirebaseService()
                                                                          .orderData
                                                                          .value[
                                                                      "queue_id"] ??
                                                                  "",
                                                            });
                                                        // fevents
                                                        //     .acceptChatByAstrologer({
                                                        //   "Name": AppFirebaseService()
                                                        //               .orderData
                                                        //               .value[
                                                        //           "customerName"] ??
                                                        //       "",
                                                        //   "order_status":
                                                        //       "Accepted",
                                                        //   "orderId": AppFirebaseService()
                                                        //               .orderData
                                                        //               .value[
                                                        //           "orderId"] ??
                                                        //       "",
                                                        //   "queueId": AppFirebaseService()
                                                        //               .orderData
                                                        //               .value[
                                                        //           "queue_id"] ??
                                                        //       "",
                                                        // });
                                                      }
                                                    }
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
