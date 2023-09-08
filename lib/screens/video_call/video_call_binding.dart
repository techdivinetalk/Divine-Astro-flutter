import 'package:divine_astrologer/screens/video_call/video_call_controller.dart';
import 'package:get/get.dart';

class VideoCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoCallController());
  }
}
