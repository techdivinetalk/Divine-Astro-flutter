import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/ask_for_gift_bottom_sheet.dart';
import 'package:divine_astrologer/common/camera.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/common/show_permission_widget.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/astrologer_gift_response.dart';
import 'package:divine_astrologer/model/chat_histroy_response.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/model/save_remedies_response.dart';
import 'package:divine_astrologer/model/tarot_response.dart';
import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/get_single_pooja_response.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/custom_puja/saved_remedies.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_list_model.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart';
import 'package:divine_astrologer/screens/live_dharam/gifts_singleton.dart';
import 'package:divine_astrologer/tarotCard/FlutterCarousel.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di/api_provider.dart';
import '../model/res_product_detail.dart';

class NewChatController extends GetxController {
  TextEditingController messageController = TextEditingController();
  TextEditingController reportMessageController = TextEditingController();
  ScrollController messageScrollController = ScrollController();
  ScrollController typingScrollController = ScrollController();
  final preference = Get.find<SharedPreferenceService>();
  RxString astrologerBackgroundColor = "".obs;
  RxString showTalkTime = "".obs;
  RxString extraTalkTime = "".obs;
  RecorderController? recorderController;
  RxBool isOfferVisible = false.obs;
  RxBool isRecording = false.obs;
  RxBool hasMessage = false.obs;
  RxBool isEmojiShowing = false.obs;
  Loading loading = Loading.initial;
  RxBool isAudioPlaying = false.obs;
  RxString astrologerName = "".obs;
  RxString customerName = "".obs;

  Duration? timeDifference;

  @override
  void onInit() {
    if (AppFirebaseService().orderData.isNotEmpty) {
      print("order is not empty");
    }
    initialiseControllers();
    getDir();
    getAllApiDataInChat();
    messageController.addListener(onMessageChanged);
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        scrollToBottomFunc();
      },
    );
    super.onInit();
  }

  getAllApiDataInChat() async {
    await getChatList();
    getCustomEcom();
  }

  @override
  void onClose() {
    if (recorderController != null) {
      recorderController?.dispose();
    }
    super.onClose();
  }

  /// ------------------ back function  ----------------------- ///
  void backFunction() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        print("userLeavePrivateChatListenerSocket");

        // chatTimer?.cancel();
        print("WentBack backFunc");
        // extraTimer?.cancel();
        // Get.delete<ChatMessageWithSocketController>();
        Get.until(
          (route) {
            return Get.currentRoute == RouteName.dashboard;
          },
        );
      },
    );
    return;
  }

  /// ------------------ scroll to bottom  ----------------------- ///
  scrollToBottomFunc() {
    if (messageScrollController.hasClients) {
      print("messageScrollController.hasClients");
      Timer(
        const Duration(milliseconds: 150),
        () => messageScrollController.animateTo(
          messageScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        ),
      );
    }
    update();
  }

  /// ------------------ download image  ----------------------- ///
  downloadImage(
      {required String fileName,
      required ChatMessage chatDetail,
      required int id}) async {
    var response = await http
        .get(Uri.parse("${preference.getAmazonUrl()}${chatDetail.awsUrl}"));

    if (response.statusCode == HttpStatus.unauthorized) {
      Utils().handleStatusCodeUnauthorizedServer();
    } else if (response.statusCode == HttpStatus.badRequest) {
      Utils().handleStatusCode400(response.body);
    }
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName =
        "${documentDirectory.path}/images/${chatDetail.id}.jpg";

    await Directory(firstPath).create(recursive: true);
    File file2 = File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    print("chat download path $filePathAndName");
    // int index = chatMessages.indexWhere((element) {
    //   return element.id == id;
    // });
    // chatMessages[index].downloadedPath = filePathAndName;
    // chatMessages.refresh();
    // write code
    update();
  }

  /// ------------------ audio recording func ----------------------- ///
  bool isRecordingCompleted = false;

  void startOrStopRecording() async {
    try {
      print("is working");
      if (isRecording.value) {
        recorderController!.reset();
        print(isRecording.value);
        print("isRecording.value");

        final path = await recorderController!.stop(false);
        print(path);
        print("pathpathpathpathpath");
        if (path != null) {
          isRecordingCompleted = true;
          uploadAudioFile(File(path));
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }
      } else {
        await recorderController!.record(path: path);
      }

      update();
    } catch (e) {
      print("failed to record ===== ${e}");
      debugPrint(e.toString());
    } finally {
      print("finally record");
      isRecording.value = !isRecording.value;
      update();
    }
  }

  Directory? appDirectory;
  String path = "";

  void getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory!.path}/recording.m4a";
    update();
  }

  void refreshWave() {
    if (isRecording.value) {
      recorderController!.stop(true);
      isRecording.value = false;
      update();
    }
  }

  uploadAudioFile(File soundFile) async {
    try {
      var uploadFile =
          await uploadImageFileToAws(file: soundFile, moduleName: "chat");
      if (uploadFile != "" && uploadFile != null) {
        print("is uploaded the file from recorder");

        /// write logic for send audio msg
        addNewMessage(msgType: MsgType.audio, awsUrl: uploadFile);
      } else {}
    } catch (e) {
      print("getting error while sending audio ${e}");
    }
  }

  void initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
    update();
  }

  /// ------------------ image sending func ----------------------- ///
  bool isGalleryOpen = false;
  File? image;

  XFile? pickedFile;

  Future getImage(bool isCamera) async {
    isGalleryOpen = true;
    print("openGallery isGalleryOpen");
    final bool result = await permissionPhotoOrStorage();
    print("photo permission $result");
    if (result) {
      if (isCamera) {
        List<CameraDescription> cameras = await availableCameras();
        await Get.to<String?>(
          () => CameraPage(cameras: cameras),
        );
        print(
            'Image path received in Page A: ${AppFirebaseService().imagePath}');
        if (AppFirebaseService().imagePath != "") {
          print('Image-in');
          image = File(AppFirebaseService().imagePath);
          await cropImage();
        }
      } else {
        pickedFile = await ImagePicker().pickImage(
            source: isCamera ? ImageSource.camera : ImageSource.gallery);
        if (pickedFile != null) {
          image = File(pickedFile!.path);
          // isDataLoad.value = false;
          await cropImage();
        }
      }
    } else {
      await showPermissionDialog(
        permissionName: 'Gallery permission',
        isForOverlayPermission: false,
      );
    }
  }

  cropImage() async {
    isGalleryOpen = true;
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
            toolbarTitle: "Send Photo",
            toolbarColor: appColors.white,
            toolbarWidgetColor: appColors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: "Send Photo",
        ),
      ],
    );
    if (croppedFile != null) {
      File uploadFile = File(croppedFile.path);
      final filePath = uploadFile!.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r".png|.jp"));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 500,
      );
      print("cropped file step reached");
      if (result != null) {
        getBase64Image(File(result.path));
      }
    } else {
      //    isDataLoad.value = true;
      debugPrint("Image is not cropped.");
    }
  }

  getBase64Image(File fileData) async {
    print("IMAGE STEP UPLOAD 1");
    final filePath = fileData.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r".png|.jp"));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minWidth: 20,
    );
    List<int> imageBytes = File(result!.path).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    print("IMAGE STEP UPLOAD 2");
    // print("IMAGE STEP UPLOAD 2 ${fileData.path}");
    String time = ("${DateTime.now().millisecondsSinceEpoch ~/ 1000}");
    var uploadFile = await uploadImageFileToAws(
        file: File(fileData.path), moduleName: "chat");
    print("IMAGE STEP UPLOAD 3 $uploadFile");
    if (uploadFile != null || uploadFile != "") {
      /// write a code for sending image
      addNewMessage(
        msgType: MsgType.image,
        messageText: uploadFile,
        base64Image: base64Image,
        downloadedPath: '',
      );
    }
  }

  /// ------------------ permission photo or storage ----------------------- ///
  Future<bool> permissionPhotoOrStorage() async {
    bool perm = false;
    if (Platform.isIOS) {
      perm = await permissionPhotos();
    } else if (Platform.isAndroid) {
      final AndroidDeviceInfo android = await DeviceInfoPlugin().androidInfo;
      final int sdkInt = android.version.sdkInt;
      perm = sdkInt > 32 ? await permissionPhotos() : await permissionStorage();
    } else {}
    return Future<bool>.value(perm);
  }

  Future<bool> permissionPhotos() async {
    bool hasPhotosPermission = false;
    final PermissionStatus try0 = await Permission.photos.status;
    if (try0 == PermissionStatus.granted) {
      hasPhotosPermission = true;
    } else {
      final PermissionStatus try1 = await Permission.photos.request();
      if (try1 == PermissionStatus.granted) {
        hasPhotosPermission = true;
      } else {}
    }
    return Future<bool>.value(hasPhotosPermission);
  }

  Future<bool> permissionStorage() async {
    bool hasStoragePermission = false;
    final PermissionStatus try0 = await Permission.storage.status;
    if (try0 == PermissionStatus.granted) {
      hasStoragePermission = true;
    } else {
      final PermissionStatus try1 = await Permission.storage.request();
      if (try1 == PermissionStatus.granted) {
        hasStoragePermission = true;
      } else {}
    }
    return Future<bool>.value(hasStoragePermission);
  }

  /// ------------------ Product bottom sheet ----------------------- ///
  Future<void> openProduct() async {
    var result = await Get.toNamed(RouteName.chatAssistProductPage, arguments: {
      'customerId':
          int.parse(AppFirebaseService().orderData.value["userId"].toString())
    });
    if (result != null) {
      final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
      // write code for send product
      addNewMessage(
        msgType: MsgType.product,
        data: {
          'data': result,
        },
        messageText: 'Product',
      );
    }
  }

  /// ------------------ Custom Product bottom sheet ----------------------- ///
  List<CustomProductData> customProductData = [];
  NoticeRepository noticeRepository = NoticeRepository();

  void openCustomShop() {
    Get.bottomSheet(
      SavedRemediesBottomSheet(
        newChatController: NewChatController(),
        customProductData: customProductData,
      ),
    );
  }

  getCustomEcom() async {
    try {
      final response = await noticeRepository.get(ApiProvider.getCustomEcom,
          headers: await noticeRepository.getJsonHeaderURL());
      CustomProductListModel savedRemediesData =
          CustomProductListModel.fromJson(jsonDecode(response.body));
      if (savedRemediesData.statusCode == 200) {
        customProductData = savedRemediesData.data!;
        print(jsonEncode(customProductData));
        print(customProductData.length);
        print("customProductData.length");
        update();
      } else {
        customProductData = [];
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  /// ------------------ Tarrot card bottom sheet ----------------------- ///
  RxBool isCardBotOpen = false.obs;

  void openShowDeck() {
    isCardBotOpen.value = true;
    showCardChoiceBottomSheet(NewChatController());
  }

  Future<void> sendTarotCard(int? choice) async {
    HashMap<String, dynamic> hsMap = HashMap();
    hsMap["isCardVisible"] = false;
    var randomTarotCards = await printRandomTarotCards(choice);
    hsMap["listOfCard"] = randomTarotCards;
    int orderId = AppFirebaseService().orderData.value["orderId"] ?? 0;
    print("hashmap" + hsMap.toString());
    if (orderId != 0) {
      await FirebaseDatabase.instance
          .ref()
          .child("order/$orderId/card")
          .set(hsMap);
    }
  }

  Future<HashMap<String, dynamic>> printRandomTarotCards(int? choice) async {
    List<TarotCard> cards = await loadTarotCards();
    HashMap<String, dynamic> listOfCard = HashMap();
    if (cards.isNotEmpty) {
      // Shuffle the list and take the first 3 cards
      cards.shuffle();
      List<TarotCard> randomCards = cards.take(choice!).toList();

      for (var card in randomCards) {
        print(card.name);
        listOfCard["${card.name}"] = card.image;
      }
      return listOfCard;
    } else {
      return HashMap();
    }
  }

  Future<List<TarotCard>> loadTarotCards() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cardsJson = prefs.getString('tarot_cards');

    if (cardsJson != null) {
      List<dynamic> jsonList = json.decode(cardsJson) as List;
      return jsonList.map((jsonItem) => TarotCard.fromJson(jsonItem)).toList();
    } else {
      return [];
    }
  }

  /// ------------------ Remedies bottom sheet ----------------------- ///
  Future<void> openRemedies() async {
    var result = await Get.toNamed(RouteName.chatSuggestRemedy);
    if (result != null) {
      addNewMessage(
        msgType: MsgType.remedies,
        messageText: result.toString(),
      );
    }
  }

  /// ------------------ Ask gift bottom sheet ----------------------- ///
  askForGift() async {
    await showCupertinoModalPopup(
      //backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) {
        return AskForGiftBottomSheet(
          customerName: customerName.value,
          giftList: GiftsSingleton().gifts.data ?? <GiftData>[],
          onSelect: (GiftData item, num quantity) async {
            Get.back();
            print('number of gifts $quantity');
            await sendGiftFunc(item, quantity);
          },
        );
      },
    );
  }

  sendGiftFunc(GiftData item, num quantity) {
    if (item.giftName.isNotEmpty) {
      final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";

      /// write code ask gift
      // unreadMessageIndex.value = -1;
      addNewMessage(
        msgType: MsgType.gift,
        messageText: item.giftName,
        productId: item.id.toString(),
        awsUrl: item.fullGiftImage,
        giftId: item.id.toString(),
      );
    }
  }

  /// ------------------ TextEditing onchanged  ----------------------- ///
  onMessageChanged() {
    hasMessage.value = messageController.text.isNotEmpty;
    update();
  }

  /// -------------------------- chat history API ------------------------ ///
  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  CallChatHistoryRepository callChatFeedBackRepository =
      CallChatHistoryRepository();

  getChatList() async {
    try {
      print(AppFirebaseService().orderData.value["orderId"]);
      print("AppFirebaseService().orderData.value");
      // endChatLoader.value = chatMessages.isEmpty;
      var userId = int.parse(AppFirebaseService().orderData.value["userId"]);
      var astroId = int.parse(AppFirebaseService().orderData.value["astroId"]);

      var response = await callChatFeedBackRepository.getAstrologerChats(
        userId,
        astroId,
      );

      if (response.success ?? false) {
        // endChatLoader.value = false;
        if (response.chatMessages!.isNotEmpty) {
          chatMessages.clear();
          chatMessages.addAll(response.chatMessages!.reversed);
          update();
          print("ChatMessage Data:: ${chatMessages.toJson()}");
          print("orderIdorderIdorderIdorderId");
        }
      } else {
        throw CustomException(response.message ?? 'Failed to get chat history');
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    } finally {
      update();
    }
  }

  /// -------------------------- send message firebase  ------------------------ ///
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  addNewMessage({
    MsgType? msgType,
    Map? data,
    String? messageText,
    String? awsUrl,
    String? base64Image,
    String? downloadedPath,
    String? kundliId,
    String? giftId,
    String? title,
    String? productPrice,
    String? productId,
    String? shopId,
    String? suggestedId,
    String? customProductId,
    CustomProduct? getCustomProduct,
  }) async {
    final String time = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    late ChatMessage newMessage;
    if (msgType == MsgType.customProduct) {
      newMessage = ChatMessage(
        orderId: AppFirebaseService().orderData.value["orderId"],
        id: int.parse(time),
        message: messageText,
        receiverId: int.parse(
            AppFirebaseService().orderData.value["userId"].toString()),
        senderId: preference.getUserDetail()!.id,
        time: int.parse(time),
        msgSendBy: "1",
        awsUrl: awsUrl,
        base64Image: base64Image,
        downloadedPath: downloadedPath,
        msgType: msgType,
        kundliId: kundliId,
        productPrice: productPrice,
        title: giftId ?? "${userData?.name} sent you a message.",
        type: 0,
        productId: productId,
        userType: "astrologer",
        getCustomProduct: getCustomProduct,
      );
    } else if (msgType == MsgType.product) {
      final isPooja = data?['data']['isPooja'] as bool;
      if (isPooja) {
        final productDetails = data?['data']['poojaData'] as Pooja;
        final saveRemediesData =
            data?['data']['saveRemediesData'] as SaveRemediesResponse;
        newMessage = ChatMessage(
          message: productDetails.poojaName,
          astrologerId: userData?.id,
          id: int.parse(time),
          time: int.parse(time),
          isSuspicious: 0,
          isPoojaProduct: true,
          awsUrl: productDetails.poojaImg ?? '',
          msgType: MsgType.pooja,
          suggestedId: saveRemediesData.data!.id,
          type: 0,
          msgSendBy: "1",
          orderId: AppFirebaseService().orderData.value["orderId"],
          userType: "astrologer",
          memberId: saveRemediesData.data!.id,
          productId: productDetails.id.toString(),
          shopId: productDetails.id.toString(),
          // msgStatus: MsgStatus.sent,
          receiverId: int.parse(
              AppFirebaseService().orderData.value["userId"].toString()),
          senderId: preference.getUserDetail()!.id,
          getPooja: GetPooja(
            poojaName: productDetails.poojaName,
            id: productDetails.id,
            gst: productDetails.gst,
            poojaDesc: productDetails.poojaDesc,
            poojaImage: productDetails.poojaImg,
            poojaPriceInr: productDetails.poojaStartingPriceInr,
          ),
        );
      } else {
        final productData =
            data?['data']['saveRemedies'] as SaveRemediesResponse;
        final productDetails = data?['data']['product_detail'] as Products;
        print("going in");
        newMessage = ChatMessage(
            message: productDetails.prodName,
            title: productDetails.prodName,
            astrologerId: preferenceService.getUserDetail()!.id,
            time: int.parse(time),
            id: int.parse(time),
            isSuspicious: 0,
            suggestedId: productData.data!.id,
            userType: "astrologer",
            isPoojaProduct: false,
            awsUrl: userData?.image ?? '',
            msgType: MsgType.product,
            msgSendBy: "1",
            type: 0,
            orderId: AppFirebaseService().orderData.value["orderId"],
            memberId: productData.data?.id ?? 0,
            productId: productData.data?.productId.toString(),
            shopId: productData.data?.shopId.toString(),
            receiverId: int.parse(
                AppFirebaseService().orderData.value["userId"].toString()),
            senderId: preference.getUserDetail()!.id,
            getProduct: GetProduct(
              prodName: productDetails.prodName,
              id: productDetails.id,
              gst: productDetails.gst,
              prodDesc: productDetails.prodDesc,
              prodImage: productDetails.prodImage,
              productLongDesc: productDetails.productLongDesc,
              productPriceInr: productDetails.productPriceInr,
            ));
      }
    } else {
      print("new message added text type");
      newMessage = ChatMessage(
        orderId: AppFirebaseService().orderData.value["orderId"],
        id: int.parse(time),
        message: messageText,
        receiverId: int.parse(
            AppFirebaseService().orderData.value["userId"].toString()),
        senderId: preference.getUserDetail()!.id,
        time: int.parse(time),
        awsUrl: awsUrl,
        msgSendBy: "1",
        productId: productId,
        base64Image: base64Image,
        downloadedPath: downloadedPath,
        msgType: msgType,
        kundliId: kundliId,
        title: giftId ?? "${userData?.name} sent you a message.",
        type: 0,
        userType: "astrologer",
      );
    }
    firebaseDatabase
        .ref()
        .child(
            "chatMessages/${AppFirebaseService().orderData.value["orderId"]}/$time")
        .update(
          newMessage.toOfflineJson(),
        );
    print("last message  ${chatMessages.last.message}");
    chatMessages.value.add(newMessage);
    scrollToBottomFunc();
  }
}
