import 'package:get/get.dart';

class RemediesDetailController extends GetxController {
  // Define your reactive variables here
  final RxString title = ''.obs;
  final RxString subtitle = ''.obs;

  // Initialize the controller with data
  void init(String title, String subtitle) {
    this.title.value = title;
    this.subtitle.value = subtitle;
  }
}