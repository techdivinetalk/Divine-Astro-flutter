import 'dart:io';

import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/profile_options/upload_story/upload_story_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_trimmer/video_trimmer.dart';

class UploadStoryUi extends GetView<UploadStoryController> {
  const UploadStoryUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadStoryController>(
      assignId: true,
      init: UploadStoryController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: appColors.blackColor,
          appBar: commonDetailAppbar(
              title: "uploadStory".tr,
              trailingWidget: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () {
                    Fluttertoast.showToast(msg: "${'uploadStory'.tr}..");
                    controller.saveVideo();
                  },
                  child: const Text("Upload"),
                ),
              )),
          body: Column(
            children: [
              controller.selectedFile?.value == false
                  ? SizedBox(
                      height: 200,
                      width: 200,
                      child: ElevatedButton(
                        child: Text("selectVideo".tr),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.video,
                            allowCompression: false,
                            withData: true,
                          );

                          if (result != null) {
                            controller.trimmer.loadVideo(
                              videoFile: File(result.files.single.path ?? ''),
                            );

                            controller.selectedFile?.value = true;

                          }
                          controller.update();
                        },
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: Obx(() => controller.selectedFile?.value == true
                    ? Column(
                        children: [
                          Expanded(
                            child: VideoViewer(trimmer: controller.trimmer),
                          ),
                          Center(
                            child: TrimViewer(
                              trimmer: controller.trimmer,
                              viewerHeight: 50.0,
                              viewerWidth: MediaQuery.of(context).size.width,
                              maxVideoLength: const Duration(seconds: 30),
                              onChangeStart: (value) =>
                                  controller.startValue = value,
                              onChangeEnd: (value) =>
                                  controller.endValue = value,
                              onChangePlaybackState: (value) {
                                controller.isPlaying.value = value;
                              },
                            ),
                          ),
                          TextButton(
                            child: controller.isPlaying.value
                                ? const Icon(
                                    Icons.pause,
                                    size: 80.0,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    size: 80.0,
                                    color: Colors.white,
                                  ),
                            onPressed: () async {
                              bool playbackState =
                                  await controller.trimmer.videoPlaybackControl(
                                startValue: controller.startValue,
                                endValue: controller.endValue,
                              );

                              controller.isPlaying.value = playbackState;
                              controller.update();
                            },
                          ),
                        ],
                      ) /*Container(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Visibility(
                          visible: controller.progressVisibility.value,
                          child: const LinearProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        ),

                        Expanded(
                          child: VideoViewer(trimmer: controller.trimmer),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TrimViewer(
                              trimmer: controller.trimmer,
                              viewerHeight: 50.0,
                              viewerWidth:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              durationStyle: DurationStyle.FORMAT_MM_SS,
                              maxVideoLength: const Duration(seconds: 30),
                              editorProperties: TrimEditorProperties(
                                borderPaintColor: Colors.yellow,
                                borderWidth: 4,
                                borderRadius: 5,
                                circlePaintColor: Colors.yellow.shade800,
                              ),
                              areaProperties: TrimAreaProperties.edgeBlur(
                                thumbnailQuality: 10,
                              ),
                              onChangeStart: (value) =>
                              controller.startValue = value,
                              onChangeEnd: (value) =>
                              controller.endValue = value,
                              onChangePlaybackState: (value) {
                                controller.isPlaying.value = value;
                              },
                            ),
                          ),
                        ),
                        TextButton(
                          child: controller.isPlaying.value
                              ? const Icon(
                            Icons.pause,
                            size: 80.0,
                            color: Colors.white,
                          )
                              : const Icon(
                            Icons.play_arrow,
                            size: 80.0,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            bool playbackState = await controller.trimmer
                                .videoPlaybackControl(
                              startValue: controller.startValue,
                              endValue: controller.endValue,
                            );
                            controller.isPlaying.value = playbackState;
                          },
                        )
                      ],
                    ))*/
                    : const SizedBox()),
              )
            ],
          ),
        );
      },
    );
  }


}
