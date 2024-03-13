import 'package:divine_astrologer/common/helper_widgets.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/SvgIconButton.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../common/custom_text_field.dart';
import '../../common/custom_widgets.dart';
import '../../common/generic_loading_widget.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../model/chat_assistant/CustomerDetailsResponse.dart';
import '../../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../../utils/enum.dart';
import '../../utils/load_image.dart';
import '../live_page/constant.dart';
import 'chat_assistance_controller.dart';

class ChatAssistancePage extends GetView<ChatAssistanceController> {
  ChatAssistancePage({super.key});

  Rx<bool> isUSerTabSelected = true.obs;

  @override
  Widget build(BuildContext context) {
    Get.put(ChatAssistanceController());
    return Scaffold(
      appBar: appBar(),
      body: GetBuilder<ChatAssistanceController>(builder: (controller) {
        if (controller.loading == Loading.loading) {
          return const Center(child: GenericLoadingWidget());
        }
        if (controller.loading == Loading.loaded) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SizedBox(
                  child: Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              isUSerTabSelected.value = true;
                              controller.getAssistantAstrologerList();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              // Adjust padding as needed
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.blue,
                                    // Color of the underline
                                    width: isUSerTabSelected.value
                                        ? 3.0
                                        : 00, // Thickness of the underline
                                  ),
                                ),
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.person, // User icon
                                      size: 30,
                                    ),
                                    SizedBox(width: 8),
                                    // Provides a space between the icon and the text
                                    Text(
                                      "Users",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              isUSerTabSelected.value = false;
                              controller.getConsulation();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              // Adjust padding as needed
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    // Color of the underline
                                    width: !isUSerTabSelected.value
                                        ? 3.0
                                        : 00, // Thickness of the underline
                                  ),
                                ),
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.folder, // User icon
                                      size: 30,
                                    ),
                                    SizedBox(width: 8),
                                    // Provides a space between the icon and the text
                                    Text(
                                      "User's Data",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() {
                if (isUSerTabSelected.value) {
                  if (controller.chatAssistantAstrologerListResponse == null ||
                      controller.chatAssistantAstrologerListResponse!.data ==
                          null ||
                      controller.chatAssistantAstrologerListResponse!.data!
                          .data!.isEmpty) {
                    return HelpersWidget().emptyChatWidget();
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      itemCount: (controller.searchData).isNotEmpty ||
                              controller.searchController.text.isNotEmpty
                          ? controller.searchData.length
                          : controller.chatAssistantAstrologerListResponse!
                              .data!.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ChatAssistanceTile(
                          controller: controller,
                          data: (controller.searchData).isNotEmpty ||
                                  controller.searchController.text.isNotEmpty
                              ? controller.searchData[index]
                              : controller.chatAssistantAstrologerListResponse!
                                  .data!.data![index],
                        );
                      },
                    );
                  }
                } else {
                  if (controller.customerDetailsResponse == null ||
                      controller.customerDetailsResponse!.data.isEmpty) {
                    return HelpersWidget().emptyChatWidget();
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        itemCount: (controller.filteredUserData).isNotEmpty ||
                                controller.searchController.text.isNotEmpty
                            ? controller.filteredUserData.length
                            : controller.customerDetailsResponse?.data.length ??
                                0,
                        itemBuilder: (context, index) {
                          return ChatAssistanceDataTile(
                            data: (controller.filteredUserData).isNotEmpty ||
                                    controller.searchController.text.isNotEmpty
                                ? controller.filteredUserData[index]
                                : controller.customerDetailsResponse!.data[index],
                          );
                        },
                      ),
                    );
                  }
                }
              })
              ,const SizedBox(height: 10,)
            ],
          );
        }
        return HelpersWidget().emptyChatWidget();
      }),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: Obx(() => Container(
              color: appColors.guideColor,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                child: controller.isSearchEnable.value
                    ? searchWidget(appColors.guideColor)
                    : AppBar(
                        surfaceTintColor: appColors.guideColor,
                        title: Text(
                          "chatAssistance".tr,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        actions: [
                          SvgIconButton(
                              onPressed: () {
                                controller.isSearchEnable(true);
                              },
                              svg: Assets.images.searchIcon.svg(
                                color: Colors.white,
                              )),
                          SizedBox(width: 10.w)
                        ],
                        backgroundColor: appColors.guideColor,
                        elevation: 0,
                      ),
              ),
            )));
  }

  Widget searchWidget(Color backgroundColor) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: SizedBox(
          height: AppBar().preferredSize.height,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  controller.isSearchEnable.value = false;
                  controller.searchController.clear();
                  controller.searchData.clear();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: appColors.white,
                ),
              ),
              Expanded(
                child: Card(
                  child: CustomTextField(
                    autoFocus: true,
                    align: TextAlignVertical.center,
                    height: 40,
                    onChanged: (value) {
                      controller.searchCall(value);
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    controller: controller.searchController,
                    inputBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.sp)),
                    prefixIcon: null,
                    suffixIcon: InkWell(
                        onTap: () {}, child: Assets.images.searchIcon.svg()),
                    hintText: '${'search'.tr}...',
                  ),
                ),
              ),
              SizedBox(width: 20.w)
            ],
          ),
        ),
      ),
    );
  }
}

class ChatAssistanceTile extends StatelessWidget {
  final ChatAssistanceController controller;
  final DataList data;

  const ChatAssistanceTile(
      {super.key, required this.data, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      late AssistChatData element;
      bool newMessageFromlist = false;
      int unreadMessageCount = 0;
      if (assistChatUnreadMessages.isNotEmpty ||
          assistChatUnreadMessages != []) {
        print(
            "list of assist chat unread messages ${assistChatUnreadMessages.length}");
        int index = assistChatUnreadMessages.lastIndexWhere((element) {
          return element.customerId.toString() == data.id.toString();
        });
        if (index != -1) {
          element = assistChatUnreadMessages[index];
          newMessageFromlist = element.message.toString() != data.lastMessage;
          if (newMessageFromlist) {
            data.lastMessage = element.message.toString();
          }
          unreadMessageCount = (data.unreadMessage ?? 0) + userUnreadMessages(data.id??0);
        }
      }
      return ListTile(
        onTap: () async {
          if (assistChatUnreadMessages.isNotEmpty) {
           assistChatUnreadMessages.removeWhere((element) => element.customerId == data.id);
          }
          chatAssistantCurrentUserId = 0.obs;
          await Get.toNamed(RouteName.chatMessageUI, arguments: data)
              ?.then((value) {
            return controller.getAssistantAstrologerList();
          });
        },
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: appColors.guideColor),
              height: 50.w,
              width: 50.w,
              child: LoadImage(
                imageModel: ImageModel(
                  assetImage: false,
                  placeHolderPath: Assets.images.defaultProfile.path,
                  imagePath: (data.image ?? '').startsWith(
                          'https://divinenew-prod.s3.ap-south-1.amazonaws.com/')
                      ? data.image ?? ''
                      : "${preferenceService.getAmazonUrl()}/${data.image ?? ''}",
                  loadingIndicator: SizedBox(
                    height: 25.h,
                    width: 25.w,
                    child: CircularProgressIndicator(
                      color: appColors.guideColor,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            )),
        title: CustomText(
          data.name ?? '',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        subtitle: lastMessage(data.msgType ?? MsgType.text),
        trailing: (unreadMessageCount) > 0
            ? CircleAvatar(
                radius: 10.r,
                backgroundColor: appColors.guideColor,
                child: CustomText(
                  unreadMessageCount.toString(),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  fontColor: appColors.brown,
                ),
              )
            : const SizedBox(),
      );
    });
  }

  Widget lastMessage(MsgType msgtype) {
    late Widget lastMessageWidget;
    switch (msgtype) {
      case MsgType.text:
        lastMessageWidget = CustomText(
          data.lastMessage ?? '',
          fontColor:
              // (index == 0) ? appColors.darkBlue:
              appColors.grey,
          fontSize: 12.sp,
          fontWeight:
              //(index == 0) ? FontWeight.w600 :
              FontWeight.normal,
        );
        break;

      case MsgType.image:
        lastMessageWidget = const Row(
          children: [
            Icon(
              Icons.image,
              size: 15,
            ),
            Text(
              "  Image",
              style: TextStyle(fontSize: 10),
            )
          ],
        );
        break;
      case MsgType.remedies:
        lastMessageWidget = Row(
          children: [
            SvgPicture.asset(
              'assets/svg/remedies_icon.svg',
              width: 10,
            ),
            Text(
              "  Remedy",
              style: TextStyle(fontSize: 10),
            )
          ],
        );
        break;
      case MsgType.product:
        lastMessageWidget = Row(
          children: [
            SvgPicture.asset(
              'assets/svg/product.svg',
              width: 10,
            ),
            Text(
              "  Product",
              style: TextStyle(fontSize: 10),
            )
          ],
        );
        break;
      case MsgType.pooja:
        lastMessageWidget = Row(
          children: [
            SvgPicture.asset(
              'assets/svg/product.svg',
              width: 10,
            ),
            Text(
              "  ${data.lastMessage}",
              style: TextStyle(fontSize: 10),
            )
          ],
        );
        break;
      case MsgType.gift:
        lastMessageWidget = const Row(
          children: [
            Icon(
              Icons.card_giftcard,
              size: 15,
            ),
            Text(
              "   Gift",
              style: TextStyle(fontSize: 10),
            )
          ],
        );
        break;
      case MsgType.voucher:
        lastMessageWidget = const Row(
          children: [
            Icon(
              Icons.money,
              size: 15,
            ),
            Text(
              "   Voucher",
              style: TextStyle(fontSize: 10),
            )
          ],
        );
        break;
      case MsgType.audio:
        lastMessageWidget = const Row(
          children: [
            Icon(
              Icons.audiotrack,
              size: 15,
            ),
            Text(
              "   Audio",
              style: TextStyle(fontSize: 10),
            )
          ],
        );
        break;
      default:
        lastMessageWidget = SizedBox();
        break;
    }
    return lastMessageWidget;
  }

  int userUnreadMessages(int userId) {
    final myUnreadMessages = [];
    if (assistChatUnreadMessages.isNotEmpty) {
      myUnreadMessages.addAll(assistChatUnreadMessages
          .where((element) => element.customerId == userId));
    }
    return myUnreadMessages.length;
  }
}

class ChatAssistanceDataTile extends StatelessWidget {
  final ConsultationData data;

  const ChatAssistanceDataTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DataList dataList = DataList();
        dataList.name = data.customerName;
        dataList.id = data.customerId;
        dataList.image = data.customerImage;
        Get.toNamed(RouteName.chatMessageUI, arguments: dataList);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: appColors.guideColor),
                  height: 50.w,
                  width: 50.w,
                  child: LoadImage(
                    imageModel: ImageModel(
                      assetImage: false,
                      placeHolderPath: Assets.images.defaultProfile.path,
                      imagePath: (data.customerImage ?? '').startsWith(
                              'https://divinenew-prod.s3.ap-south-1.amazonaws.com/')
                          ? data.customerImage ?? ''
                          : "${preferenceService.getAmazonUrl()}/${data.customerImage ?? ''}",
                      loadingIndicator: SizedBox(
                        height: 25.h,
                        width: 25.w,
                        child: CircularProgressIndicator(
                          color: appColors.guideColor,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          data.customerName ?? '',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: appColors.white, width: 1.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50.0)),
                            color: appColors.darkGreen),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: CustomText("Connect",
                              fontColor: Colors.white, fontSize: 12.sp),
                        ),
                      )
                    ],
                  ),
                  CustomText(
                    "Total Consultation : ${data.totalConsultation}",
                    fontColor:
                        // (index == 0) ? appColors.darkBlue:
                        appColors.grey,
                    fontSize: 12.sp,
                    fontWeight:
                        //(index == 0) ? FontWeight.w600 :
                        FontWeight.normal,
                  ),
                  CustomText(
                    "Last Consulted : ${data.lastConsulted}",
                    fontColor:
                        // (index == 0) ? appColors.darkBlue:
                        appColors.grey,
                    fontSize: 12.sp,
                    fontWeight:
                        //(index == 0) ? FontWeight.w600 :
                        FontWeight.normal,
                  ),
                  CustomText(
                    "Days Since Last Consulted : ${data.daySinceLastConsulted}",
                    fontColor:
                        // (index == 0) ? appColors.darkBlue:
                        appColors.grey,
                    fontSize: 12.sp,
                    fontWeight:
                        //(index == 0) ? FontWeight.w600 :
                        FontWeight.normal,
                  )
                ],
              ),
            ),
            const Center(child: Icon(Icons.keyboard_arrow_right_outlined))
          ],
        ),
      ),
    );
  }
}
