import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../pages/suggest_remedies/suggest_remedies_ui.dart';
import '../../../repository/shop_repository.dart';
import 'all_option_controller.dart';

class SuggestRemediesView extends GetView<AllOptionControler> {
  const SuggestRemediesView({Key? key}) : super(key: key);

  // final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    Get.put(AllOptionControler(Get.put(ShopRepository())));
    return const Scaffold(body: SuggestRemediesUI());
  }
}
