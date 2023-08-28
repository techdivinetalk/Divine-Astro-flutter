// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../di/fcm_notification.dart';
import '../di/hive_services.dart';
import '../di/shared_preference_service.dart';
import '../model/chat_offline_model.dart';
import '../repository/user_repository.dart';
import 'package:path/path.dart' as p;

import '../screens/chat_message/chat_message_controller.dart';
import '../screens/live_page/constant.dart';

final UserRepository userRepository = Get.find<UserRepository>();
SharedPreferenceService preferenceService = Get.find<SharedPreferenceService>();

Future<String> uploadImageToS3Bucket(
    File? selectedFile, String fileName) async {
  var commonConstants = await userRepository.constantDetailsData();
  var dataString = commonConstants.data.awsCredentails.baseurl?.split(".");
  var userData = preferenceService.getUserDetail();
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

void checkNotification() async {
  final snapshot = await FirebaseDatabase.instance
      .ref()
      .child("astrologer/573/realTime/notification")
      .get();
  if (snapshot.value != null) {
    var notificationList = snapshot.value as Map;

    notificationList.forEach((key, value) async {
      var newMessage = ChatMessage(
          id: int.parse(key),
          message: value["message"],
          receiverId: 573,
          senderId: 8601,
          time: int.parse(key),
          type: value["type"],
          awsUrl: value["awsURL"],
          base64Image: value["base64Image"],
          downloadedPath: "",
          msgType: value["msgType"]);
      if (Get.currentRoute == RouteName.chatMessageUI) {
        var chatController = Get.find<ChatMessageController>();
        if (chatController.currentUserId.value.toString() ==
            value["sender_id"]) {
          chatController.updateChatMessages(newMessage);
          updateMsgDelieveredStatus(newMessage, 2);
        } else {
          showNotificationWithActions(
              message: "${value["message"]}", title: "${value["title"]}");
          // await DatabaseHelper().insert(newMessage); //KHYATI
          updateMsgDelieveredStatus(newMessage, 1);
        }
      } else {
        showNotificationWithActions(
            message: "${value["message"]}", title: "${value["title"]}");
        // await DatabaseHelper().insert(newMessage); //KHYATI
        updateMsgDelieveredStatus(newMessage, 1);
      }
      // await DatabaseHelper().insert(newMessage);
    });
    removeNotificationNode();
    debugPrint("$snapshot");
  }
}

void setHiveDatabase(String userDataKey) async {
  // HiveServices hiveServices = HiveServices(boxName: userChatData);
  // await hiveServices.initialize();
  // databaseMessage.value.chatMessages = chatMessages;
  // await hiveServices.addData(
  //     key: userDataKey,
  //     data: jsonEncode(databaseMessage.value.toOfflineJson()));
  // await hiveServices.close();
}

void updateMsgDelieveredStatus(ChatMessage newMessage, int type) async {
  // type 1= New chat message, 2 = Delievered, 3= Msg read, 4= Other messages
  Message message = Message(
    message: newMessage.message ?? "",
    receiverId: newMessage.receiverId!.toString(),
    time: newMessage.time.toString(),
    type: type,
    title: "",
    msgType: newMessage.msgType,
    awsURL: newMessage.awsUrl,
    base64Image: newMessage.base64Image,
  );
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  final DatabaseReference messagesRef = firebaseDatabase
      .ref()
      .child("astrologer/${newMessage.receiverId}/engagement");

  messagesRef.set(message.toJson());

  // removeMsg();
}

removeNotificationNode() {
  FirebaseDatabase.instance
      .ref()
      .child("astrologer/573/realTime/notification")
      .remove();
}

String messageDateTime(int datetime) {
  var millis = datetime;
  var dt = DateTime.fromMillisecondsSinceEpoch(millis);
  return DateFormat('hh:mm a').format(dt);
}
