import 'package:get/get.dart';

class ImagePreviewController extends GetxController {
  String? selectedImageFile = "";
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      selectedImageFile = Get.arguments;
    }
  }
}
