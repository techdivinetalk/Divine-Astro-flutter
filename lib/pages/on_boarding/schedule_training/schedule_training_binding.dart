import 'package:divine_astrologer/pages/on_boarding/schedule_training/schedule_training_controller.dart';
import 'package:get/get.dart';

class ScheduleTrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ScheduleTrainingController());
  }
}
