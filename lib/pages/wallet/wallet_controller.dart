import 'package:divine_astrologer/model/wallet/wallet_model.dart';
import 'package:divine_astrologer/repository/wallet_page_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final WalletListRepo walletRepository = Get.put(WalletListRepo());
  Rx<PayoutDetails> walletListRepo = PayoutDetails().obs;
  ScrollController scrollController = ScrollController();
  Loading loading = Loading.initial;
  var currentPage = 1.obs;
  int pageSize = 10;
  RxBool isDropDownShow = false.obs;
  RxString dropDownValue = 'Today'.obs;
  bool isOrderHistoryBack = false;
  var durationOptions =
      ['Today', 'Last Week', 'Last Month', 'Select Custom'].obs;

  RxString selectedOption = "Today".obs;
  void updateDurationValue(String val) {
    if (selectedOption.value != val) {
      // if(selectedOption.value =="Yesterday"){
      //   selectedOption.value = val;
      //
      // }else{}
      selectedOption.value = val;
      int index = durationOptions.indexOf(val);
    }
  }

  var startDate;
  var endDate;
  var startSelectedDate;
  var endSelectedDate;
  setStartDate(var value) {
    startDate = value;
    update();
  }

  setEndDate(var value) {
    endDate = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null){
      isOrderHistoryBack = Get.arguments["is_order_history"];
    }
    getWalletDetailsApi();
  }

  getWalletDetailsApi() async {
    if (loading == Loading.loading) return;

    loading = Loading.loading;
    update();

    Map<String, dynamic> params = {
      "page": currentPage.value,
    };
    try {
      PayoutDetails response =
          await walletRepository.walletPayOutDetails(params);
      if (currentPage.value == 1) {
        walletListRepo.value = response;
        print("object");
        print("object");
        print("${walletListRepo.value.toJson()}");
        print("object");
        print("object");
        print("object");
        print("object");
      } else {
        walletListRepo.update((val) {
          val?.data?.paymentLog?.addAll(response.data?.paymentLog ?? []);
        });
      }
      currentPage.value++;
      loading = Loading.loaded;
    } catch (error) {
      debugPrint("error $error");
      loading = Loading.loaded;
    }
    update();
  }

  void loadNextPage() {
    currentPage.value++;
    getWalletDetailsApi();
  }
}
