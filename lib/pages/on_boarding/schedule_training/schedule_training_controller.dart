import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../common/routes.dart';
import '../../../model/AstroTrainingSessionModel.dart';
import '../../../model/SubmitScheduleTrainingModel.dart';
import '../../../repository/user_repository.dart';

class ScheduleTrainingController extends GetxController {
  UserRepository userRepository = UserRepository();
  // List of time slots with enabled/disabled status
  List<Map<String, dynamic>> times = [
    {"time": "09:00 AM", "isEnabled": true},
    {"time": "11:00 AM", "isEnabled": false},
    {"time": "01:00 PM", "isEnabled": true},
    {"time": "03:00 PM", "isEnabled": true},
  ];
  List<Map<String, dynamic>> times2 = [
    {"time": "05:00 PM", "isEnabled": true},
    {"time": "06:00 PM", "isEnabled": true},
    {"time": "07:00 PM", "isEnabled": false},
    {"time": "08:00 PM", "isEnabled": true},
  ];
  var selectedTime;

  @override
  Future<void> onInit() async {
    super.onInit();
    getTrainings();
  }

  AstroTrainingSessionModel? astroTrainingSessionModel;
  bool loadingTrainingssss = false;
  getTrainings() async {
    loadingTrainingssss = true;
    try {
      final data = await userRepository.getScheduleTrainingsss({});
      if (data.success == true) {
        astroTrainingSessionModel = data;
        loadingTrainingssss = false;
        update();
      } else {
        loadingTrainingssss = false;
      }

      update();
    } catch (error) {
      debugPrint("error::::: $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    }
  }

  SubmitScheduleTrainingModel? submitastroTrainingSessionModel;

  bool submittingTrainingss = false;
  submittingTraings() async {
    submittingTrainingss = true;
    var body = {"meeting_id": selectedTime};
    try {
      final data = await userRepository.submitScheduleTrainingsss(body);
      if (data.success == true) {
        submitastroTrainingSessionModel = data;
        submittingTrainingss = false;
        divineSnackBar(
            data: submitastroTrainingSessionModel!.message.toString(),
            color: appColors.green);

        Get.toNamed(
          RouteName.scheduleTraining2,
        );
        update();
      } else {
        submittingTrainingss = false;
      }

      update();
    } catch (error) {
      debugPrint("error::::: $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    }
  }
}
