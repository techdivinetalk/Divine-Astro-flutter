import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeBoardController extends GetxController {
  ScrollController earningScrollController = ScrollController();
  final NoticeRepository repository;

  List<NoticeDatum> noticeList = <NoticeDatum>[];
  Loading loading = Loading.initial;

  NoticeBoardController(this.repository);

  @override
  void onInit() {
    super.onInit();
    getAllNotices();
  }

  void getAllNotices() async {
    loading = Loading.loading;
    update();
    try {
      final response = await repository.noticeAPi();
      noticeList = response.data;
      loading = Loading.loaded;
      update();
    } catch (err) {
      divineSnackBar(data: err.toString(), color: appColors.redColor);
    }
  }
}
