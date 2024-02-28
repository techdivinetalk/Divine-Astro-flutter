

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../../../../../../../../repository/pooja_repository.dart';
import '../../pooja_dharam/get_pooja_addones_response.dart';
import '../../pooja_dharam/get_single_pooja_response.dart';

List<GetPoojaAddOnesResponseData> globalSelectedAddOnesList = [];
GetSinglePoojaResponseData globalSelectedPooja = GetSinglePoojaResponseData();
PoojaDateTimeModel globalPoojaDateTimeModel = PoojaDateTimeModel();

class PoojaDharamDetailsController extends GetxController {
  final PoojaRepository poojaRepository = PoojaRepository();

  final Rx<GetSinglePoojaResponse> _getSinglePooja =
      GetSinglePoojaResponse().obs;
  final Rx<GetPoojaAddOnesResponse> _getPoojaAddOnes =
      GetPoojaAddOnesResponse().obs;
  final RxBool _isLoading = false.obs;
  final RxInt _poojaId = 0.obs;
  final RxString _selectedDate = "".obs;
  final RxString _selectedTime = "".obs;

  GetSinglePoojaResponse get getSinglePooja => _getSinglePooja.value;
  set getSinglePooja(GetSinglePoojaResponse value) => _getSinglePooja(value);

  GetPoojaAddOnesResponse get getPoojaAddOnes => _getPoojaAddOnes.value;
  set getPoojaAddOnes(GetPoojaAddOnesResponse value) => _getPoojaAddOnes(value);

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading(value);

  int get poojaId => _poojaId.value;
  set poojaId(int value) => _poojaId(value);

  RxBool showOnlyDetail = false.obs;

  String get selectedDate => _selectedDate.value;
  set selectedDate(String value) => _selectedDate(value);

  String get selectedTime => _selectedTime.value;
  set selectedTime(String value) => _selectedTime(value);

  RxInt customerId = 0.obs;
  RxBool isSentMessage = false.obs;

  @override
  void onInit() {
    super.onInit();
    initData();

    // poojaId = Get.arguments;

    final result = Get.arguments;
    if (result == null) {
    } else {
      poojaId = Get.arguments['data'];
      isSentMessage(Get.arguments["isSentMessage"]);
      showOnlyDetail(Get.arguments['detailOnly']);
      customerId(Get.arguments["customerId"]??0);
    }
  }

  void initData() {
    getSinglePooja = GetSinglePoojaResponse();
    getPoojaAddOnes = GetPoojaAddOnesResponse();
    isLoading = false;
    poojaId = 0;
    selectedDate = "";
    selectedTime = "";
    return;
  }

  @override
  void onClose() {
    _getSinglePooja.close();
    _getPoojaAddOnes.close();
    _isLoading.close();
    _poojaId.close();
    _selectedDate.close();
    _selectedTime.close();
    super.onClose();
  }

  Future<void> getSinglePoojaCall({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    isLoading = true;
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{"pooja_id": poojaId};
    GetSinglePoojaResponse response = GetSinglePoojaResponse();
    response = await poojaRepository.getSinglePoojaApi(
      params: param,
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    getSinglePooja = response.statusCode == HttpStatus.ok
        ? GetSinglePoojaResponse.fromJson(response.toJson())
        : GetSinglePoojaResponse.fromJson(GetSinglePoojaResponse().toJson());
    isLoading = false;
    return Future<void>.value();
  }

  Future<void> getPoojaAddOnesCall({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    isLoading = true;
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{};
    GetPoojaAddOnesResponse response = GetPoojaAddOnesResponse();
    response = await poojaRepository.getPoojaAddOnesApi(
      params: param,
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    getPoojaAddOnes = response.statusCode == HttpStatus.ok
        ? GetPoojaAddOnesResponse.fromJson(response.toJson())
        : GetPoojaAddOnesResponse.fromJson(GetPoojaAddOnesResponse().toJson());
    isLoading = false;
    return Future<void>.value();
  }

  List<GetPoojaAddOnesResponseData> getSelectedAddOnesList() {
    return (getPoojaAddOnes.data ?? [])
        .where((element) => element.isSelected == true)
        .toList();
  }

  void assignGlobalSelectedPooja() {
    globalSelectedPooja = getSinglePooja.data ?? GetSinglePoojaResponseData();
    return;
  }

  void assignGlobalSelectedAddOnesList() {
    globalSelectedAddOnesList = (getPoojaAddOnes.data ?? [])
        .where((element) => element.isSelected == true)
        .toList();
    return;
  }

  void assignGlobalPoojaDateTimeModel() {
    globalPoojaDateTimeModel = PoojaDateTimeModel(
      poojaDate: selectedDate,
      poojaTime: selectedTime,
    );
    return;
  }
}

class PoojaDateTimeModel {
  String? poojaDate;
  String? poojaTime;

  PoojaDateTimeModel({this.poojaDate, this.poojaTime});

  PoojaDateTimeModel.fromJson(Map<String, dynamic> json) {
    poojaDate = json['poojaDate'];
    poojaTime = json['poojaTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['poojaDate'] = this.poojaDate;
    data['poojaTime'] = this.poojaTime;
    return data;
  }
}
