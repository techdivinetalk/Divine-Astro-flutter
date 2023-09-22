import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TabEnum { checkYours, checkOther }

enum Gender { none, male, female }

class KundliController extends GetxController {
  TabController? tabController;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  final yourFormKey = GlobalKey<FormState>();
  Rx<Gender> yourGender = Gender.male.obs;
  TextEditingController yourNameController = TextEditingController();
  TextEditingController yourDateController = TextEditingController();
  TextEditingController yourTimeController = TextEditingController();
  TextEditingController yourPlaceController = TextEditingController();
  Rx<Params> yourParams = Params().obs;

  final otherFormKey = GlobalKey<FormState>();
  Rx<Gender> otherGender = Gender.male.obs;
  TextEditingController otherNameController = TextEditingController();
  TextEditingController otherDateController = TextEditingController();
  TextEditingController otherTimeController = TextEditingController();
  TextEditingController otherPlaceController = TextEditingController();
  Rx<Params> otherParams = Params().obs;

  late Params submittedParams;
  late Gender submittedGender;

  UserData? userData;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  submitDetails(Params params, Gender gender) {
    submittedParams = params;
    submittedGender = gender;
    Get.toNamed(RouteName.kundliDetail, arguments: {
      "kundli_id": 0,
      "from_kundli": false,
      "params": params,
      "gender": gender,
    });
  }

  getUserData() async {
    var _userData = preferenceService.getUserDetail();
    userData = _userData;
    if (userData!.name != null) {
      yourNameController.text = userData!.name!;
    }
    /*if (userData!.dateOfBirth != null) {
      DateTime data = DateFormat("dd MMMM yyyy").parse(_userData!.dateOfBirth);
      yourDateController.text =
          "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString()}";
      yourParams.value.day = data.day;
      yourParams.value.month = data.month;
      yourParams.value.year = data.year;
    }*/
    update();
  }
}

class Params {
  int? day, month, year, hour, min;
  double? lat, long, tzone;
  String? name, location;

  Params({
    this.day,
    this.month,
    this.year,
    this.hour,
    this.min,
    this.lat,
    this.long,
    this.tzone,
    this.location,
    this.name,
  });
}
