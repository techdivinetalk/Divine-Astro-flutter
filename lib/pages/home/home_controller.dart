import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import "package:contacts_service/contacts_service.dart";
import 'package:cron/cron.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/MiddleWare.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/astro_schedule_response.dart';
import 'package:divine_astrologer/model/astrologer_training_session_response.dart';
import 'package:divine_astrologer/model/feedback_response.dart';
import 'package:divine_astrologer/model/home_model/astrologer_live_data_response.dart';
import 'package:divine_astrologer/model/home_model/training_video_model.dart';
import 'package:divine_astrologer/model/performance_response.dart';
import 'package:divine_astrologer/model/sample_text_response.dart';
import 'package:divine_astrologer/model/update_offer_type_response.dart';
import 'package:divine_astrologer/model/update_session_type_response.dart';
import 'package:divine_astrologer/model/wallet_deatils_response.dart';
import 'package:divine_astrologer/pages/home/home_ui.dart';
import 'package:divine_astrologer/pages/home/widgets/common_info_sheet.dart';
import 'package:divine_astrologer/pages/home/widgets/technical_popup.dart';
import 'package:divine_astrologer/pages/home/widgets/training_video.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_message/widgets/product/pooja/widgets/custom_widget/pooja_common_list.dart';
import 'package:divine_astrologer/screens/dashboard/dashboard_controller.dart';
import 'package:divine_astrologer/screens/dashboard/model/astrologer_nord_data_model.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:divine_astrologer/utils/show_loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import "package:permission_handler/permission_handler.dart";
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/PopupManager.dart';
import '../../common/app_exception.dart';
import '../../common/app_textstyle.dart';
import '../../common/feedback_bottomsheet.dart';
import "../../common/important_number_bottomsheet.dart";
import '../../common/switch_component.dart';
import '../../di/shared_preference_service.dart';
import '../../firebase_service/firebasae_event.dart';
import '../../model/AstroRitentionModel.dart';
import '../../model/GenerateImageModel.dart';
import '../../model/astro_notice_board_response.dart';
import '../../model/chat_assistant/CustomerDetailsResponse.dart';
import '../../model/constant_details_model_class.dart';
import '../../model/home_page_model_class.dart';
import "../../model/important_numbers.dart";
import '../../model/res_login.dart';
import '../../model/send_feed_back_model.dart';
import '../../model/view_training_video_model.dart';
import '../../repository/chat_assistant_repository.dart';
import '../../repository/home_page_repository.dart';
import "../../repository/important_number_repository.dart";
import '../../repository/notice_repository.dart';
import '../../repository/performance_repository.dart';
import '../../repository/user_repository.dart';
import 'widgets/can_not_online.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  Rx<AstroNoticeBoardResponse> astroNoticeBoardResponse =
      AstroNoticeBoardResponse().obs;
  RxBool isOpenLivePayment = false.obs;
  bool isOpenBonusSheet = false;
  bool isOpenPaidSheet = false;
  bool isOpenECommerceSheet = false;
  RxBool liveSwitch = true.obs;
  RxBool isCallEnable = true.obs;
  RxBool isChatEnable = true.obs;
  RxBool isVideoCallEnable = true.obs;
  RxBool isLiveEnable = true.obs;
  bool istraininginfo = true;
  bool noticePollChecked = false;
  var selectedPoll;

  double xPosition = 10.0;
  double yPosition = Get.height * 0.4;
  RxList<bool> customOfferSwitch = RxList([]);
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  RxString appbarTitle = "Astrologer Name ".obs;
  RxBool isShowTitle = true.obs;
  TextEditingController feedBackText = TextEditingController();
  final socket = AppSocket();
  ExpandedTileController? expandedTileController = ExpandedTileController();
  ExpandedTileController? expandedTile2Controller = ExpandedTileController();
  UserData userData = UserData();
  UserRepository userRepository = UserRepository();
  final firebaseEvent = Get.find<FirebaseEvent>();

  HomePageRepository homePageRepository = HomePageRepository();
  final homeScreenKey = GlobalKey<ScaffoldState>();
  int scoreIndex = 0;
  List<Map<String, dynamic>> yourScore = [];

  OrderDetails? order;

  String userImage = "";

  Rx<Loading> offerTypeLoading = Loading.initial.obs;
  Rx<Loading> sessionTypeLoading = Loading.initial.obs;

  onNextTap() {
    if (scoreIndex < performanceScoreList.length - 1) {
      scoreIndex++;
      update(['score_update']);
    }
  }

  onPreviousTap() {
    if (scoreIndex > 0) {
      scoreIndex--;
      update(['score_update']);
    }
  }

  var imageSS;
  int ssTimes = 0;
  captureandSendSS() {
    print("111111111111");

    if (ssTimes == 0) {
      screenshotController.capture().then(
        (value) async {
          if (value != null) {
            final directory = await getApplicationDocumentsDirectory();
            final imagePath =
                await File('${directory.path}/image.png').create();
            await imagePath.writeAsBytes(value);

            ssTimes = 1;
            print("screenshot taken ----");
            uploadImage(imagePath.path);
            imageSS = imagePath.path;
            update();
            print("${value.toString()}");
            print("screenshot taken ----");
          }
        },
      );
    }
  }

  var currentUploadedFile;
  Future<void> uploadImage(imageFile) async {
    var token = await preferenceService.getToken();

    print("image length - ${imageFile.toString()}");

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
      imageFile.toString(),
    ));
    request.fields.addAll({"module_name": "dashboardSS"});

    var response = await request.send();

    // Listen for the response

    print("responseresponseresponse");
    response.stream.transform(utf8.decoder).listen((value) {
      print("response ---- ${value.toString()}");

      if (response.statusCode == 200) {
        print("Image uploaded successfully.");

        submitIssues(jsonDecode(value)["data"]["path"]);
      } else {
        print("Failed to upload image.");
      }
      update();
    });
  }

  var submitSS;
  submitIssues(image) async {
    Map<String, dynamic> param = {
      "screenshot": image ?? "",
    };

    print("paramssss${param.toString()}");

    try {
      print(222.toString());

      final response = await userRepository.screenShotSend(param);
      if (response.success == true) {
        submitSS = response;
        // divineSnackBar(
        //     data: response.message.toString(), color: appColors.green);
      } else {
        print(3.toString());
      }
      print("Data Of submit ==> ${jsonEncode(response.data)}");
    } catch (error) {
      print(33.toString());

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    update();
  }

  final chatAssistantRepository = ChatAssistantRepository();
  int pageUsersData = 1;
  CustomerDetailsResponse? customerDetailsResponse;
  RxList filteredUserData = [].obs;
  final searchController = TextEditingController();
  var checkin = false.obs;
  var emptyRes = false.obs;
  var isLoadMoreData = false.obs;

  Future<void> getConsulation() async {
    CustomerDetailsResponse response =
        await chatAssistantRepository.getConsulation(pageUsersData);
    if (emptyRes.value == false) {
      if (response.data.isNotEmpty) {
        if (pageUsersData != 1 &&
            customerDetailsResponse != null &&
            customerDetailsResponse!.data.isNotEmpty) {
          customerDetailsResponse!.data.addAll(response.data);
          checkin(false);
        } else {
          customerDetailsResponse = response;
        }
        pageUsersData++;
      } else {
        // Fluttertoast.showToast(msg: "No more data");
        print("data ---- ${response.data.toString()}");
        emptyRes(true);
      }
      isLoadMoreData.value = false;
    } else {
      isLoadMoreData.value = false;
      print("There is no more data in user data");
    }
    update();
  }

  BroadcastReceiver broadcastReceiver =
      BroadcastReceiver(names: <String>["callKundli", "giftCount"]);

  List<MobileNumber> importantNumbers = <MobileNumber>[];
  List<Contact> allContacts = <Contact>[].obs;
  bool? isAllNumbersExist;

  final cron = Cron();

  RxList<Weeks> weekLst = <Weeks>[].obs;
  RxInt todaysRemaining = 0.obs;
  RxInt isRewardAvailable = 0.obs;
  RxInt rewardPoint = 0.obs;
  RxInt isLiveMonitor = 0.obs;

  String getWeeks(int week) {
    if (week == 1) {
      return "${week}st";
    } else if (week == 2) {
      return "${week}nd";
    } else if (week == 3) {
      return "${week}rd";
    } else {
      return "${week}th";
    }
  }

  getAstrologerLiveData() async {
    // if(preferenceService.getString("homePage") == "0"){
    //   return;
    // }
    weekLst.clear();
    todaysRemaining.value = 0;
    isRewardAvailable.value = 0;
    rewardPoint.value = 0;
    isLiveMonitor.value = 0;

    try {
      var response = await homePageRepository.doGetAstrologerLiveData();

      if (response.data != null) {
        var data = response.data;
        if (data!.todaysRemaining != null) {
          todaysRemaining.value = data.todaysRemaining!;
        }
        if (data.isRewardAvailable != null) {
          isRewardAvailable.value = data.isRewardAvailable!;
          debugPrint("test_isRewardAvailable: $isRewardAvailable");
        }
        if (data.rewardPoint != null) {
          rewardPoint.value = data.rewardPoint!;
        }
        if (data.isLiveMonitor != null) {
          isLiveMonitor.value = data.isLiveMonitor!;
        }

        if (data.weeks!.isNotEmpty) {
          weekLst.addAll(data.weeks!);
        }
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  final ScrollController scrollController = ScrollController();
  final threshold = 50.0; // Adjust as needed
  bool isInit = false;
  @override
  void onReady() {
    isInit = false;
    super.onReady();
  }

  @override
  void onInit() async {
    super.onInit();
    debugPrint("test_onInit: call");
    isInit = true;
    initData();
    getDeviceDetails();

// // Log when the scroll controller is attached
//     print('ScrollController attached: ${scrollController.positions.length}');
//     scrollController.addListener(() {
//       print('pixels ${scrollController.positions.length}');
//
//       if (scrollController.position.maxScrollExtent ==
//           scrollController.position.pixels) {
//         getConsulation();
//       }
//     });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      askNotificationPermission();
      askCameraPermission();
    });
  }

  initData() {
    WidgetsBinding.instance.addObserver(this);
    if (preferenceService.getUserDetail() != null) {
      getAllDashboardData();
      userData = preferenceService.getUserDetail()!;
      getRitentionDataApi();
      appbarTitle.value =
          "${userData.name.toString().capitalizeFirst} (${userData.uniqueNo})";

      print("${preferenceService.getBaseImageURL()}/${userData.image}");

      final String path = "astrologer/${(userData.id ?? 0)}/realTime";
      FirebaseDatabase.instance.ref().child(path).onValue.listen(
        (event) async {
          final DataSnapshot dataSnapshot = event.snapshot;

          if (dataSnapshot.exists) {
            if (dataSnapshot.value is Map<dynamic, dynamic>) {
              Map<dynamic, dynamic> map = <dynamic, dynamic>{};
              map = (dataSnapshot.value ?? <dynamic, dynamic>{})
                  as Map<dynamic, dynamic>;
              print("Home Realtime DB Listener: $map");

              // final isCallSwitchRes = map["voiceCallStatus"] ?? 0;
              // callSwitch(isCallSwitchRes > 0);
              //
              // final isChatSwitchRes = map["chatStatus"] ?? 0;
              // chatSwitch(isChatSwitchRes > 0);
              //
              // final isVideoCallSwitchRes = map["videoCallStatus"] ?? 0;
              // videoSwitch(isVideoCallSwitchRes > 0);

              final isCallEnableRes = map["is_call_enable"] ?? false;
              isCallEnable(isCallEnableRes);

              final voiceCallStatus = map["voiceCallStatus"] ?? 0;
              callSwitch(voiceCallStatus != 0);

              if (callSwitch.value) {
                selectedCallDate.value = DateTime.now();
                selectedCallTime.value = "";
              }

              final isChatEnableRes = map["is_chat_enable"] ?? false;
              isChatEnable(isChatEnableRes);

              final chatStatusRes = map["chatStatus"] ?? 0;
              chatSwitch(chatStatusRes != 0);

              if (chatSwitch.value) {
                selectedChatDate.value = DateTime.now();
                selectedChatTime.value = "";
              }

              final isVideoCallEnableRes = map["is_video_call_enable"] ?? false;
              isVideoCallEnable(isVideoCallEnableRes);

              final isLiveEnableRes = map["is_live_enable"] ?? false;
              isLiveEnable(isLiveEnableRes);

              final offers = map["offers"];
              if (offers != null) {
                final homeData = this.homeData;
                if (homeData != null) {
                  for (int i = 0;
                      i < homeData!.offers!.orderOffer!.length;
                      i++) {
                    for (int j = 0; j < offers.keys.toList().length; j++) {
                      if ("${homeData!.offers!.orderOffer![i].id}" ==
                          "${offers.keys.toList()[j]}") {
                        if ("${offers.values.toList()[j]}" == "1") {
                          homeData!.offers!.orderOffer![i].isOn = true;
                          update();
                        } else {
                          homeData!.offers!.orderOffer![i].isOn = false;
                          update();
                        }
                      }
                    }
                  }
                }
              }
            } else {}
          } else {}
        },
      );
      generateImage();
    }

    print("beforeGoing 3 - ${preferenceService.getUserDetail()?.id}");
    Future.delayed(const Duration(seconds: 3), () {
      print("isLogged");
      print(" ${preferenceService.getUserDetail()}");

      if (preferenceService.getUserDetail() != null) {
        // Check for null user details
        print("what is screen ----> home");
        AppFirebaseService().readData(
            'astrologer/${preferenceService.getUserDetail()!.id}/realTime');
      } else {
        log("user not found home controller");
        // divineSnackBar(data: "User Not Found");
      }
      //appFirebaseService.masterData('masters');
    });
    broadcastReceiver.start();
    broadcastReceiver.messages.listen((event) {
      debugPrint('broadcastReceiver ${event.name} ---- ${event.data}');
      if (event.name == "giftCount") {
        if (int.parse(event.data!["giftCount"].toString()) > 0) {
          if (MiddleWare.instance.currentPage != RouteName.chatMessageUI) {
            showGiftBottomSheet(event.data?["giftCount"], Get.context!,
                baseUrl: preferenceService.getBaseImageURL());
          }
        }
      }
    });

    getSampleText();
    getAstrologerTrainingSession();
    getAstrologerLiveData();
    getAstrologerStatus();
    getConsulation();
    // cron.schedule(Schedule.parse('*/5 * * * * *'), checkForScheduleUpdate);
  }

  GenerateImageModel? generateImageModel;
  generateImage() async {
    try {
      var data = await userRepository.generateImageRepo({});
      if (data.success == true) {
        generateImageModel = data;
      } else {
        generateImageModel = null;
      }
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  Future<String> download() async {
    var root = await getTemporaryDirectory();
    var url = pref.getAmazonUrl()! + "/" + generateImageModel!.data!.image!;

    print("urlvideo :: $url");

    // Extract filename from URL
    String filename = Uri.parse(url).pathSegments.last;
    String tempPath = "${root.path}/$filename";

    try {
      // Configure Dio
      Dio dio = Dio();
      dio.options.headers = {
        'Connection': 'keep-alive',
        'Keep-Alive': 'timeout=5, max=1000',
      };

      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      saveImage(response.data);
      // saveImage(Get.context!,url);
      // Log headers
      print(response.headers);

      // Save file
      File file = File(tempPath);
      print("File will be saved at: ${file.path}");
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      // Share the file
      await Share.shareXFiles([XFile(file.path)]);
      return file.path;
    } catch (e) {
      print("Error downloading file: $e");
      return "";
    }
  }

  saveImage(image) async {
    Directory savePath = await getGalleryPath();
    String fileName =
        "${savePath.path}/Template${DateTime.now().microsecond}${DateTime.now().millisecond}.png";
    bool isPermission = await askStoragePermission();
    if (isPermission) {
      await File(fileName).writeAsBytes(image);
    } else {
      divineSnackBar(data: "Please give permission of storage.");
      openAppSettings();
      update();
    }
    update();
  }

  Future<Directory> getGalleryPath() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Pictures');
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory(); // iOS-specific path
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Future<Directory> getDownloadPath() async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      return directory;
    } else {
      Directory appDocDirFolder = Directory('/storage/emulated/0/Download');
      bool isPermission = await askStoragePermission();
      if (isPermission) {
        directory = Directory('/storage/emulated/0/Download');
        appDocDirFolder = Directory('${directory.path}');
        if (await appDocDirFolder.exists()) {
          return appDocDirFolder;
        } else {
          final Directory _appDocDirNewFolder =
              await appDocDirFolder.create(recursive: true);
          return _appDocDirNewFolder;
        }
      }
      return appDocDirFolder;
    }
  }

  int currentSdk = 0;

  getDeviceDetails() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      currentSdk = androidDeviceInfo.version.sdkInt ?? 0;
      debugPrint("currentSdk : $currentSdk");
      update();
    }
  }

  Future<bool> askStoragePermission() async {
    bool isPermission = false;
    if (currentSdk >= 32) {
      var checkPermission = await Permission.photos.status;
      if (checkPermission.isDenied) {
        var status = await Permission.photos.request();
        if (status.isGranted) {
          isPermission = true;
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
        }
      } else if (checkPermission.isGranted) {
        isPermission = true;
      } else if (checkPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      var checkPermission = await Permission.storage.status;

      if (checkPermission.isDenied) {
        var status = await Permission.storage.request();
        if (status.isGranted) {
          isPermission = true;
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
        }
      } else if (checkPermission.isGranted) {
        isPermission = true;
      } else if (checkPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    }
    print("isPermission-->>$isPermission");
    return isPermission;
  }

  askNotificationPermission() async {
    print("notification permission denied checking ---- ");
    if (astrologer_notification.toString() == "1") {
      Permission.notification.request().then((value) async {
        if (value.isDenied) {
          if (await Permission.notification.isDenied ||
              await Permission.notification.isPermanentlyDenied) {
            showNotiSheet();
          }
        }
      });
      if (await Permission.notification.isDenied ||
          await Permission.notification.isPermanentlyDenied) {
        showNotiSheet();
      }
    }
  }

  showNotiSheet() {
    Get.bottomSheet(
      ignoreSafeArea: true,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            width: MediaQuery.of(Get.context!).size.width,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20.0)),
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 3,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: appColors.textColor.withOpacity(0.1),
                          child: Center(
                            child: Icon(
                              Icons.clear,
                              color: appColors.textColor,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/images/notification.png",
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Don't miss out on updates!",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle20(
                      fontColor: appColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        color: appColors.red.withOpacity(0.1),
                        child: ListTile(
                          selected: true,
                          selectedTileColor: appColors.red.withOpacity(0.2),
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundColor: appColors.red,
                            child: Icon(
                              Icons.notifications_active,
                              color: appColors.white,
                              size: 15,
                            ),
                          ),
                          title: Text(
                            "Notifications",
                            textAlign: TextAlign.left,
                            style: AppTextStyle.textStyle16(
                              fontColor: appColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "Get real-time updates on your mobile.",
                            textAlign: TextAlign.left,
                            style: AppTextStyle.textStyle14(
                              fontColor: appColors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Get.back();
                      AppSettings.openAppSettings(
                          type: AppSettingsType.notification);
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(Get.context!).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: appColors.red,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 2,
                            color: appColors.grey.withOpacity(0.4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Allow Access",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: appColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: Text(
                        "Maybe Later",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle18(
                          fontColor: appColors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  askCameraPermission() async {
    if (astrologer_camera_permission.toString() == "1") {
      Permission.camera.request().then((value) async {
        if (value.isDenied) {
          print("camera permission denied checking ---- ");
          if (await Permission.camera.isDenied ||
              await Permission.camera.isPermanentlyDenied) {
            print("camera permission denied checking  permantely---- 1");

            getCameraNotiFun();
          }
        }
      });
      if (await Permission.camera.isDenied ||
          await Permission.camera.isPermanentlyDenied) {
        print("camera permission denied checking  permantely---- 1");
        getCameraNotiFun();
      }
    }
  }

  getCameraNotiFun() {
    Get.bottomSheet(
      ignoreSafeArea: true,
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: appColors.grey.withOpacity(0.2),
                    border: Border.all(
                      color: appColors.grey,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.clear,
                      color: appColors.textColor,
                      size: 23,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(Get.context!).size.width,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20.0)),
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.white,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/camera_per.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Enable Camera Access",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle20(
                            fontColor: appColors.guideColor,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Allow camera access to start the live session.",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle16(
                            fontColor: appColors.textColor,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Get.back();
                          AppSettings.openAppSettings();
                        },
                        child: Container(
                            height: 40,
                            width: MediaQuery.of(Get.context!).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: appColors.red,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  color: appColors.grey.withOpacity(0.4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Allow Access",
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: appColors.white,
                                    // fontFamily: FontFamily.poppins,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAllDashboardData({bool isReapeting = false}) async {
    await getConstantDetailsData();
    if (getConstantDetails != null) {
      if (getConstantDetails!.data!.isForceTraningVideo == 1) {
        print("if----getConstantDetails!.data!.isForceTraningVideo");
        getAllTrainingVideo(isReapeting: isReapeting);
        update();
      } else {
        print("else----getConstantDetails!.data!.isForceTraningVideo");
        await getDashboardDetail();
        getAstroNoticeBoardData();

        getFilteredPerformance();
        getFeedbackData();
        tarotCardData();
        getUserImage();
        print("----------------loaded");

        if (getConstantDetails!.data!.is_screenshot_require.toString() == "1") {
          captureandSendSS();
        } else {
          print("screenshot declined");
        }
        update();
      }
    } else {
      print("getConstantDetails is null");
    }
    update();
  }

  DateTime getChatDateAndTime({
    required String dateString,
    required String timeString,
  }) {
    final DateTime date = DateTime.parse(dateString);
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final TimeOfDay time = TimeOfDay.fromDateTime(timeFormat.parse(timeString));
    final DateTime combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return combinedDateTime;
  }

  getUserImage() async {
    String? baseUrl = Get.find<SharedPreferenceService>().getBaseImageURL();

    userImage = "${baseUrl}/${userData.image}";
    print(userImage);
    print("userImageuserImageuserImageuserImage");
    update();
  }

  fetchImportantNumbers() async {
    try {
      final response = await ImportantNumberRepo().fetchData();
      if (response.data != null) {
        importantNumbers = response.data!;
      }
      isAllNumbersExist = checkForALlContact(importantNumbers);
      importantNumberBottomsheet();
    } catch (error) {
      divineSnackBar(data: error.toString(), color: appColors.redColor);
    }
  }

  getContactList() async {
    PermissionStatus contact = await Permission.contacts.status;
    if (contact.isGranted) {
      allContacts = await ContactsService.getContacts();
    } else {
      PermissionStatus status = await Permission.contacts.request();
      if (status.isGranted) {
        allContacts = await ContactsService.getContacts();
      }
    }
    // {
    //   divineSnackBar(data: 'contactPermissionRequired'.tr);
    // }
  }

  bool checkForALlContact(List<MobileNumber> importantNumbers) {
    bool isExist = true;
    for (int i = 0; i < importantNumbers.length; i++) {
      bool value = checkForContactExist(importantNumbers[i]);
      if (!value) {
        isExist = false;
        break;
      }
    }
    return isExist;
  }

  bool checkForContactExist(MobileNumber numbers) {
    Item item =
        Item(label: numbers.title ?? "", value: numbers.mobileNumber ?? "");
    List<String> numberList = [];
    if (item.value != null && item.value!.contains(",")) {
      numberList = item.value!.split(",").toList();
    }
    bool isExist = false;
    if (allContacts.isEmpty) return isExist;
    for (Contact contact in allContacts) {
      if (contact.phones != null) {
        for (var element in contact.phones!) {
          //  log(element.value!);
          if (contact.displayName == item.label
              // &&
              // numberList.every((el) => el.contains(element.value!))
              ) {
            return isExist = true;
          }
        }
      }
    }
    return isExist;
  }

  importantNumberBottomsheet() async {
    if (!isAllNumbersExist!) {
      await importantNumberBottomSheet(
        Get.context!,
      );
    }
  }

  addContact({
    required String givenName,
    required List<String> contactNumbers,
  }) async {
    PermissionStatus permission = await Permission.contacts.request();
    if (permission.isGranted) {
      List<Item> phoneItems = contactNumbers.map((contactNo) {
        return Item(label: "mobile", value: contactNo);
      }).toList();
      Contact newContact = Contact(
          givenName: givenName, //This fields are mandatory to save contact
          phones: phoneItems);
      await ContactsService.addContact(newContact);
      divineSnackBar(data: "contactSaved".tr);
      //fetchImportantNumbers();
    } else {
      openAppSettings();
    }
  }

  ConstantDetailsModelClass? getConstantDetails;
  RxBool profileDataSync = false.obs;

  HomeData? homeData;
  var walletData = <WalletPoint>[].obs;
  RxBool isFeedbackAvailable = false.obs;
  FeedbackData? feedbackResponse;
  Offset fabPosition = const Offset(20, 20);
  List<FeedbackData>? feedbacksList;
  Loading loading = Loading.initial;
  RxBool shopDataSync = false.obs;
  ViewTrainingVideoModelClass? viewTrainingVideoModelClass;
  SendFeedBackModel? sendFeedBackModel;

  PerformanceResponse? performanceResponse;
  RxList<dynamic> overAllScoreList = <dynamic>[].obs;
  RxList<dynamic> performanceScoreList = [].obs;

  getFilteredPerformance() async {
    try {
      Map<String, dynamic> params = {"filter": 'yesterday'};
      var response = await PerformanceRepository().getPerformance(params);
      log("Res-->${jsonEncode(response.data)}");
      performanceResponse = response;
      overAllScoreList.value = [
        response.data?.conversionRate,
        response.data?.repurchaseRate,
        response.data?.onlineHours,
        response.data?.liveHours,
        response.data?.ecom,
        response.data?.busyHours,
      ];

      for (int i = 0; i < overAllScoreList.length; i++) {
        int averageScore =
            int.parse(overAllScoreList[i]?.performance?.marks?[1].max ?? '0');
        int yourMarks =
            int.parse(overAllScoreList[i]?.performance?.marksObtains ?? '0');
        if (averageScore > yourMarks) {
          performanceScoreList.add(overAllScoreList[i]);
        }
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  sendFeedbackAPI(String text) async {
    Map<String, dynamic> params = {"comment": text.toString()};
    try {
      var data = await userRepository.sendFeedBack(params);
      sendFeedBackModel = data;
      feedBackText.clear();
      divineSnackBar(data: sendFeedBackModel?.message.toString() ?? '');
      profileDataSync.value = true;
      log("send FeedBack-->${sendFeedBackModel?.message}");
      log("params Body-->$text");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  trainingVideoViewData(int videoId, {bool isFromForceVideo = false}) async {
    Map<String, dynamic> params = {"training_video_id": videoId};
    try {
      var data = await userRepository.viewTrainingVideoApi(params);
      viewTrainingVideoModelClass = data;
      profileDataSync.value = true;
      await getConstantDetailsData();
      if (isFromForceVideo) {
        if (getConstantDetails!.data!.isForceTraningVideo == 1) {
          getAllDashboardData(isReapeting: true);
        } else {
          Get.back();
        }
      } else {
        Get.back();
      }

      update();
      log("DoneVideo-->${viewTrainingVideoModelClass!.message}");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  getFeedbackData() async {
    update();
    try {
      var response = await homePageRepository.getFeedbackData();

      isFeedbackAvailable.value = response.success ?? false;
      debugPrint('val: $isFeedbackAvailable');
      if (isFeedbackAvailable.value) {
        //print(" Dharam::${response.data?[0].order?.orderId}");
        feedbackResponse = response.data?[0];
        feedbacksList = response.data;

        if (feedbackResponse?.id != null && !isFeedbackAvailable.value) {
          showFeedbackBottomSheet();
          debugPrint('feed id: ${feedbackResponse?.id}');
        }
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  bool showPopup = true;
  getDashboardDetail() async {
    loading = Loading.initial;
    update();
    Map<String, dynamic> params = {
      "role_id": userData.roleId ?? 0,
      "device_token": userData.deviceToken,
    };
    try {
      var response = await HomePageRepository().getDashboardData(params);
      isFeedbackAvailable.value = response.success ?? false;
      homeData = response.data;
      print("homeData!.trainingVideo!-->>${homeData!.trainingVideo!.length}");
      loading = Loading.loaded;
      updateCurrentData();
      shopDataSync.value = true;

      showOnceInDay();
      update();

      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String lastShownDate = await SharedPreferenceService().getLastShowDate();
      if (homeData?.retention < 10 && lastShownDate != currentDate) {
        await SharedPreferenceService().setLastShowDate(currentDate);
        if (showAllPopup.value == true) {
          Get.bottomSheet(CommonInfoSheet(
            isBackButton: false,
            title: "⚠ ${"warning_astrologers".tr} ⚠".tr,
            subTitle: "warning_text".tr,
            onTap: () {
              Get.back();
            },
          ));
        }
      }

      if (homeData?.technical_support == null ||
          homeData?.technical_support == [] ||
          homeData?.technical_support!.isEmpty) {
      } else {
        log("Technical_Support -- ${homeData?.technical_support.toString()}");
        update();
        if (Get.find<DashboardController>().selectedIndex.value == 0 &&
            showPopup == true &&
            !homeScreenKey.currentState!.isDrawerOpen) {
          showTechnicalPopupAlert();
        } else {
          log("--------------------------------------");
        }
      }
      //getFeedbackData();
      //log("DashboardData==>${jsonEncode(homeData)}");
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  getAstroNoticeBoardData() async {
    try {
      Map<String, dynamic> params = {
        "role_id": userData.roleId ?? 0,
        "device_token": userData.deviceToken,
      };
      log("noticeBoard paramss --------------- ${params.toString()}");
      var response = await HomePageRepository().getAstroNoticeBoardData(params);
      astroNoticeBoardResponse.value = response;
      log("AstroNoticeBoardData==>${jsonEncode(astroNoticeBoardResponse)}");
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    update();
  }

  var loadWalletData = false.obs;

  getWalletPointDetail(wallet) async {
    update();
    loadWalletData(true);
    try {
      var response = await HomePageRepository().getWalletDetailsData(wallet);
      walletData.value = response.data;
      loadWalletData(false);
    } catch (error) {
      loadWalletData(false);

      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  tarotCardData() async {
    // loading = Loading.initial;
    try {
      print("response.data1");
      await HomePageRepository().getTarotCardData();
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  updateCurrentData() {
    // chatSwitch.value = homeData?.sessionType?.chat == 1;
    // callSwitch.value = homeData?.sessionType?.call == 1;
    // videoSwitch.value = homeData?.sessionType?.video == 1;

    chatSwitch.value = (homeData?.inAppChatPrevStatus ?? 0) == 1;
    callSwitch.value = (homeData?.audioCallPrevStatus ?? 0) == 1;
    videoSwitch.value = (homeData?.videoCallPrevStatus ?? 0) == 1;

    print("updateCurrentData called");
    print("updateCurrentData Chat ${homeData?.inAppChatPrevStatus}");
    print("updateCurrentData Audio ${homeData?.audioCallPrevStatus}");
    print("updateCurrentData Video ${homeData?.videoCallPrevStatus}");

    // socket.updateChatCallSocketEvent(
    //     //   call: callSwitch.value ? "1" : "0",
    //     //   chat: chatSwitch.value ? "1" : "0",
    //     //   video: videoSwitch.value ? "1" : "0",
    //     // );

    // if (Constants.isTestingMode) {
    //   // astroOnlineOffline(status: "chat_status=${chatSwitch.value ? "1" : "0"}");
    //   // astroOnlineOffline(status: "call_status=${callSwitch.value ? "1" : "0"}");
    // }

    if (homeData?.sessionType?.chatSchedualAt != null &&
        homeData?.sessionType?.chatSchedualAt != '') {
      DateTime formattedDate = DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(homeData!.sessionType!.chatSchedualAt!);
      String formattedTime = DateFormat("hh:mm a").format(formattedDate);

      selectedChatDate.value = formattedDate;
      selectedChatTime.value = formattedTime;
    }

    if (homeData?.sessionType?.callSchedualAt != null &&
        homeData?.sessionType?.callSchedualAt != '') {
      DateTime formattedDate = DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(homeData!.sessionType!.callSchedualAt!);
      String formattedTime = DateFormat("hh:mm a").format(formattedDate);

      selectedCallDate.value = formattedDate;
      selectedCallTime.value = formattedTime;
    }
    if (homeData?.sessionType?.videoSchedualAt != null &&
        homeData?.sessionType?.videoSchedualAt != '') {
      DateTime formattedDate = DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(homeData!.sessionType!.videoSchedualAt!);
      String formattedTime = DateFormat("hh:mm a").format(formattedDate);

      selectedVideoDate.value = formattedDate;
      selectedVideoTime.value = formattedTime;
    }

    ///Customer Offer data
    if (homeData?.offers?.customOffer != null &&
        homeData?.offers?.customOffer != []) {
      for (int i = 0; i < homeData!.offers!.customOffer!.length; i++) {
        if (homeData!.offers!.customOffer![i].toggle == 1) {
          homeData!.offers!.customOffer![i].isOn = true;
          update();
        }
      }
    }

    update();
  }

  Dio dio = Dio();

  astroOnlineOffline({String? status}) async {
    try {
      // Configure the default headers for all requests
      dio.options.headers = {
        'Connection': 'keep-alive',
        'Keep-Alive': 'timeout=5, max=1000',
      };
      final response = await dio
          .get("${ApiProvider.astOnlineOffline}${userData.uniqueNo}&$status");
      log(response.data.toString());
      print("response.data");
      if (response.statusCode == 200) {}
    } catch (e) {
      print("getting error --- getAstroCustOfferData ${e}");
    }
  }

  String chatMessage = "";
  String callMessage = "";
  String chatMessageColor = "";
  String callMessageColor = "";

  getAstrologerStatus() async {
    UserData? userData = await pref.getUserDetail();
    print("---------------${userData!.toJson().toString()}");
    try {
      dio.options.headers = {
        'Connection': 'keep-alive',
        'Keep-Alive': 'timeout=5, max=1000',
      };
      final response = await dio.get(
        "${ApiProvider.getOnlineOfflineStatus}${userData!.uniqueNo}",
      );
      print("response.dataresponse.data${response.data}");
      print("response.dataresponse.data${userData!.uniqueNo}");

      AstrologerNordModel astrologerNordModel =
          AstrologerNordModel.fromJson(response.data);
      if (astrologerNordModel.status!.code == 200) {
        if (astrologerNordModel.data != null) {
          chatMessage = astrologerNordModel.data!.chatMsg ?? "";
          callMessage = astrologerNordModel.data!.callMsg ?? "";
          chatMessageColor = astrologerNordModel.data!.chatColor ?? "";
          callMessageColor = astrologerNordModel.data!.callColor ?? "";
          print(
              "chatMessage----${chatMessage}--chatMessageColor---${chatMessageColor}--callMessage-----${callMessage}--callMessageColor--${callMessageColor}");
          update();
        } else if (response.statusCode == 110 ||
            response.statusCode == HttpStatus.networkConnectTimeoutError ||
            response.statusCode == HttpStatus.networkAuthenticationRequired) {
          divineSnackBar(
              data: "No Internet connection", color: appColors.redColor);
        }
      }
    } catch (e) {
      print("getting error --- getAstroCustOfferData ${e}");
    }
  }

  int showAgreement = 0;

  getConstantDetailsData() async {
    try {
      var data = await userRepository.constantDetailsData();
      print(data.data!.showAgreement);
      if (data.data!.showAgreement != null) {
        showAgreement = data.data!.showAgreement ?? 0;
        update();
        log("showAgreement----->>>>$showAgreement");
      }
      print("constantDetailsModelClass.data!.showAgreement");
      getConstantDetails = data;
      log(getConstantDetails!.data!.toJson().toString());
      print("getting is force training video flag");
      await preferenceService.setConstantDetails(data);
      profileDataSync.value = true;
      imageUploadBaseUrl.value =
          getConstantDetails?.data?.imageUploadBaseUrl ?? "";
      update();
      // getDashboardDetail();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        //  divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  AstroRitentionModel? getRitentionModel;
  var change = false.obs;

  getRitentionDataApi() async {
    try {
      var data = await userRepository.getRitentionData({});

      if (data.success == true) {
        getRitentionModel = data;
      } else {
        getRitentionModel = null;
      }
      update();
      // getDashboardDetail();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        //  divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  List<TrainingVideoData> traingVideoData = [];

  int videoPage = 1;

  getAllTrainingVideo({bool isReapeting = false}) async {
    try {
      var data = await homePageRepository.getAllTraningVideoApi();
      if (data.data!.isNotEmpty) {
        traingVideoData = data.data!;
      }
      for (int i = 0; i < traingVideoData.length; i++) {
        if (traingVideoData[i].isViwe == 0) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          if (!isReapeting) {
            Get.to(() {
              return TrainingVideoUI(
                video: traingVideoData[i],
              );
            })!
                .then((value) {
              print("in side going");
              getAllDashboardData();
              print("----------------loaded");

              if (homeData != null ||
                  getConstantDetails!.data != null ||
                  getConstantDetails!.data!.is_screenshot_require.toString() ==
                      "0") {
                captureandSendSS();
              } else {
                print("screenshot declined");
              }
            });
            print("isReapeting ----- ${isReapeting}");
          } else {
            print("isReapeting ----- ${isReapeting}");
            Get.off(() {
              return TrainingVideoUI(
                video: traingVideoData[i],
              );
            });
          }
          break;
        }
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  RxString marqueeText = "".obs;

  void getSampleText() async {
    marqueeText.value = "";
    debugPrint("test_marqueeText: ${marqueeText.value.length}");
    try {
      SampleTextResponse? response = await homePageRepository.doGetSampleText();

      if (response != null && response.statusCode == 200) {
        if (response.data != null && response.data!.text.isNotEmpty) {
          marqueeText.value = response.data!.text;
          debugPrint("test_marqueeText: ${marqueeText.value}");
        }
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      }
    }
  }

  RxList<AstrologerTrainingSessionModel> astrologerTrainingSessionLst =
      <AstrologerTrainingSessionModel>[].obs;

  void getAstrologerTrainingSession() async {
    astrologerTrainingSessionLst.clear();

    try {
      AstrologerTrainingSessionResponse? response =
          await homePageRepository.doGetAstrologerTrainingSession();
      print("training videsooooooooo-- ${response.toString()}");
      if (response != null && response.statusCode == 200) {
        if (response.data != null && response.data!.isNotEmpty) {
          astrologerTrainingSessionLst.addAll(response.data!);
          print(
              "astrologerTrainingSessionLst.length-->>${astrologerTrainingSessionLst.length}");
        }
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      }
    }
  }

  whatsapp() async {
    var contact = getConstantDetails?.data?.whatsappNo ?? '';
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      divineSnackBar(data: 'WhatsApp is not installed.');
      log('WhatsApp is not installed.');
    }
  }

  is_ecom_supportWhatAspp() async {
    var contact = getConstantDetails?.data?.is_ecom_support ?? '';
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      divineSnackBar(data: 'WhatsApp is not installed.');
      log('WhatsApp is not installed.');
    }
  }

  Future<void> chatSwitchFN({required Function() onComplete}) async {
    await updateSessionType(!chatSwitch.value, chatSwitch, 1);
    onComplete();
    return Future<void>.value();
  }

  Future<void> callSwitchFN({required Function() onComplete}) async {
    await updateSessionType(!callSwitch.value, callSwitch, 2);
    onComplete();
    return Future<void>.value();
  }

  Future<void> videoCallSwitchFN({required Function() onComplete}) async {
    videoSwitch(!videoSwitch.value);
    await updateSessionType(videoSwitch.value, videoSwitch, 3);
    onComplete();
    return Future<void>.value();
  }

  final noticeRepository = Get.put(NoticeRepository());

  Rx<DateTime> selectedChatDate = DateTime.now().obs;
  Rx<String> selectedChatTime = ''.obs;

  Rx<DateTime> selectedCallDate = DateTime.now().obs;
  Rx<String> selectedCallTime = ''.obs;

  Rx<DateTime> selectedVideoDate = DateTime.now().obs;
  Rx<String> selectedVideoTime = ''.obs;

  void selectChatDate(String value) {
    selectedChatDate(value.toDate());
  }

  void selectChatTime(String value) {
    selectedChatTime(value);
  }

  void selectCallDate(String value) {
    selectedCallDate(value.toDate());
  }

  void selectCallTime(String value) {
    selectedCallTime(value);
  }

  void selectVideoDate(String value) {
    selectedVideoDate(value.toDate());
  }

  void selectVideoTime(String value) {
    selectedVideoTime(value);
  }

  Future<void> updateSessionType(
    bool value,
    RxBool switchType,
    int type,
  ) async {
    showLoader();
    //type: 1 - chat, 2 - call, 3 - videoCall
    Map<String, dynamic> params = {
      "type": type,
      "role_id": 7,
      "device_token": preferenceService.getDeviceToken(),
    };

    value ? params["check_in"] = 1 : params["check_out"] = 1;

    print("here is it is comming - ${params.toString()}");

    sessionTypeLoading.value = Loading.loading;
    try {
      // UpdateSessionTypeResponse response =
      //     await userRepository.astroOnlineAPIForLive(params);
      UpdateSessionTypeResponse response =
          await userRepository.astroOnlineAPIForLive(
        params: params,
        successCallBack: (message) {
          getAstrologerStatus();

          /// o offline
          /// 1 online
          // socket.updateChatCallSocketEvent(
          //   call: callSwitch.value ? "1" : "0",
          //   chat: chatSwitch.value ? "1" : "0",
          //   video: videoSwitch.value ? "1" : "0",
          // );
          // switch (type) {
          //   case 1:
          //     astroOnlineOffline(
          //         status: 'chat_status=${chatSwitch.value ? "1" : "0"}');
          //     break;
          //   case 2:
          //     astroOnlineOffline(
          //         status: 'call_status=${callSwitch.value ? "1" : "0"}');
          //     break;
          //   default:
          //     break;
          // }
          print("message 1------>$message");
          divineSnackBar(
              data: message, duration: const Duration(milliseconds: 5000));
        },
        failureCallBack: (message) {
          switch (type) {
            case 1:
              // chatSwitch(!chatSwitch.value);
              break;
            case 2:
              // callSwitch(!callSwitch.value);
              break;
            case 3:
              videoSwitch(!videoSwitch.value);
              break;
            default:
              break;
          }
          divineSnackBar(
              data: message ?? "",
              duration: const Duration(milliseconds: 5000));
        },
      );

      Get.back();

      if (response.statusCode == 200) {
        print("here is it is comming - ${callSwitch.value}");
        print("here is it is comming - ${type}");
        print("here is it is comming - ${response.message}");
        print("here is it is comming - ${response.toJson()}");
        print("type - $type");
        if (type == 1 &&
            response.message == "Successfully Checkin" &&
            params.containsKey("check_in")) {
          print("here is it is comming --- ${params.containsKey("check_in")}");
          if (disableAstroEvent.toString() == "1") {
            firebaseEvent.chat_event({
              "astrologer_id": userData.id ?? "",
              "chat_on": "yes",
              "date_time": DateTime.now().toString(),
            });
          }
          chatSwitch(true);
          showDiscountPopup();
        } else {}

        if (type == 2 &&
            response.message == "Successfully Checkin" &&
            params.containsKey("check_in")) {
          if (disableAstroEvent.toString() == "1") {
            firebaseEvent.call_event({
              "astrologer_id": userData.id ?? "",
              "call_on": "yes",
              "date_time": DateTime.now().toString(),
            });
          }
          callSwitch(true);
          print("here is it is comming");
          showDiscountPopup();
        } else {}
        if (type == 1 &&
            response.message == "Successfully Checkout" &&
            params.containsKey("check_out")) {
          print("here is it is comming --- ${params.containsKey("check_in")}");
          if (disableAstroEvent.toString() == "1") {
            firebaseEvent.chat_event({
              "astrologer_id": userData.id ?? "",
              "chat_on": "no",
              "date_time": DateTime.now().toString(),
            });
          }
          chatSwitch(false);
        } else {}

        if (type == 2 &&
            response.message == "Successfully Checkout" &&
            params.containsKey("check_out")) {
          if (disableAstroEvent.toString() == "1") {
            firebaseEvent.call_event({
              "astrologer_id": userData.id ?? "",
              "call_on": "no",
              "date_time": DateTime.now().toString(),
            });
          }
          callSwitch(false);
        } else {}
        if (!videoSwitch.value && type == 3) {
          selectDateTimePopupForVideo();
        } else {
          selectedVideoTime.value = "";
        }
        // if (!callSwitch.value && type == 2) {
        //   // selectDateTimePopupForCall();
        // } else {
        //   selectedCallTime.value = "";
        // }
        // if (!chatSwitch.value && type == 1) {
        //   // selectDateTimePopupForChat();
        // } else {
        //   selectedChatTime.value = "";
        // }
        // switchType.value = value;
        // if (switchType.value && type == 1) {
        //   selectedChatDate.value = DateTime.now();
        //   selectedChatTime.value = "";
        // }
        // if (switchType.value && type == 2) {
        //   selectedCallDate.value = DateTime.now();
        //   selectedCallTime.value = "";
        // }
      } else if (response.statusCode == 400) {
        Get.bottomSheet(CantOnline(message: response.message));
      }
      update();
    } catch (error) {
      debugPrint("updateOfferType $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    sessionTypeLoading.value = Loading.loaded;
    update();
  }

  Future<void> updateOfferType({
    required bool value,
    required int offerId,
    required int index,
    required int offerType,
  }) async {
    Map<String, dynamic> params = {
      "offer_id": offerId,
      "offer_type": offerType,
      "action": value ? 1 : 0,
    };
    offerTypeLoading.value = Loading.loading;
    try {
      UpdateOfferResponse response =
          await userRepository.updateOfferTypeApi(params);
      if (response.statusCode == 200) {
        homeData!.offers!.customOffer![index].isOn = value;
      } else {
        homeData!.offers!.customOffer![index].isOn = !value;
      }
      if (disableAstroEvent.toString() == "1") {
        print("hfdjfdfjfjfhjdhfjdhfjdfhjdfh");
        firebaseEvent.astrolgoer_enable_offer({
          "astrologer_id": userData.id.toString(),
          "action": value.toString(),
          "offer_id": offerId.toString(),
          "offerType": offerType.toString(),
        });
      }
      update();
    } catch (error) {
      homeData!.offers!.customOffer![index].isOn = !value;
      debugPrint("updateOfferType $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    offerTypeLoading.value = Loading.loaded;
    update();
  }

  updateOrderOffer({
    required bool value,
    required int offerId,
    required int index,
  }) async {
    Map<String, dynamic> params = {
      "offer_id": offerId,
      "offer_type": 1,
      "action": value ? 1 : 0,
    };
    offerTypeLoading.value = Loading.loading;
    try {
      UpdateOfferResponse response =
          await userRepository.updateOfferTypeApi(params);
      if (response.statusCode == 200) {
        homeData!.offers!.orderOffer![index].isOn = value;
        // homeData!.offers!.orderOffer![index].isOn = !homeData!.offers!.orderOffer![index].isOn!;
      } else {
        homeData!.offers!.orderOffer![index].isOn = !value;
      }

      update();
    } catch (error) {
      homeData!.offers!.orderOffer![index].isOn = !value;
      debugPrint("updateOfferType $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    offerTypeLoading.value = Loading.loaded;
    update();
  }

  bool isValidDate(String value, String timeVal) {
    var selectedTime = timeVal;
    var selectedDate = value == "CHAT"
        ? selectedChatDate.value
        : value == "CALL"
            ? selectedCallDate.value
            : selectedVideoDate.value;
    DateTime parseDate = DateFormat("hh:mm a").parse(selectedTime);
    var formattedTime = (DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, parseDate.hour, parseDate.minute, 0));

    bool difference = DateTime.now().isBefore(formattedTime);
    return difference;
  }

  void scheduleCall(String value, bool fromSwitch) async {
    // if (fromSwitch) {
    //   showLoader();
    // }
    showLoader();
    var selectedTime = value == "CHAT"
        ? selectedChatTime.value
        : value == "CALL"
            ? selectedCallTime.value
            : selectedVideoTime.value;
    var selectedDate = value == "CHAT"
        ? selectedChatDate.value
        : value == "CALL"
            ? selectedCallDate.value
            : selectedVideoDate.value;
    DateTime parseDate = DateFormat("hh:mm a").parse(selectedTime);
    var formattedTime = (DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, parseDate.hour, parseDate.minute, 0));

    bool difference = DateTime.now().isBefore(formattedTime);

    if (difference) {
      try {
        ///Type 1:call
        ///Type 2:chat
        ///Type 3:Video
        int type = 0;

        late AstroScheduleRequest request;
        if (value == "CHAT") {
          type = 2;
          request = AstroScheduleRequest(
            scheduleDate: selectedChatDate.value.toFormattedString(),
            scheduleTime: selectedChatTime.value,
            type: type,
          );
        }
        if (value == "CALL") {
          type = 1;
          request = AstroScheduleRequest(
            scheduleDate: selectedCallDate.value.toFormattedString(),
            scheduleTime: selectedCallTime.value,
            type: type,
          );
        }
        if (value == "VIDEO") {
          type = 3;
          request = AstroScheduleRequest(
            scheduleDate: selectedVideoDate.value.toFormattedString(),
            scheduleTime: selectedVideoTime.value,
            type: type,
          );
        }

        final response = await noticeRepository.astroScheduleOnlineAPI(
          request.toJson(),
        );
        Get.back();
        if (response.statusCode == 200 && response.success) {
          divineSnackBar(data: response.message);
        }
        if (fromSwitch && value == "CHAT") {
          await chatSwitchFN(
            onComplete: () {
              // if (controller.chatSwitch.value) {
              // } else {
              //   selectDateTimePopupForChat();
              // }
            },
          );
        } else {
          sessionTypeLoading.value = Loading.loaded;
        }
        if (fromSwitch && value == "CALL") {
          await callSwitchFN(
            onComplete: () {
              // if (controller.callSwitch.value) {
              // } else {
              //   selectDateTimePopupForCall();
              // }
            },
          );
        } else {
          sessionTypeLoading.value = Loading.loaded;
        }
      } catch (err) {
        if (err is AppException) {
          err.onException();
        }
      }
    }
  }

  getBoolToString(bool value) {
    return value ? "1" : "0";
  }

  showOnceInDay() async {
    int timestamp = await preferenceService
        .getIntPrefs(SharedPreferenceService.performanceDialog);

    if (timestamp == 0 ||
        (DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(timestamp))
                .inDays >
            0) ||
        getDateDifference(timestamp)) {
      await preferenceService.setIntPrefs(
          SharedPreferenceService.performanceDialog,
          DateTime.now().millisecondsSinceEpoch);
      if (performanceScoreList.isNotEmpty) {
        showDialog(
          context: Get.context!,
          barrierColor: appColors.darkBlue.withOpacity(0.5),
          builder: (_) => PerformanceDialog(),
        ).then((value) {
          getUserImage();
          update();
        });
      }
    }
  }

  showFeedbackBottomSheet() async {
    await feedbackBottomSheet(
      Get.context!,
      title: "Feedback Available!!!",
      subTitle:
          'We noticed a little guideline slip in your \n previous order. No worries!'
          'We\'ve sorted out\n the fines and shared some helpful feedback.\n'
          'Thanks for your understanding!',
      btnTitle: "Check Report",
      onTap: () {
        Get.toNamed(RouteName.feedback, arguments: {
          'order_id': feedbackResponse?.orderId,
          'product_type': feedbackResponse?.order?.productType,
        });
      },
      /*  functionalityWidget: Html(
        data: feedbackResponse?.remark ?? '',
        onLinkTap: (url, __, ___) {
          launchUrl(Uri.parse(url ?? ''));
        },
      )*/
      // Text(
      //   feedbackResponse?.remark ?? '',
      //   textAlign: TextAlign.center,
      //   style: AppTextStyle.textStyle16(),
      // ),
    );
  }

  showGiftBottomSheet(int giftCount, BuildContext? contextDetail,
      {var baseUrl}) async {
    // if(MiddleWare.instance.currentPage == RouteName.chatMessageUI || MiddleWare.instance.currentPage == RouteName.chatMessageWithSocketUI){
    //   return;
    // }
    PopupManager.showGiftCountPopup(contextDetail!,
        title: "Congratulations",
        btnTitle: "Check Order History",
        baseUrl: baseUrl,
        totalGift: giftCount);

    // await GiftCountPopup(
    //   Get.context!,
    //   title: "Congratulations!",
    //   btnTitle: "Check Order History",
    //   totaltGift: giftCount,
    // );
  }

  getDateDifference(int timestamp) {
    DateTime dtTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();

    if (now.day != dtTimestamp.day ||
        now.month != dtTimestamp.month ||
        now.year != dtTimestamp.year) {
      return true;
    } else {
      return false;
    }
  }

  // Future<bool> hasOpenOrder() async {
  //   bool hasOpenOrder = false;
  //
  //   final String id = (preferenceService.getUserDetail()?.id ?? "").toString();
  //   final String realTimeNode = "astrologer/$id/realTime";
  //
  //   final DatabaseReference reference = FirebaseDatabase.instance.ref();
  //   final DataSnapshot dataSnapshot = await reference.child(realTimeNode).get();
  //
  //   if (dataSnapshot.exists) {
  //     if (dataSnapshot.value is Map<dynamic, dynamic>) {
  //       Map<dynamic, dynamic> map = <dynamic, dynamic>{};
  //       map = (dataSnapshot.value ?? <dynamic, dynamic>{})
  //           as Map<dynamic, dynamic>;
  //
  //       if (map.isEmpty) {
  //       } else if (map.isNotEmpty) {
  //         hasOpenOrder = map["order_id"] != null;
  //       } else {}
  //     } else {}
  //   } else {}
  //   return Future<bool>.value(hasOpenOrder);
  // }

  String getLabel() {
    if (performanceScoreList.isNotEmpty &&
        performanceScoreList.length > scoreIndex) {
      final bool b1 = (performanceScoreList ?? <dynamic>[]).isNotEmpty;
      final bool b2 = performanceScoreList[scoreIndex] != null;
      final bool b3 = performanceScoreList[scoreIndex]?.label != null;
      return (b1 && b2 && b3)
          ? performanceScoreList[scoreIndex]?.label ?? ""
          : "";
    }
    return "";
  }

  Future<void> showDiscountPopup() async {
    return Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        // insetPadding: EdgeInsets.all(16),
        // contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0,
        content: customerOfferWidget2(Get.context!),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Ok",
              style: AppTextStyle.textStyle18(
                fontWeight: FontWeight.w500,
                fontColor: appColors.darkBlue,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget customerOfferWidget2(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        // key: Get.find<DashboardController>().keyManageDiscountOffers,
        margin: EdgeInsets.only(top: 10.h),
        // padding: EdgeInsets.all(16.h),
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //         color: Colors.black.withOpacity(0.2),
        //         blurRadius: 1.0,
        //         offset: const Offset(0.0, 3.0)),
        //   ],
        //   color: appColors.white,
        //   borderRadius: const BorderRadius.all(Radius.circular(20)),
        // ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "discount_offer".tr,
                    style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w500,
                      fontColor: appColors.darkBlue,
                    ),
                  ),
                  /*InkWell(
                              onTap: () {
                                Get.toNamed(RouteName.discountOffers)!.then((value) {
                                  controller!.homeData?.offers?.customOffer = value;
                                  controller.update();
                                });
                              },
                              child: Text(
                                "viewAll".tr,
                                style: AppTextStyle.textStyle12(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.darkBlue,
                                ),
                              ),
                            ),*/
                ],
              ),
              // Text(
              //   "(You can apply each offer only once per day)",
              //   style: AppTextStyle.textStyle10(
              //     fontWeight: FontWeight.w500,
              //     fontColor: appColors.guideColor,
              //   ),
              // ),

              SizedBox(height: 10.h),
              for (int index = 0;
                  index < homeData!.offers!.customOffer!.length;
                  index++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "${homeData!.offers!.customOffer?[index].offerName}"
                                .toUpperCase(),
                            style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SwitchWidget(
                        onTap: () {
                          if (homeData!.offers!.customOffer![index].isOn!) {
                            homeData!.offers!.customOffer?[index].isOn =
                                !homeData!.offers!.customOffer![index].isOn!;
                            updateOfferType(
                                value:
                                    homeData!.offers!.customOffer![index].isOn!,
                                index: index,
                                offerId:
                                    homeData!.offers!.customOffer![index].id!,
                                offerType: 2);
                          } else if (homeData!.offers!.customOffer!
                              .any((element) => element.isOn!)) {
                            divineSnackBar(
                                data: "Only 1 custom offer is allowed at once",
                                color: appColors.redColor);
                          } else {
                            homeData!.offers!.customOffer?[index].isOn =
                                !homeData!.offers!.customOffer![index].isOn!;
                            updateOfferType(
                                value:
                                    homeData!.offers!.customOffer![index].isOn!,
                                index: index,
                                offerId:
                                    homeData!.offers!.customOffer![index].id!,
                                offerType: 2);
                          }

                          update();
                        },
                        switchValue: homeData!.offers!.customOffer?[index].isOn,
                      )
                    ],
                  ),
                ),

              /*ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homeData!.offers!.customOffer!.length,
                separatorBuilder: (context, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  DiscountOffer data = homeData!.offers!.customOffer![index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "${data.offerName}".toUpperCase(),
                            style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          // if ((controller
                          //     .homeData?.offers?.customOffer?[index].callRate ??
                          //     0) >
                          //     0)
                          //   CustomText(
                          //     " (₹${controller.homeData?.offers?.orderOffer?[index].callRate}/min)"
                          //         .toUpperCase(),
                          //     fontSize: 10.sp,
                          //   ),
                        ],
                      ),
                      SwitchWidget(
                        onTap: () {
                          if (data.isOn!) {
                            data.isOn = !data.isOn!;
                            updateOfferType(
                                value: data.isOn!,
                                index: index,
                                offerId: data.id!,
                                offerType: 2);
                          } else if (homeData!.offers!.customOffer!
                              .any((element) => element.isOn!)) {
                            divineSnackBar(
                                data: "Only 1 custom offer is allowed at once",
                                color: appColors.redColor);
                          } else {
                            data.isOn = !data.isOn!;
                            updateOfferType(
                                value: data.isOn!,
                                index: index,
                                offerId: data.id!,
                                offerType: 2);
                          }

                          update();
                        },
                        switchValue: data.isOn,
                      )
                    ],
                  );
                },
              ),*/
            ],
          ),
        ),
      );
    });
  }

  void selectDateTimePopupForVideo() {
    selectDateOrTime(
      futureDate: true,
      Get.context!,
      title: "ScheduleOnlineDate".tr,
      btnTitle: "confirmNextDate".tr,
      pickerStyle: "DateCalendar",
      looping: true,
      type: "VIDEO",
      lastDate: DateTime(2050),
      onConfirm: (value) => selectVideoDate(value),
      onChange: (value) => selectVideoDate(value),
      onClickOkay: (value) {
        Get.back();
        selectDateOrTime(Get.context!,
            title: "scheduleOnlineTime".tr,
            btnTitle: "confirmOnlineTime".tr,
            type: "VIDEO",
            selectedDate: selectedVideoDate.value,
            pickerStyle: "TimeCalendar",
            looping: true, onConfirm: (value) {
          // controller.selectVideoTime(value),
        }, onChange: (value) {
          // controller.selectVideoTime(value);
          if (isValidDate("VIDEO", value)) {
            selectVideoTime(value);
            scheduleCall("VIDEO", false);
          } else {
            // Fluttertoast.showToast(msg: "Please select future date and time");
          }
        });
      },
    );
  }

  void selectDateTimePopupForCall(fromSwitch) {
    selectDateOrTime(
      futureDate: true,
      Get.context!,
      title: "ScheduleOnlineDate".tr,
      btnTitle: "confirmNextDate".tr,
      pickerStyle: "DateCalendar",
      looping: true,
      type: "CALL",
      lastDate: DateTime(2050),
      onConfirm: (value) => selectCallDate(value),
      onChange: (value) => selectCallDate(value),
      onClickOkay: (value) {
        Get.back();
        selectDateOrTime(Get.context!,
            title: "scheduleOnlineTime".tr,
            btnTitle: "confirmOnlineTime".tr,
            type: "CALL",
            selectedDate: selectedCallDate.value,
            pickerStyle: "TimeCalendar",
            looping: true, onConfirm: (value) {
          // controller.selectCallTime(value),
        }, onChange: (value1) {
          // controller.selectCallTime(value),
        }, onClickOkay: (value1) {
          if (isValidDate("CALL", value1)) {
            selectCallTime(value1);
            scheduleCall("CALL", fromSwitch);
          } else {
            // Fluttertoast.showToast(msg: "Please select future date and time");
          }
        });
      },
    );
  }

  void selectDateTimePopupForChat(fromSwitch) {
    selectDateOrTime(
      Get.context!,
      futureDate: true,
      title: "ScheduleOnlineDate".tr,
      btnTitle: "confirmNextDate".tr,
      type: "CHAT",
      pickerStyle: "DateCalendar",
      looping: true,
      initialDate: DateTime.now(),
      lastDate: DateTime(2050),
      onConfirm: (value) => selectChatDate(value),
      onChange: (value) => selectChatDate(value),
      onClickOkay: (value) {
        Get.back();

        selectDateOrTime(
          Get.context!,
          type: "CHAT",
          title: "scheduleOnlineTime".tr,
          btnTitle: "confirmOnlineTime".tr,
          pickerStyle: "TimeCalendar",
          selectedDate: selectedChatDate.value,
          looping: true,
          onConfirm: (value) {
            // controller.selectChatTime(value),
          },
          onChange: (value) {
            // controller.selectChatTime(value),
          },
          onClickOkay: (timeValue) {
            if (isValidDate("CHAT", timeValue)) {
              selectChatTime(timeValue);
              scheduleCall("CHAT", fromSwitch);
            } else {
              // Fluttertoast.showToast(msg: "Please select future date and time");
            }
          },
        );
      },
    );
  }

  @override
  onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      getAstrologerLiveData();
    }
  }

  String getHoursFromDuration(String hours) {
    if (hours.isEmpty || int.parse(hours) <= 0) {
      return "0 Hour";
    }

    if (int.parse(hours) > 1) {
      return "$hours Hours";
    } else {
      return "$hours Hour";
    }
  }

  String convertCustomDateTime(
      String inputDate, String inputFormat, String outputFormat) {
    // Parse the input date string
    DateTime parsedDate = DateFormat(inputFormat).parse(inputDate);

    // Format the date to the desired output format
    String formattedDate = DateFormat(outputFormat).format(parsedDate);

    return formattedDate;
  }
}
