import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/speciality_list.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class EditProfileController extends GetxController {
  final state = EditProfileState();
  final UserRepository repository;

  EditProfileController(this.repository);

  GlobalKey<FormState> get formState => state.formKey;

  RxInt tag = 0.obs;
  RxList<int> tagIndexes = [0].obs;

  RxList<SpecialityData> tags = <SpecialityData>[].obs;
  List<SpecialityData> options = <SpecialityData>[].obs;

  @override
  void onInit() {
    super.onInit();
    state.init();
    options = state.specialityList.data;
  }

  @override
  void dispose() {
    super.dispose();
    state.dispose();
  }

  void editProfile() async {
    if (formState.currentState!.validate()) {
      formState.currentState!.save();
      Map<String, dynamic> param = {
        "name": state.nameController.text.trim(),
        "experiance": state.experienceController.text.trim(),
        "description": state.descriptionController.text.trim(),
        "astrologer_speciality_id":
            tags.map((element) => element.id).toList().join(",")
      };
      final response = await repository.updateProfile(param);
      if (response.statusCode == 200) {
        state.preferenceService
            .setUserDetail(UserData.fromJson(response.data!.toJson()));
        Get.back();
        Get.snackbar("Success", response.message.toString());
      }
      if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: response.statusCode.toString());
      }
    }
  }
}

class EditProfileState {
  late TextEditingController nameController;
  late TextEditingController experienceController;
  late TextEditingController descriptionController;
  late SpecialityList specialityList;

  final preferenceService = Get.find<SharedPreferenceService>();

  late final GlobalKey<FormState> formKey;

  UserData? userData;

  void init() {
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    experienceController = TextEditingController();
    descriptionController = TextEditingController();
    assignData();
  }

  void assignData() {
    userData = preferenceService.getUserDetail();

    nameController.text = userData?.name ?? "";
    experienceController.text = userData?.experiance.toString() ?? "";

    Document description = parse(userData?.description ?? "");
    descriptionController.text = description.documentElement!.text;

    String specialityString = preferenceService.getSpecialAbility()!;
    specialityList = specialityListFromJson(specialityString);
  }

  void dispose() {
    nameController.dispose();
    experienceController.dispose();
    descriptionController.dispose();
  }
}
