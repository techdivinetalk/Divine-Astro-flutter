import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/chat_message_with_socket_controller.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:divine_astrologer/tarotCard/widget/custom_image_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import "package:simple_waveform_progressbar/simple_waveform_progressbar.dart";
import 'package:url_launcher/url_launcher.dart';

import '../screens/chat_assistance/chat_message/widgets/product/pooja/widgets/custom_widget/pooja_common_list.dart';
import '../screens/live_page/constant.dart';

var chatController = Get.find<ChatMessageWithSocketController>();

class MessageView extends StatelessWidget {
  final int index;
  final ChatMessage chatMessage;
  final ChatMessage nextChatMessage;
  final String userName;
  final bool yourMessage;
  final int? unreadMessage;
  final bool? unreadMessageShow;
  final List<String>? myList;

  const MessageView({
    super.key,
    required this.index,
    required this.userName,
    required this.chatMessage,
    required this.nextChatMessage,
    required this.yourMessage,
    this.unreadMessage,
    this.unreadMessageShow = true,
    this.myList,
  });

  Widget buildMessageView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    // print("message Detail $chatMessage");
    // final currentMsgDate = DateTime.fromMillisecondsSinceEpoch(
    //     int.parse(chatMessage.createdAt ?? '0'));
    // final nextMsgDate = DateTime.fromMillisecondsSinceEpoch(
    //     int.parse(nextChatMessage.createdAt ?? '0'));
    // final differenceOfDays = nextMsgDate.day - currentMsgDate.day;
    // final isToday = (DateTime.now().day - currentMsgDate.day) == 1;
    // final isYesterday = (DateTime.now().day - currentMsgDate.day) == 2;
    Widget messageWidget;
    print("chat Message:: ${chatMessage.msgType}");
    switch (chatMessage.msgType) {
      case MsgType.gift:
        messageWidget =
            giftMsgView(context, chatMessage, yourMessage, userName);
        break;
      case MsgType.sendgifts:
        messageWidget = giftSendUi(context, chatMessage, yourMessage, userName);
        break;
      case MsgType.remedies:
        messageWidget = remediesMsgView(context, chatMessage, yourMessage);
        break;
      case MsgType.text:
        messageWidget = textMsgView(context, chatMessage, yourMessage);
        break;
      case MsgType.audio:
        messageWidget = audioView(context,
            chatDetail: chatMessage, yourMessage: yourMessage);
        break;
      case MsgType.image:
        messageWidget = imageMsgView(chatMessage.base64Image ?? "", yourMessage,
            chatDetail: chatMessage, index: index);
        break;
      case MsgType.kundli:
        messageWidget = kundliView(chatDetail: chatMessage, index: 0);
        break;
      case MsgType.customProduct:
        messageWidget = CustomProductView(chatDetail: chatMessage, index: 0);
        break;
      case MsgType.product || MsgType.pooja:
        messageWidget = productMsgView(chatMessage, yourMessage);
        break;
      default:
        messageWidget = const SizedBox.shrink();
    }

    // Conditionally add unreadMessageView() based on chat

    return unreadMessageShow! == false
        ? Column(
            children: [
              if (chatMessage.id == unreadMessage) unreadMessageView(),
              // if (index == 0)
              //   dayWidget(
              //       currentMsgDate: currentMsgDate,
              //       nextMsgDate: nextMsgDate,
              //       isToday: (DateTime.now().day - currentMsgDate.day) == 0,
              //       isYesterday: (DateTime.now().day - currentMsgDate.day) == 1,
              //       differenceOfDays: 1),

              messageWidget,
              // if (index != 0)
              //   dayWidget(
              //       currentMsgDate: currentMsgDate,
              //       nextMsgDate: nextMsgDate,
              //       isToday: (DateTime.now().day - currentMsgDate.day) == 0,
              //       isYesterday: (DateTime.now().day - currentMsgDate.day) == 1,
              //       differenceOfDays: 1),
            ],
          )
        : messageWidget;
  }

  Widget dayWidget(
      {required DateTime currentMsgDate,
      required DateTime nextMsgDate,
      required bool isToday,
      required bool isYesterday,
      required int differenceOfDays}) {
    if (differenceOfDays >= 1) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: appColors.guideColor),
          child: Text(
            isToday
                ? 'Today'
                : isYesterday
                    ? 'Yesterday'
                    : '${DateFormat('EEEE ,dd MMMM').format(nextMsgDate)}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return buildMessageView(context, chatMessage, yourMessage);
  }

  Widget productMsgView(ChatMessage chatMessage, bool yourMessage) {
    GetProduct getProduct;

    if (chatMessage.msgType == MsgType.pooja) {
      print(chatMessage.getPooja!.poojaName);
      print("chatMessage.getPooja!.poojaName");
      getProduct = GetProduct(
        productPriceInr: chatMessage.getPooja!.poojaPriceInr ?? 0,
        prodImage: chatMessage.getPooja!.poojaImage ?? "",
        prodDesc: chatMessage.getPooja!.poojaDesc ?? "",
        gst: chatMessage.getPooja!.gst ?? 0,
        id: chatMessage.getPooja!.id ?? 0,
        prodName: chatMessage.getPooja!.poojaName ?? "",
      );
    } else {
      getProduct = chatMessage.getProduct!;
    }
    return GestureDetector(
      onTap: () {
        if (chatMessage.msgType == MsgType.pooja) {
          Get.toNamed(RouteName.poojaDharamDetailsScreen, arguments: {
            'detailOnly': true,
            "isSentMessage": true,
            'data': int.parse(chatMessage.productId ?? '0')
          });
        } else {
          Get.toNamed(RouteName.categoryDetail, arguments: {
            "productId": chatMessage.productId.toString(),
            "isSentMessage": true,
            "customerId": chatMessage.senderId,
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: appColors.white,
          boxShadow: [
            BoxShadow(
              color: appColors.textColor.withOpacity(0.4),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
          // border: Border.all(color: appColors.guidedColorOnChatPage),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0.sp),
            child: CommonImageView(
              height: 50,
              width: 50,
              placeHolder: Assets.images.defaultProfile.path,
              imagePath:
                  "${Get.find<SharedPreferenceService>().getAmazonUrl()}/${getProduct.prodImage}",
            ),
          ),
          title: CustomText(
            "You have suggested a ${chatMessage.msgType == MsgType.pooja ? "Pooja" : "product"}",
            fontSize: 14.sp,
            maxLines: 2,
            fontWeight: FontWeight.w600,
          ),
          subtitle: CustomText(
            getProduct.prodName ?? '',
            fontSize: 12.sp,
            maxLines: 20,
          ),
          // onTap: () => Get.toNamed(RouteName.remediesDetail,
          //     arguments: {'title': temp[0], 'subtitle': temp[1]}),
        ),
      ),
    );
  }

  Widget giftMsgView(BuildContext context, ChatMessage chatMessage,
      bool yourMessage, String customerName) {
    return Align(
      alignment: yourMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          color: appColors.guideColor,
        ),
        constraints: BoxConstraints(
            maxWidth: ScreenUtil().screenWidth * 0.8,
            minWidth: ScreenUtil().screenWidth * 0.27),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: CustomImageWidget(
                imageUrl: chatMessage.awsUrl ?? '',
                rounded: true,
                // added by divine-dharam
                typeEnum: TypeEnum.gift,
                //
              ),
            ),
            SizedBox(width: 6.w),
            Flexible(
                child: CustomText(
              'You has requested to send ${chatMessage.message ?? ""}.',
              maxLines: 2,
              fontColor: appColors.whiteGuidedColor,
            ))
          ],
        ),
      ),
    );
  }

  String convertDate(String inputDate) {
    try {
      // Define the input and output date formats
      DateFormat inputFormat = DateFormat("dd MMM yyyy");
      DateFormat outputFormat = DateFormat("dd/MM/yyyy");

      // Parse the input date string to a DateTime object
      DateTime parsedDate = inputFormat.parse(inputDate);

      // Format the DateTime object to the desired output format
      String formattedDate = outputFormat.format(parsedDate);

      return formattedDate;
    } catch (e) {
      // Handle any parsing errors
      debugPrint("Error parsing or formatting date: $e");
      return "";
    }
  }

  DateTime parseDate(String dateStr) {
    try {
      // Define the input date format
      DateFormat inputFormat = DateFormat("dd/MM/yyyy");

      // Parse the input date string to a DateTime object
      DateTime parsedDate = inputFormat.parse(dateStr);

      return parsedDate;
    } catch (e) {
      // Handle any parsing errors
      debugPrint("Error parsing date: $e");
      return DateTime.now(); // Return the current date as a fallback
    }
  }

  Widget remediesMsgView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    var jsonString = (chatMessage.message ?? '')
        .substring(1, (chatMessage.message ?? '').length - 1);
    List temp = jsonString.split(', ');

    print("get templist $temp");

    if (temp.length < 2) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        boxShadow: [
          BoxShadow(
            color: appColors.textColor.withOpacity(0.4),
            blurRadius: 3,
            offset: Offset(0, 1),
          )
        ],
        // border: Border.all(color: appColors.guidedColorOnChatPage),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: appColors.red,
          child: CustomText(
            temp[0][0],
            fontColor: appColors.white,
          ), // Display the first letter of the name
        ),
        title: CustomText(
          temp[0],
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(temp.length, (index) {
            return GestureDetector(
                onTap: () => Get.toNamed(RouteName.remediesDetail,
                    arguments: {'title': temp[0], 'subtitle': jsonString}),
                child: CustomText(temp[index], fontSize: 12.sp));
          }),
        ),
      ),
    );
  }

  Widget textMsgView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    RxInt msgType = (chatMessage.seenStatus ?? 0).obs;

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                yourMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              !yourMessage
                  ? Obx(
                      () {
                        Map<String, dynamic> order = {};
                        order = AppFirebaseService().orderData.value;
                        String imageURL = order["customerImage"] ?? "";
                        String appended =
                            "${Get.find<SharedPreferenceService>().getAmazonUrl()}/$imageURL";
                        print("img:: $appended");
                        return Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: SizedBox(
                            height: 35,
                            width: 35,
                            child: CustomImageWidget(
                              imageUrl: appended,
                              rounded: true,
                              typeEnum: TypeEnum.user,
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox(),
              const SizedBox(width: 5),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: yourMessage
                          ? const Color(0xffFFEEF0)
                          : const Color(0xffDCDCDC)),
                  color:
                      yourMessage ? const Color(0xffFFF9FA) : appColors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(10),
                    topLeft: Radius.circular(yourMessage ? 10 : 0),
                    bottomRight: const Radius.circular(10),
                    topRight: Radius.circular(!yourMessage ? 10 : 0),
                  ),
                ),
                constraints: BoxConstraints(
                    maxWidth: ScreenUtil().screenWidth * 0.8,
                    minWidth: ScreenUtil().screenWidth * 0.27),
                child: Stack(
                  alignment: yourMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  children: [
                    Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.end,
                          children: [
                            chatMessage.message == razorPay.value
                                ? RichText(
                                    text: TextSpan(
                                      text: chatMessage.message ?? "",
                                      style: AppTextStyle.textStyle14(
                                        fontColor: Colors
                                            .blue, // Set the color for the link
                                        decoration: TextDecoration
                                            .underline, // Add underline to signify a link
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final url = chatMessage.message;
                                          if (url != null &&
                                              await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            // Handle error, e.g., show a message that the URL can't be opened
                                          }
                                        },
                                    ),
                                  )
                                : Text(
                                    chatMessage.message ?? "",
                                    style: AppTextStyle.textStyle14(
                                      fontColor: yourMessage
                                          ? chatMessage.msgType == "warningMsg"
                                              ? appColors.red
                                              : appColors.textColor
                                          : appColors.textColor,
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: chatMessage.id.toString() ==
                                  AppFirebaseService()
                                      .orderData["userId"]
                                      .toString()
                              ? 10
                              : 0,
                        ),
                        Visibility(
                          visible: chatMessage.id.toString() ==
                              AppFirebaseService()
                                  .orderData["userId"]
                                  .toString(),
                          child: CustomButton(
                              color: appColors.guideColor,
                              onTap: () {
                                log("fjdfkdjfkdjkdjkfjd");

                                print(AppFirebaseService().orderData["lat"]);
                                log("fjdfkdjfkdjkdjkfjd");
                                // Parse the date string to DateTime
                                DateTime date = DateFormat('d MMMM yyyy').parse(
                                    AppFirebaseService().orderData["dob"]);

                                // Format the DateTime to 'dd/MM/yyyy'
                                String formattedDate =
                                    DateFormat('dd/MM/yyyy').format(date);

                                final dateData = DateFormat("dd/MM/yyyy")
                                    .parse(formattedDate);
                                DateTime timeData = DateFormat("h:mm a").parse(
                                    AppFirebaseService()
                                        .orderData["timeOfBirth"]);
                                Params params = Params(
                                  name: AppFirebaseService()
                                      .orderData["customerName"],
                                  day: dateData.day,
                                  year: dateData.year,
                                  month: dateData.month,
                                  hour: timeData.hour,
                                  min: timeData.minute,
                                  lat: double.parse(AppFirebaseService()
                                      .orderData["lat"]
                                      .toString()),
                                  long: double.parse(
                                      AppFirebaseService().orderData["lng"]),
                                  location: AppFirebaseService()
                                      .orderData["placeOfBirth"],
                                );
                                log(params.day.toString());
                                log(params.month.toString());
                                log(params.year.toString());
                                log("${params.toString()}");
                                Get.toNamed(RouteName.kundliDetail, arguments: {
                                  "kundli_id": 0,
                                  "from_kundli": false,
                                  "params": params,
                                  "gender":
                                      AppFirebaseService().orderData["gender"],
                                });
                              },
                              child: Text(
                                "View Kundli",
                                style:
                                    TextStyle(color: appColors.guideTextColor),
                              )),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(
                        children: [
                          Text(
                            messageDateTime(
                                int.parse("${chatMessage.time ?? "0"}")),
                            style: TextStyle(
                                fontSize: 7,
                                color: appColors.greyColor,
                                fontFamily: FontFamily.metropolis,
                                fontWeight: FontWeight.w500),
                          ),
                          // if (yourMessage) SizedBox(width: 8.w),
                          // if (yourMessage)
                          //   Obx(() => msgType.value == 0
                          //       ? Assets.images.icSingleTick.svg()
                          //       : msgType.value == 1
                          //           ? Assets.images.icDoubleTick.svg(
                          //               colorFilter: ColorFilter.mode(
                          //                   appColors.disabledGrey,
                          //                   BlendMode.srcIn))
                          //           : msgType.value == 3
                          //               ? Assets.images.icDoubleTick.svg()
                          //               : Assets.images.icSingleTick.svg())
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

//   Widget textMsgView(
//       BuildContext context, ChatMessage chatMessage, bool yourMessage) {
//     RxInt msgType = (chatMessage.seenStatus ?? 0).obs;
//     Uint8List? bytes;
//     if (chatMessage.base64Image != null) {
//       bytes = Base64Decoder().convert(
//         "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MMMMMMMMMMMMMIQA/8QAAv/aAAwDAQACAAMAAAAQ888888888888888888888888888888888888888888888w088888888888888888888888888888888888888888888888s888PqR874/wBe+tv/AN7v/fP3/wD/AG+eMeNP/O9v/wDT/wD/AOOYN/8AzyzzzxuuJWRVw47bpWF5bxk157tD/bWgV5O/L/c5H/xDdRf/AM8488888888888888888880888888vf8888888888888888888o888w837w884w848880/w8/144/7z0/0888w704788888888o88ZtCftDxNp4/Nf1Ki/Z1sKK188eeB2oeHdlB2tBe888888o88vceP8A/LPHLDD3H3HHHnD/AMyxy8z/AMc/cf8AvLP7/HPPPPPPKPPPPPPPPPPOPPPPPPPNMPPPPPPPPPPPPO/PPPPPPOPPPPPPKPPO+0Ll/KSDmUIlE8CiDEf6GovRZc34vQZjmFru+NfJ4SntKPPLFBLZPIFDr7RCgKJdI/UqMlF+f75vfPwwhHP1f1KayVn/ACjzzzzzzzzzzzzzzzzzzzzzzzzzz/zzzzzzzzzzzzzzzzzzzyjzzj+Bfvjjf/D/AERe307wz3gQYz/05Xwzxq208y4w4+88888o8859QvpJzKKjB/2ORLv5FvbAr0S79BN9z1SJCwhlDk38888o8888c88sccM888cMscsf+8sM888cc8cMscM8cs888c88888o887/AP8AzzzzzzzzznzzzzzzzzzjzzzzzzzzzzzzzzzzjzzzzyjzyuZRK/6Bao1atTy+a/8AMepyRXl40sVaRXgFeB5fOQu3888o88/Mc/8ADXD3PDzTPXpvz7fzL/Lj3/7j7GP3Pb7LPjn3/wDzzyjzzzzzzzzzzzzzzzyzjzzzzzzzDzzzzzzzzzzzzzzzzzzzzyjzyzd0lPP50HxyUjPfvTpDxOyjlAPeF2erQZdSD/Tzzzzzzyjzw/pr1J7qTehCfflkvjpCcT5wBZSuiXb6SHt+vSfzzzzzzyjzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzyjzzv8A3z37wYz7387h7w03z783/wA85GN+/wD2nXXPHzzzzzzzzyjzz56sEqhKf0W/QXxAHU96/wAHXpYUaQyAp3v+Bh888888888o889NNMvPP/fd/ddt/wD7P/3/AB99+31/21312v338/zzzzzzzyjzzzzzzzHz3ffzzzTzzzzzzzzzzz/zzjPz/wD88/0z8888888o882pGY0CG9sqim/ZykNpYUSC1uEG8V6c/qc/0LyB8888888o88o7O3KB18wHHj8lQcC7o397GIrlfPb4KID0UEkh8888888o888888888888888888c8888888888888888888888888888o8854307/AN/PJtO+/sOPNf8A7fbBMbjLvfiTe7//AN723388888o88vB/wBcq7PyDQGL/GWQTpu/Mw5N+Ln8xZoZztNbqOt/PPPPKPPPPPPPPPHPPPPPPPPPPPPPPPPPLPPPPPPPPPFPPPPPPPPPKPPOPO++/PPMPMOMPPMdee/NNNOO/O/PPO/9PPPPONPO/PPPKPPO0a72l5ea+Nb5dsXj+KBuFlTufc3R/FjTdPVKT9xtvPPPKPPL/wA/y/x5y+z8wz8Zyzzyw4x+/wAes8ef8svvu0/vP/Pc888o8888888w88880888888888840888w888888888098888888o88r2zSprD/U8fZJhSWkSnrIDXcAeFMqZuyMoqvGlgiZV888o8846HCtkBXFa8QhT+jw6g/LaQM0eX44s7IArdcGTYiIj888o88888888888888888888888888888888888888888888888o88jh/wC/NvOdjlHUtPNO/NkN5eN9P9O9PN3PPPPPPPPPPPPPKPPODF7XClVSXV5FYOCjfuVPyJEItGu2TzufPPPPPPPPPPPPKPPPHPLPHBHDDHPPHPHHPEXPPHPLPPPLLHDPPPPPPPPPPPPPKPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPKPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPfdvOvP+9d//ACjjzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzy8W289WGA2+fyixzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzx582876x8x9zxzzzTDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDxz/xAA0EQEAAgIBAgQDBgUFAQEAAAABAhEAEiEDMRNBUWEQInEwMkBCcoEgM0NQwSNSYoKRYLH/2gAIAQIBAT8A/wDooaqCd3Ai9QK88YPNJZ5YRsuwMYJrycueG2ll+mBcHjmzJR1avGKA+uaNh6l4waURxKr3LxEwDw1su8INCoXhCTJj54lOEGhsBwhU4jyLhBV7AYwSN2JmjxaC+WA6y4OM8N4tC8IS2TPDaURo+Hht1ZfphBduTjGKA2JkYsmjGDSiOMEiNnJmjRaGSg7gHkYw4URxggKnbAW/YvNHTbyvCKX2+7eMI6Rb5cYFQ5CzEYqP8UPvx+pkU8Ub88g/N+zlEoRBLMaI9Msacs8W7/NkJESX1yRT3vOnUhi/XCQylbVmBoSVOSgxNoxpOCnOpWxTfBlnh/8AbE2Ionam3Njbv2hXwS+nDkvnLB6ZZw4UxlGwdryg6aWXZkgnLYSnCtJl+Zk20/SYozmX3O+QjRO0+7kGpRffIxCY7FXlldT3TLPDT/lkEtFqysDQkqclZNKh+nJBJ2EzaO7zwxq8Wov3f2yaOn6cg1Izi9LKqrwkMpvs1nfpx9lyaOn6cm2n0PtiVEvf7FlcYnp/HFp7XmwCEav8VTV5GLJxghfCZKOrX2TFK9z4ogPrkosWviiA4DJowLv2PggVT/FKOrXxAe79pH+XP9s/pP6sVbB8vuuKaB7udKrl+lzaJFC+co8SXtHFuMrleSkx1I9qMk1OKn5cbQtsvvihOtuL7VkqtrJTka1/tMQJdRDkOMFlGe3kWOTksYF+WLU6JUHlWSrZrteTlLWHL2yc0nx7ZWr1EOR4wkvT6l+2TlLWHL2zpKTyEn53u65bKEr8qy6mNflMnbEbEvvkO0nzDjBZRntzWTk1E8tTJylGWp2PLEPEm+hijCVyv04zqSflP+JnT7y/S5GVRiDX+clezZ9kSTtjOSU5vKu+W1WCnw2ltd84zklYTkFXm8rG8ZLniS9fgq5tLa75xnJKzZqsJyPhs1WKrbm8tlvnGckS82arBRszZ598tpM2lY3jJSnBRsxnJKxVrN5V3zaW2184zklYq4KXWE5BWLb+DRO/4Wmr/jp+zhGKSV7YxixuN96TGMItK3hAN9ntiRY2Xmj7f+4Rjps33rCBqKLfpkIh1IejlEibzxWAar6JidMQb5DNAZW8GGus0vtmsYhtdpkYh1OnT3MCC62365/T/wC2aRHV2+uJSmRiN28BhGEiVXwYRjqLfOPfGHzRDs5rH5m2hoxiVccYhPX3whH57Xhxq8nS9M57GaRZ6i5pFsBHCARFFvJx1T0TNbiJ3usYR3AeMDiDf5sl/WyMdpBlQbpTKiRGV85pG+nS84RgrEW/4SQRketYPyp7mLCTbd+Zm97354Jqnqnw2NK97wmagqV6YTCcXmjIyCx7OLEghffJIp9DGYylY05tAjILbM2jINrEM3jvBBoMJQHam/Izb5K89rzxBbWX0xrW3uuQkC32SnCUIkqtsyMolNpi2rkZV01fJo/fIyKYvbGUdajfe1zaDIk3fpjMqfu/BkbQfQMJ1PbGUaeZOEzUFSvTJNvnkJEbv9vrhM0TzzYqJ6N4zHxPfIy1kOf6Zfdy4sQldmbxvp0NGRkE7/G21X4gPllxh058cZCFyR8so1k+jiI05pLZK5xinczw5+mEVaDGKd88Ofp8JQ1Bs7ZLpOzRhFWgxinfAVoxhIr3zw5+mEVaDGKVeMTaZ6GVslHljFO5gK8GMJFY9M3jHJRuaBjFC0whJ8sjBkSfTK+Xt51d5q7a1zhGTmstgrnNJBdYRXGMhqucYSC3NJVdfYx+5P8AbOp+T9Jj/Ml+n/GH8uX1MnFlIQ4QzjbqlWuS4gmtW51F8T/zHl6od3GMonPBfbEudkf3vJNyXJixgnas6i+JnG3VKtXJcQrWrc6d216YlacJz2clCb1FPXvli9QC7clxANatx+91fpnTu2geO2TKI9z2c6dMZFW5LiFa1bj/ADj6mQq5nm48Qflq8nGUpXHs9nI2nUO7Wf039WeXie1fvhT0wI3S5+fplVTnT/mf+4U9MCN0uN7QABMlGorTHntlK2nl94ykB/EjSOSbkp5v46mrymrrjKaH7IF+yC/wGrYHnjHvycfYw5Jx9T/8z8rD/jeUM4RfIzhsdayJcg9XGQSTUrCowuhVxp6Y0DtjI8StSrwCJ1OBpKxqUBoG6xkRkx1KMPkeoHwmkXUDEN58fkyJxP6YpAiAclq5Ud+lxwmRqUlooFrIJLa4n3XLDpwaLtwrfpoBeR+abdcDjTFvX2rK1I1r2tvJgS4yyMY0FucPhNBbgj1GOpS4FwfUcnxUfQ5yFU9rvzyIbyuP5e2RSVjE7OBUY1rb65rFl5fdtDGdiMTI8T6VHcMOd1Dti6EQDktySLwV/HFYombu+2bO23neb96iF/DxG7ov1wmglCYzUqirxkstvfN12982da97zxHhov1wkive+/w+dI/KS475OddRRzfhAC8J8Ag1niSZRfQyMmLZh1EuohZjJQPTNn5fbN3awDGfCAGE+AQaxVbcJ0UgmM117cYSSW2dJqS+QN4tq4SoqhMhJZSf+Ob8IAXhPikEzd2HN+EALzduL6YKX74T4BBrFVt/u8Y3atBlR8OaN9s0ALlS5GAdQFvjCIrTwHdxiUo3kYsms0EdZWmaBEky75AGcR9cA3SL5OEDUky7uMIlLLh7Zo7Vfld5qI6t1kqOnAHJQBobbzSNkd+cIHz3KtXNCttuMYfdpse2aC0S5+Ey2ER8jNBaJW4QGOzKucC0MYVLUbbzQbCVuEChWrzXiXPbA+VcSL1Ef9v+MIjbfBkgKpvIEWE19sIlWtGSjVI2P2cU1YrWXEhIu1rHWVO1Nc5tHxIp2DIJFkX3O+Sl8qbXeQkDz2SsNY27W1xkkYwMi1KL74ak3mynFNInmLkkSHsZuEo/ppxlQ/Pf0MkjGB6ZKR4ux64aEiW3F9sZFdT3cs8OvPbCQRh6jebl3v8AtXPw3CcX0DDSMttrrsYpoHnbkWkzcOqy8rzard/pRkUA+avUcGFzOw9sdSCXbZjKPiXfFVkaF+avRyaNV3rlyCayFq6wYsQWkySVGJ5f3sF7GayuqcRO5msqunNX0xE7mELnQNYjaA4idzGMgtHGEiI18NChZVeacyF7F4RXsL8NZejhFexgOInc+CJ3HCMnsOAuMU7jjCoijzicoDmsvRzWV1TiJ3MCx75KFQFG3KcpzWVXTWU5TV/aQUh1K9sJPhPP5sG4wv8A3Z8/i+ffFTxq9ctem35Jj/Nf0/4yFaS79+axfljw9+Lxt37j5jkr0h9H4LEhCy++Rlszf+GNaQ7/ALZ+fs3rnT3uV3VN4PyxGznhMCnqW8+2KeH59+Lzp931prPn1fTzye3y1dUVnacvXTn65FWMx9Ml2h9MVJ9VMiuk2/MzZ8Lv+bJNwgvvkPudT6GT+7D6Z03mvJ4x+XWL6247+L598QTqV65SdL/t9pbltV8NpVWzlvPPfLctu7wU7OKvdxlJKVy2qtrFXvl4KYSkdly27zaT+ZwlI7KZaN3ir3V+DKT3VwlI7LluXluW885eW1WXlvwjWxeSdpLm0qrZrBTs4yXuv4Gmr+CJlOMUUrt+Apq/4KaX4IjTlNL8QXsPwpq64+zAYS9TJQPkD1pyo1KVcXQYgxJBXNOIeLXltiVHqfqMdY8MbfNzq1tx6Gf0z9ThG59SJhGMpkT93NBs0r0cO5kgl1aqucjpJ1I1fZ+E9IyTXNIkpjyBeBGmScXQYkWNhVOOkXXXt3cjARavmgxhevFK1mhtWnHrgRjFUvmjGvC4PzfCtvDf2f2x+eUJf+/tncnLzszqJ8nB90yTDxE17vfNQjP2THSOvy3wXkwjJMGTUTJG/Ua/dyTfTaOCRX2cJat1eE0298jIBEsxlYAUZvHYlrzjKyXu5vFq425OWzebfKHveb8ya74z+YkHObQ5qPwZ/MSCnN4jZGn4dSUd245urJfMyMgESxxkVQUZvFbY84T7iWOMjiiqzeN3pzhIqksxmMSJHi8avgyM6ilZGdRTBqKZKQhxyYyue3vjPifHdyUrT6BkpbSXIziRqm/Nzan5bM8SWqW9/wAWq/2CERjP9sYoXYmeG+aD6Zq/N7ZTS4wQGzHppfJZ3PgQGC2DeaDCLYd8YOwYwaaRrI9zHp/MgnfthFRewYwSvO+2eG3Vl+mahGd9xMIPFoXhCSp6YlOEHYjZmr83tgXJsPu4hpB+uRiyusYIKI4wSI2cmaPmhmj83thFofes0WUuxXfNKhN4e3OEGi0LxEUcYoD65o3XtjBC7ExEr6ZIYtfYxTSf7YP+m/qyQSlsSKc2JS6hfftlVCRZdmTRkfQxpHZi8cJ3xKr3MjzBLLsckmkP3wkD0/052F+XI/ePrlni3f5simqcXd84y107cN0YRCY7FXildTnzMUkia9vPNreo35fCzS75qsmmvDzLlwTZ5/J/jJJpD986f5+a+XA0JKnJQZN4h+nJG8thKc3HqPo8ZJBiDwYovUL7vGURhMUtrF2pNe3nk25LnTqUUfJvCV7i0yytYytLcQkRROwOdVGbX4Bb/BDRL3PsiVRT1+3orvjFKvJFKfZnc+L3f4qaX4ArR/AiA+uIDw39iFofYR5jKP7mIS1P9rTi3Gb/AMjOoqxLexjN8WvLaqyRSmTkxoj2oz+ocfl/xkZMiQ+l5AGUR9cJy8QPK+2Pbq/qM/pf9sVbp8vuuMmPThXvzhy9KT3XO0ZJ32zZWF+vfHh6qdxy2UFfJKc6n8z/AMxan1Pr3yd8Kjx3yLrBTveWvSb9TnJyYyo7YqdZ+n+Mg8TkvPHOSRh3tvv8JylpAt7Z26kv0ZGakr5osy2UG/JMk6oE6K7Vk63azphs+wpkJykyvnhwknTK9XKJPTXz75Cc3qA+vbHv/GSYtmEkunvltJjJQM2dr87xbcJyCs3ld3gpdfDxJ+uEpCuM5JS5vKu+bpCFPrjOSjfJhJLrGUlPbCUhW8ZSe+E5UF5vK1vvjJe+Rkx7YzklLm8qq83lttfOEkbzdUvsYqqubOtZvK1vyrBS8tpMJyK5zb5U81wUbM8SWW1WW0F9s8Sfr+CbPtET7Zs+0hGKSXyzWGu1temMR1Y+bWaw21tv1wgAsvJrGvCa/wB2MIjTd+uSKUzWIG125CJHqHnZZj3yoFXdphEWXPBlRYrG+PJxjCOt3yDjGBLVXCB89v3c1hrtbXpjE+VLpazU8TXyusIxqSrw4xNSRfesYm07WjEjXF36YxgNK3hGMZzO9RwBjNL8sSEaJXeEDZF4C8qLFS+MhW8b9cYkpocBd5rCQ63YZAuUfrhGPzqvDiR12L71gBOY2/LgGk0vyxjCNDd5GMY9UO5WRiSV5oxiaqCV3v8AjEIyPWs2NE98JVE9RvNunttzfesJiJLzbxlHTUvvebi2svcMW1c2jILsTNzca4Cj4XBq7EwlEZFcOXEihfOTkOvsBkpDO8Zj4nu5saJ75t8oeY3m0NyXPftmxrI9XNjSve83GU/RxYBRd4sFtu/Mzc3k+SVlhGZ61iwlS3eblya7xoyMgjM9TItSH0c2iTXlHvlxiOtqmRakPo5sVP3cs0r3zc3k+SVlhGR61jKEqW7zc3JVwGRkRUtpyUiqFf7vGGxJvthC4Kd7xix7maT9PhpKrrCEkEMYsWkzw512zU0vz2rJgSQxhUCVmPTflo7mEZKlc5pK6rnGMjuYiNOaS2qucYSBax6bUUO5iI04QuG3vnhrGKYRSdMf2whJ7YiNOEJORh82qYwkF1hCSWGEHaI8Xko6qfgYcxmHes7dJ/Vg/LBfKWVU7197v4ItqU194yl6UQ9XjPunTJeTeAkttfe7z+l/3zqffl9cRenGvJbzqfk/SY/zJ/oyHMZh3cpj05X5pRk4skQ4Qx5l1Q7vbIxkQnfHHbJ9ofpzqdz9JgL0kP8AdkvudP8AfD7/AE/05EWNa2XkypJeIyhGuayIky3kHOn+b9LiMow1Lox4elbkoy3lx+HZGsT0v7OKXyZcSKFq/wD2Nl1fPwZBVvwBWjCMnsOU3WMZHccRPL+zdd4jGl2ea9DCbHooWayq3yMuup1KntXS74b/AOj/AKj85zm86q+3VC/bJSnr1Zbvyy4Mh9+H1M8vur8znaYV2liGq1XOPAH7v9mou8o54Oc1idomUccHGax9Dveax54OfgKdn4Kvd/un/8QANhEBAAMAAQIEBAQFBAICAwAAAQACERIhMSJBUWEDEDJxEzBAgQQgQkNyBSNQghRiM2BTkbH/2gAIAQMBAT8A/wDsV9xRjyKLvlC506MbY5isLjvtPxDBxyLlz0xg6bB1SczFhfriJB3fZg7FeYYxv1QFjcwYOk5mpipG21sncJywPVhcXMZzPRSacqzmdcGcjNnPsIm/L8QzccjcM6PWFtczGKBrC/XESFxUxnM9FlbeHV84X64iQuLmMXMnI5cY2H1+qFnmmQu7bovWCJp/Nb6X7Sx/t/tL/TPpsqOMNW7ncmf7Wf8ArLVVr9pV0l9EsfaNcrXPJi8kwe8Hi20erpKbn7s/uftB46I94jx7d7b8hy9+kxS7ncjo1c8sm7cccyVeNcR2O8qdJQ6P3YDxq52Za2tOj3ljapG20Ti7kzrT7T+5/wBZcej6MXkmD3le9/vKvExGFXgdOzA2x9UofV95c2rOucs67EStPuTtd9wlP6vvKdv3fzk1Pb8kMV9f5007ziqK9v1WmpFwhYXJV038oR35iOyrpvzEVigaxcz3+Q/zVdN+avp+Zb66fvP7n/WZmaefch9b9ifE7H3JlmwudJ14VPVgJYwyVC2r32BtE3+qHRcMc7QNrudfXYbhsrUd31Zq1oL3YhW1clAG7nZgLXWvX12V3DZQOVnPOVoNZ3KD2YgXpkqHK3TznxDwyweA95hW9c84G1f8pXBTMfSX/pPJYhW1clA2z7srUa694bwoerASxhkoHV92X7V/yJY6rmyvY/KQe8Kg7OFZhuxB+XEzIVCNKrs41xMhUJwr8gCcTMhUJxN2cK/LibsADJxMyFKiM4m7EExnE6RBRnExIVCIJjCoQA2cK7OJmQqEAIgxoP6QR/S6fz7+XZRqHnBeWMG6aZG6lcO8G3LGcyLblhnaNnUEMlrLS01OJ0ivIIN0Uyc9K4dWPLlTfWbZXMwjZaX3yYtw3pk3x/8AWc7JvT7QdBllMzuxbjXc6sbW1DOkIW6O9ycrdDpqQXcYWWm+0bW8Gec65K6F37wtYrySckzUjZVBDJW2k5ZZH02F3iudZ52+0P7Us4LPH07TbKhnScrZfTtOVwFzP5UW1X0ieIfaBcMMnDOHtEeQ/LHlvtGrqgOzi8E6aywuJ3JluQsqYQola+pMstVzpMsLmIzg8bnqxLpnScfF7Zk4IZh94bueQSwuZ3Il1Nzoy1bO9BgYBLG3D17xHRIDus43KtTJxfB7HyKuWPXY12mQq6dAjVFQHZUwl6rmRq8h8pxds+pCr4PaWNEnj6diZYVM6zjbx75ywtM/W4av6hep1nOvrL3yonnBdqe0ETZyM3YWGc6xQNhYZzr6/KtxUlbmdWKBqwsMUDWFh2c6+sbAQsPaFnKPqzeI6+cLD2ih3hYdhd4rCwV1YWGN6nnLXxPeb17+XacjN8o2CcjNnOu5sbBORm7CwznXc38m310lP6v8mf0H+UfrPsytgqj36z+mjDrceW5KHgnY+GvYmi9O+d4OVxt+2SpgSvex7yn0Trnw3ZXrfeW4S+Yb6wd5dnp3lbVKA+naYnDXOkr1su70h9Pw/vL50317yjq9n3l/qq7K9bbu9If/ABP2Zbcow62PFuStitcY4cHsT+5/1nnw99/aPS71zSf03Zf6P/1HpdVzSGZd6pKviDRmh2fPswRU/Up0ZUwD0P12m5NNyaan5Wn5S5+g5d/acu3R6/k26NX3n9Rb3yblbW9WdTE5RcF9oVcHk7HbWzcAhpdN8oDw3Xcjq065pDw2TVM2Atd5Ox8XBflUbHJWC8K9f6pbvT7wOSqvea8L9ezLaB16rLDXMXuTFvY1zCP03F7R8NDN6w0TOXvs3V3l38pTc6z6rJr0hp+J17ExKFtdyLlz0SU119ZbdO+e0V41y3nE44i94u2e+HpNtx/fBhXExY9a3+8enD7wGzbV75Dc6v8AOmiTiceM4nHPKcO2q/Lgdtc9I113cYUB3WFcrk4/T7TPFs4eWuekaiHlny8IvVPaVrtAZw6iq5GnXRScDE9YgmM4dtVgdVnE8XvOPTF2FeuqsadXFIAGRrroowoG9e8a+HJ8Q2oerAwjXXdSWqAH/tOHqrGvXRScDMnHqKrOBlj1ibntGvVRSABn/L2tmAas151EzvOS7hpG60U9Y2QNOrCzuJLIGzkiaZOTyQJdSrkV4mnmRs8kCF17V6k5nHcnJ00hre2krfTcwnO2bx6Ru+HDvObucesLd9Myc3Na9PlRwtZnNOrXpGzywN6RcGF/DyTDJzTFMI2dQNycvp6d5viCalOnrGyYZ1YK9zJZsWrkbO4GsrbdMxPy7DpYnibVcwhyr0zZxtwseeyw2Bzt5Sp4t45LikeVsMyAlrSxtU9o61OnmQHkvsSo7acFH/LYV1PDkB5Wla+DGeNqnHrkx2nsTHnvtGutvcnFzOHy4rRI8rGccgPNfaPZnHaB7TjuHCWOv0/ZJlsq90hybjmGTi8M946h4ZQTZbdqhuTqWUN2VHVf+bUJyM3YIzkbmk09YI9mN8rvTYPQVII9mFhe8Lip8uTqB2nPoId3Iod35cq+pFDuzYI9n5CPZjYO7NCCPZhfbIJ0g9DUmnrORm6QRiukL7ZNJp8uRubNm/mWBvT95h+J28p2b56Twfh/tA38KZnxDPSf2z7y31nbtA626nbrkMOPZ9Elc52+QLe+ORMK/wCU68rdp/R7cpfjlfuRPE5j06jHqUzt7w+vy7S/Y9N6zw6esrx8W99dneh6cpYC1Mh3vAGvwxlg50/eYfidvKV6XuS31U+8r9V/vL9t9IdeVj0whw/D/aD1pvpN/wBz9vzMJkyca7uEw6TDdmGZkQe5ADsQrUdAmG7kAJh8mo9yYTjX0I1HuTCAHY+RUOxGtXuTD5YTCZMN2ZMPlbcclTAJxru4RB7kAOx+h03PkIzSFjp7/oNNz+TTQ+QjNND5qHd+Wm5+WqWPRhd8S+mk23Su9c1YKKLvTZr+Hvnk72o+0OVuu5Ph/T+7P63/ABjbK0WbYq2ZyTPFse0q8fh7HlU3d+VedqjynKzWqd1i20rv7wUti70hzTdlrIhudIXzeu4bObm8v2mq4OdNhvPq+Xy3jzh4a2J2antKD4uvmyvLhuzk7T3Icrb4s6yrtRiVNsweNDZUy56p+XaukabntGuojjCvVV1nBxOXScetfYnFOz0la8TJx8S+04dKnpCnRF6TjbptvkU8LVek42ejbp8qFuBjOBlQ8mWrqI4kKu6us42DB6Rr2R6kKvXXdnG2Zy6Rq6I4wq8t3yhuS1NsMabYYniGFUXr0YVyuTj1r7EqZv3lTDI1s23SZp4sZwryHD9WAf8AAWctWFtcxGcz0ZyOnvN6hC4+TC450cfk2S4Y9pyS9jqzkYs59tEj2YX8Jo/eNghYdn4hm45F8VPcnP0FjcAfWDpOZx2cjp7zfCYv1QXlaWsVzYXNzEhcXMZz9BZyOnvF6p7QsFa93Zy21TqRv1cFgiaQdU9JzM2FtcxGDuyrpv5Nvrp+8frPtKvExHZjUp7TdudHMlPpfuw7mD36kHdj0uPtD67Tipf/ACndPqj2Zn+1/wBYnUeuZ5Qrpbv2zWNvCnF3JjtPtAzR5TMKff5Y88zpuyo79pjxP8ofXb9pfvX7xeTXB6MofV95V4mIzilD1OsrqWfWYhRzsTdvVyBmjy7yhlSX0dPPpEzjh2m8rVwekHjoj3nw/pP0AB+iTU9n8pNsPp+fvWFhGDoP5b2+Z2P5t6h8lA/kEVIKn5K4L+RbparDTX1NmZap/wCsoGWc82FT8PfPIOhKhYV77P6H/KNSrVPWWUq5GteC+3eHf4f2n9z/AKwMzfXuQBvffaPQ+IHbJ3aj2yYBbPTtO/Ae2TCtwPMlPombWn/8lM6yxtwe2TA+IZ6SlRNe8wfhH3ljGoHSVEt2wz5VDnbpP6D/AClqg1zpveYVuZ5kDRWuym8TZd6Huy9agZ6k4jd30J1C4eUvWpRSHb+dBMY1HPaYbs4gswzPk0quziZkQflwrGogQqDs4V2cdtaFQEjUQhUBnEwIVCcK7OBgQAjUe8Kg7OFZxMycTMnEBzvAwCcTdnEzIg5MNGNKs4+IfQiCYzhWYbsw195+HX9Fv/DWUah5zlfePTYWTR8ibfOWEbKhXzNhv4hvpOammQdBm2VzMJZWj98YdptncyNnDp1YNhBzrBu7mdGcrJoEbPhzznK+502FnqPcJyeHL2ja21DzILqMLPGuBrBtvWDdNMyLZrV94/VXcm2dzMjd4iHXcm2LA51l94uek1Km9ZthNzGW+l+0bPgAOpBeWMVaUzDrHeVdyDZ6mZFWi+8bIB01hZ0HHf50W1X0mPMfacds+iZMvnHp941RGvkZAty19JwQwD7wMJlhczGcHinmu/LLG5mRq4depMsoudJUzfuytUpkKvg9pjzH2meJfacb8ePScXavoTHlvtOCFfUgWXrAuGGTg8A8xmK1Zlq9DMnBwPfWJrV9ImiTjZqD3JllNwCJok4u19iZ499pxeAeYzFasCx0MycHgkaqDhpAd1A/5e18QjfLHpkLD2Zzr6/LnXe8bVFNhYe0519Zryz2lXajC/iSFzrvrGwA7OVc3YWGCM5GbvSF6sLg231giaRvlsnMLWGNjjoxsEESNglreHSF6rmxsEbmKeUrbT9Dfo0Z/cP8YnW+ek3a5y/bPloYDvXszQ+JbfQn1N09J3rnL9sn9f8A1lPoIIXt75Kf1f5MzwV/yl+jVexNLXMlbAI99YfTRexFG9MlO9/vKdn7sXPiG+kr9d4/Tf8AylkLd8clHanSCF7bLY0cPOX/AKfuQStrbDr+JkrY4nX9OHis/lo50mWUXAP/ALeCoBqxEUTEnC/DnxeO5yzpvy+H8L4nxWxSjbjVs55B8lCNqndJsLD2Zo/8N/pHw0+J8b4/KtfwvhvFsgc7dCfE/hfhfF/1KnxLFbnxfgvxCtXS1w6109405fwf8IfE/hT4Rf8AjgadQTA7MufwnH/Un/w/hn/jXOHfrtuPih/D/wAO/E5nwipf/Tr/ABWp2Le0+F8L+Ffjf6d8B/hqJ8f4A3v15a71J8QwufeeffOk71/aC7m70h3X/hi1irUs8V1N6T8T4mUOdsr9Jvb7R+P8e3f4t3xb1s9/WfifE8fjt4/q69/vPxfi/wD5LfTx7vb0n4vxRo/iW2plXXQ9vkg9z5AHY/5T/8QASRAAAQMDAQQGBggDCAICAgIDAgEDBAAFERIQEyExFCIyQVFhFTQ1QnFyICMzQENSc4EwkaEkJURQYGKCsUVjU8FkkgZUg6Lw/9oACAEBAAE/Av8AUK9qtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaPOtHnWjzrR51o860edaS8a1KnP6P4n+nFHHKkXO38T/TpJjjt/E2uFobIsZwnKlvSCmViupSXrUiKkV2rnMcjxgcDmpd9AWQFfL+A6Si04SdwqtWyS5Jj6z55/iunumjcX3UzUB2fJJHzNEaz2f4VwfOPFJwOaVGdVyO0Zc1FF+kucLjnUApqo50ke/q/d4sx1ydIZLGkOX8Mjn+kERB+oxUyYMRpHCFV444UhZFFopbqXMY/DRpz/BBeabPxPoXj2e9+1W31GP8iVfvUx+eg9JyWxJsxaDHDxqNNlMykjSu/slUyUEVhXC/ZPGm0u8lN5vRbReSVNmz47e6c6p54GnelPGaQTNC627zmoj9ylsIjZImOZrRSbhAcDpBIbZLzp9cxXV/9a1anwYtquGvBCWoBzJLivmai17oeOy7OyI+5ebNdKF1koDQwEk70rpDzt03YGqNtp1qnTjaMWGR1Ol/Suj3pE178c/lq3z1f1NuDpcDmlPPvDdmGkPqKPFNkaQ8VzkNkfUROCbLs0+UdVB3SiIupPGrQxL3bLnSPqvyVPnG0YsMDqdL+ldHvSJr6QOfy1b56v623R0uhzSrjMejz2UFV06ez4rUJLgrinIVNKpwHZd5TsY4ug1RNXWr+9ZSawNGh7k76amy40gWZeFQuR1ePUHP2qISDBZVeSNpSSZ84y6NgG096nHLjDBVeJDDHaTmlWh51+LqcPK6lp2ZKkSCYiY6vaOnEu0Ud4rouinNKjSBkR0dHwqzSHnge3h6sHwpybLG4utB1uHVHuSnGry2iub4Sx7tW+Z0tjVjBJwWps51HkjRky53r4UjN5BNe+E/9tQ57z9yUVVUHT2PBdj7wMNE4XJKbO6zfrANGg7qlSrhEZMHV59hwahOEcJoiXJKNQplxf3jQFktXbXuSnSusJN6biOB30y8LzIOD7ybJ042jFhkdTpf0ro96RNe/HP5at89X9Tbg6XA5pVxmvMT2UFV06ez41CS4K4pyFTSqcBSpM6Qcjo0ROsnaLwrReGE17wXU7xq1Oo7cZRp31PnG0YMMjl0v6V0e8p1+kDn8tQJyyNYODh0OaVNmyGbigDlU08A86hJPQjKSSceSJsB99u6kyZ5AhyNXR9xmOm7XrkSINWqST8XJrkxXC0jzzl1VsTXdgPFKN91LuDWvqaeVX5t7Sh7z6vKdWoUeaBATknUGOzU10mruKgOotGESiZvONe+D5Kts5ZIEhphwO19Ne1s/E+hePZ737VbvUY/yJV/9TH56a4NB8KuvrsFf91Xz/CZ7OvjSY0pV/09Gb8ddSPZp/pVZcJb2/itXxE6CvzJX/jv/wDD/wDVMco6P56PqX+dDp0po5d2yUwj8dxvxSrbL0QXEPmzVmaVGTfLtOrmmPbj+rnp4bOHp5dH5ONSfbkb5dkP2xL+Gyf6m/8AJVn9Qapj24/q56eGzh6dXR+TjUxP75ifLtvmN5Dzy1caTklX/G4a/Nr4VdM+jFz5UWfQvD/4Uqz6OgNYqbp6I/q/ItWT1AvitWL7OR47ylxjjSI3pXTj9qsP2Uj9So/tx/5Nll4HL+eoGPSszVz7tjOn067p/Lsv2ehcPzpUbT0drTy0pV509Acz5Yq3ez2fkqwfZyP1Kn+pP/JVm9Qa/fYx7cf1c9PDZw9PLo/JxqbxvUT5dllxv5ee3q2WzT6TmaeVPdJ9MubnTr08NVf35/6qhxZYzifeUOI8cU4ienG/k23Ud25Fkp7p4Wn/AO0XOOHc2OtaiL0a4S2l5L10q0Jq38hebhrTnt0Pkq/+ph89NfZB8KcT+/W/k2W7hc53x+mfPZ+J9C6Nm5CdEByvDhUESCIwJJhUBM1emXXYoi2Ckuvupvg2Pwq5MOnKhkIKqIXGpsQZTCtr+y027doybtWN5jktTok99reuDk88Gx7kp8DWAYInW3fKrWBtQmwMVQuPCrs045DUQFVXPdWgugaccd1jH7VAha7erL4KnFedQOlxnVjuARN+6e2ewY3BWW14P4zQCgAIpyRKnwHTcGRHXDo/1rpd2Xq9E4/mqBBJhTddLU6fOrlCN9QeZX60KSVdiTR0VEX81W6K+xOeU0VUx2vHZNEiivCKZVR4JVsA24TYGOFqfBdN0ZEdcOj/AFrpd3VNHROP5qgQSYU3XS1OnzqUw6V2jOIC6UTiu2+BqchiveWK13SImhGt8PurTcOXLkC9KTSI8gq6NGcIxAVVeHCozf8AYm2zT3ERUoWJ9vMtwO8bXuoxuM0CRwN2GOXetWdpxmLpcFRXUvOnYcqLIN+KmoS7QU45dJQ7pGN0i81qNGSPHRtPCrMy6y29vAUcnTLLo3d5xQXQo89lqZdbclawVMnwqdBe36SYy/Wd6eNJJuznUSMgr+Zahs7m8EClldHFfPZIYB5k2y76a9KQfqxa3od1SmLhLYM3RxjsNpUEDCE0BJhUDjVmZdZbe3gKOT4ZqYClFeFEyqjVrA2oTYmOF48Nk+A6boyI64dH+tdLuy9XonH81QIJMKbrpanT51KZdK7RnEBdCJxXZKhSWpKyYnNe0Nb+6v8AU3CN/wC5atsR2PNkZEtPcS99T4LjjgPsLh0f610u7Y0JE4/mq3xHGNZunlw+dGy76YBzQujTz2z2N9EdBE444VaWX0V118VQ1wnHyq7MSFcbdYBVLSoljwqK1uYzbfglGy76YBzQujRzq6RSkxVEOaLlKhSJqmLbsbSiJ2qNh30wDmhdGjnshMuhcZhkCoJLwX6bnPZ+J90gf2mc/JXknVH7jevt4P6n8eecuNIF8Mk17w16biaeR6vDFW1l05Dsx0cKXZTy/wAoc57PxPuiCA8BFE+H3EgAsahRcfcNyznO7HPw/wApc57PxP8ATznPZ+J9AVFeSpsRUVOC0pInNcUiovJaucl2NG1t4zqpk1Jlsl5qmyZLmDNCOxp6w99K5em01E22SJ4VBmBKa1JwXvSrWZlKmopLwLhs1h+ZNqGC+8lahzjKZ2IYLyJNiqic1pCFeS7dQ5xlM0hh+ZNqEC+8mx+cYXBhkSHQScaQhXkqLSqiUhCvJU2yZxtTo7QkOgu1QkJclRatbhlKm6iXgXDNIQ/mTYvCkIV5ElIQryVKkzjanMNCQ6C7VCQryVF2XCacd2MLZD1iwVCYlyJFqI4a3WUKkuETlSGH5k2NxCGe49v8ovubEMF5En0EMPzJs1DnGeNZTxrOOdIQryVKtLhk9M1Eq4LYhgvvJs1JnGUzWU7l2OxCK4A9v8InubEMPzJ9wc57PxPoWD7OR+pU31N/5Fqzez2/3qK0lwffWQ6XAuAZoIUiJLDcEpNL2kWr36gvzJUf7Br5U2SzEL0wRLhNNHcYQAq70V8qsjZ6HnFTCGXCrR63P+apjr0iYkNo9KImTWlskfT1XDQvHNWyQ9vHYzy5JvvqU49Mm9FbPSA9ta9CMimW3TQ/HNQVd9Llve2gYX9qurhrIjsa9AHzWnrOAt64zh6086adcCJreTrCPWqNHcuOX33C0Z6opUqAsIN/FdLq8xWor6Px23PFNhg65d3gbLTqTivlTlkb0Krbho545qzyXHmSFztAuKfcemzCjNnpbDtrRWNlBy26aH45q1y3SV2O9226lQWEujLWF0nxWo8RiIJ7vlzWmgcubjhmZCyi4QUp+19HbV2M6SEPHGat8rpMYTXn37JsJhLkwGFw5xKo0JiLq3WeNRWXX5ktsTUQ1dbFSLQLTROsOGhjx51bZSvxRMu1yWk310kuJrUWAXu76K0IymuM6YmnnzqyEpSZhFzXGamwmEuTAYXDnEqiw2IurdIvHZd4jIyY6p+KfWqLAjxVUm0XjWh126yGwPTntL5U7ZG0BSacPeeOatEo3466+0C4Wo/tuR8lXQzKYxHU1Bsua09Z0BvXFcPeJ586jq5uQ3iYPHHY+49NmFGbPS2HbWisbKD9W6aH45q1ynSVyO9226lo8V5UWlwRAiZ8OFQ4IxNa7wiVeeaAXbpIcVTUWQXGEorVuB1xnDQ07lXnViJSOUq81WpBvTJqxmz0gHbVKKysafq3TQ/HNWqU4e8YdXrtrRi8d2fBotOpOK+CVDhjEQsGpavHZI9uR/lq8uuAjDYlpQy6xUVmZ3Wpl09eOC5qD0jo4o/20/juc9n4n0LEqD0kF7WurgQhCeVe8cVZ1xbm/wB6KJBmkTjLmku9Rrey4Mlltx3eA4uPOrkwciKoBjNNJpbFPBNkxoHbyyBjlFDlSW6CHFGBpOFWj1uf81Ox9d3cA3CDUmUVK9D/AP5j1W6PFGS4Tb5GSJhc1EVGbvKA/f5bIzouXxwh5aamJCeIWHsal5eNOwpMQCcYklgeOkq3xTLWZY4qC1bYIyI6L0lwVReIotP21ppvU7Md0/GoLbbUUBbJVHuXZH9tyPk2Wb7WZ89W9UaucsD5kvDZA+tucp0ezyqZ7aifLTwqTTgp3itW2Ej4GnSDAhLiKU7a222yI5run41bWmWo/wBUakKrnOyf7Wh/DZafW5/zU99i58q1ZeMI/mWrGSAshkuB66IhAVVV4JVkNDlTCTvxU/2tD+G28/bwfn2Q/bEv4bLH/if1Kj+25HyVLGE+YsPL1+7xp6JKhNk6xJXSPulUSRv4wOY5pst67q5zAPmS8Nlv+tukp0ezyr/zy/p0aagJPKrGaCLzK8CQ+VGYgKkS4RKsSoZyl8SpIuu6SWzdJtVXKY769D4/xj386tjEYXHSZeU1781H9tyPk2v+3I/y1L6ISCy/jrcqO2vMCpxpJJj3V5VbZZSY+suaLhf47nPZ+J9CTa1J7fMO7s++ltchwS38jWuOr4VBjlGjC0SouM07azB0nIz+71c07qYth75HpL28IeVT4xyWNAuaVzTLattAClnSnPY5CMri1J1JpFOW2FDOM9JNSRd4vCpkBuUicdJJyKvR9wVNKzepUSI1Fb0h+6+NTre3KwWdJpyKkts4uq5MXR5UxbNxN3wqmjTjFTYAStK6tJjyKltk5zqOzMhTTQMti2PJKetZI4rsZ5WlXmndSWp5wxWVI1onu0iIiYTY3CMJ7khSTBJy2QYRxifUiRdZZqbbm5KoaLoNPeSvRk8+q5N6lRozUZvQCcKn29ZBA4DmhweS1DblNISPu6/CpNs1O75h1Wzr0XJdVOkytQ+CUACAoIphE2ToHSdBiegw5LURqW2hb95D8KhQjjvSDIkXeLwox1ASeKVb4pRWVAiRetnhUu2C85vmj3bnjQ2yUeOkylIfypUGAUV+QeUwfJE7qnwOk6DA9BhyWoTUttC372vw2T4KS2x62khXKLUNia0Rb5/WmOFMwjanPPqSYPu2W+GcXe6iRdRZpuEYXByRqTBJyqdACTgtWlweRUtsmudV6ZkPCmmgabEB5Imybb25KoedBpyJK9GTz6rk3qVGjNRm9AJwroR+kulak06cY2S7Wjju+Zc3Z0FskmqdJkqYp7tQIRRTfVVTrrwxU23tycFnSY8iSlttwPqHN6lRozcZpABKbhGFwckakwSctrsIyuDcjUmkU5VNhNywRC4KnJaW2z1TQU3qVGjhHaRsOX8dzns/E/085z2fif6ec57PxPuhEICpEuESo8yPIUhbLOOf8EXmSMgQ0Uk5p9Bx1tpMmSD8dpmICpEuETvoTAxQhXKL95flx4/2holNuC4AmPJUz/FefaYHU4WEreBo156uM5ppxtwdQEipQPtGpIBoqjz/AIznPZ+J9AbhEVHF140Lhc01dYJlpRzY/KYYT6w0SmrrCcLSjn89iXGKpOprxu+1mgu8Ei07z6Dzostk4fZHnS3KGDYGp9rlWpMZ7qK7QRLCufyph9l8Mtmi1fJQbvcIq6spmrc9CNNDA4VETPDFMzGXjdAF4hzpVwiqvdUaUzIDU2vDOKSfG1ujrwrfazQ3eCpad7WUVOFPSGWEy4aJTN0hOFpRzj51A9rTaNwGxUiLCUl4gatO8pZ0cXW2tXWNMpV/9Xa+enbhFjoKGfHHKo06LI4Nnx8Kuns9/wCFWz1Bj5afmRo32jiIvhTFzhulpFzj5/QdeaYHU4aIlN3eCRad5QzGFkbjPXxmnXmmB1OEiJTd2gkWlHP57Y8xh9TEF4jzpVwmVqLKakipN5wi4p+bGj/aOJ8KYuUN5dIucfPZGlsyBUm15LinHBabIy5Jzph9t5oXA5LQXGIoGWvCCuFzTDzbzSOAvVWiJBFSXkiUUyK5cyddyrenhwpJLAxd8nBvHhS3KGDYGp9rlWUxnuo7vBEsbz+VMSGXg1Nmi0qoKZVaK8QULG8pl5p0dTZoqbH5TMZQ3mesuE2MTo77ptgvEedPyGo7etxeFT1hlFEn86FVMU8gJb3NHZ3S4qx+oB8Vq0etz/m2cqK7QQLG8/lTEhh4ctmi0pIKZVcJS3iAhY3lHPihuuvwcXq4p+Q2w0rh9mnLnDbESVztJlKjTY0j7M8+X0HOez8T6Fsig/LkkaZQS5VPgxzjOYbRFEcoqVan1KAJF7uf6VbmUmOvSX+t1sClSbdGeaUd2KL3KlWV8zZNs+bZYqHGB+5ytfZEuVS4EZxg03YouOCpVldI4eFXslijnzxIkSCSpnnQT56mKLBJEzzq5+z3/hVrgMLGB10dRL41enlRGWNWlDXrL5U05Z220DW1W8jsXFpYppoc4EKVfxHowLjjrpoAEBwKJwq0+uz/AJqd+xc+VasXqpfOtMRgfusrX2RLOKkQIzrJDuhThwVKsbpFGIVXsFiozST5z7jvEAXApTsCK4ChuhT4VaBIJ8oSXKpwzU3Mu5BFz1BTK0kKIgadyOPhRR+j3dgEXq+7V/8AVm/nqJAZBtFMUM14kq8au0QGBGSwmghXuqY5vbSZ+IItQT3drA/BvNW84RKb8p0daryKp62p1ktDjaGiZHFWp8n4YEXNOG3T0+6OC59m13UcKIQadyOPhUJpWbwbarnA/wBKu6KkmM44KqynOjbt01lRbUM92OaVGbVlgG1LVjv2F/Y7uhe49/3V1e3UMsdo+qlNB0K3eYhn96tUQHQWS8mszXvq4W9hxgyAEExTKKlW6QT8DJc0ylWH7B79Srj6k/8ALVo9QZq1Q25Dr5OcREuz50AAA6RHCeGxoA9OPDpTGjlVzFEtz+PCrXAYWMDrg6iXx7qvb2EYY1aUNesvlTTlnbbQENqt7HYuTRRXE0OcCFKvD2XWI6npBeJrQO2YAQEJqmXWWLoKRjRW3OaJsu7G8hF4h1qSX/dm+/8AX/WojaxJENxfxh4/vV1+tdiR/wAx5Wr4mICJ/vSnPZpfor/1Vk9QD4rVo9bn/NsvLpoLLArjelhaZgxmm0FGhXzWktqszN8ySCPvDV2I3H48RFxr4lTUGK2CDuRq4xEjy42jsEeceC1ePZ5/tVthsJFbMgQiJM5WrkwMWRGfa6uSwuPoOc9n4n0LN9rM+epHqz3yLVlTVAx4qVWx9Ijr0Z7qrqylSZ0dhtS1oq9yVZWTFk3D4bws1a/aM/5qc7BfCrD6u7+ou26ez5Hwq1+oMfLV6ZX6h7TqQF6yeVNNWp1tCEG6bKCU1GmIwrjmfhV/9UD56DsD8KiuDFucoHeGteC1MlstRz66KqpwSrD6oXz1b/as740vJasH2T/6lRXOgTn2neAmuRWnJcdoNZOJVoMjnyiJMKvGpqrEuYSVTqEmFpJUfRr3o4+NFI6Rd45J2eQ+dX/1Vv56hTmnWkQi0mnaRau0oXRGM0uoyLuqY3urSYflBEqCG8tYB4t4q2hDRTYktjvBLvqX6Ljt53QEvciVGUAi693u0xqVKjyWpDesM42a+gXVxT7DvfRy44hqV0cVCe314NzGMjw+FSprbDzbTrfVP3u6p8a37g3RVAPHDStWw3XIbROc9l5YVyLrHtNrmm3fSEuN+VsNRfGpLW8juh4jVolgDXRnV0mC99XCcy1HMUJFMkwiJVrjk1CQS5lxX96tDwxzfjurpLXmrrLaGKYISKRJyq0eoM1Y/wDE/qbWvbz3yVdPZ8j4VbPUGPlq9s/YP6coC9ZPKmmrS62hoDdNlBKajTEYVxzPwq8NYfYkEGoE4GlAzajDWgN4qMcM5igxGTA+/sMUISFe9MUhLueg9/SMftV2Z/sYkKcWlRUqGSSrgT/ug2iJV+9S/wCaU57NP9H/AOqsnqAfFatHrc/5tl6aLSw+KfZlxpiWw82hI4lDcdczcNBqT3i8Ku4k1Ijy0TKDwWmpkZwNaODVylC/LjaOICacfOrx7PP9qg+psfIlXzsRv1KTkm1zns/E+hHiNR1cUM9dcrRihiQryVMVGjNxm9AZxUiHHkJ9YGfOmrPCbLOjPx2Mw2mHXXRzqPnSplKjRWooKLecKueO15kHmibPkVMsiy2LY8h5UqIqYVOFOWaCRZ0qnwWmIzMccNhipcRqS2gOZxnPCkTCYqTDjyETeBnzpq1Q2cqIcfFajRm4wKDecZzTURpp914c6j57I0RqMJI3nrLnjUiKxIHDoZpq0Qmj1IGfjTcNpp9x4c6j5040DgKJjlPCvQsFCzpX4ZooEdXmncYUEwOOVSojUkBFzPBc8KkW2I+uTDj4pUeBFjLlsOPjTzQPNE2XIqZaBhoWx5JUmDFkdsOPjTVqhMlqQMr51dCJIhAHaNUH+dRmUYYbbTuTY+wy+GlwEVKCzwQLOhV+NJCYGT0hM68Y8qfjsvBpcBFShs0ESzpVaRERMJsluA3HdJeWmrIxu46uKnE1/psk2+LI4mHHxpi1Q2V1IGV89km3xZHEw4+NBaobYGKB2kxnvphgGGhbHklRojUXXoz1lyu1IjIyikJnWqYp5kHmibPkVMtAw0LY8kpURUwtOWaCRZ0qnklMRmY44bDFEIkioqZSissFVzpVPLNMsMsDpbHCbegR+ldI466cAXAIC5KmKiw2YoqLeeK99SorUlrduZxnNK0Ksq0vLTio8duO0jYZxTERpg3TDOT57FRFTC0dmhEudKp8KYisxxw2GKIRIVFUylFZoOrOlfhTluimjXDCNrkcU/HbkMq2ecLTYI22IDyFMVJiNSEDeZ6q5TH0HOez8T/M7hEdktC2JoiZ61ACAAinJE/ypzns/E/085z2fifQgz0lG6O7UdP0Jk4IqD1VIi5DTMgyjK640oYyun4VElDJa3goqcfuKvsi4LammpeSbIs0JCuoIqmhcfx1XCKtQ5gSgIhRUwWKbmtlLOPpXIpzoH3vSjrKr1EDKfwHbnh9WWWVcJOdOPAyyTh8kSoc9ySa/UKLeOBfTCQy4ZABoqjzSpL+4ZNzGcVEk9JYFzTjP3xzns/E+hAl785CboR0l3d9PXRGJhMmPVQc5orrKTrLCPR41ElNSWtYVMekrcWVVjrD2R8aRx5yE8rrWhdJcKsXqX/JahzifekN6ETdrRLpAl8Eq3zFlMqajjrYqVcQYNGxFTc/KlelZDfF+IQj4006DraGC5RaS8dd4Fa4iWBROa16WfaXL0QhDxptwHW0MVyi1LuQMGjQCpuflSvS0hrCvxCEfGm3RdATBcotP3RAcVpltXD78Ul2cbJEkxibTxoVRRRUXZJflek2S3HXTsj41EekOiW+Z3fhUKWMc5XVUiJzgKV6XeaVN/EIB8abMXAEhXgtSbkLTm6bBXHPBK9LPNqnSIpAPjQGJghCuUXZLuAxzRsQU3F91KS7OtkKSIxNovfTzu7jm6nHA5oLxqZDS0pOF7g0l3dbJOkRSBPGhMTFCFeC1IuiC7umW1cNPChuzjZIkmMTaL30qiTSqi8NNWH1d39Raj+25HyVum0cVxB6ypjNSbjundy02rjnglN3U0cFuQwrWrku2Rcxbc3TTauH4JXpZ1tU6RGJtF76ddJI6uMjrXuSoEiWD0km42slLreVXp1/caN11FRMl4VbH5Ki2BR9LaBwKpdwbjqgYUzX3Ur0rJb4uwyEPGmX2320MF4LUq4gwaNiKm5+VK9LSGuL8QhHxpXtUZXWU18OCVDkSwlSiCPqJV6yeFG+4MEnTa6yDxGmpRLb9+DSZxnTUGWkmOjmMeKVPmdDY14yqrhEpH9MdHXcD1crXpV9zjHiEY+NRbkDx7owVtzwWrhKWIxvEHPHFLdXT+wjE54r3VDugvOblwFbc8FpxwGwUyXCJXpV9zjHiEY+NRLkDx7owUHPBalSm4zWs/2r0rKRNawi3fjUaS3IaRwOVO3Rd6TUdlXCHnUa6ankZeaVs15Z/iOc9n4n0LN9rM+enGxO/ce4UX+my0dSXObTsoVTvbMP5ak+rPfItWP1L/ktWr1yf81PfYufKtWNf7IfzrUGZu3n3SYMyIuaUd1RwFEobuFqxbxGXRJFRNXDNWsBWdNPHFC4VJATjOiqe6tWRV6F8CWrKiOOyXy7WunGxcAhNOC1uQhxHUbzwFVSrZNSO2S9HMyJeJJUm4o+wbaw3eKcKs+86EKGi8F2TPbUT5dlnbHpMs156sJUxsTiPIqe4tWg19G58NVW6YjO9NWDMiLtJT1zR5owKG7xSrJvEiqJoqYLhnZMYkszkltBrTGFSlnwpSbqQChx5FUsRGA8ickb4VY2QGJvPeJVqW0DrDgkndVreNLa/wD+vVirbNFhsl6OZkS8SSpVxR9g21hu8U4Va956OwaLwzVh9Xd/UWo/tuR8mx5qTEnHIbb3gHz8a6XAm6W3RUSzwQuGx1dLTheArVtmIwJl0czIi7SVIuSPsm2sN3ilWbeJDwaLwXvqz+sTfnq9eon8UqJ6qx8iUxL3c6S6TJOLnCY7qW7IqKiw3cVZdY9JTSQjnI5qzJvHJL5drXToC4BAScFqPHbjhobzpq1+0Z/zVcPUZHy1avZ7Xwq3f2afIjLyXrDUv+1XNlj3W+sVX48MMh3KfH9qbuotgIjDdwiVLkFIeYNuM4JCXOr56gnzJUQBbitCie7V2RAmQnE5qeKvpKjDI9xHxpu6i2AiMN3CJUySUh5hwIzgkJc6ucVyQw3o7QLnFDdUFNEpgg/6qIEYGsx+yXGhSTbn3l3KuNmucpQPwJroZ4ODyReH8Rzns/E+hZvtZnz1/wCeX5Nlr9oz/mqd7Zh/LUhP7M98i1YvUv8AktKR26e64oKrTvfT90B9ogjiREqeHKrD6oXzrSKdslOZBVZcXmndTt5ZUFRhCI15cKh9J3Cb9eutWj1uf81P/YufKtWP1QvnWkU7ZLcVQVWTXmndT15aJtRjoRGvLhUVt/ouJBZIk41HeO2GbLwLu85Ekp+7bxNEQSI178UwjosijpZPv2XPLNwjSFRdCJxqNLYkoqtryqzfazPnqT6s98i1ZPUf+S00Z2t5wDBVZJcoSU9eAINEUSI15cKio+jA75cn37JUuTFl5NMsL4d1XCbGltbtltSNV4cOVOgQWshLmjVW2W5EjirgKrRclTuqTdkeBWowERFwqDD3MTdFzLtfvTDx20zZeBd3nIklP3beDoiCRGvfim0dSL9aWT08asPq7v6i1H9tyPk2OTpESWSPoqsr2VRKnyWp2huOCqertYoUwAovhSplFRaYdO1uuNOgqtKuRJKfu4mOiKJEa+VRkeRkd6WT76s/rE356vXqJ/FKheqMfIlHvLdNcd0KTLnPHdTt6j6fqkIj7kxUHpW51SF6y93hSKdsluZBVZcXmndT94aIMR0IjXlwqCMhGE35ZNaafGDcJe+yiGvBaluA7bXTDkoVafUGauyKy9Hlj7q4KrOKnvpRc3C4VdIpSY+A7YrlKZvDQggyBIDTnwoJkmXKHcoospzVe+r76j/zSmF+ob+VKvP28D9SrlEKTGwHbHilM3loQ0yBITTnwoJkmXKHcoospzVe+rgctpsTY44XrJ5UV4hm1ggJVx2cVZWXQjkpJjUWUShuL0Z5xuYi490kSn3AmzI/RgXqlkjxipk5IpNJoUta/wANzns/E+gIAOdIolaA1atKZ8diAAqqoKJnmtKAKSEoplO+loREEwIonwpUReaUjbYpwBEoRAeAiifClRF50jTQ9kBT9tggA5VBRM89giI9kUT4UqIvOhaaHsgKftsUUVMKmaFtseyCJtUUVMKmaBsA7IonwpAAc6RRPHYICKYEURPKlRFTilA02PIET9tqoi86RtseyCJ+1TvU3/kWrOiLbm0XzoW2x7IInw2KIqmFTNC22PZBE2CIB2RRPhWgNWrSmfHYoovNKFsB7Iom1RRUwqULTY8gRP22IADnAomaIRJMKiKnnSIicE2I00K5QBT9tioi86RpoOyAp+2wwbPtAi/GtAadOlMeFIKCmETCUQiSYVEVKEUFMImE2E02XaAV/akRE5JRiJJghRfjsIALGRRccthNNF2gFf2pEROSbFaazndjn4bCES7SItCIj2RRKURXGUTh/Dc57PxP8mdbFxsgLkSYqOwEdpGwzpT/ADdzns/E/wBPOc9n4m10922Z4zpTNQ5ISmt4KY8qmSwis7wkzxqJICSyLg8lqZMCIAkQquVwiJSLlEX7pHmg7IeYQVyHf90lSBjMq6SZxTLqOtA4nvJn786U5J4IA/U961PldFjk538kqAk5frHzTBJwTwpgp/TXUMfqe7+I5z2fibVTKVaPqn5cde4spVzTfyosXz1FVlVQWTHX3Dqf9fc4rPcPWWpsoYrOtefclC3eHx3m+FvPu1GmyG5HRpSJqXsl47DMWwIy5IlA9cZ2SZJGm+5aKTPgmPSFRxtfeSnn22mFdVeGKbO6zfrANGg7qlSrhEZMHV4r2HBqI4ZwWzJcro51Cl3GQJtgXHVxNe6nXLpBw44aOB3006LjKODyUc1DmXB9HGwLK6u2vclOldYSb03EcDvpp4XmQcHkqZopkuW8bcTCAPM1o1u0RN4Ro6Cc6B/pcTU0WFJOHktRWJZTZIhIwadovGmBcBoRcPUXeuyROkuyVjxE4p2irRd46a1cF1E5jVrmOyJUnJro91KN970uDWvqaeWyHIeO4ymyNVEeSVcJxskDLI6nSpGLynX345/LTdwkOXFhtch3GHnV5fdYYBWz09emDuUhwHewz4d6pVxnkwoNNDl0uVIxeca9+Py0lwknPjtrkO4x86vD7rDAE2WlddJ6VlChgYtD3J31EmyW5XRZXP3Sq9tP7lTR36tE4j41AjzdLBrJ+rx2KuE4mVBlodTp8q6Pee10gc/lqBPJ5TadHS6HOp01xtwY7A5dL+ldHvKJr6QKr+WrfO6ShCaaXA7SbJ0wYjOrmq9lKBu8vJvN8IZ92pc+c0gNH1XNXNPeSpzhhBcMVwSCnGoztzlsDuzQUROJr3rXSp0J8AkqhgXvVdFfSIrjJqijx/aocjfxm3PFKnPvdMjx2TxniXw2SXkYYN1fdSmku0oEeF4QReSVbpb5m4w+PXDv8amTnY9xQUVVHT2PFa3N4c6++EP9tQZ7qvLGkjhzuXxqfN6KCYTJl2UpGLy4mvfiP+2oc15X1jSUw4nJfGrhO6MggA6nD7KVuLyqa+kCi/lq3znHTNl8cODT0h5Luw0hroUeKVfm3tCHvPq8p1POoDMoOLr+sVHglRZDxXOS2p9ROSVPnEyoNNDqdPkldHvONXSBz+WrdOKRrbdHDgc/4LnPZ+J9B76i8tH3Ojiof19ylPdwdVKL+z3kV7nRq3/XT5cjuRdKVfde8iY/NX99/wDpp2Lcnn2De3fULu2XfPQHceVWzHQWMfkSjRvHXx+9Xz1FNP50qLp6O1p5aUq9aegHnyxUH2a1+nVh+we/Uq4p/YX/AJatns5r4VYPs5H6lT8dDkfJUHV6GXHPQVWLT0Pz1LmndO6PVy0rVhz0d3w18Kt/tSd8dtixmTnt69lo09Pm6eWad9utfJst6/3pO+NB7ePV+Thsf0+nWcfv/Kr/AOrNfPQcAH4Uvt7r/l6uyXp9NxseHGr/AOrtfPQcAH4VcfaUJavXqDn7VB9TY+RKk9J9MlutOrT1dVf35/6qiRJiT1fe0cU44oulel39zp1497wr+/P/AFVAiygmuPO6OsnHTsvHrcLV2dWy+6f7N46quXs175Uq18IDHwq/46IHz0IobCCveNWk9w7Jin7q5SrYm/lSJa+OkdjzQOtEB8iSgj3KImGTFxvwWoM5HzMDb0OjzSpGn061q/LsuGPSsPT2qu299IxdGM46ueWa/vz/ANVDFnnNZeeVvq+FSPbjGr8vDYiNa89XV/Wn/bkf5av/AKmn6iUx9i38tQ/a8v4V/wCeXV+ThsRGta4057/H+C5z2fifQvEd1xps2hVTA8pVqjkzFTWmDJcrV3jum20bQqpgXdVrYJiIKEmCXitT4iSmdHJU4otDIuzCbso28x71Rosp2R0iSuMdkE2ONi42Ta8lTjTYXGBkAb3rfdRMzp5hvg3TSLy8adjg8wTK8sU36Ug/Vo1vQ7qlMXCWwZuDjHZbSoYGMBsCTBaOVWZp1llxHAUV199TQI4byCmVUeVW5s24LYmKouOVWZl1lt7eAo5PhmpgqUV4RTKqNWxsm4LYGOF48FpYsyE6ZxU1tl7tOLdZg7vdboF5rUaOEdkWx7qcamRJzrzTO8E6juGbIkYaS8NkmFJYkrIicdXaGt9dZCaNzuk7yqzgjc2YCd3CrlBddNt9hfrQpJN2NNHRkFfzLVsivsTJGtFx+bxq4wHHTB9hcOj/AFoZd3XqdFTP5qCDJbuTDhZLvMu7NXlh11htGwUl191D2U+FXGAbyg6yuHQoZd3xo6Kmfzd1JBlBcY7hZLvMu5KvTLrrDaNgpLr7qHsp8KnsunOiGIKqDzWp8dZERxsefdUF+c3umHIq6U4a6uEE3SB5lcOh/WumXXs9E635qgRHWVN148uH/Sp0J0nRkR1w6Pd40sy7KmhImF/NVvhmwhE4epwueyfCSUzp5EnZWgfu7KbtY+vHvVMhzndDriaj1dlPdSp7ZnAdARyWlOFW8CbhsiaYVE5VemXXYoi2Ckuvupvg2Pwq9ATcht1vmaaFqGwjEZtvy47JTO+YNvOM99Nu3WKO6WPvMciqBFf6Q5Kf4EXdU1nfXdARdK6OC+dLJu7XU6MhL+ZKhQXt+smSvX7k8KuELpQDpXDg8RWkl3ZtNCxdS/mqFDkb8pMkusvIfCrjBWRocbXDocq6ZdkTQsTK/mqBDdbM331y4X9KeZdW8MOIC6EHnV5ZcdiILYKS6+6muDQJ5VFZdG6SXFBdK8lq4wTdIH2Vw6H9a6ZdcaOicfzVboJs63Xiy4fP+C5z2fiff5D0qHLUy1GwX9KO9xtH1YkReGKtUZxtHHneBuLn7+X9su+PcZ/7+k57dD5PvDnPZ+J/kCMtIuUbH+X+QIACqqIomfpaA1atKavH7w5z2fifeM/wkVF5L/HVUT/LXOez8T6GUTnWoVTguasjhmD+olXr9+xDBeRJWoc4ymfCrlMOOTCNqPWPBUJiXIk2IYLyJPoaw/MmxSFOapWUzjOy4ySjxiMFTV51FfR1loiJNSilSYhOTGXEf06fdpVQea4pSFOapXOtYJ7ybdYfmTZeHy+oZA8ay6y1CjMx21QD1ZXjxzSEK8iSs5pSFOapWocZzwpFRaQhXkSUhCvJUpVROa0iovJdikKc1pFReS7T/ttxdBx7DYeC0CCICKckSlIU5kiVnNKqJzWtQ+KbdQ4zlNimCcyTahh+ZNiEK8l2IqKnBc1bXDKfORSVUQuFS5psy47YEOku1QkJclRaUkTmtIqLyXYqonNats8399vSHgWE7tikKc1Ss5+4uc9n4m0lQRVV5IlMtu3Rw3HDUWkXCIlOW1Yo7yK4WU91eS1//H/s3/nqQb06aUZs9LYdpa9CtAmWnTE/HNW4nVuzm97aAqL+1XmK0LzB8cuH1qiwI8YtbaLlUpxXZ8w2RNRab7WO+jsrSDll0xPuXNWqWbzRC5221wuy5yXd41FZXBn3+VJZGNPXccU/HNRXX4c3ojp6hLsLV9yhw9PPVwqLbyBwX3XiJz+my+RmyYV5e0nBKgW6MgMP4XXpzU/2tC+FX/1Qfnpm19JbE5LhqSpyTklH0m3Sdy2akLidXPdXoZohy464p+OatrrzMp2I4WrTxFauL7xPtxGVwpdpfKvQkfT9oevxzUB55mUcN0tWOytXaIyMqOv/AMp9ao8NqMBo3yWrdHeko6G8UG9eVx304Q2+CuOOnlUa3FLDfynC63JKnxHIcc90ak0XAhXuq2ezmvlq2RnJO9DWotIXHHetTLb0RvfxnDRR50wwdyDfPmSB7oJUlgrY42604St5wQrUuUjEQnfLhUe3LKbR6U4SqXFEqQy5bCB5pwlbzghWhJCFCTvpxsTbIS5ElRrfHcnyWVRdI8qnv9CiJo59kaatCOghyXTU18+VOi9a3gIXFJklwqL3Vd1RbcePKocA5DTLrzqoiImkU8tk71N/5Fq3wnJcYdbqi2OcInfVwkFEjAIdpeqNN2cDBCkOmRr50m9tstoN4pMuePdV5ecbaZES0oZdYqWzMK1qadPXjguagdJSOiSO0lWf7ab89SfV3vkWrH6l/wAlq1+0Z/zVcITCT2Ewv1i9aosJiLq3aL1qYbSfKkdIdVNK8ApIL8SS2UciJpe0irskR232lbPlVrt8eTvtaL1SwlT5HQoiaOfZGmbRvQQ5Lpqa+dOi9a3gIXFJklwqL3Ui5RF+4Oc9n4m18VOO6Kd4KlWNwejE37wlTzgNNGZLySrB9m/89QFRm5y2z4KS8NkJ0XL0+Q8tK1e+cP8AUpOVR4m8myWyeNtdXDHfS2hBRVWY7/OrUzGDeky6p5552TF3V4juF2VTGdkpd9dowhx0c6vX28H9TbePUHP2qD6kx8iVP9rQvhV/9TH56Z+yD4VcvX4Px2B7ec+Srgzm7BqNQQx4Eleh/wD8t7+dRIsUJvVkEbg881ePWoP6ldy1YPs3/wBSr0BHBLHcqLUB0HIjSj+Wrw6AQXBXmXBKtns9r5asP2Uj9Srh6k/8tWj1Bmr/AOpj+olXQCK1pjuwtRbcDzAGkt3injUm3RmkRHpjnHki02OhsBTkibIPtaZV9Rd0wfcJ8aZMXGxIV4KlX0hVlplO2R1dE02vHklQfU4/yJsn+pv/ACLVm9ntfvV+Dqxz7kLjQWlDFCSY7hfOjgRQfaA5ZqWcii8alrE0i1Ix1uVFbHWUUo0kk/2ryq2TCksKp9pFwtWkkGVNBeeqpZCEV4l/ItWP1L/ktWz2hP8Amq5+0YXx2HFgzSJxo8GnNRpXJcB9kTd3jZrjz22L/E/PV9FUaYPuE+NMmJtiQrwVKvxoTTTKdsj5U0io2CeCfcHOez8T6Em1anVeYd3Z99BbHzJFlSFcRPd7qt0I4guIRIuos8Km20JOD1aXE95KS3TS6rsxVDwSo9t3E1XhVNGnCJU+GktpB1YVFyi1EYmtEu+kaxxwqZbgkEjglocT3kpbbOc6r0zIeVMMNsNoAJwTZLiNSm9J/stejZ49UZvUqHAai5XOo15ktT4RyXI5CSJuyyu2RHF9g2y76jQZ0cwTpKK0nu1Jhm7NYfQkwHdVyhnLYRsSRMFnjQpgUTyqXCN6THdQkwGxIRpcilak0qOMVMhtSm9J805LXo+4omlJvUqHBbiiuOJLzKp0I5DscxJE3ZZXZboZxBcQiRdRZ4UqISKi8lorS80ZLFkaEXupbSZtuK69rcVOCrySojBMRQaVcqiVboZxAcQiRdRZ4VKaV2O42nDUlQ2SjxgaVcqlXKIcthAFUTrZ40gJukAuPDC0trfaJViyVBF7qZta71HZLquEnLw2x4ZtTX31JMH3U60DjZAaZRa9FSmspHlqI+C1GtiNub11xXHPOp8YpEYmhVEzUdvdMNgvujjZJDesOAi9pMVBjlGjA0SoqpTzQOtkBplFr0ZMZ6rEvAeC1FtyMub1w1cc8VqZDblt6S7uS16OuGNCzepUWMEZpGwqXbN67vmnN25XoyQ4i9IkqfDgndVviFFY0EqLx7qiQTYlSXVJMOLwqfA6UgEh6TDktQ2ZbWvfvIfhT1rNHSdjPbtV5p3U1bHN8Lsl7eKPJNpWuS26ZxpGhC5pW53jG7d63DjXouU1lI8tRHwWo1sRt3euuK455/cXOez8T/TznPZ+J/p5zns/E/jsyWHTMQPKjzp15pkdThYSmJDT4am1yn8Xftb3d601eH3d15pkdThYSmZTLrSuAXVTvpiQy8Opss/wW5TDrhAB5IedOvNMjqcJESo8hp8NTa5T745z2fifQC5RFAy14QVwuaausJwtKOcaflx46fWHio8+I+WAc4+Gx+4xGFwbnHwpu4RHGzIXOymVqPIafaRxvlQ3GIqOLrxoXC5pu6wTLSjmyCkFH5G4zqz1qucth2WyKqugF6/Cobsd1rLCYHPhin58WOuHHOPhTFwiPrpBzjscu0FstKuUw+y8Ops0VKuU8OlsIJkm7Pr1FnMSVJG88PLbe1PeRBQyHUWOFeiDRMjMdzVtlP752K+uSDktN+3nfkpSEUyS4Slu8BFxvKadadDUBIqUZiAqRLhEr0xA1Y3lFOji40GrifZozEBUiXCJSXeBnG8oSEkRUXKU/KYjp9YaJTV1hOFpRz+fDa4620OoyREpLxAzjeUBiY6hXKU682yOoyREobvA1Y3lCQkiKK5SimMA/uVXBYzXpeAhad5QOAYIQllKucth2WwKqugF69R3Yj0Y92P1fFF4Yq3JERkujZxq76SfG1uhq4t9rNMSmXwI21yg86G5Q1aVzXwzjjTFzhulpFzj51Imxo/2h48qjTosjg2fHw2w0g9KkbnOvPWq5y2HZbIrnQC9fhUR6O61lhMDnwxsjTGJGvdrxHnSqgoqrySo0pqQGpvOM0/Oix/tHOPhUe4w3lwLnHzpVwirUeU1IBSb5ZxTrostk4XJOdMvA60JhyX7k5z2fifQtERt5583EyglwSrnBYKKZCCCQplFSrVHB5jpDyayXgmfBKvEZtkG5DQ6SEu6pUlW7eTqc9P/AHVrgtbgXnB1GfHjVzgtdHN1pNBind3pVl9nh8V/7q2RQflySNMoJcqnwY5xnMNiioOUVPKrQ6TsINXdwq0etz/mq4AHpKH1U41JJI8Z0xREwlW0regb2Q6Culz1VcVtxta2XAR0eWmhNyRalIe2TdW123oyjToijnfqSosEWJDjrTnUL3auoD0yF1U4nQgA8hRNt9LS5DLwLNemh92O6q/CrdHeV92U8OlT5JTft535KvDqFJYjkelvmS0LtnEEHUziorrLF0QI55ac7k7lq4apNwai56icSoYcUQ07kcfCno3R7rHAV6mcinhV7BxY4YRVFC6yU0VrkM6BQE4fvUKOsRlQ3mpM5SojsV6S6/LcHn1RWpRWh5oh1tIvcqVZXydiqKrnQWM7JP8AbLqkcvswTKpSw4ihp3I4+FQITkQnE15bXknhWnp9zcE/s2u6jhRCDRuRq2kUea/EVcinEams7+8AC8lHjSw4iho3I4+FWfLUiXHz1RXhVwAPSUPqpxpwBFlzCInVWrF6oXzrTMUZF1lIfZQsqnjW5baaNAFBTFWWK24jrjiasFhEWrtCZ6KToAgkHHhVsjNmwj7yazPvWrswEY2JLSaV18cUnFE2Wv2jP+argAekofVTjSCI8kRNif2O8f7HqvD6hF0D2nF0pSJ0K3cPcD+tWqGDjfSHk1mfjVyt7JMG4AoJgmUVKhSCft2ouelUWrF6qfzrV09Qf+FWv1Bj5fuTnPZ+J9Cxf4r56m+pv/ItWb2e38Vq+eo/8kp9lX7ZoTnoTFWqc0rAsmukw4YWrpNbSObQLqMk7vCrL7Pb+K/91ZvtZnz1I9Xe+QqsnqSfMtWn1uf81XH2nCqY1vozrad41bBgG3unmxR0eeamejI6JhgDNfdSte4h6xZ5DnQlAVvntayAM9/ilW5d3cXWWTUmcVeFxKhEvLXQkC8iRaYksPKW7POnnsvX28H9Ta37ed+Sru0gymJBjqb5FQsWog1oDeKiHDcmKLMZMB79XDMW4sysdRUwtDKjqGtHRxT0lJF1jkPYRcIvjU2Z0UQUm8iS4Xyp6Pa3m951E4dpKszjjkU0NVVELAr5VCaisyHmJQJnV1VWpIWphtTVtvySrfo3GsWN3q7tkheh3ZHy7BpjNLIYQNe9HFQZpSic+rw2nIvGkPoN0dU+w730UqMAa1dHFW3VInPy8dXkNOe3Q+TZb/ak741cfacKn/sXPlWrF6oXzrVv9qzvjR/Zl8KsPq7v6i1dPUJHy1a/UGPlq/8Aqrfz0HYH4bLX7Rn/ADVcfacLbeWFKMLo9ptc0y56QnML7jQZX41La30Z1tO8atMwBZ3Di6TDxq4zmW45gJajNMIiVboxNQEAuaov9as74M72O6ukkPvq7y2kiG2hIpF4VbPUGPl+5Oc9n4n0I0RqNr0Z6y5WnGxcbIC95MUwwEdpGgzhKlRm5LehzOKEUEUFO6pFsiPlqIOPilN22K02YiPaTCr31Hjtx2kbDOEqPEajq4oZ668aMUMSFeSpio0ZuM3uwzimIjTBumGcnzp6I06826WdQctkm3RH11GHHxSmLbEYLUIcfFdjtohGWrRj4UxFYjjhoMVIjMyG9Lg5qLAjxdahq63jUeGxGU92na57JENp9WiPOQXKbUhNJKWRx1qmKIBMdJJlKKywc50r8M0yw0yOlsdKU402YKJjlFr0LB1Z0r8M0UCOptHjG77KJRtA4KiY5Ra9Cwc50r8M022DYoIphEqTEjyE+tDNN2iE2WrRn47XWm3QUXBRUr0LBRc6V+GabbBsUEUwlPsMvBpcFFShssFCzpX4ZoREBQRTCUsNpZKSOOvGxqI00868OdR86eiNOvNulnUHKiTKKnjUaM3GDQ3nGc8aaiNNPuujnUfOlTKVFitRhIW84Vc080DzRNlyKmWhYaFsOSVLiNSW0BzOEXPCk4JsZiNMuuuDnJ86ehtOPNulnUHLbNcBuI8Rflqyx93F1rzPjsk26JIXJhx8Upi1xGF1CHHz2SbfFkcXA63ilDaoYNmCD2k4r30y0LDQthyT7k5z2fif6EuEN2UAAhIg6slQigCgp3J95c57PxP9POc9n4n8VVwirUOYEoCIUVMLjaxMB2S6wgrkNkmQMZlXSTOKR5Fj75EXGjVioE1JTZFoUcLimJoOyHWUFchzX6bTzTqKrZoX3h95GWTcXkNMPo+yLiJhC2i+yTitoaak5psakMOkog4iqnPGwZLLjZG2WpB54qBNSWJLoUcLit8zvd1rTX+WlXCKtQpgSgIhFUwuNirhFWoM7paOdRR0r9EiQUVVXCV6YgIWN5QOA4KEJZTZIksxg1uLhKYfbfaRwOyv3Bzns/E2yDJtkzEcqKZqFK6THFzGPFKk3TcTAY0IqcMr4Zoy0NkfgmagSiks70hQePCnbr9YoR2VdVPCguyiaBJYJrPfRnpaI044HNW+WsljeKOONTH1jxjdRM4pl7fQ0cxjUGasXq7v6lTLk3GJAQdZ/lShur4cX4hgHjVuISucskXguy9eoOftUVdMBtfBqrbJ6QwpbtA63JKt/tSd8aeuJJJRhhvWXf5U48DLSm4uETnXpSSfWZhkQ+NQ7k3IJQUVBxPdXZNcebYVWmta+FWyRMbaNGo2tNfOjdEGtbnVRE416Wfc+wiEY+NRLm265ujBW3PBdrN6RWyUm+tqwIp30t2kt8XYZCHjTMht9tDBcotHdUakvNGHAU4L3rUKW5IQ1JpQ8M1Iugg5umW1cPvxQ3dxtUSTGJtF76EkIUVFyi1IuaNubpptXD8EpLs62qdJjECL30JCQoSLwWnbr9YrcdlXVTwpu7KJiElhWs99ZTGaO7ERqMZgncd/dTN2+sRuQyrSryzSqiJlVpbuZGqRo5OY76k3DexH2nG1bPTyWrX6gx8Nsj+z3lk+5xMVKd3UZ0/AatuuPMYUuTwVcHd1DeL/AG4/nVra3NvFe9U1Vb5e/ZcJGkHBLwSukS/Sin0f6zT2KZcecjmrrWgvCrbMRhgwEFM1NcClJd3GzRJEYm0XvrKKOUq2yukg4u7QMFjhTl2RuU60YcBTh4rRXWSHWOEaB41HktyGkcBeC7LqzIf3LQIuhS69JCii3o3I4+FWjqSJjKdgS4UqoiKq8kp3VP376/ZNiuhPFas3s9r9/uDnPZ+JtXimKtK7l2XHX3SylEz0mPOk9+vq/AalStVoEk5uIg0+ixbQqDzQP+6tLYNwm1ROJcVq5Mg7Cdz3JlKgOEdpXPcBJ/KrH6l/yWrx7Pe/aoPs1r9OrD6u7+otWkUdlSnz7WrhSoioqLyq1No3cZYJyTZevUHP2qP7ND9L/wCqsfqhfOtOyjjzJujmRYz4VboYR2tWdRlxUqvznqwcxUuKeNDdkAURIbuKffJ+bHdbjmCoXHY59mXwqxeru/qLV8VcRmu4z402AttiIphESr6CAjL49tDoVyAr5UvJasTIZfdXmhYSiFCFRVMotWfqSJjKdkS4U02J3x3KckzUklCM6adwLirG0PRd57xEuVqW0DsdwST3atLpej3f9mcVYwTcuO+8R0+y2+2oGnBakB0W3Oo3nAjwq3ThjR0RIrhKvMk76mzklRyb6I5nuWjddGyce1pxUG4DHjgKRXF8V8anzOlMaOiuIWeC1MddSzhntKgotW9kGorSD4VeGhchGSpxDlVq9QZ+G2+B9Q26nNs81c3d7GjNj+Mqfyq7M7piM6P4RJV1c3wRGR/EJFpRQWVT/bVi9Xd/UWv/ADy/JTn2ZfCrCA7t4+/Xiro2JwXs9yZq2qq29r5asP2b/wCpTQCV8dz3DmlRCRUXktWPqrKDuQ9s+aMZvhxcXspVsikw0pH9ofEquD6vvDDbLGftFp3cNQHWwIcI2tWYh6C0mePH7g5z2fifQuhLFlq6P4rSj+9Q46NwQbXvHj+9RkM5DUNeTTpEtPso8wba+8lRJpQE6PJAsDyKpU8pg7iKBLq5lUeKjUVGP9uFqJJW3E4xIFdOcotXGf0mMYsiuhO0S1B9mtfp1YfV3f1KPe22YbmhSZcpbyyaYZAzNeSYq0CYz5KH2u/ZevUHP2qP7ND9L/6qx+qF861GZB+fcGzTgtRn3Le/0Z9fq17BVc4pvsgbfbBcpTd6Y0IjwkJpzTFR5UqXKy2iiwnj37CTIrVtmtQkdafyK66uUVZUYVb7Q9YaZvTYAgyAITTnwpwnbo+2iAosgvFV79i8lq2vvRt67o1N6sFjup2+M6cMiRH4Yq1RTZbNx3tuLlaj+25HyUYIYEC8lTFRpB2wiZeBd3nIklSLoj4bqKBERcM4qDE6PERoua9r96YdO2OuNOiqtEuRJKfuyOBoiISmvfjlQMmcPdPHkiHitRZhQE6PJBcIvVKnrob+luGKqSr2sU7HV6GTRrlVHn51Fn9DDo8oCTTyWnLi7JMG4aLz4kqVLjLIiE0q8cc/Oolz6KG4lASKPDNT5hS45oyC7seJEtW893bAPHIM1AmJKaU9CjhcbJTO9jOh4jVr1yJTKFyYCpjW+iuh4jVr1SJTWr8BvFOdgvhVi9Xd/UWpR9FuyPGi6FDnTUhqQwZtrlKsPq7v6i1cfUX/AJatfs5r5asP2b/6lR/bcj5Nlm+1mfPsuM9IYJwyZcqiSYSHv5Lup1fLlUe4xXz0NllcZp2zw3HDMtWSXPOpNmhtx3TTVlB8as0JndNyeOvj9wc57PxPoGAF2hRfjs3YatWlM+OwgAu0KLQiA9kUT4bCES7QotbtvTp0Jp8KRERMInChAB7IonwpUzzpG2x7IInwpABFVUFMrzXYQiSYJEVKwmMY4UIAHZFE+FaAQlVBRFXvo22y7QIvx2E02vaAVX4VhE2m00fNsV+KbDbaLtAK/tSIick2LyWrD9lI/UrdNCuUAc/DZoDVq0pnx2KIkmFTNCDYdkUT4bFRF4KmaRtseyCJ8NhCJJ1hRaEAHsiibDEC7QotIIj2RRNhttl2hRfjWgNOnSmPCkEUTCIiJSCI8kxtQGwVdIImfDYLbYZ0gifDYIAPZFE+FEAl2hRaEAFMCKIlCAB2RRPhSoiphU4UgiKYRMJQgAdkUT4VoDVq0pnx2CADnSKJsNts+0CL8Uro8f8A+EP5UjTILkWxT4JsVEVMLQiIphERE+4Oc9n4n+RxYjUVCRvPWXP+duc9n4n+nnOez8T6FsmOyd9rx1Swn8d0922Zr7qZqJKGUyjqCqVcZTsZY+jHXPC/TkmTcd005iOat0g5EUHD5rn+AtWuY7JBxTx1Txw/hxzn9LeR0fqvdp+W63cWGExpJONXSU5FaAm8cSxSLwT+I/vNye7TrY4VAOUrH9oTr522+Y6+7IE8dQuH3pzns/E+hbnJWp9qOialPKkvdTy3aGm9JwXB70qO+LzIOD7yU5NlSJBMxMdXtHTg3eMO8VwXUTmlQ5QSWUcT90q3SHnJUwTPKCXCnMo2a+VWh516OROHldddOmdNkst9Zc4BO5KjdKaYcKSWVTj+1NOXOciuNui2GeFQ5UsZSxpKZXuLbc23ijFu3NKIi6vOrZHmnHA25OkNXZq+rpSIvgdaLtIFDFwWk7hqDOkdIWLJTr9y+NTpiRWs4yS8BSkZvLia9+If7ahznkf6NJTB9y+Oyf6m/wDItW8pzsUW2MAI8zWikXCA4HSFQ2y76NwBaVxV6qJmgduM7JMqjTfctLJnwTHpCoba+8lOPg2yrqr1UTNNu3Sdk2iRpvuqRJuERkxeXOU6rieNQHDcgtma5VR51Yfs3/1KkzXzkdGiompO0XhRNXhlNe+E8e7UGYMpnVyVOaUU6WM99pvJfkHuSoQzBEukEirnhsgSHumSWHTzjs/CrvJeaFsGVVDLK/slQH9/EbcVeOONQnnn5snrrug4IlQpDx3CWBHkR5JUz21E+Wr/AOrtfPQdkfhs9ISRmyWhya6sAPhRMXnt78c/lq3T1k6m3Bw4PNKnTX2Lg2IKqjp7HitQhn6yOQqYVOCJT82Q7IWPETinaLwogvDCbzfC55VDlpLjqScC5L5LVrkvEb7DxZMCq4P9HiOH73JKZWQNsIzNde7Vc1aXXHoYm4WVyvGnZsqRIJmJwQeZ1/esXrmYuinaTvqxlrclkneVTJr2/SNGTLnevhSsXltNaPiX+2oE3pba5TBj2k2T33402OWtd0XBU2Q33pM59df1IcESpU59ZHRoqZPvXwomby0mvfCf+2rfNSW2q4wadpKZkPLd3mlPqIPLZa33nXJSGedJcP4rnPZ+J9CxJ6189TE/sj/yLVoz6M4f7qsONy946+NLjC5qxf4nHZ18KtPrs/5qe4MOfKtWH1QvnWoCf3rN+NEiKKovJaSFOiKvRXEIM9laiz1N/cvs6Hdsv1R/5FqyeoB8Vq+c4f6lJySpftuL8tXjedNiaceWfGv78/8AVXRLg5LYde3fU8Nk/wBTf+RasuEt7fxWr2n9hX5kqbn0P/wGofpbozW63WjTwqSxd32lbc3WFqeDjdoAF5ppzULR0RnTy0JV209Aez5Yq2ezmvlqw/ZSP1KidN6XL3GjVq62qv78/wDVVrivsE+rmnreFQ0T0zK+G2X9RdIz3cfVWgTpN1dVey0Gn+dQXejNTml/CVVSrQ1oiIS8zXVUD2pO+NTPbUT5av3q7Xz0HZH4bIOn0vLzz442N+3XNP5eNSEzfI3y7LFzlZ7WvZZ/W5unsaqlp0W6Mv8AuucCq4r0mbGjJy7RVLTEN79NatGfRnD/AHVYdO5e8dfGl5VY8byXjlqpvpnpKXuNOrPveFf35/6qt0WSy++46o9fw2XWPv4Zp3jxSgn/AN0bzPWRNP71bGNxEDPaLitWj1ybntatlu9pzdPKmfbr/wAmyzfaTPn/AIrnPZ+J9CzsutdI1go5PhUoVKM8icVUFq0tuNQhAxVFyvCnIcuI+b0XrCXMKNy6yh3e43SLzWocUYrKNp+61JiSmJSyYqZ1doaIrnLBW1Z3Q44r31Z2nGYyiYqK6u+oTLoXGWZAqCS8FpwNbZCvelN+k4WQRrfD3LUePKemJKkDo0p1RpXX3LpugNUAB62x4N40YfmFUqItwhojHRtQ6u1V2Zdd6JoBVwfGkqUw6t2jOIC6EHitXCF0ppMLgx4itJKuzSaCi61/NUSJJV9ZMlet3D4bJgqUV4RTiorirU2bcJsTFUXjwq7NOOQ1EBVVz3U2zqiC2acwwtAFxgZBsN633UTVwnEO9HdNovKnGG3I6tL2VTFNjc4GWxb3rfdUlm4S2TJ0NKInVbTvWreBhBbEhwunlVnZdabeRwFHJ99SoUhuR0mLzXtD40cm7PCrYxtGfeqDF6MzpUskvNaisujdJLhAqCqcF23Vg3Y2QTJgSElWplxtkzdHBmWVq5RJCy1VoF0uiiHQCggIp3JUJl0LjLMgVBJeC1KYdK7RnEBdCJxWr0y66y2jYKS6+6h7KfDYDDjtxlq0WDAspRSrv2Eipn81W6CTGtx1cunzp5h1buw4gLpQeex+FJYkFIie92gon7vITdpH3f8AuqDEGKzp5qvNaucZX4hIKdZOKVa2H966++Koa8EzUkVKM8icVUFq0tm1CETFUXK8Fp2HLiSCeicRLmFa7pKTQrW5H3lq0R3I5ydQKiZ6uamwn0fSVGXr+8njSy7s4mgYmlfzVAiLGbXUWoy5rtSMXpFYqL9XvNapslQpASOlRe0vaHxopN3dTQMbQv5qgQkitrlcmXaWp8J/pAyo3bTmnjW/ur6bvcI3nmdWaM6wUhDFU48FX+K5z2fifcWIqMm8erKmWVX/ACW3+1Z3x+5uGjYEa8kTNWcFNXpR8zLh90c57PxP82QARVVBRFXv+5qiKmFThSCIphERPujnPZ+J/p5zns/E2qqJzpFReVahzjKbHERxlxEPmmM+FW+OsdhUJ3Xx501PNbi6ypDu0ThTxf2d5RX3FqzmpQsmfvLzpCFeS/QQwXkSVqHOMpmtQ54rWoU5kn0FIU5qlahxnPCsotIQryWuVIqLypSFOapSKi1qROa0pCnNUpFReVTmFejKCOaPOo7atsNhr1YTnWUTmtIqLyWpDSuMOBr05TnUBhWI6CrmvzpcUhCvIk2IQryXYiovJc0pInNaRUXku1SROa06qdHdVF9xaspkUTJEq9ZazSEK8lRaQhVeaVLnGzLjtgQ6S7VCQlyVFrOKQhXkSfQnzjZkRgAhwRdahIV5Ei1DiE1JfNX9WrurKZxnjWsM41JsQgVe0m1DBeRJ9HWHLUlahThlKVUTmuK1CnNUpMLy2agTmSVeXCGHkCx1k4pUdfqGvl/guc9n4m19resOB+YasrmYqtrzAsVPNw5jkgeywQpUl9AhOO/7OFQmd3aj8SAiWrOKHb1FeSqSU1Ajlc3mFRdCDwpY7ceE62HLQVWyIcpjBuKjSLwRO+pkEoAo/HcLgvFFph1HWW3PzDnZIN6dNKM2elsO0tLZWgTLTpifjmrcrq3Zze9vQqL+1XlT6XE0drur0K0aZcdcU/HNW5x5iW7DcLVjiK7Jkjo0c3P5VGtxSw38pwutySp8RyHHPdOKTRcCFe6rd7Nb+WrF9g7+pU/1J/5ata4tzXwWoUcLgrpyHSzq7OaZiSYkxEbVSYXnnuq/rpSKvga0FrWQO8lOEpL3JySnQetTwGDikyS4VFq8Lm3mvwqO6jVubNfdaRajRTuCK/IcLSq9UUp+3PRNLsMiXjxCpRKVvdVUwqt8qtC4tzf702Lt0dcIjUWRXCIlPWjcgrkZ00MfPnVtmdJj5LtJwWrP9tN+epPq73yLVj9S/wCS0y2k+VI6Q6qaV4BSQX4kptY5ETa9pFXY84jTRmvupmo0V245ffcJAz1RSpEA4bRuR3Cxp6wL4VY/Uv8AktJvrpJc66iyC93fRWhGU1xnTE08+dWQiKRMJU4rirhCYSewmF+sXrVGhR4mtW88edNi5c3nCI1FkVwiJ309aUZBXIzpiQ8efOrfLWTGE17XJdt0hsjMY4L9afWqLBYiqStIvHnVr9oz/mq47z0syjS4JRxmisjKjneua/zZqKUx4ihK4qaFXUXfin7MANkbLhoacedWuUUiKin2hXC0u9uMtxtDUWW+eO+nLM2I6mHTE+7jVrlnIYVD7YLhdtykPK83EZXBHzWhsbGOLrmvxzRo+FyitOrq09kvFKv3qX/NKYtnSWQckuHlU4InJK0uW2a0CGqtOdy1cpaxo+oe0XBKYtCOghyXTU1486ukd6KzoQ1Jkl7+5ajertfKn8Fzns/E+gJ9DuEtO4g1pUOLvLY7ntO5KleV63xY/vE5pX9qeFBiOp4Nr/1Vj9S/5LUf23I+SpPqz3yLVi9S/wCS1ePZ737VbvUY/wAibICozc5YHzJeGyG6Lt6fIeWlauXtGF8dn/nl/T2XltSgljuVFqA6DkRpR/LV4dEITiLzLglW3jbmvlqxKmh8F5o5V0MQgvZ70xVqJBtzSr3JXQYcvLrDqiXiNNvSokxth1zeCfJe+r8ulIq+BrTRg42JjxRUq+mO5bZTtkfKrmmm148ESlFTs2lP/hSrO4JwW0TmPBafkNRw1uLhKlEhwHiTkrdWwdVpQU70KrEablxr3hPilOmLTZGS8ESrEKoy6fcR8KtJIMqaC89VTCEIryr+RasnqP8AyWiiwZpEbZ4NOajSuS7e+yBu7xs1x57J4KcJ9E/LVneEoQCnMeCpU90G4ryl+VUqyeoKnmtWMkBZDJcD15oiEBUlXglWU0OVMJO/FXL2hB+NGmQJPFKt0NHt6KvmBCXZSnLWAApnMdRPjVraYaYXdGpCq5ytIQryXOy7euQfn2Wz2hP+an/bkf5dkD2rNouwXwqw/YPfqVEh7yTJaJ4wJC7u+itCCKksx3CedWpmOAuEy6poq8VpCFeSpskFub00Z8iHZNdA7xGQfd4LV99R/wCaUx9g38qVeft4H6lXxF3LB9wnxplwDaAxXgqVfnQ6MDfepZqN6u18qfwXOez8T6FztxylAgNBVOC/CmwQAEE7kxTNrVqar2pNGVUR+NPDraMfEVSoEUorG7IkXj3VLtrhyOkMPaDxxptp/opNuuIRqi9arfEKKxuyVF41OjrIjG0KoirUZpWY7barxEcbJ1ubkqh6tDicipLbNLquzFUPBKj23o80nhVNGnCJUuEb0qO6hIiBs6EfpJZOpNOnGNhIhIqKnBaK0vNGqxZKgi91LaTNtxXXtbipwVeSVDZViM20q5VEqRa1V5Xo7u7JedFan3QLfyNZY6vglRI6sRgaLC4orU62ZFFkaM91RraQPb993eH3VfOPQ/1KK2PhxiyVBF92o1r0O759zeHU+MUmMTYqiKtR2t0w2C9w4py1GDhORX1bzzTuobW4Zicp/eY5J3U+1vI7jacMjhKgxyjRgaJUXFSbXrd3zLm7OvRUl1U6TKUh8EptsGwQBTCJUu2b13ftObtyvRkhxF6RJ18OCd1W6IUVjdkqLx7qdtZo6TsZ5W1Xn4U1bHN8Lsl7eKPJNrtpJHVcjPbtV5pQ2t0srIf3i46qd1W+IUVjQSovGplsF1zetnu3PGhtsk8dJlKY/lSoMAor8g8pg+SJ3VPgdK0Eh6THktQ2ZjWvfvIfhUq2Ibu+ZcVtz/uvRct7CSZSkPglSVCLBc08EEMJVrj7mIOe0XFdk+CkoQwWkgXgtQmJjSlv30NO6okI2JUl1SRd4vCnYZlcW5OpMCnLZHhGzMkPKSYPlS8lq3QziNuCRIuSzwqZbhePegag4nvJS2ya71XpmQ8ErQ3DilpTCANWZjSwrpdpxc7JkNqW3pPu5LSW2ePV6auj+teidD8cwJMB2s81q4xClR92JIi6s8abHSAj4JU+EclyOQkibssrTjQONqBplFr0VKZXEeWoj4U7ZyNgsu6nVXtFTY6GgHwT+C5z2fiff7sw64sXQClg+P311pt0dJjlPD+K42BgommUXupEQURE5fdHOez8T/TznPZ+J/FVURFVeSU0424OoCRU/gOOttDqMsJUeUxIFVbLOFx93VUTjTEll8VVss4X+CxJYe1bs845/wAZ10GgUzXCJTbgGCGC5RfoMSWH9W7NFxz2x5DD6Fuzzjn9wc57PxPoJcYio4uvCAuFzTV1hGWlHONPzI8dMuGiVHuER9cA5x8Nj9wisLg3OPhUe4RH1wDnHw2P3CJHXBucfCjmxpEV/dnld2XCrJ6gnxWnpceP9oaJTN1hOFpRzj58NrjgNjqIkRPGvTEDON5+9C4DgagJFSrxLZceZayuAPr1Beiugu4TCJ5Y2OvNNDqMkRKG8QFXG8oSEkyK5SnX2WR1OGiJQXeAq43lIqKmUWunRxfNlSwQplaS7wNWne0clgG94Rpp8abusJwtKOcfPYlxiKji68IC4XNNXWCZaUc4+dPzI8dMuGiVHuER9cA5x8KM0ACJeSJlajSGpDetvlT77bDauHySheAmUcTs6c0lzhq1vN5gc4pm5Q3i0i5x86PCiWeWONW1Ie7Po2cauOaekMsJlw0Sm7tBMsbz+ex+ZHj/AGhonlUe5Q310g5xqPLZf17tV6q8aduTXpJtxDPdonGo0piUBK3nHJeFW1IX13R88+tTrzTI6nDREoLvAUsbykJCTKLlKWawL6squCRM16Yg6tO8oDExQhXKbLxKFuOTeVQyThirfc46tMMqRa8Y5UZg2OSXCV6YgIWN5TbjbgoQEipsnIx0U9/2O+oqM9Gb3XY08KC5Q1bI9fBFxxpq6QnS0o5x89luSD9csfPa61O3Jr0m24hnu0TilR5TEps1DOOS8KtnQtLvR89rjmnn2WBy4aJTV1hOFpRzj50Etg3yZFesPOrtNHesgJkigfWqLPjyV0BnKJ4U/JZYHLholN3aCZad5/P+C5z2fifQtkUH5UkjTKCXLzq4wY5xXFQERRTKKlWhgXmd+91y5JnwSrxFabaGQ0mkhLuqRKILdvu/Qn9atkJrcC84Osz48aukBrcK80Ogw48KSaXorf8Avaf61aoLZMo+6msz48auUFpWDcbTQYp3VZl02/PmVQnIjrzr8twdWrqotSytLzJIhtIWOCpVnkE7E6y5UVxslJ0y5pGVfqwTK10OJo07kcfCoqLDuZRkX6s0ylXcR6TC6qcXOP8AOhER7Iomwh6bdCA/s2k5UcKKYaNyOPhUCI7EQwVzUOer5Uy30+4PE5xBvgiU7BiGCgrQ/slWgzbekRSXKAvCnGBfvZgXZxlacgxTaUN0PKrVG3zpi71gZXqpVwgxziuKgIiimUx5VaXicgtqXPl/KrZFB+XJI0ygly86uMGOcVxUbRFFMoqVaGBeZ373XLkmfBKvEVptoX2h0mJd1OGp28y8WV/6qyeoD8Vq8+oOftUb2aH6P/1VliNGBuuJq62ESrvCZ6MToAgkHHhUZxXYIGvPRVh9Xd/UWojaTpr7rvEQXApUiDFebUN2KeColRW3YkZRcPVp5fCrZHGWbkp/rdbglSbew62ukEEk7KpwqwZxIz+anwD02wmlMaeVIIj2URKsf+K+egDp9yd3n2bXIaODFMNKsj/KrURsyn4irlB4jUlhH73oXlpTP8qOFEVvRuR/lVmIgclR88ALhsvAj0B1cJnhVuBvocddCZ0JU3Mq5BFz1BTJV0OIgadyOPhTCLBum4Rfq3E4JsvHs979qt/s9n9OrNFbdV0zTOC4JVzgsFFMxBBIUymKtrquQmiLnj/qrH/if1KfbD00wOlMaa0CIrpREqwfZv8A6lMt9PuLxO8Qb5JTkGK4Cjuh/arWBN3N8CXOE51exHXE4Jxc40LbY8hRKadjPznnZTiaRXACtPnZ3W1HW0nmlWN8jZcbVc6F4L5fwHOez8T6Fm+1mfPUz1WR+mtWT1AfitXr1E/ilOMK/akBOe7TFWqa0scWjXSYcMLV0mtowTILqM+GEpIReidx72n+tWma3uEYNdJhw41cprYxzbBdRknJKsyZt2PFVqA3FbddYlAOrV1VWpQ2qO2pK0Cr3JUDT0dCFnd6uONkleh3VHy+zNMZrpUZA1b0cVFVZl0KQifVgmEWrx61B/U2qXQrsZH2He+ikxwDUrg4qBMOWhlu9I54L40waQbi+DvAXOIrTkuO0CmTg1aRNx6RKVMIa9Wm/bzvybLP9tM+epnqr/6ZVY/UR+K1ZvtZnz1M9VkfprVk9QH4rV59QP4pTY67cgJ3tY/pVmkNg0TBlpISXnV5lNdGVoSyS1G9mB+j/wDVWL1QvnWrn6g/8KgezW/kqw+ru/qLUM0hTn2XeCGuRWn5jDDSnrSorxy4pEYaELKJVqkDFN2K91V1cKkTWGW1XWil3IlWDOJGfzVKJAvUci5aaRUXktWL/FfPTRpAub284A7yWjlxmw1K4OKtQk9KkS1TArwGv/PL8my1+0J/zbLumbe9+1WxxtYTCakzpqZ/ZLoElU6hJhVrpcfRr3o4plenXXfCn1bacF2Xj2e9+1W/2ez+nVi+yf8A1KnJ/Y3/AJFqz+oNfvVj/wAT+pUokC9x1LgmmsiorhasH2b/AOpTDnQLi+DvAHOS05Mjtgpq4OKtZq5c5BkmMpV8/wAIXcjlAYEKYJOVMNRmJzzUoEwS5BVp5u1Mtqatt1bFbJpTBjdov9f4DnPZ+J9CNDajq4oZ665WnAQ2yFeSpio8duO0jYZxUmO3IaVs84oAQAEU5IlSLbDfXUQcfFKYt0SOuQDj4rsk22I+uow63lTVtiNCYiHaTGe+o0duM1u284qTDjyPtAyvjTVohNrq0Z+O11pp0NJiipXoWDnOlfhmm2gaHSAoiVIhsvk0R5yC5Ta+wy8OlwEVKSywUXOlfhmhERFBFMJT8Zh8MOBmgssESzpVfjSIgphEwldEZSUUhM61TGxiI1HJxQz11ytGCG2Qr7yYqNHbjNbsM4qPEajq4oZ668acBDbIV5KmKjx247SNhnFSY7b7StnyoAQAEU5IlSbbEfXUYcfFK9FQ0ZJtA7XNe+hZAGUaTkg4qNGbjAoN5xnNPMg80TZ8iplgG2UaTsomKjRWowkLecKueNSIrEgcOBmgs8ECzoVfjSJjlUmDGkfaBx8aYtkRgtQhlfFajRGo2vd56y5WpUKPJRN4PKosNqKJC3nCr31FhtRtejPWXK5p+Oy8GlwEWks0ESzpVf3pBEURBTCeFLEa6V0jjrxjYzEaZddcDOT57CFCFRVOC0FpiNuo4OpFRfGjaB0dJiipXoWDqzpX4U2020OkBwmx9gH2SbPktNNC00LackTFRYjUZCRvPFc8adbFxsgLvSmGQjNI0HJKjRGo2vd56y5WpUKPJRN4PKo0NqKBCGeK99RojUVCRvPFc8akRmHww4Gaas8Js9WjPxoIbLcg3kzqLnT8dp9vQ4OUqNb48U1JvVxqRGYkDhwM0FmgiWdKr8aREROH8Bzns/E/085z2fif6ec57PxPoNvsmZCJopDzTwp5xGWTcX3UqO+j7Iupwz/HkvjHZJ1UyiUy+LjAuonBRzUOY3KAiEVTC42OPNNIiuGgps6YHTOjaV1Yzn+M7OBuU3H0rk+/6BEICqquETnTbrbooQFlPGpUwIxsiQqutcJtmzkiK31FLUtd305E0I7rIKKrrXCfSMwbBSJcIlA4BihAuUX765z2fibXiMWiIB1KnJKhyJYSpRBH1Eq9ZPCpJmdsdUw0lo4pUOercRppponDROOO6mbt9cjT7KtqvKlVETNFdSI1SNHJzHfTF1+sRp9pWiXlna7dS3pNx2FcUedRbnrd3LzStn51cJiw2gJAQslijuhalSOwTuOa91R7shOo080rZedKqIiqvKiupmSpGjk5jvqPdEJxGn2laJeWau/s979qhezWv06sPq7v6i7L46/wBWuohJgqhyZhmguxtA6edPvgxeTcPkjdFdZQ9boR6PGostqS1rCpFzSPL3JCmnTnNQppyCP6lQFOSr31KuTbB7sRU3PBK9LSG+L8QhHxpp4HW0MFyi1EnE/JkM6ETdrzolwirVvmrKbMlDTgsVMuTcYkBB1n+VKG6vhxfiEAeNRLhv5LzSCmkeReNXFwW7tGMuSBRXST2ghHo8ahTW5beQ4L3psurjwR1QGtSKi6l8KtkmYLDQBG1BntVe1w7BVfz0t0fXixEMw/NUG4NysjjSacxWrjK6P0f6tC1Hjj3U8+DLSuGvBEr0rKJNYQiUPGok1uW3qHhjmmx99uO2pmvCvSko+s3CJQ8ahXBqTkcaTTmK1eCQZUIl5IVFdJC8WYZkH5qhT25aKiJgk5pUmS1Gb1uLQ3WUXWCESh40d5TUwgB2y0ki80q8OPDGIRayKp1i8KtsmYjTAdG+r/AD/fXOez8T6Fr9oz/mq4+ov/AC1Z2xCCCpzXjV+BOigfvIdXF0kteU70SodwGPHABiOcufjVwl9La0pFcQkXgtRiJY7Slz0pnY10m2uu/UqbZLnKU0/AmvAv4g8s8Fq/+qt/PUVkGmAEU7qvbQLF3nvAvBanPn6HAu80HNRbiLDAAMR3glXGX0tsUGK4houUWrgqraSVeelKhezWv06sPq7v6i7L96u189D2R+FG2J37j3Ci/wBK51aE0y5zadlCqQ0Ll7bReWnNLwFasgoZSHy4nrxRAJgokmUWrIqiUpruEuFWz2jP+aj7BfCrD6u9+otWkUdlSnz7WrhSoioqKlWptG7jLBOSVPBDvEUV5Y2QkRu7yQHljOyd6m/8i1Z/Z7X71fBQnYSL3nQogiiJRijd9b0+8PGr3zhfqVPjFJiK2PPupm4uRgFuSwQ6eGU5VCGGut2P73PZdevMhsr2c5pEREwlLCY6Tv0TB1eR1yYQr3lSJhMJSCjd96vvBxq4JvbpFZLs86ThV1aAZ8Qx940z/Orn7Pf+FWv1Bj5fvrnPZ+J9Bp8INwl75FRDXgtS3QetrxhyUKtPqDNXz1H/AJpTjHSIG68QqLceiAjEoCFQ4ItHcXpTgNw0XzNUpOWxu5ux3HG5iLz4EiU44E2dHKMCppXJFjFX9P7M389M3Lowo1KEkVE7XctSZB3MgYYBd3nrFUmIjsNWE7k4VFufRgRmUJCQcM450VwflOgERFQfeNUq7eznf2qF7Na/Tqw/YO/qbL62ZRRUUzpKolxjSNLYqurHKv8Azy/JstftCf8ANR+3A+TYKuWuS5kFVk15p3U9emyDTHEiNeXCrXFOOyqn2zXK06p2+4OPaVVpzninbsDzahHEiNU8OVWD1d39Sj3ttmm5oUmXKW8skmGAIjXkmKtKGM+Uh9rvqZ7aifLsje25HybJYqcZ4U5qK1a7gwywEdzKHqxyq8/bwP1Nj/txj5KvXOF+pU1ZKRtTHbSgvMZWsPCSF3pirOB7yS9o0tmvVTZdYzjiNPNJ1215UF7jaPrEIS8MVDelypKucQYTknjV29cg/PsP26HyVdYzupqSymSboL5H09cSQvDFS3HnpcV4x0ippoT96ntq5CfFOemrZcY4sssFlD5U7ORuYEfQvHv++Oc9n4n0DbbLtCi/GtAadOlMeFIiCmETFGAEmCFF+OwhA+0KL8aQRHkKJtIBLtCi0ICPIUSr/wCrtfPWgSAdSIvCkER5IibDAC7QotIIjyREpREkwSZSkRETCJwoQAOyKJ8NqNNCuRAUXxxWgNWrSmfHYgAKqqCiKvOlANWrSmfHYqIvOkbbFeqCJ+2xUReaUjbY9kEShAB7Ionwpy4bqYrD4IgL2SpXYbIqeQT4VaEJyRKlY6prwpQBS1KKZ8dmgELVpTPjtVplVzuxz44owAsZFFxy2aAUtWlM+NEAFjUKLsJppeKtjn4fQJppVyrY5+GwgAlTIouOWzQGrVpTPjsVprOdA58cUQAWMii45bNyznO7HPjitI51YTP3xzns/E/jy4jUkEFzPBc8K7vuz8Zl8dLgItDZIKFnSv8AOhEQFEFMIn+bOc9n4n+nnOez8T/TznPZ+J/p5zns/E/0MRiCcVoSEkyi7DNAHK0JoY5Tl9BXxR3d9/0JM1iLjeZ4+VOyWmmN8XZr0vE/3/8A6rTbouAJjyWn3247auHyr0vE/wB//wCq10llGRdUsCvetekoP/8AYCmjBwEMCynj9Bzns9//AENK67oNJUIsKQL3VIkbvAinFadcf3ao4POgJQh6koXpJjlEoZTpppEeNMyD3mhxONGa9LQcJTz7gP6RpZD7ZJvE4Lsu3s9/4J/3U/2QvyjSXEUFFSM4oY7eKVwnIquRsKqp1auKn6Oy5jV1c16SFERejOKH58UitPtIvAhWp4stMLpZDWfVHh41HaRlgATuT6B89hcCT/Qwb5x0jBK+sbkIRpzqT1ZAud1SZDZN4Gv8CvwqJ9glQu25Tnro0568n/8A3dR+vJVw7IfGg7KVdfZ0j4J/3RkgwEUm9aIKZGhlxej69Y6ccqtq7mBrPqjlV/apLrfRd5o3gc/2pZcXo+rWOnTVrEghBnvyv7Un9puP+xhP/wDZfo8yXYScKReH+hFTKYoQBvspijabLtDmiAVTCpW4ZRMaK3QadOOr4UIiKYRKFsBVdKYzW7bUteOPjStgp6tPHxpWwU9WOPjRNAadZM7HGwcBQMcovNKQURMd1dAh6tW4HNE2BgoEOR8KQREUFE4eFdBh6tW4HOxtltrVoHGVyv0Fodq9Vf8ATnNfo4UeVIX+mNSVhV+nhK0edaS8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaT8a0n41pPxrSfjWk/GtJ+NaS8a0edYT6H//xAArEAEAAgEDAwMFAAMBAQEAAAABABEhMUFREGFxgaHwIDBAkbFQYMHR4fH/2gAIAQEAAT8h/wBhNsuX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OX5y/OLJp0g0iCP0bv9cR3Fbru/12zSGem7rlOGaatR+I5agIMdMQOygV3RGNUP2NZojyEwvymO33TGYX9Jc46t79qpTFrKOrx6/V4qx5mNiv1fj+4wX2yDtx9IWFcUFzJcFeTyfYcyizpu+j5HefBcQ/p/yY5gq6iVFrpN4Ql7ciDdZqdpeTDdDJ0lKO6ZRr572mLZidoRejT+pT4/oyzzugoQVOeMTgE9ZbY4Zu9M0zmH2Yj++VGOeucPRnr4T08B51lHbmnomSwBdUrxBLHrM7lkG5wDbowI1huFQyt9bUd4L6GKH5OY4lIL4JfZerbxdyRvuzLBKi2GUDURttAtpjUvRwxGdKW4j3tqbxzB7riSHYsqe8Py8HkTTqYfWxV9Efw/uGvurgUlPkXoxs9isB3IaPFDFrYm00wrDr22cw+zEf3youe9Pc2QbPsBHYNwjNTM7vpCSQN0zYx/slSj6sYXo1krLz3nKSknG6Kbol2l5RTUKWxib558warX/WC1mR31rOzVqYMo7pl6btaEs+Sh9eK6bvo+R3gH42J7X/IQZxmG8x95q+VqaRpRD+rT4XaBD43PAoDn5RdoGy0y3lZ0x0cdKncfnac7Mf8Ak1QT6ZXoWfCdIqt+c9GNHRf10/r/ALK9CynzNQkX4z1He30WSuLSunDvKp87Gjyb8zsD/nLYu3K/sv1LFhVZuEqkpxo9p7x/ICzj/wAdMGaE+b30X07Ot+8dMLyIxj6aoOZv1Lnsf8gLII28p8bv0r0JPhOkAB+M9P2d6eTGv3P+KBVEqefYgP8A5HX7W9uve5fZjNX9YMDDD/8AaKD6F4J8ftPaf5FXiwm7b/joAZ839f8APpu+huj4DzE6iA7MqUA14Swaprcsx/ZtmLbTrxMP1eFsFIomZzMQCqpuuHQTZeZW/fEGq8/kh7RcWo7wGMOLQ66pimHHQg9IBnYcIjqD9U3wQcSiVo95xad3HmOemuYXRWCoG8TQd2OusNJ+oI1QH6pvgk4jS/bpr1LSzr1SFbB8td4Updyfe9DzGwvMvGYN26zeSsvtrq7E2iQQVDUk2OW7tG7usnlgWlaXxDn8Ha6dH0O628x2CQeysbUZwK/MqXppdGU8Q28THR92rerEE0gdoErK9iJSVAI9w8l56fwkhEdQfqm+CDiLv9mmvStL9rKdbuHa8TSRagfyjlLsD3sQS2l5YIstKvHTrmky+RKXqvYJW0Tck5qG/MWWlTjpNHL96OPyPjKFqU46dM8EFo5+vR8dN34agKwuvv8ABfjdyGn3sFnodo6ZI9LFU/xDR8dN34aCIw2k8CvwXEssKXX4CFHcU/xOj46bv8zZdX+HZdXn8LR8dN30arvDcUC1xLQCck0P8oNYPibTkZLmjiV6ZtdmMd5iJqlH6GuNj6xqHTL0L6L+L6XGKEfM9jl56IUh89B8B5mgr4eoiwm15lisnF9VqLuL6avDP7mZ8Y3ALUJr68PWqtIsvTG4UqNY0yx7Qj56IGWpr48MQRSa06Sq9It/RG+ldRnc1knsUNxCLETglisnF9MDI3aSwjFIfP0LaEeL6bD7N4OoBSIFoJrO8MqJsNunRCizi+gqFDa8wa6HpiVG7t0Q0WcX+Bo+Om7q6M906Uf7/wC4OI1BSiOupY0ggGulDnHNfDHTiaG7hMnsz4vdjIKwzPU31pnFWOREjtKzB3ac0XvwnOBcsvyjxEQmYd8H0rPolLBofWCUwdbLEhxxmrv02vp9TDSY5ZhbplEv3mNy0rqxrsNzRMLfXkgbodXfMoIj1HiX9xpVww781hqeD3zOhp5I3zAABvtjtVd6nOCEL3Xa6nJ49GHBKIapBg2IOCrA72w08kb5glBvt6EU3u+5ArE02y9o6XWnEIzBYtTAR3duZ8TxBWhZYuVbMpJKY16+jMtK6sYOxpP7bVfJPENgtTMFlL9sqw8bk3TrmHbCeoKx1puUw9tjSy9Vl5Je0U+EhmkrXo+L2YrGuDYl5rFu2IkVgXn7+j46burpLRUL1HdqwesuPf8AuKMFpdZmhIi9EznCOWo6+oHTWlZDmX9WAABQbT4vdh5NZquUr/o9FuxY8V3/AH0TS7C/FEXrVbfRHfjtkKIAtMd3IKWw0CPht1xrSEmLvPT4njrbPVavvmKAq4j2vMuZ8zzNRgB6kbSwIqCmgysBRmBFdPneenze7B8baGnzPD8JqGGAtZoDNH7Z87z1+f3IadY0y+J4g5N+30RYELc2JddHMd+gOqvX3igK6R7TmXMfbfwlR6rI8tusA8Fayk+AYTDJ3WUSFYH27Dj5njr8/sxsOXF57QtEb1cIDEMQ5Pv6Pjpu+hg5vQy9u7Ta8xDorJ3YsJwgudB2JprVuOaYit+g4wt3dRLVoNo3q0dqRv8A+jNSk3dNVModOTPdx1VHpXH3we1pKB2d0DLDNo6Oi6MInZYNIaCgMHTH803dMBilbRhOjghvPA1hmtud16T4g23eRtLRD1rRjbMnzSo4qDpfsxM1uaw2h3K0G0YfcP3H6Crd0vJ4G8ZAt4L8xIXx2iWbhTrGvt26FEE6E8YG0aZLG46C6S1R946boub0pC73GNYAdVjoKHGkN54GsM1tzusbX7IadLcN1N5YGF00fMXDLRslBubA2vAzMUbd3XvHWtU3dRWNF3RSnLPUlnG3TNTR+b8v39Hx03f69o+Om7/XtHx03fiGBBlZeb1w7/Z84AU+gqcWhgz0CjrloQyeiT8kgzuhzF5usez92m++rhp30CuYT5iNJo/EG33tHx03fRjrXIrM1SdrxNYCb3bdhymvCoNzWGaQolVVeUogiCNj1tsAumZUTDY3fSU3tUu5n18LJTI9pv8Amx2nnINojJerlQtMC2IWI1Csy/8AgCgmlDumIAKsdGV/Mw7pxSugKkeqz+w1iZLMJLH16KGPHhlmEL6DKej/ALPZJ/3IIGovQw+jz0KUZV5SozLpsYrzPLephRV2VBEs6OqtopUBkwFxLVYKVmY8D+0OjvthFAXiN6S1ZWZpR9wgK6dlTV/IFZlqKynxNZRL6Sjp4VOfEB4guNniVEw2d30ld7VLtlq38LlGD2j0wGqzV33DEHoXHS8YzAXnoqd40ZsL1jMyN4oZtgwP4tT4PmfF7vRQKtEdO72XO+q1Ghg1We+cMQVtqCF2xk0HBc0TQG9PaINKPB+jR8dN30aML3pbH5eEVpG5touB6wsdCY1HiVTGmvIdpS+0ve3KW06FUzIMsYBcYco68AeA7w/p/wBhOC44EB0aCwuMrSsvdpaYFmJdhnfSIF8bQq58Huz5Djp4myYuTeJdMaBVMs7WnxPEkRicwMIpJTxdlvTCmZWed5sHq5S3x1ngbxMJSfnR6mUpFvZPm/JPmUCK+vrYJlcsYtkY27k+Orcmz5xC8KuUenbBfCppnU94FSjIBC2GNdHFgzDk/wDaw7aylAdka10RwAsTpCGU1fEp63+dH9kwgdJ2d0NCPQRBKSenHsbQFFFdPMJUXHBEIhQ2DjK0rLaKWmBYX6cslRDW9MKa+RgelzNanpC1cy0rkPPKYb/wydoujQ6+XmfF7vS40tO2kxfDIWsIvfqytUXoQapjctmlko7wup8TvDRHQ36QexUuiDYPXR8dN30+cvzqWu0UbLUroxH1uBu2HNb9CfC7s93+gHtP96lksryKmqpYaUntc9njJ1ubSPNihN2s98nwO89pPc/5D8Gox7R8DdxGgcOLZqH88bR9WFdwItrk4F5gjGwGsJGUVqvhPk7JO+V+xBWkU7yF3r1MN03+CS7KvVpXTYfOecSlVu7jKMPl4VO6Qn9QYaWeoy8i5q7nThErK/toaN1YPMTWBKwuLjXlNZh9sCMlkC95WfEDPrPZQ31vl+J7T/Z7BEg2VgyTVUsNKQv1QZD9qOYnHlrodNFhF6yn7774n8s9NUXldmjL3CPk+Z8Xu9M0GcSu9rJenmUwjNXEX6z6MI0ycw+xN32LqD4uY6+fiCH23XR8dN30ctcWahSXrN/6uW9Zg0ttCQcUzncACiZobd3EBB3JrjCteet5lVNayz2qrRsBWoz0DlBKZufLMOBqKzAAaBKeKabowg0Sy9ZnINRud2C3EckxLbVrzK2ODuQIhnO6nexhxDzPumub9EtIojCkwZNQqCKNdSmeuA5Ze/VTUtBpouZm/gwwwg9L3UOxQNRtV9+enGEpuudFZEdBYr0TyLKeisXEBAAaHQXRKvv2m+5joa9PYYXpmjn0Z9NYYxLUW0S7HbvWeecN9dUKmcS8yqmtZarTRcdAI6jEnnDErmO/LAbpqM9K0wlbf9uqeH1MaVCMtS9ZgfWNrnhAmMy6C/lqYk1XLesz8W7vRAFjqM1vuyolU3N3YaJNRi8d2OIB3qDHPeeIFNOJfNUF8ENFuRWYFFddHx03f5PMie25C7oQen+K0fHTd/r2j46bvoGNrq7/AEHqixRdQEWtRXWWM9vwQ7vOvRixav7/AGgLg9TWwH5I7I3EMHn7DuE6dCYgrTHTVCb/AF6UlraA66bogirNh7fmaPjpu+gtMNf9ISHyhXaoTVfygB/JuM7v0tOcz/ne7NGSOBWN6ysc2P6gT6qg3Hrr4Mx/U9BmisYWfaz4pi8xSadjH4roA+GgOxh1/wChGEhxtg5kSx6MTUas05zMsId13DvuZmNqKxbGKxnt27hbPM1TBYnTSG/BQTUTQUwneWO0tys7wVZsEYQsY+1+Ggi6Q8YZ5Vh6E+Z4lahcb0IeE7OxHZypNOrk312ICPTrAiVDzXOTAT9JzyHO4m7Xl1qH3SWpP/H4lk2T118GYEPZ0rfmm9T95wQRZXTxK+IY24mZZdcCQqFd5E/gBMsIZ+8dfIKpTbjotTbIMG6e5SCAqFay3Rk09KTLxA1WYYf4RMstuGF2jnQmxHjd9zR8dN30Ko6EbIhBETDPDDP3PgeZ8vxFU3ze7PkOJVIHmhjUeaCnEpn2PujktS9SwwSP8pel6YmVV0uW1BpIYmiy3mpbTFBM6h2TRjo4sF8dPieeiRsICHOT1CHyXpS1vthHiBjSZmTOx0tT3Nwy2dBWfM1AweExUZZ8NQOyLrzzPkpC5czFBMuhZGjFgxrL46E+Z46UbRgaJieO4IAAEUzVh6EXS4oTLCZpoxgIvDs6lhyitq4bNa1KJnOJHdBzx0viW0jpJuuLy3Phd3oNK0u1La2IYNk/UiGXtkE1UDBDOOtGp0vXCKQzaIntcz12TtCaqBggOnWjUj9XEreF29UtXGOF2huH3kUkr2rvNfc0fHTd9O/y/wAOnwu7PgeZV8fE0ZZuQU2ijzl4A56ITbGciYi/C+GVJfke3afF7s+C4lZFmp0GMH/BGX7VOB2jorYVwLYdGgTFIM+/RrtQRHPt6bK6f8vxCNXTLNf1PKmmg/BMyLns6CknxTKgsnrSTe6r+oih1yrcMLleVVVze4GTJrY1wbMeNAlKyC/foT5njp2hodMXbujUZhkFwNMJTKIEwuaJxjsmgsZ9ax8BxCZyHkRTtxq9ZfqLfYibYyBSXqO1m47Ht2j0LpVe8yrXhntoY38aU1zPR0QLwpRG6beS6NLoSfM7kIaj68JnWhuqbeS6CW4Vaw03RZR0VVsTOBNgqLou0CK/ELNoNg/a0fHTd9CattaKufw/z0cHaApY2HpIyQCIlkpieBUPoE4YwLrWioLSeBUAQCRG1OwOiiVqBVxBKYPQPAqAUBO8VtTsDpVkOEuZHwZXWrIcJcs8/rSoxkWwq4giJYzsYIVKYScMyPiwdQKAkdtLkBBMFSy/7mR8GrpUmOHM9hMroIhPZUpYN61z0LoE7z2NyutWCcMzPiwdHlvyirnZPAsgAABoEQSksluJyDoBQE4YhanYHT2Q1zsBrHEKDDQCidhMJcCDDQCjpm/IBgtAHBKcHgXAAoMRtPaiXXTMod7QGgDg6ftgpfQahOEuD0D2KmdLZZf29Hx03f4awzIVNX4VeXP+X0fHTd/r2j46buuRIWhq1DbBaW1xESBQo1YDaWYdcTnMOExZVl1+ILEuVo/iK5FMHeCJQIPP5wzMYUIXf1WEq4U4UXBd/wCfc0fHTd1BB0TMUhnEj6CO3nFBWxV4Xo52GtwFIHE0HoYirTM1lpNWAbHXBMLrbzDH3VwKSPkXoy7q3e6WkiuG4Jmv+naI7ok3sy0ZGLXx46YSW4JUG0/ncIG59Qtm3Q5yqher0BJuu03LFuV2l+QZXaGOr3dvRpJ+ObLBnEKy9Up7qbKgxfyaNcTCazVBsJq4m/eW7o7NyjaUopxLNTrajvKKF9DeYkAHKuGvtLhtWk2eQcTB3/GbWoeYNr2iNU1bGPbYro3CWq5GE3qRSIPUOOLf0B6phWZqZD1nQJlxIreCts5PO8UkatOgRLLKmcj9e0p5bTSKaN0NyI9WySF4PBBZba78Ap7nGGjFghLaVRCk5nGbtT94CVc9GcWUeDWD4oYdIiZHwz9XRE9f2MySbHn7Oj46bvoxjFx56Fvivv4bzcc2PxvS8awKkLAaHKmr6fPN5+3HmKxMuAm2yVxK8bTVO479S58ztCCd0NvJu+XAWQEXdH4AyhsUeSHiI91j5nfoz9nOn6JftmFm/wDz0BY+LlPjcHTv+v2tM4SDDbPguOnfNPVTM5QBOMNb657j+o6+fidqvgquihVqQ+saK45dFv0p83mE13j8T4rklakjuA/yZUSt9SK41vHFK4fSnTY+jK+lprROsj6KV5roB6h4n/1pSVO3oxzpqV4f/LpYA/RFfh2Z8Zwz2DonyvHS0Dsq+y0fHTd9GBcY1l2KF/eYtxTVUvBtv7y3m12TAINADAvOhp0LG60a335k1aib5g6c6EIJi1m0xg816t6sdCFba3UUwGhCDcIIBRu1AFZX0JfwEAiwzy7jB4Jte0tU6y4mmuMvLOPcSLjbV7dKdoejbYfjtHYseXhZQA2eSV7pF2IyrRh9MFoDG5tIRt97EhgDBZjDlpNhqe8yHa2YAN3G1M4gLBZIx8KPZrFtEAzP2IkYG+ygmx/3ZMOPZlib4LZxBt9RsEoZ7rET8m3enTP9m+5De3i0FdU75FCSUDXWMRyqlSgGvCWC4QR86eHO0BGp+7pTjYwNmFaHAHaU9B0HYjtNJLYQS5WNqVfLmvF9jIjPFHE7UFuIGs7b5hwRcsThLvYRUnI2mJXINqLMFIbICufZZsc5FuL5sRO419n2dHx03fnjNws2nFeSBZlhwfn4GofqfH7fkaPjpu/PQSksleB5B/gHg2pCr+p9n3P5Gj46bvyKc/a0Afv5BQmv+M0fHTd9CC0HmCFOG2YtsmNrl1GKQ+ZwM5Zlu1kM0YhdOa2YxCkPn6K2m/i+iJSvS2bQvjpQo6oi2TxB3ZWdara1BrLyxNGXlggsbiikPXqG1n4voLZ+DkiD8hOpAlRzmAFjZNFXlmwe64BYicwJUBwx+leGAWAd5nwfHTSU8sAsHx0UC1ogEQ+Ci4qNgCe7gwAsbgNgHLMA4nTPRQLWiafVzeOmBB5YIlj0s1m4vpY0Na0xwS/B4MwVxF0yy+Ze6WXpjc0MPMHsE7dBbAOWAUPpqCOkw4vLACxv8HR8dN3XXWC+k5b92iws7UseI7ZlIGlt41NunNKHfwkQ4mD9kWCUG2av1mpRua+Qzd3jz0DuI8IpWIiCjWsbwxfqxOFou7oEzWeC4XsRa90nwPM9v/koVE3UPE0wK5jiZrs9aOPoscTU2/hjVLxY7Zb8QWDfu0hcpkbbhnB5JcSwrTV91gdNzFqiL4xY35HS7ivHTYW7RsLdywdYTWm8bcLhATl0u7MYWy0BERu5XNJwWTYSD4ne5PKedozMmWjoKygGDdabHmnVBDUyzah37Vmdn/8AdmeAzWiKy1o5IkaiDYiLULdsqFmq+SYQ/F8dO+F3YS6L8uWWojS7b0g5gsmsRvQVpnQIVbtAuMRlaOyI5mWjA6KyoAA0T8DR8dN3XXEI9Sc56yUmBY7eXMyX7xQLZsJs9Kgr59poeIR8bW1SGVgZYyq8FyOhYj4Y6TWHlQZm28+N3IdD+7+o/j7T5Hme1/yexw9L8fsQCnYwM1C5cl5HWmU9q/pH2p7v/JWfWI6RoE7kRExh630dV5P8g/fnsGfEcMpTvvEF+BwaJU7vIu4SpQgvV4xuMNhDSTOCBCKj2j8Xx1Yf2f3HbSV2bXFtwxFZLoR71Mb89pW3yzLAdbO3qYi89RzawHqRYT+d3epJ5dS6zMb296PodJbtwXxA3MtIEhG7J+Bo+Om76Lwm2aMziROTvMa7EVctLD310SIce/Y9I5V8YAiL9NA+7uA1lX7oV300NRlO6d2srJQ4FtkN89dDc/qdo0WahqA5WrHNIWh33QELNW0d+nq6wbQhg0PUZmL/AFAxuttWGxqB3zEsSP8AOIdVhSRYusekcjXyoIqOzpDdFdFSLDVhykduhtAAgSPoa76TY5ds6qp6A1IEAdJLdkfBOH5OyJpKZe0RMKCTt0UcFQy5iOTuyrsszUPa2I9afS8QatOR6jFrjbpmpo0aq7szv3E3hh2rZtyy58u+qNG2AamZmq1yxbWsdorOUXF+FHW5+bQiAptXvl+yPgnHsnQfg6Pjpu/17R8dN3+vaPjpu++ebTCUm87Nd9q/uio0S3f+PQbzss2WX4R2EjTX2TG6DO462az7V/maPjpu+jU/MFZhfPc4uHk06G8rWeTD0p87GWXlsDvUZpWupWmJiJWIrM1yXnE1iiadXbxF8X0tMepSFABwZZWH2uHpnBTWi54HFKkqgFmj7x82kW6dchwq1apMQWy2e4jknyfEZlDVZa9+4Ygrt1Bx65Yf0dYmcIbpkYePXLP6vWIDZMiS2dt3Ycorw6mIFqs/s9Yg4aaJEvLTFe7TEJomiSwfhsV5jqb3rEJEuiReVdKYh0UDBqy1byiVV2Cgl9lUpjFOmrMH5/TRcqQ0+TEEryYeuNK9XQ8RfG+lpiEKdDIBSglRzqC3wRKyFLStIpQHqMpf4mDDc0C41ajUKzGtQ7hMmuzb8LR8dN30agCXS+ZRdkFaQh3DNYIZY3hc2suvMUwFu54ZWL2HyEdRWjC96Wx+RwlRce21vE+L3YQijVjWWXTQCsxGjVsuo9z90rnhwnM8zF5fWBEr06QtW4Y1zMpz1FdQrrt/RIUVwiNCQuMnx/EtX0xxoHZgAS6lkDY4EtudUA0W8g2irYEuJdpNaShFPkOwSzYKt0JgZe0plsJ6F0NkfLEsPDqK5U3vw2T/AHsYKuqwUxosUC5qekI90KuUWao9DKNWNZQeaAVtFC1kp5LELdwwTLleieZjoIJqAgykbxtBxHQYXFb5Onwu7CEUasawyjOArpoNB94jgA3pmz1Su1C76Joc0TpLlY+idNfP7/hxo+Om76SanfO8wUpb8zeRmEZDfBpBt0FZVuY4LCP5riOX8nu9GmrMXmWFymisR7BRqTbjM2IUtG7EKDBfWwYGKDJ9SC3gNmAgNVTbp8buQ6fH8SjyY4WwLmcCvf8AktBNjhfALu4Tz6BN4TJcH/UdrdW0x5hGbxqVdvyI5NYNWNkRV/8AvpQXXuEXrAu7iqXNQFjec75iCC9YELH60+H26fM79H8Nx0t8DvD+10J8Dv1iV+l0+F3foYZaf4gi6DzY+qGDzCh2pWEIJqkazCM4w4QomibCd8qLj/CGj46bvo8w4blw1WK4Zr+rXOs3rN4xpNNwUTHE9cFymL4AZnUTV5c5m9fLM1CkvWbhVct6zPxbu/ydu4XHT2kYw5ZPcZQx8knnUZEtq7sxjNTtFdCUiuPNdr6Nrm1rPUtuYZxUaBUyMXjezCUO9mAk1gyn/nkufYrQQKmuGP8A4cQCemCYULZ3Idsrpe4AFB0XK9mf+SSAzLQJ5OVMu/dhBhhoERuKmuOndotnZ+lxBf0CPrHuoMl6zu524gIO5NVoVt5l51VNay2aui9ZoaAtUAAbHTP37uzs7S465EixXN4mMqX9duntDxhWydHOujntAxKOlZFs1dF6/haPjpu/0Qj+ydWYDCg/J0fHTd/r2j46bvu9oC5vXzduowGuunRnIpgh/wBYCquA3cKBuPk0fqUBWH0BpTn8gulC0I44Fg9W299ydNB9paRQFdCCJubmm0M280OLF8p2gLgcjXdO1hcOpiGfpDsGqz+h1iHWfROmoWVyxhb0Lx+Bo+Om7qPpmnNTB5NnAkzYFL4Clo/6RuEuUbsJyup0TbEhaQqdYHei5Q/mKG9JpLfD5qI2dA8k97iRlhVeoGpa6zD69Pcf1N96GvSFi0iHxO8N9v7oggwILsV6jYOhaAGm1Y5l7qS20YqYsIvKUn3UhdFoWdzz29Q2K8D4Z4anFQmIPmIpLtGgnomQwcwLGP8AffYgureMFEhYzk1bomzRi0m4Yq7m4cIj9HLIvIAWs33q2QdC/wB/O0ddSaHfp3pK87QK+U/ucyYPZLSMpesu9iG5MD2uW1ayvNXzjifuDHHFiC5rEsg5vdN03mAmU4ro8K6V7HTcbAcTbJVylnSx36oLWDJa/tGs9x/X4Gj46buoEWiZlgf5zFoN9w2xU8s0VifwzGM7vMomW7cJEbX/AAEdR/G7z2P+dCZfBS20PsUUjN7lD99Pcf111alWm+bWDKA91cS6GwKDDgUYIM2g01L6e99BKv1LIMBVQPqpXOcET2kaRcgWIFIy7qBl6xvOJrisjS/sgw1yWrs8w+9f9Rcs/LLZZekCexLOczLMAEVA90aMudyt3rrUxX6xNXMxQyzmkcLkZHjUq8rDvYl+v0WtXjRf/MaoOf1JycjxAJtSVifz/wAJh5cNTzydiUlzQ8kd14/qe/8A8iqbxPOIZdhSTAHZ9aBsPfms4+LtDD6luhxCAgAWcTDvg31/A0fHTd9BRYQgg/jMEX9EGk0bKYtERqLKm26WKAl3v/RMjXjLITnoTUa6T2X+QX5cp9BbW00wi5ES26/vfT3H9dNOoVtB/wDsycJPOnHl3Fg1gDWKjPRReRIAl26TWioYqm8ktZUgBQHE9pKgWO6lzLtM05J7cECfM8TXsS9Y17YFcdlvYVcHMAfVFSOoXNMXyBba07zGZOMliRDLQWATEHZ/pHDQMyxJnj9mBLAGl2Ih4Cq3ZA2SpqvsQbY3UO02chPQKHLV5lBso9bg8qV5I0jj9me7zGMePiodovKhLqupL94nv/8AJ8zx9EnBQYy53aWrxjNfCbEyNYvKZm+SO321x+Bo+Om76KvH6UuugLJvUGXoRQHcuYXwKug9Ady5Y/QhUHgNAGkBQHgVAFATiL34pUHr0gy9FPBCWQOoFKraAUDwKhqiwDL5goVfC4AFBiJ3yhDAFAB1StnkGVWkUtTuGAUAduntJXJy/kKRuQOlLBvWuXpUGO5c9s9XQ+kOEue02rpTPIFzQ97FdBa8iXMcB2K6ewOuO6vhiA+OAxCKMcBXVwb1IrogrvWldAUF4FQOgO5c7aKCiAIS7CoiArUYRMGwUQxy/CpSwb1pnoorDWir6V12cDMf/PLynkDogAR1GdhsBR+Bo+Om7/BOSYLNq28/5vR8dN3+vaPjpu+jwez74ClFp4hklUp7TvrB6QyH1aqYFyjrWV5+wqHxNhcPtqmAXb+TX3PDO8y+L1y5+Q+5St1/rgNqs/XXEoop+Vo+Om76MgpaEZQu3S0ml1ZCDBqYmzS7Uwf+wxwFMeMsqxpGkfgSLZTYZ42d4xfcx2BMR5j4grqLPfq/X3HGtJnEbT3l97z+qlol81d5Q1XRgtk/csue9nCJT02enUzKvPJV2l4bUnaaoAntM9tpNWXbPTsTesVzMwM17wsHjXumshSPf/5LqWsaQ/OtNJUpariZdMuPcJY+7U2Oln193h9IJXBEspfuI95Dj3EPL8U+J56P7J0LcDhoDYfVU6F3mYTS3J6GeKHV33SH9AZaxcXSII7xC8RSWqeqxY7MtsWRaL2LswczUUw7RjQdoOjLCCEoWmksG5nGFk0ru9MqT4dwbLgTXgqysHc9ITGpnCLS1ruRMmabdujujTfb7uj46bvoC1NlvzJ5bT+569x2BWejWi+csql7366GK+si/sHfAj4Y4v7T0mKzh8dTl+dR18vMIi/GJ7CY07/+pzl6WXRtQFb6a6sCHxuH44PT7kPGjPWID+tNv1VghD50u+l4+T/J8WRlRZvKIPeIWtOoUmB9eBl37CLQ58AZuMS9Z8zvPieYKn9k6eXfc6UNr/zIVw+BjpKetuntB7yqv+lG0lYiHj+M81o/c9Y4pa9N5+uk7+9+TaVPfKTffpSR/wAuZy/+LytD+uynz2XpQ5v3uOvi26IXH7rR8dN30b84tvBHoId6mqLa8wqSOeAYLu0yW78jB8SyMqt5diX+xxGezC0cwUiXFmpc3+N3ZzD04AQ2MyTd6Fb17hHQ9o4WNPL9dtJoImv2SawgW3y4RqGKMqZ7Nx0XVAgbw+zbLzK374gsfiMrxv8AMgHn5Dlhq9Co7l4VmvcirjorWP4rTsieve4sA8FMywZfenZ02XqKWATtEQLmx8V0NswHsATPZhaOY0/2aawGgskWB7Ol93OFzoykhaeM5dZ4iUedt06VdO63jEV8KZSravmZekf1yY7wIbEMmgh6T387SBcTWK643a7Q4TG24gEiuXSWlhxZl3aL/wDLqr25SBRUvSbnCYqYtCCyXHBSqprjZSOniALvOfd0fHTd+DdxfDbt/hfgd/w9Q1L0mpdvR+Jo+Om7/LavWAZfw3QFajCQw2Cj8TR8dN32BHR/KUMv0iOT8qzn83R8dN3UC0BALQnMSCJdC+gZxWlgGudywTMitf8A2ElcUo9pbouou80lfD1veMUh8z2OXmIAEXQuLqA+fo0HeWbB7oAsROYTZPiKC1ogFoTkmg7ywCxEjTpL0tqaSvLALQkvwbHZGRgzviawPM08fDCZbX2yx+t5xAtaJr48PSwpa1pmDMOsB2mhh5g1g+Ouhh5jga6o9ovc6zmIC1ont2MQAyagy6ZYsvTG4gWoE14eH6MPZt+8t/SG5R1rfpKwz2XmJWWcX0pAjxfRQyxikeH6S/UcXFAiXQuH2A5cREIvWILQ9FtAe7LjFrEVZbUfZ0fHTd1vE1CNrd9I4UqPNd2XZPdgmtej1mfAWUs10l9yMFb0dpUvlehE2P26LA0tvKTZpzTZc/Ui58FW5k+9eaPRBsdCp7Qw7sPJ6xaoj6EWN+R0/wB//k9/iuNZIVFAaUQ1c6kKOXYrxUNBm7qjxjKBBN0Y0mvYIWwy1RUWobIbsiw2LW2IL35uc1fpTXSSmDHrfr9Jw+XiKpjzBZNYna3Fh00AlUuaCsVHJCrtiotUiFiyGqQYNiKyVxO9sJdF+fLK0Cmp4mhpuUFePB2IRGH7TrRfcfLBiKmTxPhd2B4Irhe8ULF9SD2OyzaH3vJ1VHC/go2qlciLRHK3fRKD1vQ4yUrIsvN8hNGV0INqggrP1wTe5R0QyjRKPU1vL7VtHx03fQSWPXxMV/GJY72FJpNFGjLH5Np8vxNCXwO8dfKx0xnWu/MUC2MFlW+E60e2/h0q/rEfI0CcJEuMIetwouZ3/RSXj2XlmgEqxVeLL7z0tzkKr1H6qKIAVGZgCQ6uGuOX2Mx4tgmvGVL67CXiNrAf7g0NIgdoQsaxkRiLz1FT/wDodKf+yl03MVu96OmvG6fGY3GvA7BknlxMuVPC8YoQIC1mkMl7swkUvVQhrH7SoPmmbi09eglzX4PTD4tTp87uz5/Z6e5hyd0f7f8AIV4qpVSFjhaxk4SDcjKKTYehYkYH26IhePkmlLQw+Z3JW5duBQIKqEsbV2PtW0fHTd9AuAUY0HCHpHu/Yhhx2kj1JdYXb7pkiqRX8nwzCq27Z3lVgcumsL4gSdugpWhJ3/XUSIIe/Y0Scjq9P6lTTpbWCkmrMRx6NbKhiolI930xlkW8a3MZtSjWkbsXa9IBSfoJRHb/AOI05DW0JTpPS9CUHUy6R0YpLjEagyH52xPULXARSI3J3ZeL300ZXBT5pQKVBMy9xN5n3Rbdu8s5Lt900naoYn8KOrL/ABiBvixNK7xu8u2S1/gbxsCXgvzEhfHaJUurc9YaGO0RblJpFwEvmlSfcHEw1/1+muyk8FiMdoGKsBtmCrH3d0SL0RqQ2XJHDM4V6hjzCrX7CGUSMQ9/H6aFHR6kOqEk6nhanmFKiW7I72oF+IR2yG+ZWodJLZBdUMKWviOIzLaZ+vs6Pjpu/P1ljrsYhoePzKUr7t2gAUfcoeumDroFB+Jo+Om7/XtHx03fddqgtZ3l0fYYmPdlQ7Ye/wCOApoC1gSTQ19nE5uvvB565YbkVj9FBsdU6KAroSkK6vwGj46bvo23QVZmH9c4hGyaG7Dpu9jpR92MsqH7mHpUd2sso/DuNJ8vzCLvNDeAqa6iUT1U/wDDsQ8haJNgDdTLeKefojG92aB+6YgEiaJPOgpov7pRCQEdEjqiLGK8z+iViGw3pbWFK9uy+m2yCrMF114QjZNDdh03exNbPeAgFlamStIhKa1Fxs21ONpuCGRSpK57aGFwFG0vRAP/AEaV3MCGr2VBEscSrvNt0oI7XCzPhiuVmOx0zTr4l4AOSkAo7NuZ5+FNEfdKIVMmiTJ3XZgPMR97WIGNNE6V58c3MYQrVrXzHBy1Wf0OsR6i0Tpbb6cNYVLa1+JhfvqVmFT2eyIJCUO45jsMbNr4loI6lILGPDvSsR7w5XWlKjPErFYhdLA2YxF6uw2iUQPfeCBV7KgiCNj9jR8dN30Wkvp6Wiz/AJFaT9uz1ggkTuERnXR5ivbLuesAM1bGfAuyFB1LLEG+i3jZuQxeye80XsXoTi0tMwnvH6ItFJ5jxeqH9YC7Q9fuDCD/AKArprf9VY5Vo2pUMllCAz18OBxY1oTodSu5ojyAR4GYWGSXHwC6WxxvXFQqVi7fpLYX1ttFDfIrSft2esENoVnCMzeMfH8z5XfozAjJWQgKoQcY1uWf6iqNqV89JeY1oCMM7Wq7M1BluobSBGUh2Gd7a5q3trGjDkE7FTRED5YYPyStqM9oWiXD1neGiKkIlYyiOt0S0qhl6zuqysyy2VrnecR1RcVkcHT4nee1fyV/9b6XzLZEgVH8vB0YGcsysaMKalOhU93/AJDzR1NYmVqKSPJTndUEubKrXSEC9WxUDBtDiJvExQJNAH/sTR8dN30/8TxPj+Yrkb1c9GYE0N8GkCnhskuq7v8AUEC0TCyBrTDJjdYV3Y+8p+ttyTYKR1ZcIPQ0ectwnEzd3PWBJT2r+nXRmWO+Oa6XrFrVpJnXfBlNFWKYj6gj4/jr/wAZxPn+en/E8T4/npB9ae+gy2GYXKwGlhmg6EVQjn7f718mvpq0Y0sJgvKyjCAcjFBoa3RhsTKzlZ3lrjGVuvrD8D4ehA942Y7rhzrLOJ9Cfy/w6fG7vRKPH9QRVCVcS1eMp2Q3dzjMuTp8TvPYv5Pe/wCdLPid+mabkfuXQXG2Z7v/ACHlBvblUMOdYuG208XMbuQ/qWxsNHoDZLGSGAdYDVuD+vsaPjpu+jJ1yDNTdLwzHiq5bczLSu2GXJ0gvtMab7CzOee89MGK3wZqMl8TBGBVy3rCysPVA5TNL3NOiBz2Z/8AHyFQPQJtNUu/XyOLaXevdhDQgYCVLnbkno7FiHTBoENbUM46Zo+RZpzqvDB2NVy3rN6uWZqbpeGY8VXLbmW83dmmXJYRfaYfPEWC2BuNkuIxPNaTL0ajcvMqprWWK4C3M12hWvMri4O5NATzsgABQSpS7GsxdOmSJPlhhVc6E1icZhtc8m4SvJ2npzHCE1DQS21+9iumfr3dx6dLcQUjvD3sAaI9Y9Rj/UWIXOex0um361xL+cdetTD9vWvM0Jqmu8vtzVedZ5uw3Aq50JrMVO7K5ju3rXmVrV05IOCY77mCNVliNAQdewrLZCgOLuQ141WQgAA0PsaPjpu/17R8dN3+vaPjpu+jS3pQaSljUPlBwP31NUcHeI0KEm8UP0fIGheYNlwv/oJ95PIVmz6DDAtO0Is+g0mjEM6mLjWINh7fWkYxG31GP1y6EKqLCb/m6Pjpu60a15ZvU3ecuvXizGLT0eUd3V7SIE0Bazd3PbLfG4HqjUWDSU7Pobo0Y1jUanNBujhnpsjtUC1grVZ2zwlKGfM7z2v+dSMxjHO1O7hWaRA9WjEzkuaAm8nDKChvvnxLXNDIIvU8WHh2CwxDAoLa5nYQh9rdRuJUXSFF6mamHA2DCd1efeU7Dn4mSQYbU6UTr8Wdzy/LmC7oLP7J7SAuDXYQDH/74SnxmT/zFUzSSp9R6V3x79HsyulDU1ZXwz2SBcexr/UjGobG69DtZKnRBbqe9I8wZ3oGW3P5uj46bvo+F3elkdqpiKNCpjZMnXzHEayBq5lbZ45pD8p+s6A3veyJMTTdBVX4DMbUGCLWC9Uaa1EDLzEENpJq8rf3Pa/59BFr6SFA2fpIQCJidjRPVgX2BTwRWA0JmVFaGsBSMujc743dnv0+C4mSwUttDZIlIze5Q/cLW0fa2UTA48XQTPff3NJKj9pAmoDBKE1/zQfL2iuVi+iUjZhWqlgDPT0O+9hzCAUGkBaUZpxAE4pf2QjCgMTBFFwnHbh7wAAKCD1T+qg/r/2e0fm6Pjpu+hiupR3jhXeGe26UJbip4ZtqAbEhUZe0BCgFtrWOjU8DMioBE4iTAzh7MAseYNCLoVNf8fWQOVQBSXNZsFQJfx/U9r/k9/6IlorHKJuo4n8v8Onxu71fPH4yQswe4Ge2rHtE5rVsY0+RsO6Xzcv5KLQW1tNJ3uRHp0/vc+J5+gB/sIlEuVO5nwO5DSfO8z5viYM4GtbIArnPe2Uosz9L6l7uJUctu1nI+CPjdzp83tFbmRySv5PJfJ9daBmFTaw9G5QXdNS1+n3/AJmj46bvo9mdc7AaxxDowaBglADwLgAUT25Vw+iOArqXXkC4HRHAV0emiUwlwyjOArp7m5cMozgKjkCaiWQaQBVGkIQF2FdEEpnMyABn8P8APTXyQClif1/n99AKAnDL94IHQCgThliWWtFSxCXhUrSbsMO561pFRSGMbOiMnQczetMvW815BcWt24XXRBxOlczTj5LLrolYckLArTrbg5IgBgjA9qJddFP1nnplDdpccT24XXR9jJcsKqaNZPzNHx03ffwaKFqzAAHH41FT7kyb9nCHFFgP8to+Om7/AF7R8dN3+vaPjpu/17R8dN3+jXAg5mVo56JnwQ5rPoxs23+j0DqTLQOI6cw45rGK7LKY5LXguEc0b8dDWH/1IeB9B9Gj46XX+jb+sIu9kRWEtMDQzfAGP3Kb8avM8mfiaPJNjHNZ0lQhMY9JQD2INlwltf8A5J89zAYcWMZnAZbSUwi2HS7lOgnZh3C7LLIZXXT6xp7V+v0ZenoLH+iqBbKjluswrUOuoloix1rD2n96XH04K+e3Rvl8T3SP9U+C4S/brkJhne3tBsdz7JxCt6ZBnyln2xftCnFQHc2T9EfWCyLv9EAi0YckVHpNJRykvKcwTHgLpBtFzlIlrHGKUis4oHSABRB9a4gUmBVT391CBIUrSDXCUbKldfd1AqYI+uF3+h0QUeepbDSDf+tXUNbb6Vl6ILrj/WEJudPrW2ltv9Wckkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk+28BbfR/8QAKxABAAICAAUCBwEBAQEBAAAAAQARITEQQVFhcaHBIDBAgZGx8GBQ4dHx/9oACAEBAAE/EP8AQrfwr/M1VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUFdo5tkw8RLH4D0vb/NoO5cPWyF0E2cT0vb/OuetckQBOB6XtxftKaq6IKU7IQYjWgIwc92F0BZRNfPufIq+z5qwkO9Peil82+A2OtIgyUhgPlDc0rWzLCQwZKLF/FW4G2rppiVpNTCn6cAxZuFfLWbATHK+WBthKKrB0uEzVprevkACM7UPA9L2+D+Xt4NIf35QY/Mt9UwIDr14tQL75h9zRbQFwXclAofzBXcOaIHtd0CIQYLphqbW8FwMX34wn4uoAHA4vBgoQZi9HQQs2PQqZf9AdCIBXXIrbq5cCN2OWuBbY01VwWuPxFUOzYDM0h0IoVtol6CV1Jb+dT1CZYb2Z8FK+GregByPLfUxRpJKQw7ZF36CxEkVJO2BoNwpZUHsPkirazwZn7DjJFkF23s9kW9JctCU8+ZQkG8Y+CWVkb6cw2JimpfnnlIVQvlRjgrNX3quQRCTXMtEIO2tohYD7W/a1KmU2jy4Ah6OaFUZpgpeeBNtAdCIBXXIrbq5cWW1OusSwM9RnGo+yoGtcVSOnARVwaGrddRjSpnQQSLIxroDosSEb0nwwnLVSgsjltE9IZ3ZDbKSqnIGei+VYbtuh++55Ia0kZ6vXZxdHSELr4xiuBQnA9L2+D+Xt4RL+v1Sp8CsOWIAIqn7Kwte59m4xNdKtVD3VCwLq4MxtGVWm4S2xyzptwJ3bJR4aej0VwepVPt5i/lUZ6EnRmi7m/kCy4V3tjHxhtwH2cL8rpHDRGI+jlemlZcOm1MfGCWJ7OMx1mE6/BVdIS5WOdkjNrGWC6/Plo0vAzzMlKvP7qghm1U0rvNb1KcqhV/VhFrP/Thpj0pWPz/AIdWBs/bbhz9UpRR9lVDVDh8wHmVENRZNLc8O9NDy4V3tjHxhyWezhCWvBkFXl0hUiTTKZ3pv8Qb3FFRDHGQ+qYMQtvHdP8A++xncN589AgV/XlO6fblWxpThwEFv3+NlE4D0vb4MJPxtanBwUJAhIu8raFA5ojbYhC/CDsNIZA66VhJcP8AIQvYLKKKkVwAplTUrNqmkuWANarYZsO8L0qKNH0VY4Ebz6lY8az7i+bYTwBHQQ/60rAUa1vV1ksCr3hg+W3fFYQNZZZLlxzxbbXA6AoWqD5+voXAWVBHETBXKuyWRF7wyjI8y3rjSZ+xJYAHNCp0yKhwFHYNQbWoEhT9qwYFJdsTqvb2cuK2zYKmJi+5mRci9y+ptft9sUeszS0JXIQ5m4LS6s0GU7hpdGNKnJGkvjsuws4Anq3zHkwJK/NZIcCSckwMCY8CpVQmx0KuhNqsNlYpP6GkvgBIWkcBRrW9XWSwKveGUAkmZ64VYWRtSc9CZsdYcNTTEl1Np0Uas01klYm8T2SO3XVbLxWqsvy5KusUUzOIhBaDCLKG/dHagKuLFFaQLVyUo+clZSykRMXgWNRHQ2+TJ6Xt9GyAAKvQJm+X9C+jT0ePnCrS5a8BfvuiASu+P+Uk9L2+jBARKRyIx2mtoBfg+hu8ILT7X89BESVc/Of8uT0vb/sjKizl9GmULaPpJPS9vgEUEaaKR8IBarQQM56SyFX5IEoQeqslgyNOUytPH5RacF4qiQLEVvUA3222cGf8DIZMZ9sS+CAVaJ2b4BZesQW1eiKAqgTtuwC8LgD1VEMsvsPEypsqoeJs/wBpfBQFWWi+gF4Zm7tSjUHoQ3VT8RQM6rRLz7aPHLFNtKNsCwTdVPxBGtAqGHYzoF4LExzVoiOp5AzQOGC+UWattpRtgarN0U/HBoHAFhRCgWC0NS+3Rlkyte0vg+bTVl26nQiBVAObOwhAPFQFWidkWAvCvlK8z0TYmAEUjQJ1WiDfgRg5Uss0tigWtEtt9ArwSKC2qn2lWQGkEa4D+mjhWqYOFvvpG/opPS9uPpngLo50fzZxIjp6Yd1X/DpUOn6OF3na6CDqwVWkP8Vl9Ilz/QHgXq1nYve7xzPVVwquT2USXUpJqoIdtOXg2NDrE2QureZmAtcuC9hSVsiMFdHMcEoujlimKBom/uEfX07E3HeNIQleLTaMVfb7le4UdlSGZNbtI1dU0sSyqhli1ZFwsn4W7JghoxzNRqIccQqWKQCJujuijqyYMZXTDEcZ0jky7PukKOb4R5kwBgIc7XDG123UEIRXIzOcfLeVDI92uiMtQ7HwjYNeeSIkoG2IO3RHoOG67xpCDOxbT53vszlIPUhhdrGdLQyqUyrHSuBtqVRxsuieRSxebltzwvvF2Xf6/wClKQK3Xbb4na5h8YNrfXWJ2h03BqafoZPS9uItHaVHJKTVryiS6J+/FqXjUp/152Up6symWyU2YOBfK5udDDoXLcBjAoBQEx8GVBD7U7YjZhMo04uMNcs87ZUBVoISel9Umg22/uS14uToVb2p5zWFD4GM0WWWZTrafYP4EVUIvOWSomHiAWrog50w8qWfx9p9cjpCLfumJmjOiWC5hHh/X34KidBKmQcFpBHJLNxzyVNAEJmvFTHZf7fExXlPo8cVYedwjaUikaPKXldbSHzZnQ4Dyco1BWKiALV0Qc3YeXghO/wrykF04m0i/hseRBvQSR5oYEFcIsAtVwW+B0oJ0+Dwuhy1Hkyiq2lbiFIu5Z+hJPS9vgzvbrKhuhpWUOP8c025jQ6Wi47djh49UVGtIcmps6pUw3wJGsW74TiFMFzea5meVc8+VZTWWDyFX8oGV/I8k08lThKfkd5gFsL/AHVycs6UwTHnEjmwvcmVQtDTgCBgNAcEOq9uuuAd2nvY4IWs+1OjSJQLMr90xEgai1GlJVIW/nziJXa6JHiGPQHBkq2gy9zRVIb0lzeSxkgT10IqZrnKqorAm9ci28uBJEFYSIS0y+WygGW4sK4CO+ypgE8AlKlQUJXwCl1M3BEfK/uvAfZyNyF0kyoTx9jgbeyR9qdGkSgWZX7pgsqHfmA4faF7cpf5pxD98MlY/wB94RKosJUyVwi2/wB1FE8/uuuNh8du7SRMaO3YlZZYMsB67V7ba/Qyel7f6CT0vb/QSel7fSXyOOoCATGkMV8lqfTN+Q+C9XYKFiAI2JY8BXVbKBazAS5brH6lX5gtwr8ZRV/NCLEQuaypN7f5N2ekVG1B7waiIKp1r7/QSel7fA6lYCJ0kBnG0ilggEbHTOX0ifwEGC6i6QAiI6Yn27EE2kAHRq1A+wLE0nFIACCwLUE7a8aoaA5JYAjK5GlSHVS9oRngqwNZc9Zil5LDiRNQKpHmRvgC4j6CVVIlNs0iPkK6ujhpRCGRGAHvQuXwQ2OkCX4QU02uiIOHq3LLRCsKPQ4Ddk2a+hEEeLVGju/qxFHWVMIDG0FiRQFvwK+uSgO8NCixDUqBZQbIYhXNQmWsFCwAgiWJwbxvPY+GFcFJeQRAmE5p0uPHTPmTINBLY7dBXwRDHr10jDJfgtCAQBWiYbcl14yPBYKKVVMvMEMLaFsw9frQhuTyR2wRoFQJ0Vo1Q1JyGACP7EaVTFHNtdpA1PaqAjZdG+xzyiPgU5XSIEQTTNUviwhJ2bBSsF+5bBhU6IDpP+V1z0jhHWAtXAErzTSoY7M6syQjR2igIid+V1nOWyxlTC21FmEyClVrWLBadWrD8Unpe3wAGV5y20h/uVsTceuV+okONnO1QN3WlcmbvFbnPJfyO6uBJ0FsIsW3YtKQS0SNE/y0ymHFf7Mtyr3h6CAoG5dGHqSkKJ6subFQ4RLaliGANE1h2mPhxBdwngJ6ReJaH62orgw8PWL27nsWa6greokSc1sIBkU6/UE0ekhg7bt1uspD15BMJhkwCZR+CIX/AL+SBIu710u4fa5ozoTGk8junvXE3FuHKiCluhAfYkELy/cGIzLCRmcvkjZcv7Q4FC1XQKb4gKaoD3rcV6DqAwquTXs3UePupM7P+RPX+BmJr3LdbUvcXRoLiICJSOkinIFVPJIZSrBQFZY3fvB0EGuZy6MFRlI0RIZcmJd/YlozioZI5DKtpbzh1P2BYPhht+FRR0sXk1CWH3LyI0Dg4Pcfvz0jhJ1AD3kUVQhLYQ465cLjMQ5wZKKKbS6jyq4QajC//QwTAuHLfhlO8gPwyel7fCAdY/ty8WkEG2iw5st7DXKSvViO+Gf+50iDjX9PplLHkYI1n6qYIWwtsOAvN38Er7//AMYUHT4sqSqO/wAh0RKvWfrP7RfmRV/LhFrzpxDTIFCLpAIzVSe4E0o/GwFW5Ql1cWSqFhG7rASPt1MHvUeQYPM/wkAVaL37U0xuTO/soOtYfqgNvOjG9pXdOASre5UYHJMQqxOAI+4y+OWa09oTDKuMVdSR2A0PCp2IbdTmAI8rzXf7PMQF5EuBY8hirXIovbYwcY7nRF/Jn2Dap6zBHn4+vT/T6eGnujvVitVi20kMIvN3xb8ZsBLyV24y8PXWcCpE47CmNat0HOreFrHgKDf+AHbxzsb/AJ856RwjL65+ljLZmVAK6QF3YNQSwPTyjNbRsiS1IB5XqRR5pHADPCnp/wAMnpe3wJJbaWZdZZI00aYYejdlwRD5RRNUiyEAAAUBNFh19rWalkHwzJJWYW44mot1QRnOom21APLQLEepEQvtsw3NOxnyMXcnGRFjlIPBCRgUWDGqIlgdko6vWZbHzsXkdWCAQeZM+6Z1AROdrwMZldmDHksU+wm7lIQ5n26kdjyVEEbXnIuNsoDBqA97EjayzTQjL1579tERDiUPFzYWoQoREdUKCgD68CbrE2PUYFKCxOiKQqwEDUZ8gDYepArrNl+RFsAFAHClsOdJKIKpFdo64DBd3bFbZTrnA6OhQ8QKF12umJmVfcDNeSTi0u3dMxXTbqgjLi+e7agf2QFiMsR1tpwlZNt+RhFroliRmCdlPhh+11Xirz7dc3ZUaIOToKgE5XsLACYGWyJnAvfBlTGixmWrjPczosVxwHSZAWIxO3K2cSEnueRhQ7o1iTzxmk5TwlXIY0HC+cJv0EraKLlFSRQAAaCvhk9L2/6db7XvYciGsBRyBX/Mk9L2/wBBJ6XtxWhZQaM+BVolbrOtZmBMPrNHe19CZL7Zx9jhZ9k8788HDDfhHGoRzpCAb9qTStfeZPkVmvKVO/8AzEhIvmnfxsoumWvvAs/XbbUvS8dO1fXSel7fAQcn7u6C8ggqmCGH2wVbhetLT6XJlJoEvUTScHRi14vwCANBkt1I4S3naXH4ZPKJp49y4utt1ukCwcEKqvRWytSiRngi4MHFQq0KwOJRTV3VqpX69tMFA4GkeFi8+TuEPYngtRLnqBbms1OJAKWbmMWc2NE43DUyEOKMtYjwM8Fx84uIkrmVO6IEsd5KygqU9PEkXcNsRnem9yUhuGxj2hAzYkYcCCAiXK5ASvE21p2rIJI2CcO2xKyz8qNhFzs20FQD9kLi7WDs7fubJbgEm6gnWd34THTjbSEfNZNXH+XCp5tVzUEJEI1ddTM/K+XtLx2PvyQMaqqVhEB0VuQgdA2rSlqUAbLmoLIaDsIMhdc+C6vvohBiTPrzAxEGa1Q7tauRBhBoKwY51f58TtpfwSIn15fXCH0aVstjG85S3o/axJ85J6Xt8IQUYSPUEHogiOkgMJB+cT+PvP8AR65WxVeHwzAl2vdoimNK+SYFGNMlEGiQTpNeuOvklhi3pIQ1L4rkQij7OjHJOLECZRtf5GX5gAa5bCkGY00eH9fbhJyvSBeKV8rAxsknFtRwJA6TOVumYRaoRvnhUHAetAYg7rUgS05+XdUgUN4DYEylh3IFgjnatKjRxu8jMK4kL02DpGEUYYcSCq3nXi5zUErxZqYACaoyu9kO9c5ji4ApbNMd/nRTO104fUB1/TGj9kDQYPZUZhGMacS6SS1Hr9mDyZd3j9qGDEXhOfyIGeAkjc6nTbYC1S0Ocgy/gJddZt6RKjzkO4HYKowuYMNV7B3STL+Al1BX3pL8wdZOwDfrHqpNqFsaabcm01wRFPnSel7fC7x+v/j7zYHfv+AWH5cbvLt/+nzKWFBdypv9jbI070gEhs76gqrqPSJIB6xIWc51yZRu8IKVYwbMozFWDC3NECmGxcUyIGK6OrcKT57uDz7VUKcI/o9cFbQQhfIkWtGmuDZUuW0KE8uArU2vgHOzaGM9v/uQQO11k0hHqEzwZM6UflCKJCgGGy0EZEcS4AosaIw4kHLLWwmyiZFXLoQC6oQ4rcHZxFBXxRLW+LcJKie4FAvI+B/DPH20WzB6gVFKPLVZWuiMr/0jdpTuNEDRdewbW+ooDrrCWY8Szpz1uJlsAOcmen9sRJQpkevPoyGue61g1HIDn7U9NniJD3xLFvI0UGtdtewdc3TAk9UXuZvVSc5FO8795V3FeWKRUd0DBAGwfmSel7fAqhds0urUVdStYcel8FuFYae6bh0Eo18TB7IIiWIzKZboD8EQu+wEgLfUdjvUd2LaAX9orUbEsjNr5scF8hYafdNxAAiUjpI/fW6AvrRFbVsFjO84mOCJN5Iesv8AwD/Ti2TdiH4YMTVYG/4i9e7Rpd6h9gIiWIyiIK1B+CMmPYCTL26/qOKNo2JYxbzW/SJS7uRe3uGVm3bRT+OHZQqD1l++C/0iCIljFjxtBC9cSq4qIjO7wT9PgJGlMd12/HFMv7ASJv8AKjHBmyrZpdWtxstbJ+BgMSoFAR8JNiWM7U9B4I2jYWM6xTWOHKc0j+8CdflGp0qaK2MH2I9etmD9macGMH2OCVtObHrCpHoKJk+t1DfWmAgAKAKCOKSw0+ovBSmuZftDploKOHl74R2k0gfmLFzkQ9ImrlaCj1L+bJ6Xt/xqUjRVNMSeyr7LX/2ZPS9v9BJ6XtxYRAKqBaEuF+10VAxQNdjFO5apCqpjRfFFo6zRWbL+kop+YfSLPeGO20RiyuwN5+uZgRapWnUB1Iwzt0wVoPnNJ6XtxCe1A6jHveaWeldHlSRM3oKV7eZt5HEQjo3q8BTln6BETixbmN+bCmbP359oIjPrmWiEDSC0QsGBjM2ogZ2mi+iITQaUUzgUBfJcOYaavLgBDMY0FUicUeDgmuvciyKgY3KNrK7jvXIpVtw1w6xV1pvsXEV1ouawNCqsNL07Zrg64g2s4MXuYLHTMLMg1KqwtMOZReeDVikoxtsNJi8sMKEdbsRL1bGqWsh+4c3gEcRLfUQaXO9CUeqotzlKvO+ME/8ACz1ZmmoQEHTXJHUgmWvOpNhQ+AF1MfpU1CLcOvuxFyC7aGxRMaGvuQxNy9MdTxXGFLSf7eOAuc8CAXdEX35EVoILsK+0AdZqooyR1UQcPFYokysVDEPu37YMedIXzVaBn/tIAMFE1IGO+2EnS4CK2hU2fTlkg+R3Jur75UA/8CPViFKVpqi+Dvk/Lyel7fAA9B4sc0PBvqZ6VlLRhQonZ5+kUYwjsQ9LALCVr0W8VlY1qBTNRVEv7wsp4viyhfaFVQvGj3pMczrOmZ/+EjQvUg8yojNLCbkbSdkqvMAKXyezN8MP9f8A34WprdYht/s64ADTo+kmXNcA8Fgv3l3PmzgE42OUAHUyj4FJ9pVboHLx4CxS8oFLqYTNegVCAKdF4AHAAwwfCWA+c3UdNwPWcPESrhc3zwCeGwOU/WUorVYl4gF/BHUobvDIH/00CmkPqQoxk9v9O4NtMErfpvHJAqHmgQUrgfFfA/MwoNP5BDqSO5kUpN56Rn5cB465owfuETjE+kz+D0jB2XPJAz8eAxbOxs818uT0vb4BMoA3FZQ7uMWplEu6JIHopFxF4IPjN3qUQziNYzgtFkXZiIdlA0bCAgi2aVWTsck0kbudMyJVrMzXAxvczlQ5EErPFKIR0zwlq3AkGBpGHGKhVlIlva2VjTqrqQgzfr1Kj3DxmWOsxjabWbA3dww5rvPcNF0rWDxzmVRbRFKnhbYg76C1KxXlmV7wU8AtCuBx0+QCBRorklUODzAVQjOzFoSx0oA/YhB97oJEBKmkixW4WbSBwzItCBGlID5qWImgsk4gNbpS4WAFlpEWfYuugxHlTal7iLJYmHcmmxGyQSrKczAUJ2nCrj2yyfp4eCXQg0kABsK00YF3oGkYSLvK2hQgSCTohKNPxu5BHFJXV5XhtNj6QbGG9DzzBbN37n0ZIqtjNIWEbSqdqDU0OSwQMKPvH1IqSqhdbh6gmATApPztltUo3vMzWhbssraBhdQtOSEpzNYqIydu6EVNLWSfCgZ+Xk9L2+v1pmDdoEUpV8h+vUz9e4d6O/F9A+qSel7fXvgJsSxnY28P/AdwllryT4nBIChGp5+qk9L2+oRQQLo+Sobg60DTTdfPEpnVaIIBER/50npe3wVovVURPzTKP0jB9DSEBVANrOwxgLL2EC0D0S1WAm1kDKHKEpEAqgG1nblgF+DBJ1DcESyELKoAX4uUhAtWLeBUb45wvSOXjcMVtEpQYyxuvErtrq2CGiK6QIcGHmNkueuiBYIljwskO1vhU2cMxsIYKp+sQglIaQEIUGmkbJV53oELLpboqCXnQbGKkilBCKKLyBndwSqAU/uHhS5vmBKsHqr4OhAWq0Eq29rc3E4N3YabjgeICFBjqNx6RbSiILDYpTwbCAtVoIUEnqr1QRBGxjAn6AMFAR0nBlfhl8GC+qANeYhFQAtWUD17BJUmoohmrFRbSJkyGwKfiFWf1QTuA5DwamW0Ai3fwFWgAUI6SPHhoSqMdRs+jk9L24rXSn2FsaDBeod5KvxuE2xjui6qI8y8zBhCAoDmq6DLZk8iDUbW2LrWkVAEhLa4EyPJ4QvDy+S6K8x5ui4yyuqepZWeBV6V0cFu368ERdejsZAD+3DX+vKACBrcahnOUXduEy+Z1Egen2MqZPV3LHim6zr+ZwE5z3FdX3fGo6cS78qGMfql81id+WGHnfnTL1CHrpJW0Y7FXwnKQDd1XA5HuUDIAd6YY9LPcN07GwxwLL4GD+2DGm0en0iRvxC0Il96haA5+rbCjWTcrLN+pYKA6EGC5hrHLJgldsugek30jYiKd3bHQBvU1q8dsQWXqvRr0xwv6vXEHAz2Nnv2YU+hTMEhLj+D4CsQeBUBKKlSXj18DAux0mG429CIOfK2wzFgT7/RSel7cRE/MqEv1CHnSUt+NQ+uwIG23mCYgQALViRC1OtjP4bnK/Ci/SEt5jQrKOUeQu1w8J7haQYEAjYx/i3zObgL0PHCuArXrB/b3j+v1T+H0lBvBj4s359jYFJmAHnGB/hYHAefy5/M6IgIzeH+HcgpGZiBvwj16f0jSOcGc7hCIjXx0cdJep9JjAKhdCvChSgbeMOd28qeYR1IuYTc3ylZgHLiJC/1Zx+ruymQAKhy7/8ABi6jgMV1uBrLIXVCDjl0UN0IwoLMZTrQErmMOP2ykJJeU0J3czhr54F3DRxrAxaAmptbS7ofRSel7fBYtt8yjRApYQ1CtDbqCJB6TDGknDE++V411FwVb5MN6vGUjBvbUVlFxSIlL/fdea8Lhi1xYF1qAusB7vgZVGbFsUaIYDgwCHLNobGNNOl1aaSPbkEFRZXOFhOxMjl6XwOqhnOqAlkKLh2OHTJrEvle+wvAyWwBncQSIfAW2BIZ9hekdjEJxeSOFTJwp+D1MfQMUJQkQbXUCxz1DTnICy6gSUhNDklVLXwGcwtFRbCcebQeQsahUVg9g7g3vnWlmSM1lppmvworg+Z8aFiVUbrckPLTCFpOWvdIc4O1JAjpKct0sRX+JebNtYQeN3IMBRjLKIjT+3aqUzY31TZhKUmtUxNVNIxy73JiWv3VTcTtQ7X1pv1c0l3+tXcUTH6NMnpe3+gk9L2/0Enpe3z1Q3XKR4PNWTacXWsnzX284Yn07o+as2wqqbBQc8fVVuo+S26aHZHI01Z6EXVJutZPrpPS9vgAuYav0kMEJRVuhDdvejsToIseE7MOxqgByoDEdoQmwUSrkY/8mQe0hs41CUsEAjYyoT5SgrcQf5JdgxwBJnP4XlnPgaO+KAq0EQ2NVok5PibaYtjUQ2u4spkNv540prN3QI4H+7CRBjJj/wBvaTcXbqAiHoN1lzb5uyHRi10EN+1yvHfJReSDQi10E0t5uS/nYWIwPcNJ/AQozqLrQRBGx4A5PLom2PvyXn7VYwqL29StKN7pJVZtViMuPO1UrdsXgVdVTITttVjBSNc2GUwkm8aziEQMxBrOd6tImgs0ULC43b8lGnkDCwCUAypBqwfpIaPFvEQaVqkS3EH/AEl2DHoUma2LQtOCFC+e2MMMm/QLYj4l3djtHbETetJaJHS14C41XCVdIcIyBaC1GCraikfpJPS9vgJAsZl+0RcBTbgATljVshg7U1g6aXhyfXuFjG0uSoquEn9v3gBlecttIcl2bEXGJH98OiekyF7SzWod+i0L4FgJgoFK+IHQ5t6snUmFQyhD7qWwMPKWV6K9W5l3aQsaa8cUag4G27E9PUKL7s7j/b2keFNTRMXdEbGZJvcBFlD3RJTSmiwv5iOZnaKbED+fcsh8WKvjwjQqu3B0m4tEbXtWOK81CufC4OrfTjuzagMyhtVwJfcJyjLMTkEPuQkINvIg9WDKLcSZ+TUD8pZRdwUHZTWoBVTUhAEVvlv1QrUY/wDKI1bVXByjK4u2LF/lkXv1iugBhYRG0E7er+TjOJ2jWtQkWm6Q9OBu/TbxmbOZtGK5Zp6yy8HRIplhE83C31Sl8FIB6n9Z6V9JJ6Xt8GnlgQrB3+Xw11kv7QNJdT4GRLon2+qSIdz96MjGv5s4xIdeFwogmYeoRQMrtCddatw6Ak3kOyCC6zHQd9fRaP09smwQsgMzr+rg9HnoeOH9PacDVzv6u1zvFTNQ6qKYXCi6bsrwSqWHL5LEo39uoObbSEpuFojBB1LFDwKaVq1jNdEczQuBOAflXAgOW9TKOnLc203n6Ex0PqC3DFa2z6Lw+p/t8GQB6z+0Ip/sjCF6J+s9KnpsoI/s+KeVgxp0gkFDeUzn/GLJLuxXzI8uKViRjrX0ZDa6LIYUoQuwQqxQTmPpJPS9vgHxjqmmQhbVJBr06L2tXFbWHPa4u0r3ZaI+52G8NDLtbcM/bbcjtFYtb3Z7S6yyRpo0wI9e7LUT9b9F2sPn244MCXO185aaLVECIIlIxQXWlNhNHu4BDm2aV1GKSqayoiFWaLfDTuFUyHPHZMcirFaHYkZUvZSdHNmz5YTrqHZH8sqnPfZKJ3IYiKNZD3eGpHfVGoJSxnblfhqxTgIABQHDYFTkTKXOtSNG6PQRUtapkYJReqgkn0OglF6vOTwqpJeSdcEaLsRFvOKugqZdtmRcIFatWfYTQcw+GZCKzy03S4qkDeGJxu1dI4FSFi5pGAPBw6o7mXa4ImHYjiOkp75jQh+kXajhQoPbXTdsir8AsnItfAfjZVbuhicbtXT6ST0vb/CAndkUnIhTgxHIPq5PS9v9BJ6Xt80HSxqeIMXVm68Syoca3B5VB3ZYvklztARb49JrO6ofEIhQCr0CWl77YdH1HOXvBLDE5/6IBxE2VjgHU4c0z2MO0AKryCBN9h7G4tPGpElXvtru0gOFjfhEffZupwNMUehvBcSnfh4a92qgJZOz0tkSU2ux4Zh0gCxegRF6GwU01p+ik9L24jeANo2MrZuA3YhnJWkKmjEYPYXK7bROptzLS6mvGGEMEAL3iA2T582QZKNGobENqbRbCDqTrufFB8OSIEC4StpHiYcYPwJIINydZ67+81380simVDZfQnfD7iR9fQydBjcZcaVLTUzgSfJ6Ra8qtYMZcDF2kFmFNb7XjxERlxY7PRhsFsVXVGCC/Bt1pgVPskRp1G0DOANsRgUX2s0eeGwgGmjcIxVLFa2NknWdKWP1jFRB4qxoYV0C2sVwROgOcJMOtMNWodQhuD6p4xJVY4d/X5uVDvD8g2SmmkvLDIGBvWW1Nx7C4jZasvUEV84S2lbg8bitwMsp96WGCXoaSNIznZjbD2h1avVGPLl50bg5o2PBVxdmgLGkh/KO3pvySCjYRgAipz0uH0b3J6XtxHW0A6jLJweFkwXZoqhwJ13kwfO3uhIfLuWsXBuZGFX1LvUtARvQfriYFhCKkb3JdCoaxGbf7wzjY9DhlTzix0uVq6uKIwbfYJaaru6JCnaAlSqt+PHKfxekdTLqaJQNgAFAQbRwMZrbeLnqsJ2pJdRBrEY3m3fzSKpmvewTHJ2kQgEyu+YI1ALbkFgltKivtVlU89ZU5/38kPpzDAdRS1J1Exxr0i454pZApDN2oOl3AuexvPhDbRHR6PK1hHP3NAnwGu2QQ2jqoJVJcnfLEjPQ48BXCoKlwAH8EbBs9WiUzo36JGDKL7I/udEN7e+zEOSyjSMCmXa8dfbVyq5xe77ttqDAaE0r3BxR+ywPY7zOb9FJ6Xt8DrcDSUnQOqbhSr0wXuGfBJejyZYt6tJXMKIZZUtTTq7sPTtPQZYHnmqgDjSpODcnd4xOWXAgreSjr4mPQ+Cad5g8N4adnjQMY0O78NqlK1iH7XWrwUVyZ9yU/g82a7fAIBVDREpPnmoMzQAnqsYfrzRskoMHTMpQZqpLvgRBH8MimLv7IEY0ptAw4A87oI5g0BL13BsIUZ0hoIKspuwKVr4mqw7T5NQyQzrHuIgVSW/om/nKsb4mAg3ks8aVJ3hY3MBJicCjwh+oR2jL/cCEotp+uQj5MV9yE/udI2IoD5n6QEGKVpZBGEL1Pglh/Zh8IXWi50Tuxy3rEnbgsldFhAkGklS4NXJ+RGyDfRMnpe3wDm12Bu6lwAKJZrylLurw7DmIesMR3MAenDtwYx6zeO3lPtDi4ogB0CMzjaEL1xE7RtFjGqd2in8TQUBTyPBMq2ZPswEe0ECnSoxvW6AvwRh52SeURPXpSS+lwsABQBQQ/wBYsesInGgKDj/E0JZAAAAaCBOobBCZFoFBw9VgRAR/UnXd5DwoeCgJ5nh2wKQ9YI5bdP6cH6ZsA9Zd9yR/TgMI9CHrCE6EP9OBwMcj/aHdsyHpwDMZqn94Rioprx7kJASghTpROmZRD046cFSnynBelylPmogiJYxkUbQheuJ2LGQ/DFqJdnydiLFi0BXq1D3JQBE7jAAxQYPsQHIVoJXq1EjjoSM7vCxz7ZpdWuDS080P5jygzwB1LpXSzgblqBYnRGGDLRg+x9FJ6Xt/wgIPMmcoM+/7qT0vb/QSel7fB1hFX56vSY2huDePOXlUMrbq94uHaeYfEB50NKTMb8GjCPkIs5Jh+lQxRQfLZ/4dUgkO9Nr1A9VlG4ru1P3PmI+EgdM6AsFU8Rbaz/WSel7fAo2lDRojIUpBlaFHkxN71ojNHpzkk7baTZ7IS/q6owVnHnRCGCxwG650wCbUVx5ctxUJ2HVtYwAHHHGwmCyVGS3sZwjN2/eYIZipfSiogN6ggjk0i3JpI5c5FeJmPcJLylSk19uoJKI6Slx88se5th9Kpk42hcjogV4whbJB6g+t1CAXltrP7nRHBgvPmV/E434ofirLXqE5uY0juteuAMt+kx9iIpFSI4/GYp20ReFixFqs2f19p9Bn8vpwed4uipbWBDsiGXXqAjXVoMhHigrxnHNbd+BlHxh5IT7k/wCxgCzejBHVHxgW1QMAX0SxfF1Pk5bDrqYsjBS5bfjUNi9oNS9j/AOKpgUgADhLGEbrQqcEelz7E8Wl45IeFF7fqjwUlO1KPz5PS9vg6isBX2fqho2anq5kDec6HNlqucVBtCgbus7IACrxGURrRgHzJJErdUUx7EjK27u3yuLvQfvwe4/fgsWLH8ziQckA3b2ZDCfwdcoLR0JxmMxtGW2AqiLGdv2Nk/SeCC6scxRyxNasQiCrq14gvdP4eeoRH8DCBpvOrVo9WXya0UIVNl6415F4B4rT60al/R8inq7z8sYK9X7z+vtP21n8vpwLvhwP526QOria1q3UtTb54zAeR7dwmLmSMfYpEswY+05Wf71oY8Dw8HLVQ9LmSkw/TSO9N5hUDQuvALgD70gZdu6GPOE2v/5eAuv++kQE8+Ht6XH58npe3wC5x1apEqivtSAITJ3DSC4raLeZJ3WuFhv5T7YD33IfpCxD0ow+uFSkecxFQ2g/W1KoVZGeXdnUjP2vILf7Sm4OLZPStQKtdPqLXya3W5FG9CUJlGW9T4NSiCwjphMs8JT3CdTvxKVaXTSXLAGtVsToIXZiNXppGp0fMczvW+SIEMC4uQZnfMHd4dhYGgx3azFXQiPMc6iBIm5XjDfR1bcoQAY4u6ksyqFY/OkgOkPxUyhMdPBFmERUNpRgWZb1IPtnWhAmKQHtRwsv6Xnq5KbswNzUui9sURGmYtuFfHmmiKzZmD8+fewUJtgcM9UIUS6O21UAQp7ZCkFxcK20dzJKvXIAfYCqoIaUwwhHCXxCFdpsqD04EERLGWSgAaAXAAFAUTBRK0IEwtmnlermXMZehEKcg5ac0RcINCqnz5PS9voQunkBTkex/wAX1n9vo3urxyIS1jeN+mk9L2/62o8Enlfow3ZQBHyM1FiMHgPppPS9vkA2CdT6oBQA5sESzioCsAEE6n1Q6gFNg/Xyel7cUZRtWggNo0Gxmy+SBeFHZcmybxETjtsCetWCsJUWjmkekhytnM1C6VfQeKAUgE7APA1BkEJbVQ8TcswAsux2hAwRBGzjX/ZQgDxXWV+YdeDAbIiDjSoQY8MG1aCD2rSWQMyPQJ3QwNk3S1ULPa4KNzpAndRA2Qla3LTwxm7QteMrz+qCDX4cZcaAWqSOGtGmXRKUuotEeRnnQ8K0mqAKeaigpAC1Z3H4hIVZ/VBKkHqh4lWf1QQ54Q0kUr1ktVGwuotEtbQ5AzUuUFPMaiotpSa4m6qeajQQ5rRLsZ50PwUQpupBQmeEbqRBKYHO3ecrQrTFvtKkfWFyyrnbFgLwAUAObLUboC/DgXjtzcaIAvgmVOVYCC1HSgJWCdRs4GlbkAx/U0UGJWVq7Wvlyel7cSLED8umX0XoY56wwsy11A0Rq+cPOkEJfDMYw90n2QoVtosGD+u75VYCxntEZqRovG+HeF1URPl9kEL4BQNKpAtW+PLSFDhvSF0IrvvBU6KfrYiO5xj5YJ6d+dMvUY6/nwhz8pAXZQJTr+lljw/3rlmIT1MA/wBhXnSGIivcpzdsmyWH2kWUmPjGNZFXgzUvcUOlQLXoDjkZO0yZXlbhSVZC/ChGYAj+XPORMBLj+HyGFtwhvv7YGpSeZTKId/Wj1SkK9o6H7XTDEcZ0jkwezOlqNjY7NmAgiSrsS1PTtlGcENwgUIV4/lWXX2rjUMmRwTngK7KRhu7Na80tylcuqxAfRZvF2Ji9Wb1f50yP1ti4iOPmpxVaQFtYVprkxcBGJu0i8MugC9Psha0lLutRGIh7a84JShVi8Fp2uuT/AGOny5PS9vgzMp02KLvCx6uZPKonzvgkgCOgKOpKPJT/AEevgn0/6+KUqRnvFRMQIAFqwqyR1aN8fQp14E9IsXjWh2wUk7vaWoIMO1IZioBVhGp6pEBpki3oyoGRumeTFK2FSLkykMe0k1tzGwepZ/EgINrzAjMrORzVZqSPLUk0QZ8pg6nqS+AsSvatLdCMLmWw1AB29aAmqP5q9mAlLF4c1L9riDbcgoFkIGIMPMaENQ0miUiScUUlDQBDmo74ZnOj9qAhB70NyjM61ilUcoNVE00NPeuAPE8JhP5cEVJvJoVfz4x+fQ+RNfVOGvKVRDZYUCnngVd6+hqBEEbHTBeu0PJjGK3pvanpsxrQoJjSSle6Yc4M/kdPlyel7fBzH/6qG6FcdBU61YUmAaknQsQ+L5ZVKM6HMljBqDYKGYQ0dy2qUFyhL6UGa56pKOBC4Ia/TGDA9eV411LEZ73A51g35gOAgGFaR2RHRXonDNG65OGRszw5JulZtYcEy3kota5Xp81yAu6biYbAtnrOZR/Oz0g5wpxsMCl9KY15+NqVGAFe+SadglQ0r2rmEaKy62xgJFzLg72XAQLkcfIIf2B3IbLohklDBc7yyqUYId70xbP3qbgglMzStjwpuQGojpN92mGft/za8o4EmS3hNhMuzh5ECFoplg7lEFWKNEDYsAdcEYtf5/he0mazsmBSiZ056s2cwoS5bu08FrHdqFN4VB8xecw2oECD9UqF1L+FIld4OdUP2zKqzXfTwNAsXY5VeCutIDJfcr1WNpqCqoRgVo00qDgWV7FGAfsXBm3Id1FQN7yHKg5yCmlHy5PS9vr8l91bzQaN5D6zDsGRS5EABQFB8wG1grBIYUoGgNH00npe3+gk9L2+aeNxWgMqwehqX2Y+Rs269E1HHVGF/Tg6WRoCdrtzPyFAV0R8YdvL51W8oqvCnp4qAq0E59DrXBGABVeQRU0fcn6KT0vb4GzkYx7S4GIihKVlCp3u8ARep6G7wpync8Wq+DIRxvDQBWpWCXjCdIudltQPzKAtoImOAqBtNECV492TkHl2Q1o4vwjx/wBtHDamRauEbMt0knIiqxI/6rLbDZtWr8BvNaLEiQ7JQNRuA3D70lnQdC3SA7SgBKgiCRtqzavaQFKKEJWUKne7wBF6nobsWxFgLabYb+gorVRlZlkWWo44ZFDcu0j14E8QCHyGoTdKqih1RmBleihFkml6ty+CXmtoUMPkUWJkYOkRexQjdNGyFlDJNIJkdVSokoYvspvL80pQ5FxAZ81VwMLrq/ApI2ixI1/IoVbth9T96RAeKrE4HZyIGusjJuqmyc5A7droIbAelzvwk7OFUKr0qM0JKkdVSm0NN6dr9JAXKhRvEQliU9xitlKVphyLgKS6xEiSjCrZctu4AO1qEZ6J7tl8EGgirBWZltlKeZc7+a64K2WGgn/Vs+BL4U0KFg4gWJp+VJ6Xt8AUuaJTaQG/a3c05GcSsrI75M7nSmeCmixJrlQSzCObqlVO+Vrk16igt5xa9NP/AJyYosQni0wqhLxhhQqnfDhVdrXeGXRil/mIFKeu6XKqqFgN4sQF3V+nAUz4SMCUo2C7hIh4dSLLubNySPaAO4EjhkVvSMAwQ1rUfcqDjdRIKa1n78F/+djCSM/cxRmBKt02kOx2tjNORnErKxjNWqTed5cxo9f3Z66NvtpNRHVr68t1hLt53zgIAPOc1KnZYBCFUDt2BAjGXaQg0Opg+tQUXdUmGGZTZg+FNoVn7Q35Meld0ixrhoIB9yLtW28oXLGYNUjFecpAHe4yDf8AupwU0GFSwTB7S8fJCaKDavUV5XAEX+ZtG7t34eh/XwfE89mTuxUJ9/WJNe9eaquGzzQJXDDswIVyNQWu0/mdEt+6HY9dUA90JDPv1sKBM2AC8pR+Taa9Jj15TCttZcWVbXdi+VJ6Xt8MIQ6ftx1/FnGXymTto7q1gytVrVI4+G7gwz8uM78Zdr+/iR5sd3K3Ee0/k1LL74IeV/Nm2sDTdp9F4NV5cvOg50MVMW4Veq+CeXM3uhzN8Ehbhbr7Ksb4NmJr+tgKviLRWDKn8dce/wADrgFunCwhDp+3HX8WfA/JyrzKwo01gsuGmbG9AgYVOm9rwdhCc81Fwc2tTLyQQKNmCoquCBxxYXBhIP6AIk5RhgPL9EaEWJ/NBmnlloab8DNXMFYT4lZzh+D58rKp+jHC0dViEaaOTTqoLV0wxRZ2lfD0P6+HTT+zCAQmHn/fK/khL1rfwIAfi2I/mdEt2udGamgBWFyJuJGEj5St+9G1rMTF2uQ9GVz7tovkExPdmwa+Uk9L2+DqHk2ZaHTA000zGkxuFcxjEt8hEuyDW1CvnIshXkAtXDqux7o3sUJunTTFmrTMtXDjQAwY1nrx8AAAAaOBnUlUV9+nTZV0QHwUqyiOeKHplsoHC9YzTg8egIUNN0rwMAqu3mwYsaFQE3gOcujRwR3JlxfaXJ4naaaaiqoBmFrivW29ntLQ6YGmmmY0mNwrmNKl5RHvpL1tQ7su1koYdTltOb9k3hheG1ZlsxXTbqgjNPtllJln57Foap/bgTCVYRAqAoDABC0RKMUjnbFuTviMszIpF6jHgdq91UEv6kMzuetseow31fOk+l0SgJRrQdiA1wXzL9lrXgCU7pgyp5bxKWVBsYf17nWYwuGnHCdK1yu+a9dBUX22ziLyr16movk2rbZXBAvJZM50XqMeZ3pfuqiC22cQMJbX0GXDoBTIb+LGxI19og7E5kyEtlYSvPdiDprNk4KVgAoA+VJ6Xt/oJPS9v9BJ6Xt8DLrplq1TKJbLZIu+3OHz87O21tUFW5O6S4CZdG6hwuZfuh6CAAbEsYZNY6sUH51Beuqm/gY+bRA5sub/AGbVNR1d262GeKfxuzDq6sPxgiumqUPiJNYvoFq2WONOsH18npe3HP8AVvq96mZ/V8vaZsybbxafke51D42CMQaiNAQ9mqDEljW+ZcW/7WOWGYh00hkCxqQs5BrugYkP6OxgY0kaA5yjnbROF5w2IAr6fr4asOBM5Fx36Qfh2L3JEpTAmVKhBneLuqMOpafZbGb4TF9oh5uDG0+0s6glnOsuJmKUU3xrmIgxd7XWo3iIRagZQK+NpqJZEGbgcWolvuF+0jW56KWElg83+GUw4Vj3D02zPrOmSg/0Cd0UcwgdSCru2EU52F+wpKkFK88iHOpTnYajwMSGN+euhAvQxWKSrO+uQcPZsBAUT5hpjd8qM5IlPPRHCFix4Sq0I/C2cGcymp+v5PS9vhn9TgyRedqsqpB88EiPQ7dJruan0u5U6mVhCaYO7HB0LpzSyRnOhM4RXaRzerKAKOd6R4BNwvAOFc7gYezSpR/zrw1YcCCeHMm/2QU5yPUINRRSOkgYyL7YQr9rNLDVA6Hgg/FmY1M+UEYK3byBn6H8WIq/kwg8jfOS/RwViM2X3hknvRJ5yAAAqqqCYXw8KVZOpUCrc/BYbMcAoAI0U7ic2AP47kYNFvSwd+HDiD1JfdzOpws40+SgHAgBgAgPGpVLFZJjwY+zIZAwAoAlKlkDLSVyrmBrAoAoAhkTJOacIXr+v/wDSel7fBSSPmiWY8FVRU9bmp6x1i7HJZKwKoMOZ5jsENNoA9TCoKlMMKrq7K5FiO2DHl4imKl/KYKJyeLAAT6aYEvABAgtyvVCDbY/X+DXNLoWdJney0r4L34SZBEYb0JyygeZquCT/wDEZaMkORWtA3vbdzaWEc0fpw412d3g/cxwFDZoujrj+vt8FmZAnq1KaSDWWd1uono8T+LtBT+O5VrRtmHsIOg1VEH2TfBPGofNI4lymZg60dHpc9J4XpcN5Tj3FpnQpbOc7Gvl4se/BzqhQqa1xLFTXRT66T0vb4CQrdU1/MCdflGp0qa8lMD7EyPS6BvwwEAAUAUExg3Y/adopIenGqz6EPWdipIek9BleerGDHedr9oenA4OmV/tO0Y0PSaguMnkZXhwIAdAikItCV6tcEACJSMwi1KYPcirqVrDj0vg4s7H8lNwQkJWHHpwK2rYWRY/5rD+OD9i2FjA+kZ2gqtWglerUzFXXMAL+2Cv4iY2S8OQdGvieBgIqEnmeNLYRELHMWIrLaNPqXrg83GkKTszIodp2dS+KwoAAAA0HHvTamAAAGgibDsdPsuuBxVisOPS+HlrHrInsLRrxvXCodZswL1uKZipQh2frpPS9vnsvXjYg16AH2+mIm2lMnZlwUXnppCYNQH/AGJPS9v9BJ6Xt/oJPS9v9BJ6Xt/hj701aGCPocKNGxiC3kO/wA3UHaWX8DbYoqNK6pEJ5uiWnRiCMeWeOqb6h6jDFXBUWWtENTU4IjccTURh4b8W3LH4pbL2/wAMmjTa8xFc3hwAGYdKaeVNy2IHyLMzaXLf/AQmJO64RqCmkmQqDLudzDa6VyrGb/QADSRFTcAAnX9KcuYt0ldHdNMZZWnVTcCRrZ09YQsBgh4YNQUS8lrGXlzPwXp6cBEa/wAKzSgLWArdWZgiVWVYU3iKTWHoVE9zl9oBXpCg5e/2xC3k+6UDsT6EglfYmzi1CjxoSwhc5qsMKYUXwFFckzZ4F0PsAZYJZKK/W7Earkh3qtbFwozuo6PwzmcjHC6rZkhl1MP+EPWwpIZMLdFwmp1SzsTJifU7lsaUmVtW7hptYQl6pYXNQ2bos+IEaHVm9VGiU6s9KhQhWWpAQUGiAGMEIINl1AbhRyUcovc1rhTgu2RDT3IYAqon5hcAAAAaCFUBarXeS/Bbv4mfd8XNc3AFj/mkC2Bua/AglM3U6Jjsn+Y1OXpBF49EACj4tzHWggGhO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SdpO0naTtJ2k7SW7EaM3ia34H/2Q==",
// //chatMessage.base64Image!
//       );
//     }
//     return SizedBox(
//       width: double.maxFinite,
//       child: IntrinsicHeight(
//         child: Column(
//           crossAxisAlignment:
//               yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment:
//                   yourMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
//               children: [
//                 !yourMessage
//                     ? Obx(
//                         () {
//                           Map<String, dynamic> order = {};
//                           order = AppFirebaseService().orderData.value;
//                           String imageURL = order["customerImage"] ?? "";
//                           String appended =
//                               "${Get.find<SharedPreferenceService>().getAmazonUrl()}/$imageURL";
//                           print("img:: $appended");
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 3),
//                             child: SizedBox(
//                               height: 35,
//                               width: 35,
//                               child: CustomImageWidget(
//                                 imageUrl: appended,
//                                 rounded: true,
//                                 typeEnum: TypeEnum.user,
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                     : const SizedBox(),
//                 const SizedBox(width: 5),
//                 Container(
//                   // padding:
//                   //     const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                         color: yourMessage
//                             ? const Color(0xffFFEEF0)
//                             : const Color(0xffDCDCDC)),
//                     color:
//                         yourMessage ? const Color(0xffFFF9FA) : appColors.white,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: const Radius.circular(10),
//                       topLeft: Radius.circular(yourMessage ? 10 : 0),
//                       bottomRight: const Radius.circular(10),
//                       topRight: Radius.circular(!yourMessage ? 10 : 0),
//                     ),
//                   ),
//                   constraints: BoxConstraints(
//                       maxWidth: ScreenUtil().screenWidth * 0.8,
//                       minWidth: ScreenUtil().screenWidth * 0.27),
//                   child: Stack(
//                     alignment: yourMessage
//                         ? Alignment.centerRight
//                         : Alignment.centerLeft,
//                     children: [
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           chatMessage.base64Image != null // && yourMessage
//                               ? Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                       child: Container(
//                                         width: 4,
//                                         decoration: BoxDecoration(
//                                           color: appColors.guideColor,
//                                           borderRadius: const BorderRadius.only(
//                                               topLeft:
//                                                   const Radius.circular(4.0),
//                                               bottomLeft:
//                                                   const Radius.circular(4.0)),
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             0, 4, 8, 4),
//                                         child: Container(
//                                           // constraints: BoxConstraints(
//                                           //     maxWidth: ScreenUtil()
//                                           //             .screenWidth *
//                                           //         0.62,
//                                           //     minWidth: ScreenUtil()
//                                           //             .screenWidth *
//                                           //         0.27),
//                                           decoration: BoxDecoration(
//                                             color: appColors.white,
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 5, top: 4),
//                                                 child: Text(
//                                                     yourMessage
//                                                         ? "You"
//                                                         : "User",
//                                                     maxLines: 1,
//                                                     style: AppTextStyle
//                                                         .textStyle12(
//                                                             fontColor: appColors
//                                                                 .guideColor)),
//                                               ),
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 child: Image.memory(
//                                                   bytes!,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : SizedBox(),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 10, top: 5, right: 10),
//                             child: Wrap(
//                               alignment: WrapAlignment.end,
//                               children: [
//                                 chatMessage.message == razorPay.value
//                                     ? RichText(
//                                         text: TextSpan(
//                                           text: chatMessage.message ?? "",
//                                           style: AppTextStyle.textStyle14(
//                                             fontColor: Colors
//                                                 .blue, // Set the color for the link
//                                             decoration: TextDecoration
//                                                 .underline, // Add underline to signify a link
//                                           ),
//                                           recognizer: TapGestureRecognizer()
//                                             ..onTap = () async {
//                                               final url = chatMessage.message;
//                                               if (url != null &&
//                                                   await canLaunch(url)) {
//                                                 await launch(url);
//                                               } else {
//                                                 // Handle error, e.g., show a message that the URL can't be opened
//                                               }
//                                             },
//                                         ),
//                                       )
//                                     : Text(
//                                         chatMessage.message ?? "",
//                                         style: AppTextStyle.textStyle14(
//                                           fontColor: yourMessage
//                                               ? chatMessage.msgType ==
//                                                       "warningMsg"
//                                                   ? appColors.red
//                                                   : appColors.textColor
//                                               : appColors.textColor,
//                                         ),
//                                       ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: chatMessage.id.toString() ==
//                                     AppFirebaseService()
//                                         .orderData["userId"]
//                                         .toString()
//                                 ? 10
//                                 : 0,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 20, top: 5, right: 20),
//                             child: Visibility(
//                               visible: chatMessage.id.toString() ==
//                                   AppFirebaseService()
//                                       .orderData["userId"]
//                                       .toString(),
//                               child: CustomButton(
//                                   color: appColors.guideColor,
//                                   onTap: () {
//                                     log("fjdfkdjfkdjkdjkfjd");
//
//                                     print(
//                                         AppFirebaseService().orderData["lat"]);
//                                     log("fjdfkdjfkdjkdjkfjd");
//                                     // Parse the date string to DateTime
//                                     DateTime date = DateFormat('d MMMM yyyy')
//                                         .parse(AppFirebaseService()
//                                             .orderData["dob"]);
//
//                                     // Format the DateTime to 'dd/MM/yyyy'
//                                     String formattedDate =
//                                         DateFormat('dd/MM/yyyy').format(date);
//
//                                     final dateData = DateFormat("dd/MM/yyyy")
//                                         .parse(formattedDate);
//                                     DateTime timeData = DateFormat("h:mm a")
//                                         .parse(AppFirebaseService()
//                                             .orderData["timeOfBirth"]);
//                                     Params params = Params(
//                                       name: AppFirebaseService()
//                                           .orderData["customerName"],
//                                       day: dateData.day,
//                                       year: dateData.year,
//                                       month: dateData.month,
//                                       hour: timeData.hour,
//                                       min: timeData.minute,
//                                       lat: double.parse(AppFirebaseService()
//                                           .orderData["lat"]
//                                           .toString()),
//                                       long: double.parse(AppFirebaseService()
//                                           .orderData["lng"]),
//                                       location: AppFirebaseService()
//                                           .orderData["placeOfBirth"],
//                                     );
//                                     log(params.day.toString());
//                                     log(params.month.toString());
//                                     log(params.year.toString());
//                                     log("${params.toString()}");
//                                     Get.toNamed(RouteName.kundliDetail,
//                                         arguments: {
//                                           "kundli_id": 0,
//                                           "from_kundli": false,
//                                           "params": params,
//                                           "gender": AppFirebaseService()
//                                               .orderData["gender"],
//                                         });
//                                   },
//                                   child: Text(
//                                     "View Kundli",
//                                     style: TextStyle(
//                                         color: appColors.guideTextColor),
//                                   )),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(4.0),
//                               child: Text(
//                                 messageDateTime(
//                                     int.parse("${chatMessage.time ?? "0"}")),
//                                 style: TextStyle(
//                                     fontSize: 7,
//                                     color: appColors.greyColor,
//                                     fontFamily: FontFamily.metropolis,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             ),
//                             // if (yourMessage) SizedBox(width: 8.w),
//                             // if (yourMessage)
//                             //   Obx(() => msgType.value == 0
//                             //       ? Assets.images.icSingleTick.svg()
//                             //       : msgType.value == 1
//                             //           ? Assets.images.icDoubleTick.svg(
//                             //               colorFilter: ColorFilter.mode(
//                             //                   appColors.disabledGrey,
//                             //                   BlendMode.srcIn))
//                             //           : msgType.value == 3
//                             //               ? Assets.images.icDoubleTick.svg()
//                             //               : Assets.images.icSingleTick.svg())
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

  Widget audioView(BuildContext context,
      {required ChatMessage chatDetail, required bool yourMessage}) {
    RxInt msgType = (chatDetail.seenStatus ?? 0).obs;
    return GetBuilder<ChatMessageWithSocketController>(builder: (controller) {
      return SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment:
              yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: 230,
              padding: const EdgeInsets.all(8.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3.0,
                      offset: const Offset(0.0, 3.0))
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
              ),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // AbsorbPointer(
                  //   absorbing: controller.isAudioPlaying.value,
                  //   child: VoiceMessageView(
                  //       controller: VoiceController(
                  //           audioSrc: chatDetail.awsUrl ??
                  //               "" /*?? chatDetail.message ?? ""*/,
                  //           maxDuration: const Duration(minutes: 30),
                  //           isFile: false,
                  //           onComplete: () {
                  //             controller.isAudioPlaying(false);
                  //           },
                  //           onPause: () {
                  //             controller.isAudioPlaying(false);
                  //           },
                  //           onPlaying: () {
                  //             print(
                  //                 "value of audio playing ${controller.isAudioPlaying.value}");
                  //             if (controller.isAudioPlaying.value) {
                  //               Fluttertoast.showToast(
                  //                   msg: "Audio is Already playing");
                  //             } else {
                  //               controller.isAudioPlaying(true);
                  //             }
                  //           }),
                  //       innerPadding: 0,
                  //       cornerRadius: 20),
                  // ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (controller.selectedIndex.value == index) {
                            if (chatDetail.isPlaying!) {
                              controller.audioPlayer.pause();
                              chatDetail.isPlaying = false;
                            } else {
                              if (controller.durationTime.value.inSeconds ==
                                      0 ||
                                  controller.durationTime.value.inSeconds ==
                                      controller.currentDurationTime.value
                                          .inSeconds) {
                                controller.initAudioPlayer(
                                    path: chatDetail.awsUrl ?? "",
                                    index: index);
                              } else {
                                controller.audioPlayer.resume();
                              }
                              chatDetail.isPlaying = true;
                            }
                          } else {
                            if (chatDetail.isPlaying!) {
                              chatDetail.isPlaying = false;
                              controller.audioPlayer.pause();
                            }
                            controller.selectedIndex.value = index!;
                            controller.initAudioPlayer(
                                path: chatDetail.awsUrl ?? "", index: index);
                          }
                          controller.update();
                        },
                        child: Container(
                          height: 33,
                          width: 33,
                          decoration: BoxDecoration(
                            color: appColors.guideColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            chatDetail.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Obx(() {
                      //   return ;
                      // }),
                      SizedBox(width: 5),
                      // Obx(() {
                      //   return ;
                      // }),
                      Center(
                        child: Container(
                          height: 22,
                          width: 150,
                          child: WaveformProgressbar(
                            onTap: (double) {
                              chatDetail.progress = double;
                              var cutSecond =
                                  controller.durationTime.value.inSeconds *
                                      double;
                              print(cutSecond);
                              print('cutSecond');
                              Duration newPosition =
                                  Duration(seconds: cutSecond.toInt());
                              controller.audioPlayer.seek(newPosition);
                            },
                            color: appColors.guideColor.withOpacity(0.4),
                            progressColor: appColors.guideColor,
                            progress:
                                double.parse(chatDetail.progress.toString()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    // bottom: 0,
                    right: 0,
                    top: 27,
                    child: Row(
                      children: [
                        Text(
                          messageDateTime(
                              int.parse("${chatDetail.time ?? "0"}")),
                          style: AppTextStyle.textStyle10(
                              fontColor: appColors.black),
                        ),
                        // if (yourMessage) SizedBox(width: 8.w),
                        // if (yourMessage)
                        //   Obx(() => msgType.value == 0
                        //       ? Assets.images.icSingleTick.svg()
                        //       : msgType.value == 1
                        //           ? Assets.images.icDoubleTick.svg(
                        //               colorFilter: ColorFilter.mode(
                        //                   appColors.lightGrey, BlendMode.srcIn))
                        //           : msgType.value == 3
                        //               ? Assets.images.icDoubleTick.svg()
                        //               : Assets.images.icSingleTick.svg())
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget giftSendUi(BuildContext context, ChatMessage chatMessage,
      bool yourMessage, String customerName) {
    print("giftsend called");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          yourMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        !yourMessage
            ? Obx(
                () {
                  Map<String, dynamic> order = {};
                  order = AppFirebaseService().orderData.value;
                  String imageURL = order["customerImage"] ?? "";
                  String appended =
                      "${Get.find<SharedPreferenceService>().getAmazonUrl()}/$imageURL";
                  print("img:: $appended");
                  return Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: CustomImageWidget(
                        imageUrl: appended,
                        rounded: true,
                        typeEnum: TypeEnum.user,
                      ),
                    ),
                  );
                },
              )
            : SizedBox(),
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
                color: yourMessage
                    ? const Color(0xffFFEEF0)
                    : const Color(0xffDCDCDC)),
            color: yourMessage ? const Color(0xffFFF9FA) : appColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(10),
              topLeft: Radius.circular(yourMessage ? 10 : 0),
              bottomRight: const Radius.circular(10),
              topRight: Radius.circular(!yourMessage ? 10 : 0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: SizedBox(
                  width: ScreenUtil().screenWidth * 0.6,
                  child: Text(
                    "${customerName.capitalizeFirst} have sent ${chatMessage.message!.contains("https") ? "" : chatMessage.message ?? ""}",
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.red,
                        fontFamily: FontFamily.metropolis,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(width: 10.h),
              SizedBox(
                height: 32,
                width: 32,
                child: CustomImageWidget(
                  imageUrl: chatMessage.awsUrl ?? '',
                  rounded: true,
                  // added by divine-dharam
                  typeEnum: TypeEnum.gift,
                  //
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget imageMsgView(String image, bool yourMessage,
      {required ChatMessage chatDetail, required int index}) {
    // Uint8List bytesImage = base64.decode(image);
    Rx<int> msgType = (chatDetail.seenStatus ?? (chatDetail.type ?? 0)).obs;
    print(
        "chatDetail.type ${msgType.value} - ${chatDetail.type} - ${chatDetail.seenStatus} - ${yourMessage}");

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3.0,
                  offset: const Offset(0.0, 3.0),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            constraints: BoxConstraints(
              maxWidth: ScreenUtil().screenWidth * 0.7,
              minWidth: ScreenUtil().screenWidth * 0.27,
            ),
            child: yourMessage
                ? chatDetail.downloadedPath == null
                    ? GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteName.imagePreviewUi,
                              arguments: chatDetail.message);
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4.h),
                            padding: const EdgeInsets.all(8.0),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 3.0,
                                    offset: const Offset(0.0, 3.0)),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                            ),
                            constraints: BoxConstraints(
                                maxWidth: ScreenUtil().screenWidth * 0.7,
                                minWidth: ScreenUtil().screenWidth * 0.27),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0.sp),
                                  child: CachedNetworkImage(
                                    imageUrl: chatDetail.message ?? '',
                                    fit: BoxFit.cover,
                                    height: 200.h,
                                    width: 200.h,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                                horizontal: 6)
                                            .copyWith(left: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomRight:
                                                  Radius.circular(10.r)),
                                          gradient: LinearGradient(
                                            colors: [
                                              appColors.darkBlue
                                                  .withOpacity(0.0),
                                              appColors.darkBlue
                                                  .withOpacity(0.0),
                                              appColors.darkBlue
                                                  .withOpacity(0.5),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Text(
                                          messageDateTime(int.parse(
                                              "${chatDetail.time ?? "0"}")),
                                          style: AppTextStyle.textStyle10(
                                              fontColor: appColors.white),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    : Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteName.imagePreviewUi,
                                  arguments: chatMessage.message != null
                                      ? "${chatMessage.message}"
                                      : "${chatMessage.awsUrl}");
                            },
                            child: Image.network(
                              chatMessage.message != null
                                  ? "${chatMessage.message}"
                                  : "${chatMessage.awsUrl}",
                              fit: BoxFit.cover,
                              height: 200.h,
                              width: 200.h,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6)
                                  .copyWith(left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10.r),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    appColors.darkBlue.withOpacity(0.0),
                                    appColors.darkBlue.withOpacity(0.0),
                                    appColors.darkBlue.withOpacity(0.5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    messageDateTime(
                                        int.parse("${chatDetail.time ?? "0"}")),
                                    style: AppTextStyle.textStyle10(
                                      fontColor: appColors.white,
                                    ),
                                  ),
                                  // if (yourMessage) SizedBox(width: 8.w),
                                  // if (yourMessage)
                                  //   msgType.value == 0
                                  //       ? Assets.images.icSingleTick.svg()
                                  //       : msgType.value == 1
                                  //           ? Assets.images.icDoubleTick.svg(
                                  //               colorFilter: ColorFilter.mode(
                                  //                 appColors.greyColor,
                                  //                 BlendMode.srcIn,
                                  //               ),
                                  //             )
                                  //           : msgType.value == 3
                                  //               ? Assets.images.icDoubleTick
                                  //                   .svg()
                                  //               : Assets.images.icSingleTick
                                  //                   .svg(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                : FutureBuilder(
                    future: getDownloadedImagePath(chatDetail.id ?? 0),
                    builder: (context, snapshot) {
                      return (chatDetail.downloadedPath == "" ||
                                  chatDetail.downloadedPath == null) &&
                              snapshot.data == null
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0.sp),
                                  child: ImageFiltered(
                                    imageFilter: ImageFilter.blur(
                                        sigmaX: 5.0, sigmaY: 5.0),
                                    child: Image.network(
                                      "${chatDetail.message}",
                                      fit: BoxFit.cover,
                                      height: 200.h,
                                      width: 200.h,
                                    ),
                                  ),
                                ),
                                if (chatDetail.message != null)
                                  InkWell(
                                    onTap: () {
                                      chatController.downloadImage(
                                        fileName: image,
                                        chatDetail: chatDetail,
                                        index: index,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            appColors.darkBlue.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.download_rounded,
                                        color: appColors.white,
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ).copyWith(left: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10.r),
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              appColors.darkBlue
                                                  .withOpacity(0.0),
                                              appColors.darkBlue
                                                  .withOpacity(0.0),
                                              appColors.darkBlue
                                                  .withOpacity(0.5),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Text(
                                          messageDateTime(int.parse(
                                              "${chatDetail.time ?? "0"}")),
                                          style: AppTextStyle.textStyle10(
                                            fontColor: appColors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () {
                                Get.toNamed(RouteName.imagePreviewUi,
                                    arguments: chatDetail.message != null
                                        ? "${chatDetail.message}"
                                        : "${pref.getAmazonUrl()}${chatDetail.awsUrl}");
                              },
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0.r),
                                    child: chatDetail.message != null
                                        ? Image.network(
                                            "${chatDetail.message}",
                                            fit: BoxFit.cover,
                                            height: 200.h,
                                            width: 200.h,
                                          )
                                        : Image.file(
                                            File(chatDetail.downloadedPath ??
                                                ""),
                                            fit: BoxFit.cover,
                                            height: 200.h,
                                            width: 200.h,
                                          ),
                                  ),
                                ],
                              ),
                            );
                    }),
          ),
        ],
      ),
    );
  }

  Widget kundliView({required ChatMessage chatDetail, required int index}) {
    String convertDate(String inputDate) {
      try {
        // Define the input and output date formats
        DateFormat inputFormat = DateFormat("dd MMM yyyy");
        DateFormat outputFormat = DateFormat("dd/MM/yyyy");

        // Parse the input date string to a DateTime object
        DateTime parsedDate = inputFormat.parse(inputDate);

        // Format the DateTime object to the desired output format
        String formattedDate = outputFormat.format(parsedDate);

        return formattedDate;
      } catch (e) {
        // Handle any parsing errors
        debugPrint("Error parsing or formatting date: $e");
        return "";
      }
    }

    DateTime parseDate(String dateStr) {
      try {
        // Define the input date format
        DateFormat inputFormat = DateFormat("dd/MM/yyyy");

        // Parse the input date string to a DateTime object
        DateTime parsedDate = inputFormat.parse(dateStr);

        return parsedDate;
      } catch (e) {
        // Handle any parsing errors
        debugPrint("Error parsing date: $e");
        return DateTime.now(); // Return the current date as a fallback
      }
    }

    return InkWell(
      onTap: () {
        log("fjdfkdjfkdjkdjkfjd");

        Get.toNamed(RouteName.kundliDetail, arguments: {
          "kundli_id": chatDetail.kundliId ?? chatDetail.kundli!.kundliId,
          "from_kundli": true,
          "birth_place":
              chatDetail.kundliPlace ?? chatDetail.kundli!.kundliPlace,
          "gender": chatDetail.gender ?? chatDetail.kundli!.gender,
          "name": chatDetail.kundliName ?? chatDetail.kundli!.kundliName,
          "longitude": chatDetail.longitude ?? chatDetail.kundli!.longitude,
          "latitude": chatDetail.latitude ?? chatDetail.kundli!.latitude,
        });
      },
      child: Card(
        color: appColors.white,
        surfaceTintColor: appColors.white,
        child: Container(
          padding: EdgeInsets.all(12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: appColors.extraLightGrey),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    chatDetail.kundliName?[0] ??
                        chatDetail.kundli?.kundliName[0] ??
                        '',
                    style: AppTextStyle.textStyle24(
                        fontColor: appColors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatDetail.kundliName ??
                          chatDetail.kundli?.kundliName ??
                          "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      chatDetail.kundliDateTime ??
                          chatDetail.kundli!.kundliDateTime,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        //color: appColors.lightGrey,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      chatDetail.kundliPlace ??
                          chatDetail.kundli?.kundliPlace ??
                          "",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: appColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomProductView(
      {required ChatMessage chatDetail, required int index, String? baseUrl}) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 165,
        height: 220,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffDCDCDC)),
          color: appColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(0),
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomImageView(
              height: 165,
              width: 165,
              imagePath:
                  "${Get.find<SharedPreferenceService>().getAmazonUrl()}/${chatDetail.getCustomProduct!.image}",
              radius: const BorderRadius.vertical(top: Radius.circular(10)),
              placeHolder: "assets/images/default_profiles.svg",
              fit: BoxFit.cover,
            ),
            Text(
              chatDetail.getCustomProduct!.name ?? "",
              maxLines: 1,
              style: AppTextStyle.textStyle12(
                fontColor: appColors.textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "₹${chatDetail.getCustomProduct!.amount ?? "0"}",
              style: AppTextStyle.textStyle12(
                fontColor: appColors.textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget unreadMessageView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: appColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Text("unreadMessages".tr),
      ),
    );
  }
}

/// ------------------ check if file exists  ----------------------- ///
Future<String?> getDownloadedImagePath(
  int chatDetailId,
) async {
  var documentDirectory = await getApplicationDocumentsDirectory();
  var filePathAndName = "${documentDirectory.path}/images/$chatDetailId.jpg";

  // Check if the file already exists
  if (await File(filePathAndName).exists()) {
    return filePathAndName;
  } else {
    return null;
  }
}
