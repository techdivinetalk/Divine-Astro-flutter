import 'package:divine_astrologer/screens/chat_message_with_socket/remedy_view/remedies_detail_controller.dart';
import 'package:get/get.dart';

class RemediesDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RemediesDetailController());
  }
}
