import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/home_model/astrologer_live_log_response.dart';
import 'package:divine_astrologer/repository/live_logs_page_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LiveLogsController extends GetxController {
  LiveLogsPageRepository liveLogsPageRepository = LiveLogsPageRepository();
  RxList<LiveLogModel> liveLogsLst = <LiveLogModel>[].obs;
  Rx<Loading> loading = Loading.initial.obs;
  int currentPage = 1;

  @override
  void onInit() {
    astrologerLiveLog();
    super.onInit();
  }

  astrologerLiveLog() async {
    if (loading.value == Loading.loading) return;
    loading.value = Loading.loading;

    try {
      Map<String, dynamic> params = {
        "page": currentPage,
      };
      var response = await liveLogsPageRepository.doAstrologerLiveLog(params);

      if (currentPage == 1) {
        liveLogsLst.clear();
      }

      if (response.data != null) {
        var data = response.data;

        if (data != null && data.isNotEmpty) {
          liveLogsLst.addAll(data);
          currentPage++;
        }
      }
      loading.value = Loading.loaded;
    } catch (error) {
      loading.value = Loading.loaded;
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  String convertUtcToLocal(String inputDate, String outputFormat) {
    if (inputDate.isEmpty) return "-";

    // String inputDate = "2024-04-29T10:54:02.000000Z";
    DateTime utcDate = DateTime.parse(inputDate);
    DateTime localDate = utcDate.toLocal();

    String formattedDate = DateFormat(outputFormat).format(localDate);
    debugPrint(formattedDate); // Output: 29-04-24

    return formattedDate;
  }

  String convertFormat(String inputDate, String outputFormat) {
    if (inputDate.isEmpty) return "-";

    // String inputDate = "2024-04-29 16:24:02";
    DateTime checkInDate = DateTime.parse(inputDate);

    String formattedDate = DateFormat(outputFormat).format(checkInDate);
    debugPrint(formattedDate); // Output: 29-04-24

    return formattedDate;
  }

  String convertDurationToFormattedMinutes(String? durationStr) {
    if (durationStr == null || durationStr.isEmpty) {
      return '-';
    }

    List<String> parts = durationStr.split(':');
    if (parts.length != 3) {
      return '-';
    }

    try {
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2]);

      Duration duration =
          Duration(hours: hours, minutes: minutes, seconds: seconds);
      int totalMinutes = duration.inMinutes;
      int remainingSeconds = duration.inSeconds % 60;

      if (totalMinutes == 0 && remainingSeconds > 0) {
        return '0 Min';
      } else if (totalMinutes == 1) {
        return '1 Min';
      } else {
        return '$totalMinutes Mins';
      }
    } catch (e) {
      return '-';
    }
  }
}
