import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:divine_astrologer/model/res_product_detail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../app_socket/app_socket.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../di/shared_preference_service.dart';
import '../../firebase_service/firebase_service.dart';
import '../../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../../model/chat_assistant/chat_assistant_chats_response.dart';
import '../../model/message_template_response.dart';
import '../../model/save_remedies_response.dart';
import '../../repository/chat_assistant_repository.dart';
import '../../repository/chat_repository.dart';
import '../../repository/kundli_repository.dart';
import '../live_page/constant.dart';

class ChatMessageController extends GetxController {
  final chatAssistantRepository = ChatAssistantRepository();
  final messageScrollController = ScrollController();
  ChatAssistChatResponse? chatAssistChatResponse;
  RxList chatMessageList = [].obs;
  var preference = Get.find<SharedPreferenceService>();
  // RxString userProfileImage = "".obs;
  RxList<AssistChatData> unreadMessageList = <AssistChatData>[].obs;
  RxList<MessageTemplates> messageTemplates = <MessageTemplates>[].obs;
  final keyboardVisibilityController = KeyboardVisibilityController();
  RxInt currentPage = 1.obs;
  Set<int> processedPages = {};
  final messageController = TextEditingController();
  RxBool isEmojiShowing = false.obs;
  DataList? args;
  RxString? baseImageUrl = "".obs;
  RxBool loading = false.obs;
  File? image;
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  RxMap selectedVoucher = {}.obs;
  List<Map> voucherList = [
    {
      "id": 1,
      "name": "5 Minutes",
      "description": "User can chat free for 5 minutes.",
    },
    {
      "id": 2,
      "name": "10 Minutes",
      "description": "User can chat free for 10 minutes.",
    },
    {
      "id": 3,
      "name": "15 Minutes",
      "description": "User can chat free for 15 minutes.",
    }
  ];
  File? uploadFile;
  RxBool isDataLoad = false.obs;
  final appSocket = AppSocket();

  ChatMessageController(KundliRepository put, ChatRepository put2);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    args = Get.arguments;
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   listenSocket();
  //   if (Get.arguments != null) {
  //     args = Get.arguments;
  //     getAssistantChatList();
  //     userjoinedChatSocket();
  //     listenjoinedChatSocket();
  //     getMessageTemplatesLocally();
  //
  //     FirebaseMessaging.instance.onTokenRefresh.listen((newtoken) {
  //       AppFirebaseService()
  //           .database
  //           .child("astrologer/${userData?.id}/")
  //           .update({'deviceToken': newtoken});
  //     });
  //
  //     assistChatNewMsg.listen((newChatList) {
  //       if (newChatList.isNotEmpty) {
  //         print("new chat list ${newChatList.length} ");
  //         for (int index = 0; index < newChatList.length; index++) {
  //           print("new chat list ${jsonEncode(newChatList[index])} ");
  //           var responseMsg = newChatList[index];
  //
  //           if (int.parse(responseMsg?["sender_id"].toString() ?? '') ==
  //               args?.id) {
  //             print("inside chat add condition");
  //             chatMessageList([
  //               ...chatMessageList,
  //               AssistChatData(
  //                   message: responseMsg['message'],
  //                   astrologerId:
  //                       int.parse(responseMsg?["userid"].toString() ?? ''),
  //                   createdAt: DateTime.parse(responseMsg?["created_at"])
  //                       .millisecondsSinceEpoch
  //                       .toString(),
  //                   // id: responseMsg["chatId"] != null &&
  //                   //         responseMsg["chatId"] != ''&& responseMsg["chatId"]=='undefined'
  //                   //     ? int.parse(responseMsg["chatId"])
  //                   //     : null,
  //                   isSuspicious: 0,
  //                   sendBy: SendBy.customer,
  //                   msgType: responseMsg["msg_type"] != null
  //                       ? msgTypeValues.map[responseMsg["msg_type"]]
  //                       : MsgType.text,
  //                   seenStatus: SeenStatus.received,
  //                   customerId: int.parse(responseMsg['sender_id'] ?? 0))
  //             ]);
  //             chatMessageList.refresh();
  //             scrollToBottomFunc();
  //             assistChatNewMsg.removeAt(index);
  //             update();
  //             print(
  //                 "outside chat add condition ${json.encode(chatMessageList.last)}");
  //           }
  //         }
  //         update();
  //       }
  //       scrollToBottomFunc();
  //       reArrangeChatList();
  //     });
  //     update();
  //     //to check if the list has enough number of elements to scroll
  //     // messageScrollController.hasClients ? null : getAssistantChatList();
  //     //
  //
  //     messageScrollController.addListener(() {
  //       final topPosition = messageScrollController.position.minScrollExtent;
  //       if (messageScrollController.position.pixels == topPosition) {
  //         //code to fetch old messages
  //         print("to fetch old messages");
  //         getAssistantChatList();
  //       }
  //     });
  //
  //     messageScrollController.addListener(() {
  //       final bottomPosition = messageScrollController.position.maxScrollExtent;
  //       if (messageScrollController.position.pixels == bottomPosition) {
  //         //code to fetch old messages
  //       }
  //     });
  //     // getAssistantChatList();
  //     scrollToBottomFunc();
  //     update();
  //   }
  // }

  // getBaseimageUrl() {}
  //
  @override
  void dispose() {
    // TODO: implement dispose
    // readUnreadMessages();
    chatMessageList.clear();
    userjoinedChatSocket();
    listenjoinedChatSocket();
    processedPages.clear();
    currentPage(1);
    super.dispose();
  }
  //
  // @override
  // void onReady() {
  //   super.onReady();
  //   Future.delayed(const Duration(milliseconds: 600)).then((value) {
  //     scrollToBottomFunc();
  //   });
  // }

  // void readUnreadMessages() {
  //   if (assistChatUnreadMessages.isNotEmpty) {
  //     assistChatUnreadMessages
  //         .removeWhere((element) => element.customerId == args?.id);
  //   }
  //   update();
  // }
  getMessageTemplatesLocally() async {
    final sharedPreferencesInstance = SharedPreferenceService();
    final data = await sharedPreferencesInstance.getMessageTemplates();
    messageTemplates(data);
    update();
  }

  // getOurImage()async {
  //   final prefs = await SharedPreferences.getInstance();
  //  final baseAmazonUrl = prefs.getString(SharedPreferenceService.baseImageUrl);
  //   userProfileImage( "$baseAmazonUrl/${userData?.image}");
  // }

  sendMsgTemplate(MessageTemplates msg) {
    final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    sendMsg(MsgType.text, {'text': msg.description});
  }

  userjoinedChatSocket() {
    appSocket.emitForStartAstroCustChatAssist(
        userData?.id.toString(), args?.id.toString(), 0);
  }

  listenjoinedChatSocket() {
    print("listen joined chat socket called");
    appSocket.listenUserJoinedSocket(
      (p0) {
        print(" listen user joined socket" + p0);
      },
    );
  }

  void listenSocket() {
    appSocket.listenForAssistantChatMessage((chatData) {
      final newChatData = AssistChatData.fromJson(chatData['msgData']);
      print(
          "new message update in chatassist listen scoket ${newChatData.toJson()}");
      // newChatData.seenStatus = chatData['seen_status'] != null
      //     ? seenStatusValues.map[chatData["seen_status"].toString()]
      //     : SeenStatus.sent;
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
    print("assistant chat ${await FirebaseMessaging.instance.getToken()} ");
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
    print("inside send message ${userData?.image}");

    late AssistChatData msgData;
    switch (msgType) {
      case MsgType.text:
        msgData = AssistChatData(
            message: data['text'],
            profileImage: userData?.image,
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
            message: data['text'],
            astroId: preferenceService.getUserDetail()!.id.toString());
        break;
      case MsgType.remedies:
        msgData = AssistChatData(
            message: data['message'],
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            profileImage: userData?.image,
            msgType: MsgType.remedies,
            sendBy: SendBy.astrologer,
            seenStatus: SeenStatus.notSent,
            customerId: args?.id);
        appSocket.sendAssistantMessage(
            customerId: args!.id.toString(),
            msgData: msgData,
            message: data['message'],
            astroId: preferenceService.getUserDetail()!.id.toString());
        break;
      case MsgType.image:
        msgData = AssistChatData(
            message: data['awsUrl'],
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            profileImage: userData?.image,
            msgType: MsgType.image,
            sendBy: SendBy.astrologer,
            seenStatus: SeenStatus.notSent,
            // msgStatus: MsgStatus.sent,
            customerId: args?.id);
        appSocket.sendAssistantMessage(
            customerId: args!.id.toString(),
            msgData: msgData,
            message: data['awsUrl'],
            astroId: preferenceService.getUserDetail()!.id.toString());
        break;
      case MsgType.product:
        final productData =
            data['data']['saveRemedies'] as SaveRemediesResponse;
        final productDetails = data['data']['product_detail'] as Products;
        print("delete product data ${productDetails} ${productData}");
        msgData = AssistChatData(
            message: productDetails.prodName,
            astrologerId: preferenceService.getUserDetail()!.id,
            createdAt: DateTime.now().toIso8601String(),
            id: DateTime.now().millisecondsSinceEpoch,
            isSuspicious: 0,
            profileImage: userData?.image,
            msgType: MsgType.product,
            sendBy: SendBy.astrologer,
            product: Product(
                id: productData.data?.shopId,
                prodName: productDetails.prodName),
            productImage: productDetails.prodImage ?? '',
            productId: productData.data?.productId.toString(),
            shopId: productData.data?.shopId.toString(),
            seenStatus: SeenStatus.notSent,
            // msgStatus: MsgStatus.sent,
            customerId: args?.id);
        appSocket.sendAssistantMessage(
            customerId: args!.id.toString(),
            msgData: msgData,
            message: productDetails.prodName ?? '',
            astroId: preferenceService.getUserDetail()!.id.toString());
        break;
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
