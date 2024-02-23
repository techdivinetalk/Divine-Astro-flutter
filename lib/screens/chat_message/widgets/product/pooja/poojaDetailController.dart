import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/app_exception.dart';
import '../../../../../common/colors.dart';
import '../../../../../common/common_functions.dart';
import '../../../../../repository/pooja_repository.dart';
import 'pooja/pooja_module_detail_response.dart';

class PoojaDetailController extends GetxController {
  List<PoojaDetailsModel> model = <PoojaDetailsModel>[];

  List<PoojaDetailsModel> get selectedData => model.where((element) => element.isSelected == true).toList();

  RxInt counter = RxInt(0);

  Duration duration = const Duration(days: 1, hours: 19, minutes: 39, seconds: 25);
  PoojaModuleDetailResponse? poojaModuleDetailResponse;
  Rx<bool> isLoading = false.obs;
  final poojaRepository = PoojaRepository();
  late DateTime _startTime;
  late Duration remainingTime;

  void _updateRemainingTime() {
    final now = DateTime.now();
    remainingTime = _startTime.difference(now);
    if (remainingTime.isNegative) {
      remainingTime = Duration.zero;
    }
    update();
  }

  getPoojaDetailData() async {
    isLoading.value = true;
    try {
      PoojaModuleDetailResponse data = await poojaRepository.getPoojaDetailData();
      poojaModuleDetailResponse = data;
      isLoading.value = false;
      update();
    } catch (error) {
      isLoading.value = false;
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else if (error is OtpInvalidTimerException) {
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    }
  }

  @override
  void onReady() {
    getPoojaDetailData();
    _startTime = DateTime.parse("2023-12-01 10:58:50");
    _updateRemainingTime();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
    super.onReady();
  }

  String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${_formatTimeUnit(days)}d : ${_formatTimeUnit(hours)}h : ${_formatTimeUnit(minutes)}m : ${_formatTimeUnit(seconds)}s Left';
  }

  String _formatTimeUnit(int unit) {
    return unit.toString().padLeft(2, '0');
  }

  void incrementCounter() {
    counter.value++;
    update();
  }

  void decrementCounter() {
    if (counter.value > 0) {
      counter.value--;
    }

    update();
  }

  void addItem(PoojaDetailsModel value) {
    for (PoojaDetailsModel element in model) {
      if (element.id == value.id) {
        element.isSelected = true;
        break;
      }
    }
    update();
  }

  void removeItem(PoojaDetailsModel value) {
    for (PoojaDetailsModel element in model) {
      if (element.id == value.id) {
        element.isSelected = false;
        break;
      }
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    model.addAll(
      List.generate(
        10,
            (index) => PoojaDetailsModel(
          title: "Individual Pooja with Dakshina",
          isSelected: false,
          price: "₹${500 * index}",
          id: index,
        ),
      ),
    );
  }
}

class PoojaDetailsModel {
  int id;
  String title;
  String price;
  bool isSelected;

  PoojaDetailsModel({
    required this.title,
    required this.price,
    required this.isSelected,
    required this.id,
  });
}
