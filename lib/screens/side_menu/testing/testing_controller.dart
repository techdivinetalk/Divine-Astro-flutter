import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../di/shared_preference_service.dart';
import '../../../repository/user_repository.dart';

class TestingController extends GetxController {
  TestingController(this.userRepository);

  final UserRepository userRepository;
  var preference = Get.find<SharedPreferenceService>();

  bool isTechnicalLoading = false;

  getTechnicalTickets() async {
    try {
      isTechnicalLoading = true;

      log(222.toString());

      final response = await userRepository.getTechnicalIssuesApi();
      if (response.success == true) {
        isTechnicalLoading = false;
        Fluttertoast.showToast(msg: "Data Fetched");
        update();
      } else {
        isTechnicalLoading = false;
      }
      update();
    } catch (error) {
      isTechnicalLoading = false;
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    update();
  }
}
