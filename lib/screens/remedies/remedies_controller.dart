import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/faq_response.dart';
import 'package:divine_astrologer/repository/faqs_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemediesController extends GetxController {

  RxInt orderList = 3.obs;
  ScrollController orderScrollController = ScrollController();
}