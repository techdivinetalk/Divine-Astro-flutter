import 'package:get/get.dart';

import '../../model/feedback_response.dart';

class OrderFeedbackController extends GetxController{

  RxList<FeedbackData> feedbacks = <FeedbackData>[].obs;

  @override
  void onInit() {
    var arguments = Get.arguments;
    if (arguments != null) {
      var args = arguments as List;
      feedbacks.value = args.first;
    }
    super.onInit();
  }
}