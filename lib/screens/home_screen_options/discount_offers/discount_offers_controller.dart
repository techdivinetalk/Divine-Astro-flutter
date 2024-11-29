import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/constants.dart';
import 'package:divine_astrologer/repository/discount_offer_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/home_page_model_class.dart';
import '../../../model/update_offer_type_response.dart';

class DiscountOffersController extends GetxController {
  List<DiscountOffer> discountOffers = [];
  Rx<Loading> offerTypeLoading = Loading.initial.obs;

  Loading loading = Loading.initial;

  @override
  void onInit() {
    super.onInit();
    getDiscountOffers();
  }

  getDiscountOffers() async {
    loading = Loading.loading;
    update();

    final List<DiscountOffer> discountList =
        await DiscountOfferRepository().getAllDiscountOffers();

    discountOffers = discountList;
    for (int i = 0; i < discountOffers.length; i++) {
      if (discountOffers[i].toggle == 1) {
        discountOffers[i].isOn = true;
      } else {
        discountOffers[i].isOn = false;
      }
    }

    loading = Loading.loaded;
    update();
  }

  Future<void> updateOfferType({
    required bool value,
    required int offerId,
    required int index,
    required int offerType,
  }) async {
    Map<String, dynamic> params = {
      "offer_id": offerId,
      "offer_type": offerType,
      "action": value ? 1 : 0,
    };
    offerTypeLoading.value = Loading.loading;
    try {
      UpdateOfferResponse response =
          await userRepository.updateOfferTypeApi(params);
      if (response.statusCode == 200) {
        discountOffers[index].isOn = value;
      }
      update();
    } catch (error) {
      discountOffers[index].isOn = !value;
      debugPrint("updateOfferType $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    offerTypeLoading.value = Loading.loaded;
    update();
  }

  backMethod() {
    Get.back(result: discountOffers);
  }
}
