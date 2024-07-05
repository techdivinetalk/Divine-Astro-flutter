import 'dart:async';
import 'dart:developer';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/ChatOrderResponse.dart';
import 'package:divine_astrologer/model/speciality_list.dart';
import 'package:divine_astrologer/repository/pre_defind_repository.dart';
import 'package:divine_astrologer/screens/dashboard/widgets/terms_and_condition_popup.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:divine_astrologer/utils/force_update_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../cache/custom_cache_manager.dart';
import '../../common/app_exception.dart';
import '../../common/app_textstyle.dart';
import '../../common/common_functions.dart';
import '../../di/fcm_notification.dart';
import '../../model/astrologer_gift_response.dart';
import '../../model/chat/req_common_chat_model.dart';
import '../../model/chat/res_common_chat_success.dart';
import '../../model/res_login.dart';
import '../../repository/astrologer_profile_repository.dart';
import '../../repository/chat_repository.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  final PreDefineRepository repository;

  DashboardController(this.repository);

  RxInt selectedIndex = 0.obs;

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  RxString userProfileImage = "".obs;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  UserData? userData;
  final appFirebaseService = AppFirebaseService();
  BroadcastReceiver broadcastReceiver =
      BroadcastReceiver(names: <String>["AcceptChat", "ReJoinChat"]);

  // StreamSubscription<DatabaseEvent>? realTimeListener;
  // StreamSubscription<DatabaseEvent>? astroChatListener;
  // Socket? socket;
  ChatOrderData? chatOrderData;

  GlobalKey<State<StatefulWidget>> keyHome = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyPerformance = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyAssistance = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyQueue = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyProfile = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyHide = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyProfileHome = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyTodayAmount = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyTotalAmount = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyCheckKundli = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyRetentionRate = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyRepurchaseRate = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyEcommerceWallet = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyHelp = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyNoticeBoard = GlobalKey();
  GlobalKey<State<StatefulWidget>> keySessionType = GlobalKey();
  GlobalKey<State<StatefulWidget>> keyManageDiscountOffers = GlobalKey();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  var commonConstants;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("checkPermissions");
      // Check permissions when app is resumed
      //  checkPermissions();
      getOrderFromApi();
      if (preferenceService.getUserDetail() != null) {
        // Check for null user details
        appFirebaseService.readData(
            'astrologer/${preferenceService.getUserDetail()!.id}/realTime');
      } else {
        divineSnackBar(data: "User Not Found");
      }
    }
  }

  void checkPermissions() async {
    if (await Permission.camera.isDenied ||
        await Permission.microphone.isDenied) {
      Get.bottomSheet(
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: Text(
                  "Permission Missing",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Allow permission to take audio and video calls smoothly",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  requestPermissions();
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: appColors.guideColor,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Text(
                    "Grant Permission",
                    style: AppTextStyle.textStyle20(
                      fontColor: appColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    }
    await Future.delayed(const Duration(seconds: 3));

    if (isTime.toString() == "1") {
      compareTimes(commonConstants.data!.currentTime!.toInt());
      print(DateTime.now().millisecondsSinceEpoch / 1000);
    }
  }

  void requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
    Get.back(); // Close the bottom sheet after requesting permissions
    if (await FlutterOverlayWindow.isPermissionGranted() == false) {
      await FlutterOverlayWindow.requestPermission();
    }
  }

  void checkAndRequestPermissions() async {
    // storagePermission();
  }

  Future<bool> storagePermission() async {
    final DeviceInfoPlugin info =
        DeviceInfoPlugin(); // import 'package:device_info_plus/device_info_plus.dart';
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    debugPrint('releaseVersion : ${androidInfo.version.release}');

    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;

    if (androidVersion >= 13) {
      final request = await [
        Permission.videos,
        Permission.photos,
        //..... as needed
      ].request(); //import 'package:permission_handler/permission_handler.dart';

      havePermission =
          request.values.every((status) => status == PermissionStatus.granted);
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      // if no permission then open app-setting
      await openAppSettings();
    }

    return havePermission;
  }

  Future<void> furtherProcedure() async {
    try {
      if (kDebugMode) {
        Fluttertoast.showToast(
            msg: AppFirebaseService().payload["order_id"] ?? "");
        Fluttertoast.showToast(
            msg: AppFirebaseService().payload["queue_id"] ?? "");
      }
      if (AppFirebaseService().payload["order_id"].toString() == "") {
        return;
      }
      ResCommonChatStatus response = await ChatRepository().chatAccept(
          ReqCommonChatParams(
                  queueId: int.parse(
                      AppFirebaseService().payload["queue_id"].toString()),
                  orderId: int.parse(
                      AppFirebaseService().payload["order_id"].toString()),
                  isTimeout: 0,
                  acceptOrReject: 1)
              .toJson());
      print("chat_reject 2");
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Waiting for Customer to accept the request");
      } else {
        Fluttertoast.showToast(msg: response.message.toString());
      }
      return Future<void>.value();
    } catch (e) {
      // Handle exceptions
      print('Error in furtherProcedure: $e');
      // Optionally, show a snackbar or dialog to inform the user about the error
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    if(appFirebaseService.astroMsg != null){serverUnderMaintenancePopup(appFirebaseService.astroMsg);}
    WidgetsBinding.instance.addObserver(this);
    //  checkPermissions();
    getOrderFromApi();
    checkAndRequestPermissions();
    if (AppFirebaseService().payload != null) {
      // if (AppFirebaseService().payload!["type"] == null) {
      //   return;
      // }
      if (AppFirebaseService().payload!["type"] == "2") {
        furtherProcedure();
      }
    }
    //   print("microphone ${await FlutterOverlayWindow.isPermissionGranted()}");
    print("beforeGoing 2 - ${preferenceService.getUserDetail()?.id}");
    broadcastReceiver.start();
    broadcastReceiver.messages.listen((event) {
      print("broadCastResponse");
      print(AppFirebaseService().openChatUserId != "");
      if (event.data != null) {
        // Check for null data before accessing
        print(event.data!["orderData"]);
        if (event.name == "ReJoinChat" &&
            AppFirebaseService().openChatUserId != "" &&
            event.data != null &&
            event.data!["orderData"]["status"] != null) {
          var orderData = event.data!["orderData"];
          Get.toNamed(RouteName.chatMessageWithSocketUI, arguments: orderData);
        }
      } else {
        print("event.data is null");
      }
    });

    commonConstants = await userRepository.constantDetailsData();
    if (commonConstants?.data != null) {
      imageUploadBaseUrl.value =
          commonConstants?.data?.imageUploadBaseUrl ?? "";
      update();
    }
    preferenceService.setConstantDetails(commonConstants);
    preferenceService
        .setBaseImageURL(commonConstants.data!.awsCredentails.baseurl!);
    if (commonConstants.data.notice == null ||
        commonConstants.data.notice == "null") {
    } else {
      log(commonConstants.data.notice.toString());
      showRecommendedPopupAlert();
    } //added by: dev-dharam
    Get.find<SharedPreferenceService>()
        .setAmazonUrl(commonConstants.data!.awsCredentails.baseurl!);
    //
    print(commonConstants.data!.awsCredentails.baseurl);
    print("commonConstants.data!.awsCredentails.baseurl");
    String? baseAmazonUrl = preferenceService.getBaseImageURL();
    print(baseAmazonUrl);
    print("baseAmazonUrlbaseAmazonUrlbaseAmazonUrl");
    // Handle potential null userData
    if (preferenceService.getUserDetail() != null) {
      userData = preferenceService.getUserDetail();
      String? userImageUrl =
          userData?.image != null ? "$baseAmazonUrl/${userData?.image}" : "";
      userImage(userImageUrl ??
          ""); // Use nullish coalescing operator (??) for default value
      print(userData?.image);
      print(userProfileImage.value);
    } else {
      print("userData is null");
    }

    loadPreDefineData();
    initMessaging();
    // firebaseMessagingConfig(Get.context!);
    // getConstantDetailsData();
    print("currentTime");
    cacheGift();
  }

  void compareTimes(int serverTime) {
    print("millisecondsSinceEpoch");
    print(isTime.toString());
    // Get the current local time in milliseconds since epoch
    int localTime = DateTime.now().millisecondsSinceEpoch;

    // Convert serverTime to milliseconds since epoch
    int serverTimeMillis = serverTime * 1000;

    // Calculate the absolute difference in milliseconds
    int difference = serverTimeMillis > localTime
        ? (serverTimeMillis - localTime).abs()
        : (localTime - serverTimeMillis).abs();
    print(serverTimeMillis);
    print("serverTimeMillis");
    // Check if the difference is less than 30 seconds (30000 milliseconds)
    if (difference > 30000) {
      print("if difference");
      showTimeDIffBottomSheet(Get.context!);
    } else {
      print("else difference");
    }
  }

  void showTimeDIffBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Mobile Time issue',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Your mobile's time is incorrect. Please adjust it to proceed.",
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: GestureDetector(
                    onTap: () {
                      const AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.DATE_SETTINGS',
                        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                      );
                      intent.launch();
                    },
                    child: const Text('Change time')),
              ),
            ],
          ),
        );
      },
      isDismissible: true, // allows tapping outside to dismiss
      enableDrag: false,
    );
  }

  @override
  void onReady() {
    final socket = AppSocket();
    socket.socketConnect();
    super.onReady();
  }

  Future<void> requestPermissions1() async {
    if (await Permission.storage.request().isGranted) {
      print("isGranted1");
    } else {
      print("isGranted0");
    }
  }

  getOrderFromApi() async {
    try {
      ChatOrderResponse data = await userRepository.getChatOrderDetails();
      if (data.data != null) {
        chatOrderData = data.data!;
      } else {
        chatOrderData = null;
      }
      update();
    } catch (e) {
      print("getting error ${e}");
    }
  }

  getConstantDetailsData(context) async {
    try {
      final data = await userRepository.constantDetailsData();
      if (data.data != null) {
        imageUploadBaseUrl.value = data?.data?.imageUploadBaseUrl ?? "";

        update();

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        print(data.data!.appVersion!.split(".").join(""));
        print(packageInfo.version.split(".").join(""));
        print('packageInfo.version!.split(".").join("")');
        if (int.parse(data.data!.appVersion!.split(".").join("")) >
            int.parse(packageInfo.version.split(".").join(""))) {
          print("objectobjectobjectobject");
          Get.bottomSheet(
            const ForceUpdateSheet(),
            isDismissible: false,
          );
          // showTutorial(context);
        } else {
          // showTutorial(context);
        }
      }

      update();
    } catch (error) {
      debugPrint("error::::: $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadPreDefineData() async {
    SpecialityList response = await repository.loadPreDefineData();
    await preferenceService.setSpecialAbility(response.toPrettyJson());
  }

  void askPermission() async {
    await [Permission.camera, Permission.microphone, Permission.contacts]
        .request();

    PermissionStatus? permissionStatus;
    if (permissionStatus == PermissionStatus.granted) {
      await checkContacts();
    }
    while (permissionStatus != PermissionStatus.granted) {
      try {
        permissionStatus = await _getContactPermission();
        if (permissionStatus != PermissionStatus.granted) {
          await openAppSettings();
        } else {}
      } catch (e) {
        await openAppSettings();
      }
    }
  }

  checkContacts() async {
    var allContacts = await ContactsService.getContacts();
    var isContactExists = allContacts.any((element) {
      if (element.phones != null) {
        return element.phones!
            .any((element) => element.value!.contains("+91 9876543210"));
      } else {
        return false;
      }
    });
    if (!isContactExists) {
      Get.toNamed(RouteName.importantNumbers);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted) {
      final result = await Permission.contacts.request();
      return result;
    } else {
      return status;
    }
  }

  List<TargetFocus> createTargets() {
    return [
      TargetFocus(identify: "Target 1", keyTarget: keyHome, contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Home Tab",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Amount of today's prediction and total prediction, retention rate, repurchase rate, and e-commerce wallet, noticboard, and other details, manage call and chat, manage discount  offers, manage profile, and feedback, and other details.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ]),
      TargetFocus(identify: "Target 2", keyTarget: keyPerformance, contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Performance Tab",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Your performance details with graph",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ]),
      TargetFocus(identify: "Target 3", keyTarget: keyAssistance, contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Assistance Tab",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Find old users data and chats here",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ]),
      TargetFocus(identify: "Target 4", keyTarget: keyQueue, contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Queue Tab",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Waitlist of users who are waiting for your call and chat",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ]),
      TargetFocus(identify: "Target 5", keyTarget: keyProfile, contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Profile Tab",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Manage your profile, bank details, story, gallery, language, E-commerce and other details",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ]),
      TargetFocus(identify: "Target 6", keyTarget: keyHide, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hide and Show amount",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Hide and show amount of today's prediction and total prediction",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ]),
      TargetFocus(identify: "Target 7", keyTarget: keyProfileHome, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Your Profile",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Manage your profile, bank details, story, gallery, language, E-commerce and other details",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ]),
      TargetFocus(identify: "Target 8", keyTarget: keyTodayAmount, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Today's Amount",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Amount of today's prediction",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ]),
      TargetFocus(identify: "Target 9", keyTarget: keyTotalAmount, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.only(top: 60),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Total Amount",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Amount of total prediction",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ))
      ]),
      TargetFocus(identify: "Target 10", keyTarget: keyCheckKundli, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.only(top: 30),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Check Kundli",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Check Kundli of users",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ))
      ]),
      TargetFocus(
          identify: "Target 11",
          keyTarget: keyRetentionRate,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Retention Rate",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Retention rate of users",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ))
          ]),
      TargetFocus(
          identify: "Target 12",
          keyTarget: keyRepurchaseRate,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Repurchase Rate",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Repurchase rate of users",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ))
          ]),
      TargetFocus(
          identify: "Target 13",
          keyTarget: keyEcommerceWallet,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "E-commerce Wallet",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Your e-commerce wallet",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ]),
      TargetFocus(identify: "Target 14", keyTarget: keyHelp, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Help",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Get help from us",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ]),
      TargetFocus(identify: "Target 15", keyTarget: keyNoticeBoard, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.only(top: 130),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Notice Board",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Notice board for you",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ))
      ]),
      TargetFocus(identify: "Target 16", keyTarget: keySessionType, contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.only(bottom: 140),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Session Type",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Manage your sessions",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ]),
      TargetFocus(
          identify: "Target 17",
          keyTarget: keyManageDiscountOffers,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Manage Discount Offers",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Manage your discount offers",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ))
          ]),
    ];
  }
  void serverUnderMaintenancePopup(String? message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("$message🤑🤑🤑🤑🤑🤑🤑🤑🤑🤑");
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        // Prevents closing the popup by tapping outside
        builder: (BuildContext context) {
          return PopScope(
            canPop:false,
            child: AlertDialog(
              title: const Text('Notification'),
              content: Text(message!),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                    SystemNavigator.pop(); // Close the app
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void showTutorial(context) {
    TutorialCoachMark(
      targets: createTargets(),
      // List<TargetFocus>
      colorShadow: Colors.black,
      // DEFAULT Colors.black
      // alignSkip: Alignment.bottomRight,
      // textSkip: "SKIP",
      // showSkipInLastTarget: true,
      hideSkip: true,
      paddingFocus: 0,

      // opacityShadow: 0.8,
      onClickTarget: (target) {
        print(target);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
        return false;
      },
      onFinish: () {
        print("finish");
      },
    )..show(context: context);
  }

  cacheGift() async {
    try {
      GiftResponse response = await AstrologerProfileRepository()
          .getAllGiftsAPI(successCallBack: (s) {}, failureCallBack: (s) {});
      if (response.data != null) {
        for (final element in response.data!) {
          String link = element.animation ?? '';
          if (link.isNotEmpty) {
            await CustomCacheManager().getFile(link);
          }
        }
        print("Gifts cached");
      }
    } catch (e) {
      debugPrint("Error caching gifts: $e");
    }
  }

  var isLoading = false.obs;
  var submitTermsAndCondition;
  void postAcceptTerms(noticeId) async {
    isLoading(true);
    Map<String, dynamic> param = {
      "notice_id": noticeId,
    };
    try {
      final rstatus = await repository.postTermsConditionSubmit(param);

      if (rstatus.success == true) {
        submitTermsAndCondition = rstatus;
        isLoading(false);
        Get.back();
      } else {
        isLoading(false);
      }
      update();
    } catch (error) {
      isLoading(false);
    }
  }

  // RxBool is a reactive boolean observable
  var isChecked = false.obs;

// Method to toggle the checkbox state
  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
  }
}
