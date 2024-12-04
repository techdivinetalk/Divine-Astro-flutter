import 'dart:convert';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/chat/req_common_chat_model.dart';
import 'package:divine_astrologer/repository/chat_repository.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../di/shared_preference_service.dart';
import '../gen/fonts.gen.dart';
import '../model/chat/res_common_chat_success.dart';
import '../model/chat_offline_model.dart';
import '../screens/live_page/constant.dart';
import 'colors.dart';

final UserRepository userRepository = Get.find<UserRepository>();
SharedPreferenceService preferenceService = Get.find<SharedPreferenceService>();
Future<String> uploadImageToS3Bucket(
    File? selectedFile, String fileName) async {
  var commonConstants = await userRepository.constantDetailsData();
  var dataString = commonConstants.data!.awsCredentails.baseurl?.split(".");
  var extension = p.extension(selectedFile!.path);
  if (commonConstants?.data != null) {
    imageUploadBaseUrl.value = commonConstants?.data?.imageUploadBaseUrl ?? "";
  }
  print("extension: " + extension);
  var response = await AwsS3.uploadFile(
    // accessKey: commonConstants.data.awsCredentails.accesskey!,
    // secretKey: commonConstants.data.awsCredentails.secretKey!,
    accessKey: 'AKIAXAGRISMJ5CDGY5OM',
    secretKey: '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',
    file: selectedFile,
    bucket: dataString![0].split("//")[1],
    destDir: 'astrologer/${preferenceService.getUserDetail()?.id}',
    filename: '$fileName$extension',
    region: dataString[2],
  );

  if (response != null) {
    return response;
  } else {
    return "";
  }
}

Future<String> getUserData(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? "";
}

Future<String?> uploadImageFileToAws(
    {required File file, required String moduleName, String? pathType}) async {
  var token = preferenceService.getToken();

  var uri = Uri.parse("${ApiProvider.imageBaseUrl}uploadImage");
  print(ApiProvider.imageBaseUrl);
  print("ApiProvider.imageBaseUrl");
  var request = http.MultipartRequest('POST', uri);

  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Content-type': 'application/json',
    'Accept': 'application/json',
  });

  // Attach the image file to the request
  request.files.add(await http.MultipartFile.fromPath(
    'image',
    file.path,
  ));
  request.fields.addAll({"module_name": moduleName});

  var response = await request.send();

  // Listen for the response
  String? url;

  if (response.statusCode == 200) {
    var urlResponse = await http.Response.fromStream(response);
    if (pathType == "path") {
      url = json.decode(urlResponse.body)["data"]['path'];
    } else {
      url = json.decode(urlResponse.body)["data"]['full_path'];
    }
  } else {
    url = null;
  }
  return url;
}

void checkNotification(
    {required bool isFromNotification, Map? updatedData}) async {
  // if (Get.currentRoute == RouteName.chatMessageUI) {
  //   var chatController = Get.find<ChatMessageController>();
  //   if (chatController.currentUserId.value == value["sender_id"] ||
  //       chatController.currentUserId.value == value["receiver_id"]) {
  //     chatController.updateChatMessages(newMessage, true);
  //     if (value["sender_id"] == chatController.currentUserId.value) {
  //       chatController.updateChatMessages(newMessage, true);
  //     }
  //   } else {
  //     if (value["type"] == 0) {
  //       showNotificationWithActions(message: "${value["message"]}", title: "${value["title"]}");
  //       updateMsgDelieveredStatus(newMessage, 1);
  //     }
  //
  //     setHiveDatabase("userKey_${userData?.id}_$senderId", newMessage);
  //   }
  // } else {
  //   if (value["type"] == 0) {
  //     showNotificationWithActions(message: "${value["message"]}", title: "${value["title"]}");
  //     updateMsgDelieveredStatus(newMessage, 1);
  //   }
  //
  //   setHiveDatabase("userKey_${userData?.id}_$senderId", newMessage);
  // }
  //  removeNotificationNode();
}

void updateMsgDelieveredStatus(ChatMessage newMessage, int type) async {
  // type 1= New chat message, 2 = Delievered, 3= Msg read, 4= Other messages
  ChatMessage message = ChatMessage(
    orderId: newMessage.orderId,
    message: newMessage.message ?? "",
    receiverId: newMessage.receiverId,
    senderId: newMessage.senderId,
    time: newMessage.time.toString(),
    type: type,
    msgType: newMessage.msgType,
    awsUrl: newMessage.awsUrl,
    base64Image: newMessage.base64Image,
    kundliId: newMessage.kundliId,
    kundliName: newMessage.kundliId,
    kundliDateTime: newMessage.kundliDateTime,
    kundliPlace: newMessage.kundliPlace,
  );
  // FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  //
  // firebaseDatabase
  //     .ref("user/${currentChatUserId.value}/realTime/notification/${newMessage.time}")
  //     .set(message.toOfflineJson());
  //
  // removeNotificationNode(nodeId: "/${newMessage.time}");
}

String messageDateTime(int datetime) {
  var millis = datetime;
  var dt = DateTime.fromMillisecondsSinceEpoch(millis * 1000);
  return DateFormat('hh:mm a').format(dt);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void divineSnackBar({required String data, Color? color, Duration? duration}) {
  BuildContext? context = navigator?.context;
  if (data[data.length - 1] != ".") {
    data = "$data.";
  }
  if (context != null) {
    final snackBar = SnackBar(
      duration: duration ?? const Duration(milliseconds: 10000),
      content: Text(
        data,
        style: TextStyle(
          color: color != null ? appColors.white : appColors.blackColor,
          fontSize: 11.0,
        ),
      ),
      backgroundColor: color ?? appColors.guideColor,
      showCloseIcon: true,
      closeIconColor: color != null ? appColors.white : appColors.blackColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Future<bool> acceptOrRejectChat(
    {required int? orderId,
    required int? queueId,
    String? astrologerImageLink}) async {
// *accept_or_reject: 1 = accept, 3 = chat reject by timeout
// * is_timeout: should be 1 when reject by timeout"
  print("chat_reject 1");
  ResCommonChatStatus response = await ChatRepository().chatAccept(
      ReqCommonChatParams(
              queueId: queueId,
              orderId: orderId,
              isTimeout: 0,
              acceptOrReject: 1,
              astrologerImage: kDebugMode ? null : astrologerImageLink)
          .toJson());
  print("chat_reject 2");
  if (response.statusCode == 200) {
    print("chat_reject 3");
    // Show the Snackbar
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
        backgroundColor: appColors.guideColor,
        content: Text(
          'Waiting for User to Join',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.metropolis,
              fontSize: 20.sp,
              color: appColors.black),
        ),
        duration: Duration(days: 365), // Long duration
      ),
    );
    // Get.bottomSheet(
    //   Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       GestureDetector(
    //         onTap: () => Get.back(),
    //         child: Container(
    //           padding: const EdgeInsets.all(15.0),
    //           decoration: BoxDecoration(
    //             border: Border.all(color: appColors.white),
    //             borderRadius: const BorderRadius.all(
    //               Radius.circular(50.0),
    //             ),
    //             color: appColors.white.withOpacity(0.2),
    //           ),
    //           child: const Icon(
    //             Icons.close,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //       const SizedBox(height: 10.0),
    //       Container(
    //         width: double.infinity,
    //         decoration: BoxDecoration(
    //             borderRadius:
    //                 const BorderRadius.vertical(top: Radius.circular(30.0)),
    //             color: appColors.white),
    //         child: Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               SizedBox(height: 15.h),
    //               Image.asset(
    //                 "assets/images/user_accepting.png",
    //                 height: 100,
    //               ),
    //               SizedBox(height: 8.h),
    //               Text("Waiting for User to Join",
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.w600,
    //                       fontFamily: FontFamily.metropolis,
    //                       fontSize: 20.sp,
    //                       color: appColors.brownColour)),
    //               SizedBox(height: 5.h),
    //               Text(
    //                   "Please hold on. The user has received your connection request and will join shortly.",
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.w400,
    //                       fontFamily: FontFamily.metropolis,
    //                       fontSize: 16.sp,
    //                       color: appColors.grey)),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: InkWell(
    //                   borderRadius: BorderRadius.circular(50),
    //                   onTap: () {
    //                     Get.back();
    //                   },
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(50),
    //                       color: appColors.guideColor,
    //                     ),
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(
    //                           left: 20, right: 20, top: 12, bottom: 12),
    //                       child: Text("Okay",
    //                           style: TextStyle(
    //                               fontWeight: FontWeight.w600,
    //                               fontFamily: FontFamily.metropolis,
    //                               fontSize: 16.sp,
    //                               color: appColors.white)),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(height: 5.h),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    // divineSnackBar(data: message, color: appColors.redColor);
    return true;
  } else {
    divineSnackBar(data: response.message ?? "", color: appColors.redColor);
    print("chat_reject 4");
    return false;
  }
}

Future<String?> getDeviceId() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Theme.of(Get.context!).platform == TargetPlatform.iOS) {
      var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      debugPrint('iOs Device token - ${iosDeviceInfo.identifierForVendor}');
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      debugPrint('androidDevice token - ${androidDeviceInfo.id}');
      return androidDeviceInfo.id;
    }
  } catch (e) {
    debugPrint('Failed to get device ID: $e');
  }
  return '';
}
