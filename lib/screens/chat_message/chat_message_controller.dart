// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:divine_astrologer/model/res_login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../di/hive_services.dart';
import '../../di/shared_preference_service.dart';
import '../../model/chat_offline_model.dart';
import '../../repository/user_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../live_page/constant.dart';

class ChatMessageController extends GetxController {
  final UserRepository userRepository = Get.find<UserRepository>();
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  TextEditingController messageController = TextEditingController();
  UserData? userData = UserData();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  var chatMessages = <ChatMessage>[].obs;
  var databaseMessage = ChatMessagesOffline().obs;
  ScrollController messgeScrollController = ScrollController();
  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;
  final preference = Get.find<SharedPreferenceService>();
  RxInt currentUserId = 8601.obs;
  String userDataKey = "userKey";
  bool sendReadMessageStatus = false;
  RxBool emojiShowing = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is bool) {
        sendReadMessageStatus = true;
      }
    }
    userData = preferenceService.getUserDetail();
    currentUserId.value = 8601;

    Stream<DatabaseEvent> notiticationCheck = firebaseDatabase
        .ref()
        .child("astrologer/${userData?.id}/realTime/notification")
        .onValue;

    notiticationCheck.listen((event) {
      checkNotification();
      debugPrint("Valuesssssss: ${event.snapshot.value}");
    });
    userDataKey = "userKey_${userData?.id}_$currentUserId";
    getChatList();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 56)).then((value) {
      messgeScrollController.jumpTo(
        messgeScrollController.position.maxScrollExtent,
      );
    });
  }

  getChatList() async {
    chatMessages.clear();
    HiveServices hiveServices = HiveServices(boxName: userChatData);
    await Hive.initFlutter();
    await hiveServices.initialize();
    var res = await hiveServices.getData(key: userDataKey);
    if (res != null) {
      var msg = ChatMessagesOffline.fromOfflineJson(jsonDecode(res));
      chatMessages.value = msg.chatMessages ?? [];
      if (sendReadMessageStatus) {
        for (int i = 0; i < chatMessages.length; i++) {
          if (chatMessages[i].type != 2) {
            updateMsgDelieveredStatus(chatMessages[i], 2);
          }
        }
      }
    }
  }

  sendMsg() {
    if (messageController.text.trim().isNotEmpty) {
      var time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
      // type 1= New chat message, 2 = Delievered, 3= Msg read, 4= Other messages
      storeMessageInLocal(time);
      Message message = Message(
        message: messageController.text.trim(),
        receiverId: '8601',
        senderId: '573',
        time: time,
        type: 0,
        title: "${userData?.name} sent you text",
        msgType: "text",
        awsURL: "",
        base64Image: "",
      );
      messageController.clear();
      // final DatabaseReference messagesRef =
      //     firebaseDatabase.ref().child("astrologer/${userData?.id}/engagement");

      // messagesRef.set(message.toJson());
      Future.delayed(const Duration(milliseconds: 56)).then((value) {
        messgeScrollController.jumpTo(
          messgeScrollController.position.maxScrollExtent,
        );
      });
      firebaseDatabase
          .ref("user/8601/realTime/notification/$time")
          .set(message.toJson());
    }
  }

  storeMessageInLocal(String time,
      {String? awsUrl, String? base64Image, String? downloadedPath}) async {
    var newMessage = ChatMessage(
        id: int.parse(time),
        message: messageController.text.trim(),
        receiverId: 8601,
        senderId: userData?.id,
        time: int.parse(time),
        awsUrl: awsUrl,
        base64Image: base64Image,
        downloadedPath: downloadedPath,
        msgType: messageController.text.trim() != "" ? "text" : "image",
        type: 0);
    updateChatMessages(newMessage);
  }

  updateChatMessages(ChatMessage newMessage) async {
    var index =
        chatMessages.indexWhere((element) => newMessage.id == element.id);
    if (index >= 0) {
      chatMessages[index].type = newMessage.type;
    } else {
      chatMessages.add(newMessage);
      // chatMessages.insert(0, newMessage);
    }

    setHiveDatabase();
    // Future.delayed(const Duration(seconds: 5)).then((value) async {
    //   // await hiveServices.close();
    // });
  }

  void setHiveDatabase() async {
    var userDataKey = "userKey_${userData?.id}_$currentUserId";
    HiveServices hiveServices = HiveServices(boxName: userChatData);
    await hiveServices.initialize();
    databaseMessage.value.chatMessages = chatMessages;
    await hiveServices.addData(
        key: userDataKey,
        data: jsonEncode(databaseMessage.value.toOfflineJson()));
    // await hiveServices.close(); //KHYATI
  }

//OpenEmoji Keyboard

//download image
  downloadImage(
      {required String fileName,
      required ChatMessage chatDetail,
      required int index}) async {
    var response = await http.get(Uri.parse(chatDetail.awsUrl!));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName =
        '${documentDirectory.path}/images/${chatDetail.id}.jpg';

    await Directory(firstPath).create(recursive: true);
    File file2 = File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    chatMessages[index].downloadedPath = filePathAndName;
    setHiveDatabase();
  }
//Upload image

  Future getImage(bool isCamera) async {
    pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile!.path);

      await cropImage();
    }
  }

  cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Update image',
            toolbarColor: AppColors.white,
            toolbarWidgetColor: AppColors.blackColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Update image',
        ),
      ],
    );
    if (croppedFile != null) {
      uploadFile = File(croppedFile.path);
      final filePath = uploadFile!.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 500,
      );
      if (result != null) {
        getBase64Image(File(result.path));
      }
    } else {
      debugPrint("Image is not cropped.");
    }
  }

  getBase64Image(File fileData) async {
    final filePath = fileData.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minWidth: 20,
    );
    List<int> imageBytes = File(result!.path).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    String time = ("${DateTime.now().millisecondsSinceEpoch ~/ 1000}");
    debugPrint(base64Image);
    var uploadFile = await uploadImageToS3Bucket(File(fileData.path), time);
    if (uploadFile != "") {
      Message message = Message(
          message: "",
          receiverId: '8601',
          senderId: '573',
          time: time,
          type: 0,
          title: "${userData?.name} sent you image",
          msgType: "image",
          awsURL: uploadFile,
          base64Image: base64Image);
      // final DatabaseReference messagesRef =
      //     firebaseDatabase.ref().child("astrologer/${userData?.id}/engagement");
      // messagesRef.set(message.toJson());

      firebaseDatabase
          .ref("user/8601/realTime/notification/$time")
          .set(message.toJson());
      // receiverNotification.set(message.toJson());
      storeMessageInLocal(time,
          awsUrl: uploadFile,
          base64Image: base64Image,
          downloadedPath: outPath);
    }
  }
}

class Message {
  String message;
  String receiverId;
  String senderId;
  String time;
  String title;
  String? base64Image;
  String? awsURL;
  String? msgType;
  int type;

  Message({
    required this.message,
    required this.receiverId,
    required this.senderId,
    required this.time,
    required this.type,
    required this.title,
    required this.msgType,
    this.base64Image,
    this.awsURL,
  });

  Message.fromJson(Map<dynamic, dynamic> json)
      : time = json['time'] as String,
        message = json['message'] as String,
        receiverId = json['receiver_id'] as String,
        senderId = json['sender_id'] as String,
        title = json['title'] as String,
        base64Image = json['base64Image'] as String,
        awsURL = json['awsURL'] as String,
        msgType = json['msgType'] as String,
        type = json['type'] as int;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'time': time.toString(),
        'message': message,
        'receiver_id': receiverId,
        'sender_id': senderId,
        'title': title,
        'base64Image': base64Image,
        'awsURL': awsURL,
        'msgType': msgType,
        'type': type,
      };
}
