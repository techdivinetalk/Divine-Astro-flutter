import 'package:divine_astrologer/model/resignation/ResignationCancelModel.dart';
import 'package:divine_astrologer/model/resignation/ResignationReasonModel.dart';
import 'package:divine_astrologer/model/resignation/ResignationSubmitModel.dart';
import 'package:divine_astrologer/model/resignation/Resignation_status_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../repository/user_repository.dart';

class NewRegistrationController extends GetxController {
  NewRegistrationController(this.userRepository);

  final UserRepository userRepository;
  ResignationStatus? resignationStatus;
  ResignationCancelModel? resignationCancelModel;
  ResignationSubmitModel? resignationSubmitModel;
  ResignationReasonModel? resignationReasonModel;
  var isLoading = true.obs;
  var loadingReasons = true.obs;

  RxString selectedValue = ''.obs;
  var selectedReason;
  RxBool showRichText = false.obs;
  RxBool status = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getResignationStatus();
    getResignationReasons();
  }

  getResignationReasons() async {
    loadingReasons(true);

    try {
      final rstatus = await userRepository.getResignationReason({});
      print(rstatus.success.toString());
      print(rstatus.data.toString());
      print(rstatus.statusCode.toString());
      if (rstatus.success == true) {
        resignationReasonModel = rstatus;
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

  void getResignationStatus() async {
    isLoading(true);

    try {
      final rstatus = await userRepository.getResignationStatus({});
      print(rstatus.success.toString());
      print(rstatus.data.toString());
      print(rstatus.statusCode.toString());
      if (rstatus.success == true) {
        resignationStatus = rstatus;
        selectedReason = resignationReasonModel!.data![0];
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

  void getResignationCancel() async {
    isLoading(true);

    try {
      final rstatus = await userRepository.getResignationCancel({});
      print(rstatus.success.toString());
      print(rstatus.statusCode.toString());
      print(rstatus.message.toString());
      if (rstatus.success == true) {
        resignationCancelModel = rstatus;
        divineSnackBar(
            data: rstatus.message.toString(), color: appColors.green);

        getResignationStatus();

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

  void postResignationSubmit() async {
    isLoading(true);
    var param = {
      "reason_id": "1",
      "comment": "Personal reasons",
    };
    try {
      final rstatus = await userRepository.postsubmitResignation(param);

      print(rstatus.success.toString());
      print(rstatus.statusCode.toString());
      print(rstatus.message.toString());
      if (rstatus.success == true) {
        resignationSubmitModel = rstatus;
        isLoading(false);
        getResignationStatus();
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

  updateStatus(val) {
    selectedValue.value = val;
    update();
  }
}
