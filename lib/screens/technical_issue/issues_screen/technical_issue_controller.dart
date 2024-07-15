import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/TechnicalIssuesData.dart';
import '../../../repository/user_repository.dart';

class TechnicalIssuesListController extends GetxController {
  TechnicalIssuesListController(this.userRepository);

  final UserRepository userRepository;
  var preference = Get.find<SharedPreferenceService>();

  var isTechnicalLoading = false.obs;
  TechnicalIssuesData? technicalIssuesList;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getTechnicalTickets();
  }

  getTechnicalTickets() async {
    isTechnicalLoading(true);

    try {
      log(222.toString());

      final response = await userRepository.getTechnicalIssuesApi();
      if (response.success == true) {
        technicalIssuesList = response;

        isTechnicalLoading(false);
      } else {
        log(3.toString());

        isTechnicalLoading(false);
      }
    } catch (error) {
      log(33.toString());

      isTechnicalLoading(false);
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    update();
  }
}
