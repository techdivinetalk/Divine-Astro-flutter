import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/repository/home_page_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/feedback_response.dart';

class OrderFeedbackController extends GetxController{

  var isFeedbackAvailable = false.obs;
  Loading loading = Loading.initial;
  FeedbackData? feedbackResponse;


  RxList<FeedbackData> feedbacks = <FeedbackData>[].obs;
  final HomePageRepository homePageRepository = Get.put(HomePageRepository());

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