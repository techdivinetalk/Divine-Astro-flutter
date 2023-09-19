import 'dart:convert';
import 'dart:developer';

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
    // await Future.delayed(const Duration(milliseconds: 2000));
//     String data = '''
//     {
//     "data": [
//         {
//             "id": 1,
//             "astrologer_ids": "all",
//             "title": "test",
//             "description": "ddfgfg",
//             "schedule_date": "2023-08-22",
//             "schedule_time": "13:23:07",
//             "status": 1,
//             "created_at": null,
//             "updated_at": null
//         },
//                 {
//             "id": 1,
//             "astrologer_ids": "all",
//             "title": "test",
//             "description": "ddfgfg",
//             "schedule_date": "2023-08-22",
//             "schedule_time": "13:23:07",
//             "status": 1,
//             "created_at": null,
//             "updated_at": null
//         },
//                 {
//             "id": 1,
//             "astrologer_ids": "all",
//             "title": "test",
//             "description": "ddfgfg",
//             "schedule_date": "2023-08-22",
//             "schedule_time": "13:23:07",
//             "status": 1,
//             "created_at": null,
//             "updated_at": null
//         }
//     ],
//     "success": true,
//     "status_code": 200,
//     "message": "successfully found"
// }
//     ''';
//NoticeResponse response = noticeResponseFromJson(data);
    try {
      final response = await repository.noticeAPi();
      noticeList = response.data;
      log("NoticData==>${jsonEncode(noticeList.toString())}");
      loading = Loading.loaded;
      update();
    } catch (err) {
      divineSnackBar(data: err.toString(),color: AppColors.redColor);
    }
  }
}
