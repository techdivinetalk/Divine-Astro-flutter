import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/model/leave/LeaveReasonsModel.dart';
import 'package:divine_astrologer/model/leave/LeaveStatusModel.dart';
import 'package:divine_astrologer/model/leave/LeaveSubmitModel.dart';
import 'package:divine_astrologer/screens/new_leave/widgets/submit_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../model/leave/LeaveCancelModel.dart';
import '../../repository/user_repository.dart';

class NewLeaveController extends GetxController {
  NewLeaveController(this.userRepository);

  TextEditingController textController = TextEditingController();
  final UserRepository userRepository;
  LeaveStatusModel? leaveStatus;
  LeaveCancelModel? leaveCancelModel;
  LeaveSubmitModel? leaveSubmitModel;
  LeaveReasonsModel? leaveReasonModel;
  var isLoading = true.obs;
  var loadingReasons = true.obs;
  var startDate;
  var endDate;
  RxString selectedValue = ''.obs;
  var selectedReason;
  var selectedReasonData;
  RxBool showRichText = false.obs;
  RxBool status = false.obs;

  updateSelectReason(var value) {
    selectedReason = value.reason;
    selectedReasonData = value;
    update();
  }

  setStartDate(var value) {
    startDate = value;
    update();
  }

  setEndDate(var value) {
    endDate = value;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLeaveReasons();

    getLeaveStatus();
  }

  String parseDate(value) {
    DateTime date = DateTime.parse(value.toString());
    String result = "${date.day}-${date.month}-${date.year}";
    update();

    return result;
  }

  getLeaveReasons() async {
    loadingReasons(true);

    try {
      final rstatus = await userRepository.getLeaveReason({});
      if (rstatus.success == true) {
        leaveReasonModel = rstatus;
        selectedReason = leaveReasonModel!.data![0].reason.toString();
        selectedReasonData = leaveReasonModel!.data![0];
        loadingReasons(false);

        // return rstatus.data!; // Return the list of Data objects
      } else {
        loadingReasons(false);
        // return []; // Return an empty list if success is false
      }
      update();
    } catch (error) {
      loadingReasons(false);

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        loadingReasons(false);

        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    // return [];
  }

  void getLeaveStatus() async {
    isLoading(true);

    try {
      final rstatus = await userRepository.getLeaveStatus({});

      if (rstatus.success == true) {
        leaveStatus = rstatus;

        if (leaveStatus!.data == null) {
        } else {
          selectedReason = leaveReasonModel!.data![0].reason.toString();
          selectedReasonData = leaveReasonModel!.data![0];

          selectedReason = leaveStatus!.data['comment'].toString();

          textController.text = leaveStatus!.data['comment'].toString();
        }
        isLoading(false);
      } else {
        isLoading(false);
      }

      update();
    } catch (error) {
      isLoading(false);

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        isLoading(false);

        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  void getLeaveCancel() async {
    isLoading(true);

    try {
      final rstatus = await userRepository.getLeaveCancel({});
      print(rstatus.success.toString());
      print(rstatus.statusCode.toString());
      print(rstatus.message.toString());
      if (rstatus.success == true) {
        leaveCancelModel = rstatus;
        selectedReason = "";
        selectedReasonData = null;
        textController.clear();
        divineSnackBar(
            data: rstatus.message.toString(), color: appColors.green);
        getLeaveReasons();
        getLeaveStatus();
      } else {
        divineSnackBar(
            data: rstatus.message.toString(), color: appColors.green);

        isLoading(false);
      }

      update();
    } catch (error) {
      isLoading(false);

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        isLoading(false);

        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  void postLeaveSubmit() async {
    log(2.toString());

    DateTime sd = DateTime.parse(startDate.toString());
    DateTime ed = DateTime.parse(endDate.toString());
    Map<String, dynamic> param = {
      "leave_reason_id": selectedReasonData!.id,
      "comment": selectedReason.toString(),
      "start_date": "${sd.year}-${sd.month}-${sd.day}",
      "end_date": "${ed.year}-${ed.month}-${ed.day}",
    };
    log(22.toString());

    isLoading(true);

    try {
      log(222.toString());

      final response = await userRepository.postsubmitLeave(param);
      if (response.success == true) {
        log(2222.toString());

        leaveSubmitModel = response;
        showLeavePopupAlert();

        getLeaveStatus();
        getLeaveReasons();
      } else {
        log(3.toString());

        isLoading(false);
      }
      update();
      log("Data Of submit ==> ${jsonEncode(response.data)}");
    } catch (error) {
      log(33.toString());

      isLoading(false);
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  updateStatus(val) {
    selectedValue.value = val;
    update();
  }
}
