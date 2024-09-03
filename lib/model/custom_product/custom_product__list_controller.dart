import 'dart:convert';

import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_list_model.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../di/api_provider.dart';

class CustomProductListController extends GetxController {
  NoticeRepository noticeRepository = NoticeRepository();
  List<CustomProductData> customProductData = [];
  bool isLoading = false;
  String noData = "";

  @override
  void onInit() {
    super.onInit();
    getSavedRemedies();
  }

  getSavedRemedies() async {
    try {
      isLoading = true;
      final response = await noticeRepository.get(ApiProvider.getCustomEcom,
          headers: await noticeRepository.getJsonHeaderURL());
      CustomProductListModel savedRemediesData =
          CustomProductListModel.fromJson(jsonDecode(response.body));
      if (savedRemediesData.statusCode == 200) {
        if(savedRemediesData.data != null && savedRemediesData.data!.isNotEmpty){
          customProductData = savedRemediesData.data!;
          noData = "";
        } else{
          noData = "No data available!";
          customProductData = [];
        }
        update();
      } else {
        noData = "No data available!";
        customProductData = [];
      }
      isLoading = false;
    } catch (e, s) {
      noData = "No data available!";
      isLoading = false;
      update();
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
