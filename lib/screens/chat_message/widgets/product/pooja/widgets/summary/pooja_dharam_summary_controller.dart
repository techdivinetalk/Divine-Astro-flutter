
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:intl/intl.dart';

import '../../../../../../../repository/pooja_repository.dart';
import '../../pooja_dharam/get_pooja_addones_response.dart';
import '../../pooja_dharam/get_single_pooja_response.dart';
import '../../pooja_dharam/get_user_address_response.dart';
import '../../pooja_dharam/insufficient_balance_model.dart';
import '../../pooja_dharam/wallet_recharge_response.dart';
import '../address_flow/view/address_view_controller.dart';
import '../details/pooja_dharam_details_controller.dart';

class PoojaDharamSummaryController extends GetxController {
  final PoojaRepository poojaRepository = PoojaRepository();

  final RxList<GetPoojaAddOnesResponseData> _localSelectedAddOnesList =
      <GetPoojaAddOnesResponseData>[].obs;
  final Rx<GetSinglePoojaResponseData> _localSelectedPooja =
      GetSinglePoojaResponseData().obs;
  final Rx<PoojaDateTimeModel> _localPoojaDateTimeModel =
      PoojaDateTimeModel().obs;
  final Rx<Addresses> _localSelectedAddress = Addresses().obs;
  final Rx<WalletRecharge> _walletRecharge = WalletRecharge().obs;
  final RxBool _isLoading = false.obs;

  List<GetPoojaAddOnesResponseData> get localSelectedAddOnesList =>
      _localSelectedAddOnesList.value;
  set localSelectedAddOnesList(List<GetPoojaAddOnesResponseData> value) =>
      _localSelectedAddOnesList(value);

  GetSinglePoojaResponseData get localSelectedPooja =>
      _localSelectedPooja.value;
  set localSelectedPooja(GetSinglePoojaResponseData value) =>
      _localSelectedPooja(value);

  PoojaDateTimeModel get localPoojaDateTimeModel =>
      _localPoojaDateTimeModel.value;
  set localPoojaDateTimeModel(PoojaDateTimeModel value) =>
      _localPoojaDateTimeModel(value);

  Addresses get localSelectedAddress => _localSelectedAddress.value;
  set localSelectedAddress(Addresses value) => _localSelectedAddress(value);

  WalletRecharge get walletRecharge => _walletRecharge.value;
  set walletRecharge(WalletRecharge value) => _walletRecharge(value);

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading(value);

  @override
  void onInit() {
    super.onInit();
    initData();
    assignData();
  }

  void initData() {
    localSelectedAddOnesList = <GetPoojaAddOnesResponseData>[];
    localSelectedPooja = GetSinglePoojaResponseData();
    localPoojaDateTimeModel = PoojaDateTimeModel();
    localSelectedAddress = Addresses();
    walletRecharge = WalletRecharge();
    isLoading = false;
    return;
  }

  @override
  void onClose() {
    _localSelectedAddOnesList.close();
    _localSelectedPooja.close();
    _localPoojaDateTimeModel.close();
    _localSelectedAddress.close();
    _walletRecharge.close();
    _isLoading.close();
    super.onClose();
  }

  void assignData() {
    isLoading = true;
    localSelectedAddOnesList = globalSelectedAddOnesList;
    localSelectedPooja = globalSelectedPooja;
    localSelectedAddress = globalSelectedAddress;
    localPoojaDateTimeModel = globalPoojaDateTimeModel;
    walletRecharge = WalletRecharge();
    isLoading = false;
    return;
  }

  int calculateTotalAmount() {
    int amount = 0;
    if (localSelectedPooja.pooja?.isEmpty ?? true) {
    } else {
      final Pooja pooja = localSelectedPooja.pooja?[0] ?? Pooja();
      final int poojaPrice = pooja.poojaStartingPriceInr ?? 0;
      amount = amount + poojaPrice;
    }
    if (globalSelectedAddOnesList.isEmpty) {
    } else {
      for (var element in globalSelectedAddOnesList) {
        amount = amount + (element.amount ?? 0);
      }
    }
    return amount;
  }

  List<int> getAddOnesIds() {
    final List<int> temp = <int>[];
    if (globalSelectedAddOnesList.isEmpty) {
    } else {
      for (var element in globalSelectedAddOnesList) {
        temp.add(element.id ?? 0);
      }
    }
    return temp;
  }

  Future<void> checkWalletRechargeForBookingPooja({
    required Function(InsufficientBalModel balModel) needRecharge,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{
      "product_type": 10,
      "balance": localSelectedPooja.pooja?[0].poojaStartingPriceInr ?? "",
      "type": 2,
      "text": localSelectedPooja.pooja?[0].poojaName ?? "",
      "product_id": localSelectedPooja.pooja?[0].id ?? "",
      "quantity": 1,
      "address_id": localSelectedAddress.id ?? "",
      "appointment_date": convertedDate(),
      "appointment_time": convertedTime(),
      "pooja_addon": getAddOnesIds(),
    };

    WalletRecharge walletRechargeRes = WalletRecharge();
    walletRechargeRes = await poojaRepository.walletRechargeApi(
      params: param,
      needRecharge: needRecharge,
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    walletRecharge = walletRechargeRes.statusCode == HttpStatus.ok
        ? WalletRecharge.fromJson(walletRechargeRes.toJson())
        : WalletRecharge.fromJson(WalletRecharge().toJson());
    return Future<void>.value();
  }

  String convertedDate() {
    DateFormat inputFormat = DateFormat("dd MMMM yyyy");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    DateTime date = inputFormat.parse(localPoojaDateTimeModel.poojaDate ?? "");
    String formattedDate = outputFormat.format(date);
    return formattedDate;
  }

  String convertedTime() {
    DateFormat inputFormat = DateFormat("hh:mm a");
    DateFormat outputFormat = DateFormat("HH:mm:ss");
    DateTime time = inputFormat.parse(localPoojaDateTimeModel.poojaTime ?? "");
    String formattedTime = outputFormat.format(time);
    return formattedTime;
  }
}
