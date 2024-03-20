import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/pages/home/home_controller.dart';
import 'package:divine_astrologer/repository/home_page_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/feedback_response.dart';

class OrderFeedbackController extends GetxController {
  bool loading = true;
  FeedbackData? feedbackResponse;
  final HomePageRepository homePageRepository = Get.put(HomePageRepository());
  RxList<FeedbackData> feedbacks = <FeedbackData>[].obs;

  @override
  void onInit() {
    var arguments = Get.arguments;
    if (arguments == null) {
      if (arguments != null && arguments is List != null) {
        feedbacks.value = arguments.first;
      }
    }
    getFeedbackData();
    super.onInit();
  }

  getFeedbackData() async {
    loading = true;
    update();
    try {
      var response = await homePageRepository.getFeedbackDataList();
      feedbacks.addAll(response.data!);
      // loading = Loading.loaded;
      loading = false;
      debugPrint('feed id: ${feedbackResponse?.id}');
      update();
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
      loading = false;
      update();
    }
  }
}
