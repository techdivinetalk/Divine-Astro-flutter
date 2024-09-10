import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/app_exception.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../common/routes.dart';
import '../../../di/shared_preference_service.dart';
import '../../../gen/fonts.gen.dart';
import '../../../model/AstroTrainingSessionModel.dart';
import '../../../model/SubmitScheduleTrainingModel.dart';
import '../../../model/astrologer_training_session_response.dart';
import '../../../repository/user_repository.dart';

class ScheduleTrainingController extends GetxController {
  UserRepository userRepository = UserRepository();
  late Timer timer;
  Duration remainingTime = Duration();

  var selectedTime;
  var preference = Get.find<SharedPreferenceService>();
  String specialityNames = "";
  @override
  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments == null) {
      getTrainings();
    } else {
      getAstroTra();
    }

    specialityNames = preference
        .getUserDetail()!
        .astrologerSpeciality!
        .map((e) => e.specialityDetails!.name ?? "Astrology")
        .join(', ')
        .toString();
    print(
        "astrologer specialty -- ${preference.getUserDetail()!.astrologerSpeciality!.map((e) => e.toJson().toString()).join(', ')}");
  }

  String formatDate(String dateString) {
    // Parse the input date string (assuming it's in the format yyyy-MM-dd)
    DateTime date = DateTime.parse(dateString);

    // Format the day with the ordinal suffix
    String daySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    // Get the formatted day with the suffix
    String day = '${date.day}${daySuffix(date.day)}';

    // Format the full date string
    String formattedDate = '$day, ${DateFormat('MMMM yyyy').format(date)}';

    return formattedDate;
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
        print(astroTrainingSessionModel!.toJson());
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

  String formattedDate = "";
  String formattedTime = "";
  void _startTimer(targetEpochTime) {
    DateTime targetDateTime =
        DateTime.fromMillisecondsSinceEpoch(targetEpochTime * 1000);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime currentTime = DateTime.now();
      remainingTime = targetDateTime.difference(currentTime);
      update();

      if (remainingTime.isNegative) {
        timer.cancel(); // Stop the timer when the countdown is over
      }
      update();
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  AstrologerTrainingSessionResponse? astrologerTrainingSessionResponse;
  var getCurrentTraining = false.obs;
  getAstroTra() async {
    getCurrentTraining.value = true;
    try {
      final data = await userRepository.doGetAstrologerTrainingSession();
      if (data != null && data.success == true) {
        astrologerTrainingSessionResponse = data;
        getCurrentTraining.value = false;
        if (astrologerTrainingSessionResponse!.data!.first.meeting_date_epoch ==
            null) {
        } else {
          _startTimer(astrologerTrainingSessionResponse!
              .data!.first.meeting_date_epoch);
        }
        print(
            "---------------------------------------------------------${astrologerTrainingSessionResponse!.toJson().toString()}");
        update();
      } else {
        getCurrentTraining.value = false;
      }
      update();
    } catch (error) {
      getCurrentTraining.value = false;

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

        submitStage7();
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

  submitStage7() async {
    update();
    var body = {
      "meeting_id": selectedTime ?? "",
      "page": 7,
    };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        Get.offNamed(RouteName.scheduleTraining2, arguments: "sheduled");
        update();
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  void showExitAppDialog() {
    Get.defaultDialog(
      title: 'Close App?',
      titleStyle: TextStyle(
        fontSize: 20,
        fontFamily: FontFamily.metropolis,
        fontWeight: FontWeight.w600,
        color: appColors.appRedColour,
      ),
      titlePadding: EdgeInsets.only(top: 20, bottom: 5),
      middleText:
          'You\'re just a few steps away from getting started with divinetalk.',
      middleTextStyle: TextStyle(
        fontSize: 14,
        fontFamily: FontFamily.poppins,
        fontWeight: FontWeight.w400,
        color: appColors.black.withOpacity(0.8),
      ),
      backgroundColor: appColors.white,
      radius: 10,
      barrierDismissible: true, // Can tap outside to close the dialog
      actions: [
        TextButton(
          onPressed: () {
            // Handle exit action
            exit(0);
          },
          child: Text(
            'Exit App',
            style: TextStyle(
              fontSize: 16,
              fontFamily: FontFamily.metropolis,
              fontWeight: FontWeight.w600,
              color: appColors.darkBlue,
            ),
          ),
          style: TextButton.styleFrom(
            side: BorderSide(color: appColors.darkBlue),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle continue action
            Get.back(); // Close dialog
            // Add any other functionality you need
          },
          child: Text(
            'Continue',
            style: TextStyle(
              fontSize: 16,
              fontFamily: FontFamily.metropolis,
              fontWeight: FontWeight.w600,
              color: appColors.white,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: appColors.appRedColour,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
