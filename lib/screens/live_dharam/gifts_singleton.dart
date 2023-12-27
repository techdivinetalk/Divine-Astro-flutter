import "dart:async";

import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/zeo_team/cache.dart";
import "package:flutter/foundation.dart";
import "package:get/get.dart";
import "package:get/get_connect/http/src/status/http_status.dart";

import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/model/astrologer_gift_response.dart";
import "package:divine_astrologer/repository/astrologer_profile_repository.dart";

class GiftsSingleton {
  static final GiftsSingleton _singleton = GiftsSingleton._internal();

  factory GiftsSingleton() {
    return _singleton;
  }

  GiftsSingleton._internal();

  final SharedPreferenceService _pref = Get.put(SharedPreferenceService());
  final AstrologerProfileRepository liveRepository =
      AstrologerProfileRepository();

  final Rx<GiftResponse> _gifts = GiftResponse().obs;
  GiftResponse get gifts => _gifts.value;
  set gifts(GiftResponse value) => _gifts(value);

  final RxList<CustomGiftModel> _customGiftModel = <CustomGiftModel>[].obs;
  List<CustomGiftModel> get customGiftModel => _customGiftModel.value;
  set customGiftModel(List<CustomGiftModel> value) => _customGiftModel(value);

  Future<void> init() async {
    await getAllGifts();
    mapAndMergeGiftsWithConstant();
    cache();
    return Future<void>.value();
  }

  Future<void> getAllGifts() async {
    GiftResponse giftResponse = GiftResponse();
    giftResponse = await liveRepository.getAllGiftsAPI();
    gifts = giftResponse.statusCode == HttpStatus.ok
        ? GiftResponse.fromJson(giftResponse.toJson())
        : GiftResponse.fromJson(GiftResponse().toJson());

    for (int i = 0; i < (gifts.data?.length ?? 0); i++) {
      final String awsURL = _pref.getAmazonUrl() ?? "";
      gifts.data?[i].giftImage = isValidImageURL(
          imageURL: "$awsURL/${gifts.data?[i].giftImage ?? ""}");
    }
    return Future<void>.value();
  }

  void mapAndMergeGiftsWithConstant() {
    final List<CustomGiftModel> temp = <CustomGiftModel>[];
    gifts.data?.forEach(
      (GiftData element) {
        final String id =
            _pref.getConstantDetails().data?.lottiFile?.keys.firstWhere(
                      (String e) => e == element.id.toString(),
                      orElse: () => "",
                    ) ??
                "";
        final String giftSvga =
            _pref.getConstantDetails().data?.lottiFile?[id] ?? "";
        final CustomGiftModel customGiftModel = CustomGiftModel(
          giftId: element.id,
          giftName: element.giftName,
          giftImage: element.giftImage,
          giftPrice: element.giftPrice,
          giftSvga: giftSvga,
          bytes: <int>[],
        );
        temp.add(customGiftModel);
      },
    );
    customGiftModel = temp;
    return;
  }

  void cache() {
    for (var itemData in customGiftModel) {
      debugPrint(
          '${DateTime.now()} GiftsSingleton(): cache(): try cache ${itemData.giftImage}');
      GiftCache().read(url: itemData.giftImage).then(
        (value) {
          debugPrint(
              '${DateTime.now()} GiftsSingleton(): cache(): cache done: ${itemData.giftImage} ');
        },
      );
    }
  }

  String isValidImageURL({required String imageURL}) {
    if (GetUtils.isURL(imageURL)) {
      return imageURL;
    } else {
      imageURL = "${_pref.getAmazonUrl()}$imageURL";
      if (GetUtils.isURL(imageURL)) {
        return imageURL;
      } else {
        return "https://robohash.org/details";
      }
    }
  }
}
