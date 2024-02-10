
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/faq_response.dart';
import 'package:divine_astrologer/repository/faqs_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQsController extends GetxController {
  late final FAQsRepository faqsRepository;
  Rx<FAQsResponse> faqsResponse = FAQsResponse().obs;
  Loading loading = Loading.initial;

  FAQsController(this.faqsRepository);

  @override
  void onInit() {
    super.onInit();
    getFAQsApi();
  }

  getFAQsApi() async {
    loading = Loading.loading;
    update();
    try {
      FAQsResponse response = await faqsRepository.getFAQs();
      faqsResponse.value = response;
      loading = Loading.loaded;
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
      loading = Loading.loaded;
    }
    update();
  }
}
