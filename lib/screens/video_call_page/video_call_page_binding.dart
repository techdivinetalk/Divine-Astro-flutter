import 'package:divine_astrologer/screens/video_call_page/video_call_page_controller.dart';
import 'package:get/get.dart';

class VideoCallPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoCallPageController());
  }
}
