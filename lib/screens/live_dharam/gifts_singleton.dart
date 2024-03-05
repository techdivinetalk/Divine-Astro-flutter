import "dart:async";
import "dart:developer";

import "package:divine_astrologer/screens/live_dharam/zego_team/cache.dart";
import "package:get/get.dart";
import "package:get/get_connect/http/src/status/http_status.dart";

import "package:divine_astrologer/model/astrologer_gift_response.dart";
import "package:divine_astrologer/repository/astrologer_profile_repository.dart";
import "package:divine_astrologer/screens/live_dharam/gift/gift.dart" as gift;

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
    cacheAllFiles();
    cache();
    return Future<void>.value();
  }

  Future<void> getAllGifts() async {
    GiftResponse giftResponse = GiftResponse();
    giftResponse = await liveRepository.getAllGiftsAPI(
      successCallBack: log,
      failureCallBack: log,
    );
    gifts = giftResponse.statusCode == HttpStatus.ok
        ? GiftResponse.fromJson(giftResponse.toJson())
        : GiftResponse.fromJson(GiftResponse().toJson());
    return Future<void>.value();
  }

  void cacheAllFiles() {
    final List<gift.ZegoGiftItem> giftItemList = <gift.ZegoGiftItem>[];
    for (final GiftData itemData in gifts.data ?? <GiftData>[]) {
      giftItemList.add(
        gift.ZegoGiftItem(
          sourceURL: itemData.animation,
          weight: 100,
          name: itemData.giftName,
          icon: itemData.giftImage,
          source: gift.ZegoGiftSource.url,
          type: gift.ZegoGiftType.svga,
        ),
      );
    }
    gift.ZegoGiftManager().cache.cacheAllFiles(giftItemList);
    return;
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
