import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../../../../../../repository/pooja_repository.dart';
import 'pooja_dharam/get_booked_pooja_response.dart';
import 'pooja_dharam/get_pooja_response.dart';

class PoojaDharamMainController extends GetxController {
  final PoojaRepository poojaRepository = PoojaRepository();

  final Rx<GetPoojaResponse> _getPooja = GetPoojaResponse().obs;
  final Rx<GetBookedPoojaResponse> _getBookedPooja =
      GetBookedPoojaResponse().obs;
  final RxBool _isLoading = false.obs;

  GetPoojaResponse get getPooja => _getPooja.value;
  set getPooja(GetPoojaResponse value) => _getPooja(value);

  GetBookedPoojaResponse get getBookedPooja => _getBookedPooja.value;
  set getBookedPooja(GetBookedPoojaResponse value) => _getBookedPooja(value);

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading(value);

  RxInt customerId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void initData() {
    getPooja = GetPoojaResponse();
    customerId(Get.arguments["customerId"] ?? 0);
    getBookedPooja = GetBookedPoojaResponse();
    isLoading = false;
    return;
  }

  @override
  void onClose() {
    _getPooja.close();
    _getBookedPooja.close();
    _isLoading.close();
    super.onClose();
  }

  Future<void> getPoojaCall({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    isLoading = true;
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{"master_category_id": 1};
    GetPoojaResponse response = GetPoojaResponse();
    response = await poojaRepository.getPoojaApi(
      params: param,
      successCallBack: successCallBack,
      failureCallBack:  failureCallBack,
    );
    getPooja = response.statusCode == HttpStatus.ok
        ? GetPoojaResponse.fromJson(response.toJson())
        : GetPoojaResponse.fromJson(GetPoojaResponse().toJson());
    isLoading = false;
    return Future<void>.value();
  }

  Future<void> getBookedPoojaCall({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    isLoading = true;
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{};
    GetBookedPoojaResponse response = GetBookedPoojaResponse();
    response = await poojaRepository.getBookedPoojaApi(
      params: param,
      successCallBack: successCallBack,
      failureCallBack: customerId.value == 0 ? failureCallBack : (message) {},
    );
    getBookedPooja = response.statusCode == HttpStatus.ok
        ? GetBookedPoojaResponse.fromJson(response.toJson())
        : GetBookedPoojaResponse.fromJson(GetBookedPoojaResponse().toJson());
    isLoading = false;
    return Future<void>.value();
  }
}
