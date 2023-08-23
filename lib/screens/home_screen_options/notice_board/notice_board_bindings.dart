import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:get/get.dart';

import 'notice_board_controller.dart';

class NoticeBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NoticeBoardController(Get.put(NoticeRepository())));
  }
}
