import 'dart:io';

import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../../../common/colors.dart';
import 'image_preview_controller.dart';

class ImagePreviewUi extends GetView<ImagePreviewController> {
  const ImagePreviewUi({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ImagePreviewController());
    String? filePath = controller.selectedImageFile;
    print('image file path: ' + filePath.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.guideColor,
        centerTitle: false,
      ),
      body: Center(
        child: CommonImageView(
          imagePath: filePath??'',
        ),
      ),
    );
  }
}
