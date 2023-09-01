import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/model/kundli/astro_details_model.dart';
import 'package:divine_astrologer/model/kundli/birth_details_model.dart';
import 'package:divine_astrologer/model/kundli/horo_chart_model.dart';
import 'package:divine_astrologer/model/kundli/kalsarpa_dosh_model.dart';
import 'package:divine_astrologer/model/kundli/kundli_prediction_model.dart';
import 'package:divine_astrologer/model/kundli/manglik_dosh_model.dart';
import 'package:divine_astrologer/model/kundli/pitra_dosh_model.dart';
import 'package:divine_astrologer/model/kundli/sadhesati_dosh_model.dart';
import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class KundliDetailController extends GetxController {
  RxInt currentIndex = 0.obs;
  List<Widget> detailPageImage = [
    Assets.images.icGirlKundli.svg(width: 87.w, height: 87.h),
    Assets.images.icWedding.svg(width: 87.w, height: 87.h),
    Assets.images.icMoon.svg(width: 87.w, height: 87.h),
    Assets.images.icSun.svg(width: 87.w, height: 87.h),
    Assets.images.icMars.image(width: 87.w, height: 87.h),
    Assets.images.icSwastika.svg(width: 87.w, height: 87.h),
    Assets.images.icGanesh.svg(width: 87.w, height: 87.h),
    Assets.images.icEye.svg(width: 87.w, height: 87.h),
  ];

  final _kundliController = Get.find<KundliController>();

  late final TabController tabController;

  KundliController get kundliController => _kundliController;

  late final KundliRepository kundliRepository;

  Map<String, dynamic> params = {};

  Rx<AstroDetails> astroDetails = AstroDetails().obs;
  Rx<BirthDetails> birthDetails = BirthDetails().obs;
  Rx<HoroChart> lagnaChart = HoroChart().obs,
      moonChart = HoroChart().obs,
      sunChart = HoroChart().obs,
      navamashaChart = HoroChart().obs;
  Rx<ManglikDosh> manglikDosh = ManglikDosh().obs;
  Rx<KalsarpaDosh> kalsarpaDosh = KalsarpaDosh().obs;
  Rx<SadesathiDosh> sadesathiDosh = SadesathiDosh().obs;
  Rx<PitraDosh> pitraDosh = PitraDosh().obs;
  Rx<KundliPrediction> kundliPrediction = KundliPrediction().obs;

  KundliDetailController(this.kundliRepository);

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
      AstroDetails response = await kundliRepository.getAstroDetails(params);
      astroDetails.value = response;
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
      BirthDetails response = await kundliRepository.getBirthDetails(params);
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
      KalsarpaDosh response = await kundliRepository.getKalsarpaDoshDetails(params);
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
      HoroChart response = await kundliRepository.getHoroChart(params, ':chartId');
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
      HoroChart response = await kundliRepository.getHoroChart(params, 'MOON');
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
      HoroChart response = await kundliRepository.getHoroChart(params, 'SUN');
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
      HoroChart response = await kundliRepository.getHoroChart(params, 'D9');
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
      ManglikDosh response = await kundliRepository.getManglikDoshDetails(params);
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
      KalsarpaDosh response = await kundliRepository.getKalsarpaDoshDetails(params);
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
      SadesathiDosh response = await kundliRepository.getSadesathiDoshDetails(params);
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
      PitraDosh response = await kundliRepository.getPitraDoshDetails(params);
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
      KundliPrediction response = await kundliRepository.getKundliPredictionDetails(params);
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
