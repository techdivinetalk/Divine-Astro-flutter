import 'dart:convert';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/chat/req_common_chat_model.dart';
import 'package:divine_astrologer/repository/chat_repository.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../di/hive_services.dart';
import '../di/shared_preference_service.dart';
import '../model/chat/res_common_chat_success.dart';
import '../model/chat_offline_model.dart';
import '../screens/live_page/constant.dart';
import 'colors.dart';

final UserRepository userRepository = Get.find<UserRepository>();
SharedPreferenceService preferenceService = Get.find<SharedPreferenceService>();
var userData = preferenceService.getUserDetail();

Future<String> uploadImageToS3Bucket(
    File? selectedFile, String fileName) async {
  var commonConstants = await userRepository.constantDetailsData();
  var dataString = commonConstants.data!.awsCredentails.baseurl?.split(".");
  var extension = p.extension(selectedFile!.path);
  print("extension: " + extension);
  var response = await AwsS3.uploadFile(
    // accessKey: commonConstants.data.awsCredentails.accesskey!,
    // secretKey: commonConstants.data.awsCredentails.secretKey!,
    accessKey: 'AKIAXAGRISMJ5CDGY5OM',
    secretKey: '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',
    file: selectedFile,
    bucket: dataString![0].split("//")[1],
    destDir: 'astrologer/${userData?.id}',
    filename: '$fileName$extension',
    region: dataString[2],
  );

  if (response != null) {
    return response;
  } else {
    return "";
  }
}

Future<String?> uploadImageFileToAws(
    {required File file, required String moduleName}) async {
  var token = preferenceService.getToken();

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
    file.path,
  ));
  request.fields.addAll({"module_name": moduleName});

  var response = await request.send();

  // Listen for the response
  String? url;
  print(response.request);
  print(response.request);
  print("responseresponseresponseresponse");
  if (response.statusCode == 200) {
    print("Image uploaded successfully.");
    var urlResponse = await http.Response.fromStream(response);
    print(urlResponse.body);
    url = json.decode(urlResponse.body)["data"]['full_path'];
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

void setHiveDatabase(String userDataKey, ChatMessage newMessage) async {
  var databaseMessage = ChatMessagesOffline();
  HiveServices hiveServices = HiveServices(boxName: userChatData);
  await hiveServices.initialize();
  String? res = await hiveServices.getData(key: userDataKey);

  if (res != null) {
    var msg = ChatMessagesOffline.fromOfflineJson(jsonDecode(res));
    databaseMessage = msg;
  }
  List<ChatMessage>? chatMessages = databaseMessage.chatMessages ?? [];

  var index = chatMessages.indexWhere((element) => newMessage.id == element.id);
  if (index >= 0) {
    chatMessages[index].type = newMessage.type;
  } else {
    chatMessages.add(newMessage);
  }
  databaseMessage.chatMessages = chatMessages;

  await hiveServices.addData(
      key: userDataKey, data: jsonEncode(databaseMessage.toOfflineJson()));
  Future.delayed(const Duration(seconds: 5)).then((value) async {
    await hiveServices.close();
  });
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
    {required int? orderId, required int? queueId}) async {
// *accept_or_reject: 1 = accept, 3 = chat reject by timeout
// * is_timeout: should be 1 when reject by timeout"
  print("chat_reject 1");
  ResCommonChatStatus response = await ChatRepository().chatAccept(
      ReqCommonChatParams(
              queueId: queueId,
              orderId: orderId,
              isTimeout: 0,
              acceptOrReject: 1)
          .toJson());
  print("chat_reject 2");
  if (response.statusCode == 200) {
    print("chat_reject 3");
    return true;
  } else {
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
