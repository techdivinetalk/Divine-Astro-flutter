import 'package:divine_astrologer/repository/important_number_repository.dart';
import 'package:get/get.dart';
import 'important_numbers_controller.dart';

class ImportantNumbersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ImportantNumbersController(Get.put(ImportantNumberRepo())));
  }
}
