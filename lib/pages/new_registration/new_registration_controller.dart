import 'dart:developer';

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
  TextEditingController textController = TextEditingController();
  final UserRepository userRepository;
  ResignationStatus? resignationStatus;
  ResignationCancelModel? resignationCancelModel;
  ResignationSubmitModel? resignationSubmitModel;
  ResignationReasonModel? resignationReasonModel;
  var isLoading = true.obs;
  var loadingReasons = true.obs;

  RxString selectedValue = ''.obs;
  var selectedReason;
  Data? selectedReasonData;
  RxBool showRichText = false.obs;
  RxBool status = false.obs;

  updateSelectReason(Data value) {
    selectedReason = value.reason;
    selectedReasonData = value;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getResignationReasons();
    getResignationStatus();
  }

  getResignationReasons() async {
    loadingReasons(true);

    try {
      final rstatus = await userRepository.getResignationReason({});
      if (rstatus.success == true) {
        resignationReasonModel = rstatus;
        selectedReason = resignationReasonModel!.data![0].reason.toString();
        selectedReasonData = resignationReasonModel!.data![0];
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
        if (resignationStatus!.data == null) {
        } else {
          selectedReason = resignationReasonModel!.data![0].reason.toString();
          selectedReasonData = resignationReasonModel!.data![0];

          selectedReason = resignationStatus!.data['comment'].toString();

          textController.text = resignationStatus!.data['comment'].toString();
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

  void getResignationCancel() async {
    isLoading(true);

    try {
      final rstatus = await userRepository.getResignationCancel({});
      print(rstatus.success.toString());
      print(rstatus.statusCode.toString());
      print(rstatus.message.toString());
      if (rstatus.success == true) {
        resignationCancelModel = rstatus;
        selectedReason = "";
        selectedReasonData = null;
        textController.clear();
        divineSnackBar(
            data: rstatus.message.toString(), color: appColors.green);
        getResignationReasons();
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

  void postResignationSubmit() async {
    Map<String, dynamic> param = {
      "reason_id": selectedReasonData!.id.toString(),
      "comment": selectedReason.toString(),
    };
    isLoading(true);

    try {
      final rstatus = await userRepository.postsubmitResignation(param);
      log(rstatus.success.toString());
      if (rstatus.success == true) {
        resignationSubmitModel = rstatus;
        getResignationStatus();
        getResignationReasons();
      } else {
        isLoading(false);
      }
      update();
    } catch (error) {
      debugPrint("Error occurred: $error");
      if (error is AppException) {
        error.onException();
      } else {
        // Handle other types of errors if needed
        debugPrint("Unexpected error: $error");
      }
      isLoading(false);
    }
  }

  updateStatus(val) {
    selectedValue.value = val;
    update();
  }
}
