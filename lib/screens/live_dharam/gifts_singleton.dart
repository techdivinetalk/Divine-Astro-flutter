import "dart:async";

import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/zego_team/cache.dart";
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

  final AstrologerProfileRepository liveRepository =
      AstrologerProfileRepository();

  final Rx<GiftResponse> _gifts = GiftResponse().obs;
  GiftResponse get gifts => _gifts.value;
  set gifts(GiftResponse value) => _gifts(value);

  Future<void> init() async {
    await getAllGifts();
    cache();
    return Future<void>.value();
  }

  Future<void> getAllGifts() async {
    GiftResponse giftResponse = GiftResponse();
    giftResponse = await liveRepository.getAllGiftsAPI();
    gifts = giftResponse.statusCode == HttpStatus.ok
        ? GiftResponse.fromJson(giftResponse.toJson())
        : GiftResponse.fromJson(GiftResponse().toJson());
    return Future<void>.value();
  }

  void cache() {
    for (final GiftData itemData in gifts.data ?? <GiftData>[]) {
      // debugPrint(
      //   '${DateTime.now()} GiftsSingleton(): cache(): try cache ${itemData.animation}',
      // );
      GiftCache().read(url: itemData.animation).then(
        (value) {
          // debugPrint(
          //   '${DateTime.now()} GiftsSingleton(): cache(): cache done: ${itemData.animation}',
          // );
        },
      );
    }
  }
}
