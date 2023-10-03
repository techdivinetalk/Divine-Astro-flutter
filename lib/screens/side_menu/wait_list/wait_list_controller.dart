import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/repository/waiting_list_queue_repository.dart';
import 'package:get/get.dart';

import '../../../di/shared_preference_service.dart';
import '../../../model/waiting_list_queue.dart';
import '../../../utils/enum.dart';

class WaitListUIController extends GetxController {
  var preference = Get.find<SharedPreferenceService>();
  final WaitingListQueueRepo repository;

  WaitListUIController(this.repository);

  Loading loading = Loading.initial;
  List<WaitingPerson> waitingPersons = <WaitingPerson>[];

  @override
  void onInit() {
    super.onInit();
    getWaitingList();
  }

  getWaitingList() async {
    try {
      final response = await repository.fetchData();
      if (response.data != null) {
        waitingPersons = response.data!;
      }
      loading = Loading.loaded;
      update();
    } catch (err) {
      divineSnackBar(data: err.toString(), color: AppColors.redColor);
    }
  }
}
