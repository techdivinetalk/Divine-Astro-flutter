import 'dart:convert';
import 'package:divine_astrologer/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AppOpenLink {
  static Future<void> openAppLink(Uri newUri) async {
    String value = '';
    Uri? uri;
    String path = '';
    String fullPath = newUri.path;
    if (!newUri.path.startsWith('https://divinetalk.in/')) {
      fullPath = 'https://divinetalk.in/${newUri.path}';
    }
    if (fullPath.startsWith('/')) {
      value = fullPath.substring(1);
      try {
        List<int> decodedBytes = base64Url.decode(value);
        if (decodedBytes.isNotEmpty) {
          String decodedUrl = utf8.decode(decodedBytes);
          uri = Uri.parse(decodedUrl);
          path = '/${uri.path.replaceAll('/', '').split('').join()}';

          final dataQueryParam = uri.queryParameters['data'];
          final decodedJsonString = Uri.decodeComponent(dataQueryParam!);
          final Map<String, dynamic> jsonData = jsonDecode(decodedJsonString);

          if (validRoutes.contains(path)) {
            Get.toNamed(path, arguments: jsonData);
          } else {
            Fluttertoast.showToast(msg: 'Invalid path');
          }
        } else {
          Fluttertoast.showToast(msg: 'path not found');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'path not found');
      }
    }
  }

  static void redirectionPage(dynamic value) {
    String paramJson = '';
    String baseUrl = 'https://divinetalk.in/';
    String url = '$baseUrl${value.page}/';

    if (value.param != null) {
      Map<String, dynamic> nonNullValues = {};

      if (value.param!.astrologerId != null) {
        nonNullValues['astrologerId'] = value.param!.astrologerId!;
      }

      if (value.param!.extraAmount != null) {
        nonNullValues['extraAmount'] = value.param!.extraAmount!;
      }

      if (value.param!.offerAmount != null) {
        nonNullValues['offerAmount'] = value.param!.offerAmount!;
      }

      if (value.param!.percentage != null) {
        nonNullValues['percentage'] = value.param!.percentage!;
      }

      if (value.param!.rechargeAmount != null) {
        nonNullValues['rechargeAmount'] = value.param!.rechargeAmount!;
      }

      if (nonNullValues.isNotEmpty) {
        paramJson = Uri.encodeComponent(jsonEncode(nonNullValues));
        url += '?data=$paramJson';
      }
    }

    debugPrint('final url $url');
    int index = url.indexOf(".in/") + 4;
    if (index >= 4 && index < url.length) {
      String valueAfterIn = url.substring(index);
      String base64EncodedValue = base64Url.encode(utf8.encode(valueAfterIn));
      debugPrint("Value after .in/: $valueAfterIn");
      debugPrint("Base64 Encoded Value: $base64EncodedValue");
      debugPrint("Final URL Base64 Encoded Value: $baseUrl$base64EncodedValue");
      openAppLink(Uri.parse('$baseUrl$base64EncodedValue'));
    } else {
      debugPrint("Invalid URL format");
    }

    // if (value.param != null && (value.param!.toJson().values.where((v) => v != null).isNotEmpty)) {
    //   debugPrint('param values ${value.param!.toJson()}');
    // }
    // String baseUrl = "https://divinetalk.in/";
    // String paramJson = Uri.encodeComponent(jsonEncode(value.param));
    // String url = '$baseUrl${value.page}/?data=$paramJson';
    // debugPrint('final url $url');

    // if (value.page == 'astrologerProfile') {
    //   debugPrint('id---> ${value.param.astrologerId}');
    //   Get.toNamed(RouteName.astrologerProfile,
    //       arguments: {"astrologer_id": value.param.astrologerId.toString()});
    //   debugPrint('astrologer_profile_page');
    // } else if (value.page == 'chat') {
    //   controller.mainNavigationController.navigateTo(1);
    //   debugPrint('chat');
    // } else if (value.page == 'call') {
    //   controller.mainNavigationController.navigateTo(1);
    //   debugPrint('call');
    // } else if (value.page == 'wallet_recharge_offer') {
    //   Get.toNamed(RouteName.paymentSummary,
    //       arguments: CommonOffer(
    //           extraAmount: int.parse(value.param.extraAmount),
    //           offerAmount: int.parse(value.param.offerAmount),
    //           percentage: int.parse(value.param.percentage),
    //           rechargeAmount: int.parse(value.param.rechargeAmount)));
    //   debugPrint('wallet_recharge_offer');
    // } else if (value.page == 'wallet') {
    //   Get.toNamed(RouteName.wallet);
    //   debugPrint('wallet');
    // } else if (value.page == 'wallet_page_offer') {
    //   Get.toNamed(RouteName.paymentSummary,
    //       arguments: CommonOffer(
    //           extraAmount: value.param.extraAmount.toInt(),
    //           offerAmount: value.param.offerAmount.toInt(),
    //           percentage: value.param.percentage?.toInt(),
    //           rechargeAmount: value.param.rechargeAmount.toInt()));
    //   debugPrint('wallet_page_offer');
    // } else if (value.page == 'puja') {
    //   Get.toNamed(RouteName.poojaDetailPage);
    //   debugPrint('puja');
    // } else if (value.page == 'shop') {
    //   Get.toNamed(RouteName.divineShopPage);
    //   debugPrint('shop');
    // } else if (value.page == 'live') {
    //   if (controller.astrologers.isNotEmpty) {
    //     controller.mainNavigationController.navigateTo(2);
    //   }
    //   debugPrint('live');
    // }
  }
}
