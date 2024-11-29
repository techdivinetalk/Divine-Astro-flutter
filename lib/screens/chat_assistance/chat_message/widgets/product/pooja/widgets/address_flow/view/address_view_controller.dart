
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../../../../../../../../../repository/pooja_repository.dart';
import '../../../pooja_dharam/get_user_address_response.dart';

Addresses globalSelectedAddress = Addresses();

class AddressViewController extends GetxController {
  final PoojaRepository poojaRepository = PoojaRepository();

  final Rx<GetUserAddressResponse> _getAddress = GetUserAddressResponse().obs;
  final RxBool _isLoading = false.obs;
  final RxInt _index = (-1).obs;

  GetUserAddressResponse get getAddress => _getAddress.value;
  set getAddress(GetUserAddressResponse value) => _getAddress(value);

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading(value);

  int get index => _index.value;
  set index(int value) => _index(value);

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    getAddress = GetUserAddressResponse();
    isLoading = false;
    index = -1;
    return;
  }

  @override
  void onClose() {
    _getAddress.close();
    _isLoading.close();
    _index.close();
    super.onClose();
  }

  Future<void> getUserAddressCall({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    isLoading = true;
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{};
    GetUserAddressResponse response = GetUserAddressResponse();
    response = await poojaRepository.getUserAddressApi(
      params: param,
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    getAddress = response.statusCode == HttpStatus.ok
        ? GetUserAddressResponse.fromJson(response.toJson())
        : GetUserAddressResponse.fromJson(GetUserAddressResponse().toJson());
    isLoading = false;
    return Future<void>.value();
  }

  Future<void> deleteUserAddress({
    required int addressId,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    isLoading = true;
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{"address_id": addressId};
    await poojaRepository.deleteUserAddressApi(
      params: param,
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    isLoading = false;
    return Future<void>.value();
  }

  void assignGlobalSelectedAddress(Addresses address) {
    globalSelectedAddress = address;
    return;
  }
}
