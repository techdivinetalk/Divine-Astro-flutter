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
    Assets.images.icGirlKundli.svg(),
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
    params = {
      "day": kundliController.params.value.day,
      "month": kundliController.params.value.month,
      "year": kundliController.params.value.year,
      "hour": kundliController.params.value.hour,
      "min": kundliController.params.value.min,
      "lat": kundliController.params.value.lat,
      "lon": kundliController.params.value.long,
      "tzone": 5.5,
    };
    astroDetailsApi();
    birthDetailsApi();
    kalsarpaDetails();
    lagnaChartApi();
    moonChartApi();
    sunChartApi();
    navamashaChartApi();
    mangalikDoshApi();
    kalsarpaDoshApi();
    sadesathiDoshApi();
    pitraDoshApi();
    kundliPredictionApi();
  }

  void astroDetailsApi() async {
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

  void birthDetailsApi() async {
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

  void kalsarpaDetails() async {
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

  void lagnaChartApi() async {
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
  }

  void moonChartApi() async {
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
  }

  void sunChartApi() async {
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
  }

  void navamashaChartApi() async {
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
  }

  void mangalikDoshApi() async {
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
  }

  void kalsarpaDoshApi() async {
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
  }

  void sadesathiDoshApi() async {
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
  }

  void pitraDoshApi() async {
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
  }

  void kundliPredictionApi() async {
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
  }
}
