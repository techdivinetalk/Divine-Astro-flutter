import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../app_socket/app_socket.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../../model/chat_assistant/chat_assistant_chats_response.dart';
import '../../repository/chat_assistant_repository.dart';
import '../../repository/chat_repository.dart';
import '../../repository/kundli_repository.dart';
import '../live_page/constant.dart';

class ChatMessageController extends GetxController {
  final chatAssistantRepository = ChatAssistantRepository();
  final messageScrollController = ScrollController();
  ChatAssistChatResponse? chatAssistChatResponse;
  RxList chatMessageList = [].obs;
  RxList<AssistChatData> unreadMessageList = <AssistChatData>[].obs;
  RxInt currentPage = 1.obs;
  Set<int> processedPages = {};
  final messageController = TextEditingController();
  RxBool isEmojiShowing = false.obs;
  DataList? args;
  RxBool loading = false.obs;
  File? image;
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;
  RxBool isDataLoad = false.obs;
  final appSocket = AppSocket();

  ChatMessageController(KundliRepository put, ChatRepository put2);
  @override
  void onInit() {
    super.onInit();
    listenSocket();
    if (Get.arguments != null) {
      args = Get.arguments;
      getAssistantChatList();

      assistChatNewMsg.listen((newChatList) {
        if (newChatList.isNotEmpty) {
          print("new chat list ${newChatList.length} ");
          for (int index = 0; index < newChatList.length; index++) {
            print("new chat list ${newChatList[index]} ");
            var responseMsg = newChatList[index];
            if (int.parse(responseMsg?["sender_id"]) == args?.id) {
              chatMessageList.add(AssistChatData(
                  message: responseMsg['message'],
                  astrologerId: int.parse(responseMsg?["sender_id"].toString() ?? ''),
                  createdAt: DateTime.parse(responseMsg?["created_at"])
                      .millisecondsSinceEpoch
                      .toString(),
                  id: responseMsg["chatId"] != null && responseMsg["chatId"] != ''
                      ? int.parse(responseMsg["chatId"])
                      : null,
                  isSuspicious: 0,
                  sendBy: SendBy.customer,
                  msgType: responseMsg['msg_type'] != null
                      ? msgTypeValues.map[responseMsg['msg_type']]
                      : MsgType.text,
                  seenStatus: SeenStatus.received,
                  customerId: int.parse(responseMsg['sender_id'] ?? 0)));
            }
          }
          assistChatNewMsg.value = [];
          update();
        }
        scrollToBottomFunc();
        reArrangeChatList();
      });

      //to check if the list has enough number of elements to scroll
      // messageScrollController.hasClients ? null : getAssistantChatList();
      //

      messageScrollController.addListener(() {
        final topPosition = messageScrollController.position.minScrollExtent;
        if (messageScrollController.position.pixels == topPosition) {
          //code to fetch old messages
          print("to fetch old messages");
          getAssistantChatList();
        }
      });

      messageScrollController.addListener(() {
        final bottomPosition = messageScrollController.position.maxScrollExtent;
        if (messageScrollController.position.pixels == bottomPosition) {
          //code to fetch old messages
        }
      });
      // getAssistantChatList();
      scrollToBottomFunc();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    readUnreadMessages();
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      scrollToBottomFunc();
    });
  }

  void readUnreadMessages() {
    if (assistChatUnreadMessages.isNotEmpty) {
      assistChatUnreadMessages
          .removeWhere((element) => element.customerId == args?.id);
    }
    update();
  }

  void listenSocket() {
    appSocket.listenForAssistantChatMessage((chatData) {
      print("data from chatAssist message $chatData");
      final newChatData = AssistChatData.fromJson(chatData['msgData']);
      print(
          "new message update in chatassist listen scoket ${newChatData.toJson()}");
      final updateAtIndex = chatMessageList
          .indexWhere((oldChatData) => oldChatData.id == newChatData.id);
      if (updateAtIndex == -1) {
        chatMessageList.add(newChatData);
      } else {
        chatMessageList[updateAtIndex] = newChatData;
      }
      update();
    });
  }

  Future getImage(bool isCamera) async {
    pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile!.path);
      isDataLoad.value = false;
      await cropImage();
    }
  }

  Future<void> cropImage() async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: <CropAspectRatioPreset>[
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          toolbarTitle: "Update image",
          toolbarColor: appColors.white,
          toolbarWidgetColor: appColors.blackColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: "Update image"),
      ],
    );
    if (croppedFile != null) {
      uploadFile = File(croppedFile.path);
      final String filePath = uploadFile!.absolute.path;
      final int lastIndex = filePath.lastIndexOf(RegExp(r".png|.jp"));
      final String splitted = filePath.substring(0, lastIndex);
      final String outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 500,
      );
      if (result != null) {
        await getBase64Image(File(result.path));
      }
    } else {
      isDataLoad.value = true;
      debugPrint("Image is not cropped.");
    }
  }

  Future<void> getBase64Image(File fileData) async {
    final String filePath = fileData.absolute.path;
    final int lastIndex = filePath.lastIndexOf(RegExp(r".png|.jp"));
    final String splitted = filePath.substring(0, lastIndex);
    final String outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minWidth: 20,
    );
    final List<int> imageBytes = File(result!.path).readAsBytesSync();
    final String base64Image = base64Encode(imageBytes);
    final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";

    final String uploadFile =
        await uploadImageToS3Bucket(File(fileData.path), time);
    if (uploadFile != "") {
      print("image message upload file ${uploadFile} ${base64Image}");
      final Map<String, dynamic> data = {
        'awsUrl': uploadFile,
        'base64Image': base64Image,
        'time': time,
      };
      sendMsg(MsgType.image, data);
    }
  }

  scrollToBottomFunc() {
    print("chat Assist Scrolled to bottom");
    messageScrollController.hasClients
        ? messageScrollController.animateTo(
            messageScrollController.position.maxScrollExtent * 2,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut)
        : ();
  }

  reArrangeChatList() {
    // to remove duplicacy of messages
    // chatMessageList(chatMessageList
    //     .groupBy((chat) => chat.id)
    //     .values
    //     .map((group) => group.first)
    //     .cast<AssistChatData>()
    //     .toList());

    //
    chatMessageList.sort((a, b) {
      if (a is AssistChatData && b is AssistChatData) {
        return a.createdAt?.compareTo(b.createdAt ?? '0') ?? 1;
      }
      return 0;
    });
    update();
  }

  getAssistantChatList() async {
    try {
      loading(true);
      if (processedPages.contains(currentPage.value)) {
        loading(false);
        return;
      }
      final map = {"customer_id": args!.id, "page": currentPage.value};
      print("payload data $map");
      final response = await chatAssistantRepository.getAstrologerChats(
          {"customer_id": args!.id, "page": currentPage.value});
      if (response.data != null) {
        if (response.data!.chatAssistMsgList?.isNotEmpty == true) {
          chatMessageList.addAll(response.data!.chatAssistMsgList!);
          print("---------------------chatAssistMsgList--------------------");
          print(response.data?.toJson());
          if (response.data!.nextPageUrl != null) {
            currentPage++;
          } else {
            processedPages.add(currentPage.value);
          }
        } else {
          processedPages.add(currentPage.value);
        }
      }
    } catch (e, s) {
      debugPrint("Error fetching chat messages: $e $s");
    }

    reArrangeChatList();
    loading(false);
  }

  void sendMsg(MsgType msgType, Map data) {
    print("inside send message");

    late AssistChatData msgData;
    switch (msgType) {
      case MsgType.text:
        msgData = AssistChatData(
            message: messageController.text,
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            msgType: MsgType.text,
            sendBy: SendBy.astrologer,
            seenStatus: SeenStatus.notSent,

            // msgStatus: MsgStatus.sent,
            customerId: args?.id);
        appSocket.sendAssistantMessage(
            customerId: args!.id.toString(),
            msgData: msgData,
            message: messageController.text,
            astroId: preferenceService.getUserDetail()!.id.toString());
      case MsgType.image:
        msgData = AssistChatData(
            message: "https://divinenew-prod.s3.ap-south-1.amazonaws.com/astrologer/71019/1708498690.jpg",
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            msgType: MsgType.image,
            sendBy: SendBy.astrologer,
            seenStatus: SeenStatus.notSent,
            // msgStatus: MsgStatus.sent,
            customerId: args?.id);
        appSocket.sendAssistantMessage(
            customerId: args!.id.toString(),
            msgData: msgData,
            message:data['awsUrl'],
            astroId: preferenceService.getUserDetail()!.id.toString());
      default:
    }

    // print("socket msg");
    // print(preferenceService.getUserDetail()!.id.toString());
    // print(args!.id.toString());
    print("adding data ${msgData.toJson()}");
    chatMessageList.add(msgData
      ..createdAt = DateTime.parse(msgData.createdAt ?? '')
          .millisecondsSinceEpoch
          .toString());
    scrollToBottomFunc();
    messageController.clear();
  }
}
