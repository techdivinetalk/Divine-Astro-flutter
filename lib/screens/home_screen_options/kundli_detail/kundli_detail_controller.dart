import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/model/kundli/horo_chart_model.dart';
import 'package:divine_astrologer/model/kundli/kundli_prediction_model.dart';
import 'package:divine_astrologer/model/kundli/pitra_dosh_model.dart';
import 'package:divine_astrologer/model/kundli/sadhesati_dosh_model.dart';
import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';
import '../../../model/internal/astro_details_model.dart';
import '../../../model/internal/birth_details_model.dart';
import '../../../model/internal/horo_chart_model_class.dart';
import '../../../model/internal/kundli_prediction_model.dart';
import '../../../model/internal/manglik_dosh_model.dart';

class KundliDetailController extends GetxController {
  RxInt currentIndex = 0.obs;
  List<Widget> detailPageImage = [
    Assets.images.icGirlKundli.svg(width: 87.w, height: 87.h),
    Assets.images.icWedding.svg(width: 87.w, height: 87.h),
    Assets.images.icMoon.svg(width: 87.w, height: 87.h),
    Assets.images.icSun.svg(width: 87.w, height: 87.h),
    Assets.images.icMars.image(width: 87.w, height: 87.h),
    Assets.images.icSwastika.svg(width: 87.w, height: 87.h),
    Assets.images.bgDasha.svg(width: 87.w, height: 87.h),
    Assets.images.bgDasha.svg(width: 87.w, height: 87.h),
    Assets.images.icGanesh.svg(width: 87.w, height: 87.h),
    Assets.images.icEye.svg(width: 87.w, height: 87.h),
  ];

  final _kundliController = Get.find<KundliController>();

  late final TabController tabController;

  KundliController get kundliController => _kundliController;

  late final KundliRepository kundliRepository;

  Map<String, dynamic> params = {
  };

  Rx<AstroDetailsModel> astroDetails = AstroDetailsModel().obs;
  Rx<BirthDetailsModel> birthDetails = BirthDetailsModel().obs;
  Rx<HoroChartModel> lagnaChart = HoroChartModel().obs, moonChart = HoroChartModel().obs, sunChart = HoroChartModel().obs, navamashaChart = HoroChartModel().obs;
  Rx<ManglikDoshModel> manglikDosh = ManglikDoshModel().obs;
  Rx<ManglikDoshModel> kalsarpaDosh = ManglikDoshModel().obs;
  Rx<ManglikDoshModel> sadesathiDosh = ManglikDoshModel().obs;
  Rx<ManglikDoshModel> pitraDosh = ManglikDoshModel().obs;
  Rx<KundliPredictionModel> kundliPrediction = KundliPredictionModel().obs;

  KundliDetailController(this.kundliRepository);


  RxBool isVimshottari = RxBool(true);
  RxBool isYogini = RxBool(false);
  RxBool isSubDasha = RxBool(false);

  List<List<String>> planetList = <List<String>>[
    ["ME-RA", ''],
    ["ME-RA", ''],
    ["ME-RA", ''],
  ];
  List<List<String>> startDateList = <List<String>>[
    ['Birth', ''],
    ['12th-Apr', ''],
    ['Birth', ''],
  ];
  List<List<String>> endDateList = <List<String>>[
    ['12th-Apr', ''],
    ['12th-Apr', ''],
    ['12th-Apr', ''],
  ];

  @override
  void onInit() {
    super.onInit();
    if (_kundliController.submittedGender != Gender.female) {
      detailPageImage[0] = Assets.images.icBoyKundli.svg(width: 87.w, height: 87.h);
    }
    params = {
      "day": kundliController.submittedParams.day,
      "month": kundliController.submittedParams.month,
      "year": kundliController.submittedParams.year,
      "hour": kundliController.submittedParams.hour,
      "min": kundliController.submittedParams.min,
      "lat": kundliController.submittedParams.lat,
      "lon": kundliController.submittedParams.long,
      "tzone": 5.5,
    };
    getApiData();
  }

  Rx<Params> kundliParams = Params().obs;
  getApiData() async {
    await Future.wait([
      astroDetailsApi(),
      birthDetailsApi(),
      kalsarpaDetails(),
      lagnaChartApi(),
      moonChartApi(),
      sunChartApi(),
      navamashaChartApi(),
      mangalikDoshApi(),
      kalsarpaDoshApi(),
      sadesathiDoshApi(),
      pitraDoshApi(),
      kundliPredictionApi(),
    ]);
  }

  Future<void> astroDetailsApi() async {
    try {
      AstroDetailsModel response = await kundliRepository.getAstroDetails(params);
      astroDetails.value = response;
      log("Data====>${jsonEncode(astroDetails)}");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> birthDetailsApi() async {
    try {
      BirthDetailsModel response = await kundliRepository.getBirthDetails(params);
      birthDetails.value = response;
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> kalsarpaDetails() async {
    try {
      ManglikDoshModel response = await kundliRepository.getKalsarpaDoshDetails(params);
      kalsarpaDosh.value = response;
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> lagnaChartApi() async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(params, ':chartId');
      lagnaChart.value = response;
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> moonChartApi() async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(params, 'MOON');
      moonChart.value = response;
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> sunChartApi() async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(params, 'SUN');
      sunChart.value = response;
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> navamashaChartApi() async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(params, 'D9');
      navamashaChart.value = response;
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> mangalikDoshApi() async {
    try {
      ManglikDoshModel response = await kundliRepository.getManglikDoshDetails(params);
      manglikDosh.value = response;
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> kalsarpaDoshApi() async {
    try {
      ManglikDoshModel response = await kundliRepository.getKalsarpaDoshDetails(params);
      kalsarpaDosh.value = response;
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> sadesathiDoshApi() async {
    try {
      ManglikDoshModel response = await kundliRepository.getSadesathiDoshDetails(params);
      sadesathiDosh.value = response;
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> pitraDoshApi() async {
    try {
      ManglikDoshModel response = await kundliRepository.getPitraDoshDetails(params);
      pitraDosh.value = response;
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }

  Future<void> kundliPredictionApi() async {
    try {
      KundliPredictionModel response = await kundliRepository.getKundliPredictionDetails(params);
      kundliPrediction.value = response;
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    update();
  }
}
