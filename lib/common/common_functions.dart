// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/model/chat/req_common_chat_model.dart';
import 'package:divine_astrologer/repository/chat_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../di/fcm_notification.dart';
import '../di/hive_services.dart';
import '../di/shared_preference_service.dart';
import '../model/chat/res_common_chat_success.dart';
import '../model/chat_offline_model.dart';
import '../repository/user_repository.dart';
import 'package:path/path.dart' as p;

import '../screens/chat_message/chat_message_controller.dart';
import '../screens/live_page/constant.dart';
import 'colors.dart';

final UserRepository userRepository = Get.find<UserRepository>();
SharedPreferenceService preferenceService = Get.find<SharedPreferenceService>();
var userData = preferenceService.getUserDetail();

Future<String> uploadImageToS3Bucket(
    File? selectedFile, String fileName) async {
  var commonConstants = await userRepository.constantDetailsData();
  var dataString = commonConstants.data.awsCredentails.baseurl?.split(".");
  var extension = p.extension(selectedFile!.path);
  var response = await AwsS3.uploadFile(
    accessKey: commonConstants.data.awsCredentails.accesskey!,
    secretKey: commonConstants.data.awsCredentails.secretKey!,
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

void checkNotification(
    {required bool isFromNotification, Map? updatedData}) async {
  Map notificationList;
  if (isFromNotification) {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("astrologer/${userData?.id}/realTime/notification")
        .get();
    notificationList = snapshot.value as Map;
  } else {
    notificationList = updatedData!;
  }
  if (notificationList.isNotEmpty) {
    notificationList.forEach((key, value) async {
      var newMessage = ChatMessage(
          id: int.parse(key),
          message: value["message"],
          receiverId: value["receiver_id"],
          senderId: value["sender_id"],
          time: int.parse(key),
          type: value["type"],
          awsUrl: value["awsUrl"],
          base64Image: value["base64Image"],
          kundliId: value["kundli_id"],
          kundliName: value["kundli_name"],
          kundliDateTime: value["kundli_date_time"],
          kundliPlace: value["kundli_place"],
          downloadedPath: "",
          msgType: value["msgType"]);
      var senderId = value["sender_id"];
      if (Get.currentRoute == RouteName.chatMessageUI) {
        var chatController = Get.find<ChatMessageController>();
        if (chatController.currentUserId.value == value["sender_id"] ||
            chatController.currentUserId.value == value["receiver_id"]) {
          chatController.updateChatMessages(newMessage, true);
          if (value["sender_id"] == chatController.currentUserId.value) {
            chatController.updateChatMessages(newMessage, true);
          }
        } else {
          if (value["type"] == 0) {
            showNotificationWithActions(
                message: "${value["message"]}", title: "${value["title"]}");
            updateMsgDelieveredStatus(newMessage, 1);
          }

          setHiveDatabase("userKey_${userData?.id}_$senderId", newMessage);
        }
      } else {
        if (value["type"] == 0) {
          showNotificationWithActions(
              message: "${value["message"]}", title: "${value["title"]}");
          updateMsgDelieveredStatus(newMessage, 1);
        }

        setHiveDatabase("userKey_${userData?.id}_$senderId", newMessage);
      }
    });
    removeNotificationNode();
    debugPrint("$notificationList");
  }
}

void setHiveDatabase(String userDataKey, ChatMessage newMessage) async {
  var databaseMessage = ChatMessagesOffline();
  HiveServices hiveServices = HiveServices(boxName: userChatData);
  await hiveServices.initialize();
  var res = await hiveServices.getData(key: userDataKey);

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
    receiverId: newMessage.receiverId!,
    senderId: newMessage.senderId!,
    time: newMessage.time,
    type: type,
    msgType: newMessage.msgType,
    awsUrl: newMessage.awsUrl,
    base64Image: newMessage.base64Image,
    kundliId: newMessage.kundliId,
    kundliName: newMessage.kundliId,
    kundliDateTime: newMessage.kundliDateTime,
    kundliPlace: newMessage.kundliPlace,
  );
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  // final DatabaseReference messagesRef = firebaseDatabase
  //     .ref()
  //     .child("astrologer/${newMessage.receiverId}/engagement");

  // messagesRef.set(message.toOfflineJson());
  firebaseDatabase
      .ref(
          "user/${currentChatUserId.value}/realTime/notification/${newMessage.time}")
      .set(message.toOfflineJson());

  removeNotificationNode(nodeId: "/${newMessage.time}");
}

removeNotificationNode({String? nodeId}) {
  var userData = preferenceService.getUserDetail();
  if (nodeId == null) {
    FirebaseDatabase.instance
        .ref()
        .child("astrologer/${userData?.id}/realTime/notification")
        .remove();
  } else {
    FirebaseDatabase.instance
        .ref()
        .child("astrologer/${userData?.id}/realTime/notification$nodeId")
        .remove();
  }
}

String messageDateTime(int datetime) {
  var millis = datetime;
  var dt = DateTime.fromMillisecondsSinceEpoch(millis * 1000);
  return DateFormat('hh:mm a').format(dt);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void divineSnackBar({required String data, Color? color, Duration? duration}) {
  BuildContext? context = navigator?.context;
  if (context != null) {
    final snackBar = SnackBar(
      duration: duration ?? const Duration(milliseconds: 4000),
      content: Text(
        data,
        style: TextStyle(
            color: color != null ? AppColors.white : AppColors.blackColor),
      ),
      backgroundColor: color ?? AppColors.lightYellow,
      showCloseIcon: true,
      closeIconColor: color != null ? AppColors.white : AppColors.blackColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

acceptOrRejectChat({required int? orderId, required int? queueId}) async {
// *accept_or_reject: 1 = accept, 3 = chat reject by timeout
// * is_timeout: should be 1 when reject by timeout"

  ResCommonChatStatus response = await ChatRepository().chatAccept(
      ReqCommonChatParams(
              queueId: queueId,
              orderId: orderId,
              isTimeout: 0,
              acceptOrReject: 1)
          .toJson());
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
