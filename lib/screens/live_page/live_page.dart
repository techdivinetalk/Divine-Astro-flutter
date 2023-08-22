// Dart imports:

// Flutter imports:
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:divine_astrologer/screens/live_page/live_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_prebuilt_live_streaming/src/components/message/view.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:http/http.dart' as http;
import '../../common/cached_network_image.dart';
import '../../common/colors.dart';
import '../../common/custom_button.dart';
import '../../common/custom_text.dart';
import '../../common/custom_text_field.dart';
import '../../gen/assets.gen.dart';
import 'constant.dart';
import 'gift.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;
  final String localUserID;
  final String? astrologerName, astrologerImage;

  const LivePage({
    Key? key,
    required this.liveID,
    required this.localUserID,
    this.astrologerImage,
    this.astrologerName,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  final liveController = ZegoUIKitPrebuiltLiveStreamingController();
  final List<StreamSubscription<dynamic>?> subscriptions = [];
  final controller = Get.put(LiveController());
  final liveStateNotifier =
      ValueNotifier<ZegoLiveStreamingState>(ZegoLiveStreamingState.idle);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      liveController.connect.onRequestCoHostEvent = (user){
        print(user.name);
        controller.coHostUser = user;
        liveController.connect.hostAgreeCoHostRequest(user);
      };
      subscriptions.addAll([
        (ZegoUIKit()
            .getSignalingPlugin()
            .getInRoomCommandMessageReceivedEventStream()
            .listen((event) {
          onInRoomCommandMessageReceived(event);
        })),
      ]);
    });
  }

  @override
  void dispose() {
    super.dispose();

    for (final subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
      plugins: [ZegoUIKitSignalingPlugin()],
    );

    final giftButton = ZegoMenuBarExtendButton(
      index: 0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(shape: const CircleBorder()),
        onPressed: () {
          sendGift();
        },
        child: const Icon(Icons.blender),
      ),
    );

    final audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
      plugins: [ZegoUIKitSignalingPlugin()],
    )..bottomMenuBarConfig.coHostExtendButtons = [giftButton];
    //..bottomMenuBarConfig.audienceExtendButtons = [giftButton];

    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return ZegoUIKitPrebuiltLiveStreaming(
          appID: yourAppID,
          appSign: yourAppSign /*input your AppSign*/,
          userID: localUserID,
          userName: 'user_$localUserID',
          liveID: widget.liveID,
          controller: liveController,
          config: (widget.isHost ? hostConfig : audienceConfig)
            ..topMenuBarConfig
            ..avatarBuilder = customAvatarBuilder
            ..bottomMenuBarConfig.hostButtons = const [
              //ZegoMenuBarButtonName.soundEffectButton,
              //ZegoMenuBarButtonName.switchCameraButton,
              //ZegoMenuBarButtonName.toggleCameraButton,
              //ZegoMenuBarButtonName.toggleMicrophoneButton,
            ]
            ..bottomMenuBarConfig.coHostButtons = [
              ZegoMenuBarButtonName.toggleCameraButton,
              ZegoMenuBarButtonName.toggleMicrophoneButton,
              ZegoMenuBarButtonName.coHostControlButton,
              ZegoMenuBarButtonName.switchCameraButton,
              ZegoMenuBarButtonName.soundEffectButton,
            ]
            ..bottomMenuBarConfig.showInRoomMessageButton = false
            ..bottomMenuBarConfig.audienceButtons = []
            ..audioVideoViewConfig.useVideoViewAspectFill = true
            ..maxCoHostCount = 1

            /// gallery-layout, show top and bottom if have two audio-video views
            ..layout = ZegoLayout.gallery()
            ..topMenuBarConfig = ZegoTopMenuBarConfig(
              height: 0,
            )

            // ///  only the host can view the video of the co-host
            // ..audioVideoViewConfig.playCoHostVideo = (
            //   ZegoUIKitUser localUser,
            //   ZegoLiveStreamingRole localRole,
            //   ZegoUIKitUser coHost,
            // ) {
            //   /// only play co-host video by host,
            //   /// audience and other co-hosts can't play
            //   return ZegoLiveStreamingRole.host == localRole;
            // }

            ///  only the host can hear the audio of the co-host
            ..audioVideoViewConfig.playCoHostAudio = (
              ZegoUIKitUser localUser,
              ZegoLiveStreamingRole localRole,
              ZegoUIKitUser coHost,
            ) {
              /// only play co-host audio by host,
              /// audience and other co-hosts can't play
              return ZegoLiveStreamingRole.host == localRole;
            }

            /// hide the co-host audio-video view to audience and other co-hosts
            /*..audioVideoViewConfig.visible = (
              ZegoUIKitUser localUser,
              ZegoLiveStreamingRole localRole,
              ZegoUIKitUser targetUser,
              ZegoLiveStreamingRole targetUserRole,
            ) {
              if (ZegoLiveStreamingRole.host == localRole) {
                /// host can see all user's view
                return true;
              }

              /// comment below if you want the co-host hide their own audio-video view.
              if (localUser.id == targetUser.id) {
                /// local view
                return true;
              }

              /// if user is a co-host, only show host's audio-video view
              return targetUserRole == ZegoLiveStreamingRole.host;
            }*/
            ..onLiveStreamingStateUpdate = (ZegoLiveStreamingState state) {
              liveStateNotifier.value = state;
            }
            ..inRoomMessageConfig.visible = false
            ..foreground = foreground(constraints),
        );
      }),
    );
  }

  Widget messageWidget() {
    return StreamBuilder<List<ZegoInRoomMessage>>(
      stream: liveController.message.stream(),
      builder: (context, snapshot) {
        final messages = snapshot.data ?? <ZegoInRoomMessage>[];

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: SizedBox(
            width: 200,
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messageItem(messages[index]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget messageItem(ZegoInRoomMessage message) {
    return Container(
      width: 200.w,
      margin: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 2,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white, width: .8),
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(5),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: SizedBox(
                width: 18,
                child: Center(
                  child: ZegoAvatar(
                    user: message.user,
                    avatarSize: const Size(18, 18),
                  ),
                ),
              ),
            ),
            WidgetSpan(child: SizedBox(width: 4.w)),
            TextSpan(
              text: '${message.user.name}: ',
              style: const TextStyle(
                color: AppColors.appColorDark,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: message.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget foreground(BoxConstraints constraints) {
    const shortMessageHeight = 30.0;
    const padding = 10.0;

    final messageView = SizedBox(
      width: Get.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 15.w),
          messageWidget(),
          const Spacer(),
          sideButtons(),
          SizedBox(width: 15.w)
        ],
      ),
    );

    List<String> shortMessages = [
      'Hi! 🖐🏻',
      'Namastey 🙏🏻',
      'Hello ❤️',
      'Hey 🔥',
      'Buy 👋🏻',
      'Morning ☀️',
      'Night 🌛'
    ];
    final shortMessageView = SizedBox(
      width: constraints.maxWidth - padding * 5,
      height: shortMessageHeight,
      child: ListView.separated(
        itemCount: shortMessages.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white38),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  liveController.message.send(shortMessages[index]);
                },
                child: Text(
                  shortMessages[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 5);
        },
      ),
    );

    return ValueListenableBuilder<ZegoLiveStreamingState>(
      valueListenable: liveStateNotifier,
      builder: (context, liveState, _) {
        return ZegoLiveStreamingState.idle == liveState
            ? Container()
            : Stack(
                children: [
                  Positioned(
                    top: 20.h,
                    child: SizedBox(
                      width: Get.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Assets.images.leftArrow.svg()),
                          ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                    color: AppColors.blackColor.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(40)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 49.w,
                                      height: 49.h,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: circleAvatar(),
                                    ),
                                    SizedBox(width: 10.w),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          widget.astrologerName ?? "",
                                          fontSize: 16.sp,
                                          fontColor: AppColors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        CustomText(
                                          "Toret",
                                          fontSize: 12.sp,
                                          fontColor: AppColors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        messageView,
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: CustomTextField(
                                onTap: () {
                                  showCupertinoModalPopup(
                                    barrierColor:
                                    AppColors.textColor.withOpacity(.5),
                                    context: context,
                                    builder: (context) => SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: Material(
                                          color: AppColors.transparent,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 14.w,
                                                right: 14.w,
                                                bottom: 18.h),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(40.sp),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 5, sigmaY: 5),
                                                child: CustomTextField(
                                                  controller: controller.msg,
                                                  hintText: 'Say Hi...',
                                                  autoFocus: true,
                                                  fillColor: AppColors.white
                                                      .withOpacity(.5),
                                                  inputBorder:
                                                  OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.textColor
                                                          .withOpacity(0.5),
                                                    ),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        40.sp),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                readOnly: true,
                                hintText: 'Say Hi...',
                                inputBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                    AppColors.textColor.withOpacity(0.15),
                                  ),
                                  borderRadius: BorderRadius.circular(40.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget circleAvatar() {
    if (widget.astrologerImage != null || widget.astrologerImage!.isNotEmpty) {
      return CachedNetworkPhoto(
        url: widget.astrologerImage,
        fit: BoxFit.fill,
      );
    }
    return CircleAvatar(
      child: Text(widget.astrologerName![0].toUpperCase()),
    );
  }

  Widget sideButtons() {
    return Column(
      children: [
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: InkWell(
              onTap: (){
                liveController.connect.removeCoHost(controller.coHostUser!);
              },
              child: Container(
                width: 56.w,
                height: 56.h,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.redColor),
                child: const Center(child: Icon(Icons.call_end,color: AppColors.white)),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
              width: 56.w,
              height: 56.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.appRedColour),
              child: const Center(child: Icon(Icons.exit_to_app,color: AppColors.white)),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
              width: 56.w,
              height: 56.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(.6)),
              child: Center(child: Assets.images.leaderboardLive.svg()),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
              width: 56.w,
              height: 56.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(.6)),
              child: Center(child: Assets.images.giftLive.svg()),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
              width: 56.w,
              height: 56.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(.6)),
              child: Center(child: Assets.images.waitlistLive.svg()),
            ),
          ),
        ),
      ],
    );
  }

  /// if you use unreliable message channel, you need subscription this method.
  void onInRoomCommandMessageReceived(
    ZegoSignalingPluginInRoomCommandMessageReceivedEvent event,
  ) {
    final messages = event.messages;

    /// You can display different animations according to gift-type
    for (final commandMessage in messages) {
      final senderUserID = commandMessage.senderUserID;
      final message = utf8.decode(commandMessage.message);
      debugPrint('onInRoomCommandMessageReceived: $message');
      if (senderUserID != localUserID) {
        GiftWidget.show(context, "assets/sports-car.svga");
      }
    }
  }

  void sendGift() async {
    final data = json.encode({
      'app_id': yourAppID,
      'server_secret': yourServerSecret,
      'room_id': widget.liveID,
      'user_id': widget.localUserID,
      'user_name': 'user_${widget.localUserID}',
      'gift_type': 1001,
      'gift_count': 1,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    try {
      // const url = 'http://localhost:3000/api/send_gift';
      const url = 'https://zego-virtual-gift.vercel.app/api/send_gift';
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: data);
      if (response.statusCode == 200) {
        GiftWidget.show(context, "assets/sports-car.svga");
      } else {
        debugPrint('[ERROR], Send Gift Fail: ${response.statusCode}');
      }
    } on Exception catch (error) {
      debugPrint("[ERROR], Send Gift Fail, ${error.toString()}");
    }
  }
}

Widget customAvatarBuilder(
  BuildContext context,
  Size size,
  ZegoUIKitUser? user,
  Map<String, dynamic> extraInfo,
) {
  return CachedNetworkImage(
    imageUrl: 'https://robohash.org/${user?.id}.png',
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        CircularProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) {
      ZegoLoggerService.logInfo(
        '$user avatar url is invalid',
        tag: 'live audio',
        subTag: 'live page',
      );
      return ZegoAvatar(user: user, avatarSize: size);
    },
  );
}
