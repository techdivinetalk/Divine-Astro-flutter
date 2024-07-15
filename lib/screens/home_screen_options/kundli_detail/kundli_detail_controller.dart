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
import '../../../di/shared_preference_service.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/internal/astro_details_model.dart';
import '../../../model/internal/birth_details_model.dart';
import '../../../model/internal/dasha_chart_data_model.dart';
import '../../../model/internal/horo_chart_model_class.dart';
import '../../../model/internal/kp_data_model.dart';
import '../../../model/internal/kundli_prediction_model.dart';
import '../../../model/internal/manglik_dosh_model.dart';
import '../../../model/internal/planet_detail_model.dart';
import '../../../model/internal/pran_dasha_model.dart';
import '../../../model/internal/pratyantar_dasha_model.dart';
import '../../../model/internal/sookshma_dasha_model.dart';
import '../../../model/kundli/KundaliPlanetDataModel.dart';

class KundliDetailController extends GetxController {
  RxInt currentIndex = 0.obs;
  List<Widget> detailPageImage = [
    Assets.images.icBoyKundli.svg(width: 87.w, height: 87.h),
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
  List<String> detailsPagesNames = [
    "Lagna",
    "Dasha",
    "Navamasha",
    "Sun",
    "Moon",
    "Kp",
    "Dosha",
    "Personal Details",
    "Prediction",
    "Basic Panchang",
  ];
  List<String> dropdownData = [
    "All Charts Available Here",
    "Chalit Chart",
    "Sun Chart",
    "Moon Chart",
    "D1 : For Brith Chart",
    "D2 : For Hora Chart",
    "D3 : For Dreshkan Chart",
    "D4 : For Chathurthamasha Chart",
    "D5 : For Panchmansha Chart",
    "D7 : For Saptamansha Chart",
    "D8 : For Ashtamansha Chart",
    "D9 : For Navamansha Chart",
    "D10 : For Dashamansha Chart",
    "D12 : For Dwadashamsha Chart",
    "D16 : For Shodashamsha Chart",
    "D20 : For Vishamansha Chart",
    "D24 : For Chaturvimshamsha Chart",
    "D27 : For Bhamsha Chart",
    "D30 : For Trishamansha Chart",
    "D40 : For Khavedamsha Chart",
    "D45 : For Akshvedansha Chart",
    "D60 : For Shashtymsha Chart",
  ];

  final _kundliController = Get.put(KundliController());

  late final TabController tabController;

  KundliController get kundliController => _kundliController;
  ScrollController scrollController = ScrollController();

  late final KundliRepository kundliRepository;

  Map<String, dynamic> params = {};
  RxString subDashaPlanetName = ''.obs;

  Rx<AstroDetailsModel> astroDetails = AstroDetailsModel().obs;
  Rx<KundaliPlanetDataModel> kundaliPlanetDetails =
      KundaliPlanetDataModel().obs;

  Rx<BirthDetailsModel> birthDetails = BirthDetailsModel().obs;
  Rx<HoroChartModel> lagnaChart = HoroChartModel().obs,
      moonChart = HoroChartModel().obs,
      sunChart = HoroChartModel().obs,
      navamashaChart = HoroChartModel().obs,
      // chalitChart = HoroChartModel().obs,
      brithChart = HoroChartModel().obs,
      horaChart = HoroChartModel().obs,
      dreshkanChart = HoroChartModel().obs,
      chathurthamashChart = HoroChartModel().obs,
      panchmanshaChart = HoroChartModel().obs,
      saptamanshaChart = HoroChartModel().obs,
      ashtamanshaChart = HoroChartModel().obs,
      navamanshaChart = HoroChartModel().obs,
      dashamanshaChart = HoroChartModel().obs,
      dwadashamshaChart = HoroChartModel().obs,
      shodashamshaChart = HoroChartModel().obs,
      vishamanshaChart = HoroChartModel().obs,
      chaturvimshamshaChart = HoroChartModel().obs,
      bhamshaChart = HoroChartModel().obs,
      trishamanshaChart = HoroChartModel().obs,
      khavedamshaChart = HoroChartModel().obs,
      akshvedanshaChart = HoroChartModel().obs,
      shashtymshaChart = HoroChartModel().obs;
  Rx<ManglikDoshModel> manglikDosh = ManglikDoshModel().obs;
  Rx<HoroChartModel> chalitChart = HoroChartModel().obs;
  Rx<KpDataModel> kpTableData = KpDataModel().obs;
  Rx<PlanetlDetailModel> planetDataDetail = PlanetlDetailModel().obs;
  Rx<DashaChartDataModel> dashaTableData = DashaChartDataModel().obs;
  Rx<PratyantarDashaModel> pratyantarDataDetail = PratyantarDashaModel().obs;
  Rx<SookshmaDashaModel> sookshmaDataDetail = SookshmaDashaModel().obs;
  Rx<PranDashaModel> pranDataDetail = PranDashaModel().obs;
  Rx<KundliPredictionModel> kundliPrediction = KundliPredictionModel().obs;
  Rx<ManglikDoshModel> manglikDoshData = ManglikDoshModel().obs;

  KundliDetailController(this.kundliRepository);

  var preference = Get.find<SharedPreferenceService>();

  RxBool isVimshottari = RxBool(true);
  RxBool isYogini = RxBool(false);
  // RxBool isSubDasha = RxBool(false);
  RxInt subDashaLevel = RxInt(0);

  Rx<Params> kundliParams = Params().obs;
  String? kundaliId;
  Map<String, dynamic> kundaliIdParms = {};

  var args;
  @override
  void onInit() {
    super.onInit();
    args = Get.arguments;

    if (args != null) {
      if (args['from_kundli']) {
        log("--IF--");
        //From Previous Kundlis
        getDataFromKundli(args);
      } else {
        log("--Else--");
        //New Kundli
        getNewKundliData(args);
      }
    }
  }

  String selectedDrop = "All Charts Available Here";
  changeMaintap(value) {
    selectedTab = "null";
    selectedDrop = value;
    appBarName = value;
    if (args != null) {
      if (args['from_kundli']) {
        //From Previous Kundlis
        getDataFromKundli(args);
      } else {
        //New Kundli
        getNewKundliData(args);
      }
    }
    update();
  }

  String selectedTab = "Lagna";
  String appBarName = "Lagna";
  changingTab(value) {
    selectedTab = value;

    selectedDrop = "All Charts Available Here";

    appBarName = value;
    if (args != null) {
      if (args['from_kundli']) {
        //From Previous Kundlis
        getDataFromKundli(args);
      } else {
        //New Kundli
        getNewKundliData(args);
      }
    }
    update();
  }

  getDataFromKundli(dynamic args) async {
    Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    kundaliId = args["kundli_id"].toString();
    if (args['gender'] != Gender.female) {
      detailPageImage[0] =
          Assets.images.icBoyKundli.svg(width: 87.w, height: 87.h);
    }
    kundaliIdParms.addAll({"kundli_id": kundaliId});
    kundliParams.value = Params(
      name: args['name'].toString(),
      location: args["birth_place"].toString(),
    );
    log("Kundli===>$kundaliId");
    getApiData(true);
    getPlanetsDetails(true);
  }

  getNewKundliData(dynamic args) async {
    if (args['gender'] != Gender.female) {
      detailPageImage[0] =
          Assets.images.icBoyKundli.svg(width: 87.w, height: 87.h);
    }
    kundliParams.value = Params(
      name: args['params'].name ?? "",
      day: args['params'].day ?? 0,
      month: args['params'].month ?? 0,
      year: args['params'].year ?? 0,
      hour: args['params'].hour ?? 0,
      min: args['params'].min ?? 0,
      lat: args['params'].lat ?? 0.0,
      long: args['params'].long ?? 0.0,
      tzone: 5.30,
      // tzone: args['params'].tzone,
      location: args['params'].location ?? "",
    );
    params = {
      "day": args['params'].day,
      "month": args['params'].month,
      "year": args['params'].year,
      "hour": args['params'].hour,
      "min": args['params'].min,
      "lat": args['params'].lat,
      "lon": args['params'].long,
      "tzone": 5.30,
      // "tzone": args['params'].tzone,
    };
    getApiData(false);
    getPlanetsDetails(false);
  }

  /*getApiData(bool fromKundali) async {
    await Future.wait([
      astroDetailsApi(fromKundali),
      birthDetailsApi(fromKundali),
      kundliPredictionApi(fromKundali),
      manglikDetails(fromKundali),
      lagnaChartApi(fromKundali),
      moonChartApi(fromKundali),
      sunChartApi(fromKundali),
      navamashaChartApi(fromKundali),
      getKpTableDataListAPI(fromKundali),
      getDashaTableDataListAPI(fromKundali),
      chalitChartApi(fromKundali),
    ]);
  }*/
  getApiData(bool fromKundali) async {
    log(preference.getAmazonUrl().toString());
    log(preference.getAmazonUrl().toString());
    // lagnaChartApi(fromKundali);

    switch (appBarName) {
      case "Personal Details":
        if (astroDetails.value.data == null) {
          astroDetailsApi(fromKundali);
        }
        if (birthDetails.value.data == null) {
          birthDetailsApi(fromKundali);
        }
        break;
      case "Lagna":
        if (lagnaChart.value.data == null) {
          lagnaChartApi(fromKundali);
        }

        break;
      case "Moon":
        if (moonChart.value.data == null) {
          moonChartApi(fromKundali);
        }
        break;
      case "Sun":
        if (sunChart.value.data == null) {
          sunChartApi(fromKundali);
        }
        break;
      case "Navamasha":
        if (navamanshaChart.value.data == null) {
          navamashaChartApi(fromKundali);
        }
        break;
      case "Dosha":
        if (manglikDoshData.value.data == null) {
          manglikDetails(fromKundali);
        }
        break;
      case "Kp":
        if (kpTableData.value.data == null) {
          getKpTableDataListAPI(fromKundali);
        }
        break;
      case "Dasha":
        // getKpTableDataListAPI(fromKundali);
        if (dashaTableData.value.data == null) {
          getDashaTableDataListAPI(fromKundali);
        }

        break;
      case "Basic Panchang":
        if (birthDetails.value.data == null) {
          birthDetailsApi(fromKundali);
        }

        break;
      case "Prediction":
        if (kundliPrediction.value.data == null) {
          kundliPredictionApi(fromKundali);
        }
        break;
      ///////////////
      case "Chalit Chart":
        if (chalitChart.value.data == null) {
          chalitChartApi(fromKundali);
        }
        break;
      case "Sun Chart":
        if (sunChart.value.data == null) {
          sunChartApi(fromKundali);
        }
        break;
      case "Moon Chart":
        if (moonChart.value.data == null) {
          moonChartApi(fromKundali);
        }
        break;
      case "D1 : For Brith Chart":
        if (brithChart.value.data == null) {
          brithChartApi(fromKundali);
        }
        break;
      case "D2 : For Hora Chart":
        if (horaChart.value.data == null) {
          horaChartApi(fromKundali);
        }
        break;
      case "D3 : For Dreshkan Chart":
        if (dreshkanChart.value.data == null) {
          dreshkanChartApi(fromKundali);
        }
        break;
      case "D4 : For Chathurthamasha Chart":
        if (chathurthamashChart.value.data == null) {
          chathurthamashChartApi(fromKundali);
        }
        break;
      case "D5 : For Panchmansha Chart":
        if (panchmanshaChart.value.data == null) {
          panchmanshaChartApi(fromKundali);
        }
        break;
      case "D7 : For Saptamansha Chart":
        if (saptamanshaChart.value.data == null) {
          saptamanshaChartApi(fromKundali);
        }
        break;
      case "D8 : For Ashtamansha Chart":
        if (ashtamanshaChart.value.data == null) {
          ashtamanshaChartApi(fromKundali);
        }
        break;
      case "D9 : For Navamansha Chart":
        if (navamanshaChart.value.data == null) {
          navamashaChartApi(fromKundali);
        }
        break;
      case "D10 : For Dashamansha Chart":
        if (dashamanshaChart.value.data == null) {
          dashamanshaChartApi(fromKundali);
        }
        break;
      case "D12 : For Dwadashamsha Chart":
        if (dwadashamshaChart.value.data == null) {
          dwadashamshaChartApi(fromKundali);
        }
        break;
      case "D16 : For Shodashamsha Chart":
        if (shodashamshaChart.value.data == null) {
          shodashamshaChartApi(fromKundali);
        }
        break;
      case "D20 : For Vishamansha Chart":
        if (vishamanshaChart.value.data == null) {
          vishamanshaChartApi(fromKundali);
        }
        break;
      case "D24 : For Chaturvimshamsha Chart":
        if (chaturvimshamshaChart.value.data == null) {
          chaturvimshamshaChartApi(fromKundali);
        }
        break;
      case "D27 : For Bhamsha Chart":
        if (bhamshaChart.value.data == null) {
          bhamshaChartApi(fromKundali);
        }
        break;
      case "D30 : For Trishamansha Chart":
        if (trishamanshaChart.value.data == null) {
          trishamanshaChartApi(fromKundali);
        }
        break;
      case "D40 : For Khavedamsha Chart":
        if (akshvedanshaChart.value.data == null) {
          khavedamshaChartApi(fromKundali);
        }
        break;
      case "D45 : For Akshvedansha Chart":
        if (akshvedanshaChart.value.data == null) {
          akshvedanshaChartApi(fromKundali);
        }
        break;
      case "D60 : For Shashtymsha Chart":
        if (shashtymshaChart.value.data == null) {
          shashtymshaChartApi(fromKundali);
        }
        break;
    }
  }

  //Dasha table Data
  Future<void> getDashaTableDataListAPI(bool fromKundali) async {
    try {
      DashaChartDataModel response = await kundliRepository
          .getDashaChart(fromKundali ? kundaliIdParms : params);
      dashaTableData.value = response;

      update();
      log("dashaTableData==>${jsonEncode(dashaTableData.value)}");
    } catch (error) {
      debugPrint("kpTableDataError $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  Future<void> getPlanetsDetails(bool fromKundali) async {
    // [log] response: {"data":null,"success":false,"error":"Method App\\Http\\Controllers\\Api\\v7\\AstrologerController::astroApiCall does not exist.","status_code":500,"errors":[]}
    // [log] planetDetails==>{"success":false,"status_code":500,"message":null}

    try {
      KundaliPlanetDataModel response = await kundliRepository
          .getPlanetDetails(fromKundali ? kundaliIdParms : params);
      kundaliPlanetDetails.value = response;
      debugPrint("Body==> $kundaliIdParms");
      log("planetDetails==>${jsonEncode(kundaliPlanetDetails.value)}");
    } catch (error) {
      debugPrint("astroDetailsError $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  Future<void> getAntraDataApiList(String planetName) async {
    try {
      PlanetlDetailModel response =
          await kundliRepository.getPlanetDetailsAPI(params, planetName);
      if ((response.data ?? []).isNotEmpty) {
        planetDataDetail.value = response;
      } else {
        subDashaLevel.value = 0;
        divineSnackBar(data: "noDataAntarDasha".tr);
      }
      log("planetDataDetail-->${jsonEncode(planetDataDetail.value.data)}");
      update();
    } catch (error) {
      debugPrint("planetDataDetailError $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  Future<void> chalitChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'CHALIT');
      chalitChart.value = response;
      log("------------------------------${preference.getAmazonUrl()}/${chalitChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("chalitChartError $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  Future<void> manglikDetails(bool fromKundali) async {
    try {
      ManglikDoshModel response = await kundliRepository
          .getManglikDoshDetails(fromKundali ? kundaliIdParms : params);
      manglikDosh.value = response;
      log("manglikDoshData==>${jsonEncode(manglikDosh.value)}");
    } catch (error) {
      debugPrint("manglikDoshData==> $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
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

      log("kpTableData==>${jsonEncode(kpTableData.value)}");
    } catch (error) {
      debugPrint("kpTableDataError $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  Future<void> astroDetailsApi(bool fromKundali) async {
    try {
      AstroDetailsModel response = await kundliRepository
          .getAstroDetails(fromKundali ? kundaliIdParms : params);
      astroDetails.value = response;
      log("astroDetails====>${jsonEncode(astroDetails)}");
    } catch (error) {
      debugPrint("astroDetailsError $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
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
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  Future<void> lagnaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, ':chartId');
      lagnaChart.value = response;
      log("------------------------------${preference.getAmazonUrl()}/${lagnaChart.value.data!.svg}");
      log("------------------------------${lagnaChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  Future<void> moonChartApi(bool fromKundali) async {
    log(fromKundali.toString());
    log(kundaliIdParms.toString());
    log(params.toString());

    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'MOON');
      moonChart.value = response;
      log("------------------------------${preference.getAmazonUrl()}/${moonChart.value.data!.svg}");
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  Future<void> sunChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'SUN');
      sunChart.value = response;
      log("------------------------------${preference.getAmazonUrl()}/${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  Future<void> navamashaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D9');
      navamashaChart.value = response;
      log("------------------------------${preference.getAmazonUrl()}/${navamashaChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  ///

  Future<void> brithChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D1');
      brithChart.value = response;
      log("brithChart==>${jsonEncode(brithChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> horaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D2');
      horaChart.value = response;
      log("horaChart==>${jsonEncode(horaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> dreshkanChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D3');
      dreshkanChart.value = response;
      log("dreshkanChart==>${jsonEncode(dreshkanChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> chathurthamashChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D4');
      chathurthamashChart.value = response;
      log("chathurthamashChart==>${jsonEncode(chathurthamashChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> panchmanshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D5');
      panchmanshaChart.value = response;
      log("panchmanshaChart==>${jsonEncode(panchmanshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> saptamanshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D7');
      saptamanshaChart.value = response;
      log("saptamanshaChart==>${jsonEncode(saptamanshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> ashtamanshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D8');
      ashtamanshaChart.value = response;
      log("ashtamanshaChart==>${jsonEncode(ashtamanshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> dashamanshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D10');
      dashamanshaChart.value = response;
      log("dashamanshaChart==>${jsonEncode(dashamanshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");
      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> dwadashamshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D12');
      dwadashamshaChart.value = response;
      log("dwadashamshaChart==>${jsonEncode(dwadashamshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> shodashamshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D16');
      shodashamshaChart.value = response;
      log("shodashamshaChart==>${jsonEncode(shodashamshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> vishamanshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D20');
      vishamanshaChart.value = response;
      log("vishamanshaChart==>${jsonEncode(vishamanshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> chaturvimshamshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D24');
      chaturvimshamshaChart.value = response;
      log("chaturvimshamshaChart==>${jsonEncode(chaturvimshamshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> bhamshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D27');
      bhamshaChart.value = response;
      log("bhamshaChart==>${jsonEncode(bhamshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> trishamanshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D30');
      trishamanshaChart.value = response;
      log("trishamanshaChart==>${jsonEncode(trishamanshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> khavedamshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D40');
      khavedamshaChart.value = response;
      log("khavedamshaChart==>${jsonEncode(khavedamshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> akshvedanshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D45');
      akshvedanshaChart.value = response;
      log("akshvedanshaChart==>${jsonEncode(akshvedanshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  Future<void> shashtymshaChartApi(bool fromKundali) async {
    try {
      HoroChartModel response = await kundliRepository.getHoroChart(
          fromKundali ? kundaliIdParms : params, 'D60');
      shashtymshaChart.value = response;
      log("shashtymshaChart==>${jsonEncode(shashtymshaChart.value)}");
      log("------------------------------${preference.getAmazonUrl()}${sunChart.value.data!.svg}");

      update();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }

    update();
  }

  /// //
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
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  //Pratyantar dasha table
  Future<void> getPratyantarDashaApiList(
      String planetName, String atraName) async {
    try {
      PratyantarDashaModel response = await kundliRepository
          .getPratyantarDashaDetailsAPI(params, planetName, atraName);
      if ((response.data ?? []).isNotEmpty) {
        pratyantarDataDetail.value = response;
      } else {
        subDashaLevel.value = 1;
        divineSnackBar(data: "noDataPratyantarDasha".tr);
      }
      log("pratyantarDataDetail-->${jsonEncode(pratyantarDataDetail.value.data)}");
      update();
    } catch (error) {
      debugPrint("pratyantarDataError $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  //Sookshma dasha
  Future<void> getSookshmaDashaApiList(
      String planetName, String atraName, String pratyantarName) async {
    try {
      SookshmaDashaModel response =
          await kundliRepository.getSookshmaDashaDetailsAPI(
              params, planetName, atraName, pratyantarName);
      if ((response.data ?? []).isNotEmpty) {
        sookshmaDataDetail.value = response;
      } else {
        subDashaLevel.value = 2;
        divineSnackBar(data: "noDataSookshmaDasha".tr);
      }
      log("sookshmaDataDetail-->${jsonEncode(sookshmaDataDetail.value.data)}");
      update();
    } catch (error) {
      debugPrint("sookshmaDataDetailError $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }

  //Pran dasha
  Future<void> getPranDashaApiList(String planetName, String atraName,
      String pratyantarName, String sookshmaName) async {
    try {
      PranDashaModel response = await kundliRepository.getPranDashaDetailsAPI(
          params, planetName, atraName, pratyantarName, sookshmaName);
      if ((response.data ?? []).isNotEmpty) {
        pranDataDetail.value = response;
      } else {
        subDashaLevel.value = 3;
        divineSnackBar(data: "noDataPranDasha".tr);
      }
      log("pranDataDetail-->${jsonEncode(sookshmaDataDetail.value.data)}");
      update();
    } catch (error) {
      debugPrint("pranDataDetailError $error");
      if (error is AppException) {
        error.onException();
      } else {
        if (error.toString() == "Null check operator used on a null value") {
        } else {
          divineSnackBar(data: error.toString(), color: appColors.red);
        }
      }
    }
    update();
  }
}
