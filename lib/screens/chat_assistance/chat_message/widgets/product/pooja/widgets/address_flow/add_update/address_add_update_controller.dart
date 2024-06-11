
import 'package:get/get.dart';


import '../../../../../../../../../repository/pooja_repository.dart';
import '../../../pooja_dharam/get_user_address_response.dart';

class AddressAddUpdateController extends GetxController {
  final PoojaRepository poojaRepository = PoojaRepository();

  final RxString _addressTitle = "".obs;
  final RxString _addressflatNo = "".obs;
  final RxString _addressLocality = "".obs;
  final RxString _addressLandmark = "".obs;
  final RxString _addressCity = "".obs;
  final RxString _addressState = "".obs;
  final RxString _addressPincode = "".obs;
  final RxString _addressPriPhoneNo = "".obs;
  final RxString _addressAltPhoneNo = "".obs;

  String get addressTitle => _addressTitle.value;
  set addressTitle(String value) => _addressTitle(value);

  String get addressflatNo => _addressflatNo.value;
  set addressflatNo(String value) => _addressflatNo(value);

  String get addressLocality => _addressLocality.value;
  set addressLocality(String value) => _addressLocality(value);

  String get addressLandmark => _addressLandmark.value;
  set addressLandmark(String value) => _addressLandmark(value);

  String get addressCity => _addressCity.value;
  set addressCity(String value) => _addressCity(value);

  String get addressState => _addressState.value;
  set addressState(String value) => _addressState(value);

  String get addressPincode => _addressPincode.value;
  set addressPincode(String value) => _addressPincode(value);

  String get addressPriPhoneNo => _addressPriPhoneNo.value;
  set addressPriPhoneNo(String value) => _addressPriPhoneNo(value);

  String get addressAltPhoneNo => _addressAltPhoneNo.value;
  set addressAltPhoneNo(String value) => _addressAltPhoneNo(value);

  final Rx<Addresses> _addresses = Addresses().obs;
  final RxBool _isLoading = false.obs;

  Addresses get addresses => _addresses.value;
  set addresses(Addresses value) => _addresses(value);

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading(value);

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    addressTitle = "";
    addressflatNo = "";
    addressLocality = "";
    addressLandmark = "";
    addressCity = "";
    addressState = "";
    addressPincode = "";
    addressPriPhoneNo = "";
    addressAltPhoneNo = "";
    addresses = Addresses();
    isLoading = false;
    return;
  }

  @override
  void onClose() {
    _addressTitle.close();
    _addressflatNo.close();
    _addressLocality.close();
    _addressLandmark.close();
    _addressCity.close();
    _addressState.close();
    _addressPincode.close();
    _addressPriPhoneNo.close();
    _addressAltPhoneNo.close();
    _addresses.close();
    _isLoading.close();
    super.onClose();
  }

  void fillData() {
    addressTitle = addresses.addressTitle ?? "";
    addressflatNo = addresses.flatNo ?? "";
    addressLocality = addresses.locality ?? "";
    addressLandmark = addresses.landmark ?? "";
    addressCity = addresses.city ?? "";
    addressState = addresses.state ?? "";
    addressPincode = (addresses.pincode ?? "").toString();
    addressPriPhoneNo = (addresses.phoneNo ?? "").toString();
    addressAltPhoneNo = (addresses.alternatePhoneNo ?? "").toString();
    return;
  }

  Future<void> addUpdateUserAddressCall({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    isLoading = true;
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{
      "address_title": addressTitle,
      "flat_no": addressflatNo,
      "locality": addressLocality,
      "landmark": addressLandmark,
      "city": addressCity,
      "state": addressState,
      "pincode": addressPincode,
      "phone_no": addressPriPhoneNo,
      "alternate_phone_no": addressAltPhoneNo,
    };

    if (addresses.id != null) {
      int id = addresses.id ?? 0;
      if (id != 0) {
        param.addAll(<String, dynamic>{"address_id": id});
      } else {}
    } else {}

    !param.containsKey("address_id")
        ? await poojaRepository.addUserAddressApi(
            params: param,
            successCallBack: successCallBack,
            failureCallBack: failureCallBack,
          )
        : await poojaRepository.updateUserAddressApi(
            params: param,
            successCallBack: successCallBack,
            failureCallBack: failureCallBack,
          );

    isLoading = false;
    return Future<void>.value();
  }
}
