import 'package:get/get.dart';
import 'important_numbers_controller.dart';

class ImportantNumbersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ImportantNumbersController());
  }
}
