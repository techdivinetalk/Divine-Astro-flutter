import 'dart:convert';
import 'dart:developer';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/internal/astro_details_model.dart';
import '../../../model/internal/birth_details_model.dart';
import '../../../model/internal/dasha_chart_data_model.dart';
import '../../../model/internal/horo_chart_model_class.dart';
import '../../../model/internal/kp_data_model.dart';
import '../../../model/internal/kundli_prediction_model.dart';
import '../../../model/internal/manglik_dosh_model.dart';
import '../../../model/internal/planet_detail_model.dart';

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

  final _kundliController = Get.put(KundliController());

  late final TabController tabController;

  KundliController get kundliController => _kundliController;

  late final KundliRepository kundliRepository;

  Map<String, dynamic> params = {};
  RxString subDashaPlanetName = ''.obs;

  Rx<AstroDetailsModel> astroDetails = AstroDetailsModel().obs;
  Rx<BirthDetailsModel> birthDetails = BirthDetailsModel().obs;
  Rx<HoroChartModel> lagnaChart = HoroChartModel().obs,
      moonChart = HoroChartModel().obs,
      sunChart = HoroChartModel().obs,
      navamashaChart = HoroChartModel().obs;
  Rx<ManglikDoshModel> manglikDosh = ManglikDoshModel().obs;
  Rx<HoroChartModel> chalitChart = HoroChartModel().obs;
  Rx<KpDataModel> kpTableData = KpDataModel().obs;
  Rx<PlanetlDetailModel> planetDataDetail = PlanetlDetailModel().obs;
  Rx<DashaChartDataModel> dashaTableData = DashaChartDataModel().obs;

  Rx<KundliPredictionModel> kundliPrediction = KundliPredictionModel().obs;
  Rx<ManglikDoshModel> manglikDoshData = ManglikDoshModel().obs;

  KundliDetailController(this.kundliRepository);

  RxBool isVimshottari = RxBool(true);
  RxBool isYogini = RxBool(false);
  RxBool isSubDasha = RxBool(false);

  Rx<Params> kundliParams = Params().obs;
  String? kundaliId;
  Map<String, dynamic> kundaliIdParms = {};

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
    var args = Get.arguments;
    if (args != null) {
      if (args['from_kundli']) {
        //From Previous Kundlis
        getDataFromKundli(args);
      } else {
        //New Kundli
        getNewKundliData(args);
      }
    }
  }

  getDataFromKundli(dynamic args) async {
    Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    kundaliId = args["kundli_id"].toString();
    if (args['gender'] != Gender.female) {
      detailPageImage[0] =
          Assets.images.icBoyKundli.svg(width: 87.w, height: 87.h);
    }
    kundliParams.value = Params(
      location: args["birth_place"].toString(),
    );
    log("Kundli===>$kundaliId");
    getApiData(true);
  }

  getNewKundliData(dynamic args) async {
    if (args['gender'] != Gender.female) {
      detailPageImage[0] =
          Assets.images.icBoyKundli.svg(width: 87.w, height: 87.h);
    }
    kundliParams.value = Params(
      day: args['params'].day,
      month: args['params'].month,
      year: args['params'].year,
      hour: args['params'].hour,
      min: args['params'].min,
      lat: args['params'].lat,
      long: args['params'].long,
      tzone: 5.5,
      // tzone: args['params'].tzone,
      location: args['params'].location,
    );
    params = {
      "day": args['params'].day,
      "month": args['params'].month,
      "year": args['params'].year,
      "hour": args['params'].hour,
      "min": args['params'].min,
      "lat": args['params'].lat,
      "lon": args['params'].long,
      "tzone": 5.5,
      // "tzone": args['params'].tzone,
    };
    getApiData(false);
  }

  getApiData(bool fromKundali) async {
    await Future.wait([
      astroDetailsApi(fromKundali),
      birthDetailsApi(fromKundali),
      kundliPredictionApi(fromKundali),
      // manglikDetails(fromKundali),
      lagnaChartApi(fromKundali),
      moonChartApi(fromKundali),
      sunChartApi(fromKundali),
      navamashaChartApi(fromKundali),
      getKpTableDataListAPI(fromKundali),
      getDashaTableDataListAPI(fromKundali),
      chalitChartApi(fromKundali),
    ]);
  }

  //Dasha table Data
  Future<void> getDashaTableDataListAPI(bool fromKundali) async {
    try {
      DashaChartDataModel response = await kundliRepository
          .getDashaChart(fromKundali ? kundaliIdParms : params);
      dashaTableData.value = response;
      update();
      log("dashaTableData==>${jsonEncode(kpTableData.value)}");
    } catch (error) {
      debugPrint("kpTableDataError $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
    update();
  }

  Future<void> getPlanetDataApiList(String planetName) async {
    try {
      PlanetlDetailModel response =
          await kundliRepository.getPlanetDetailsAPI(params, planetName);
      planetDataDetail.value = response;
      log("planetDataDetail-->${jsonEncode(planetDataDetail.value.data)}");
      update();
    } catch (error) {
      debugPrint("planetDataDetailError $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
    update();
  }

  Future<void> chalitChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'CHALIT');
      chalitChart.value = response;
      // log("chalitChart==>${jsonEncode(chalitChart.value)}");

      update();
    } catch (error) {
      debugPrint("chalitChartError $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
    update();
  }

  Future<void> manglikDetails(bool fromKundali) async {
    try {
      ManglikDoshModel response = await kundliRepository
          .getManglikDoshDetails(fromKundali ? kundaliIdParms : params);
      manglikDoshData.value = response;
      log("manglikDoshData==>${jsonEncode(manglikDoshData.value)}");
    } catch (error) {
      debugPrint("manglikDoshData==> $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
    update();
  }

  //KP table Data
  Future<void> getKpTableDataListAPI(bool fromKundali) async {
    try {
      KpDataModel response = await kundliRepository
          .getKpTableData(fromKundali ? kundaliIdParms : params);

      kpTableData.value = response;
      update();
      log("kpTableData==>${jsonEncode(kpTableData.value)}");
    } catch (error) {
      debugPrint("kpTableDataError $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
    update();
  }

  Future<void> astroDetailsApi(bool fromKundali) async {
    try {
      AstroDetailsModel response = await kundliRepository
          .getAstroDetails(fromKundali ? kundaliIdParms : params);
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

  Future<void> birthDetailsApi(bool fromKundali) async {
    try {
      BirthDetailsModel response = await kundliRepository
          .getBirthDetails(fromKundali ? kundaliIdParms : params);
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

  Future<void> lagnaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, ':chartId');
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

  Future<void> moonChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'MOON');
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

  Future<void> sunChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'SUN');
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

  Future<void> navamashaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D9');
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

  Future<void> mangalikDoshApi(bool fromKundali) async {
    try {
      ManglikDoshModel response = await kundliRepository
          .getManglikDoshDetails(fromKundali ? kundaliIdParms : params);
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

  Future<void> kundliPredictionApi(bool fromKundali) async {
    try {
      KundliPredictionModel response = await kundliRepository
          .getKundliPredictionDetails(fromKundali ? kundaliIdParms : params);
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
