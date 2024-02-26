
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../common/colors.dart';
import '../../../../../../../../common/common_functions.dart';
import '../../../pooja_dharam/get_user_address_response.dart';
import '../../custom_widget/pooja_custom_button.dart';
import 'address_add_update_controller.dart';

class AddressAddUpdateScreen extends StatefulWidget {
  const AddressAddUpdateScreen({super.key});

  @override
  State<AddressAddUpdateScreen> createState() => _AddressAddUpdateScreenState();
}

class _AddressAddUpdateScreenState extends State<AddressAddUpdateScreen> {
  final AddressAddUpdateController _controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressTitleCtrl = TextEditingController();
  final TextEditingController _addressflatNoCtrl = TextEditingController();
  final TextEditingController _addressLocalityCtrl = TextEditingController();
  final TextEditingController _addressLandmarkCtrl = TextEditingController();
  final TextEditingController _addressCityCtrl = TextEditingController();
  final TextEditingController _addressStateCtrl = TextEditingController();
  final TextEditingController _addressPincodeCtrl = TextEditingController();
  final TextEditingController _addressPriPhoneNoCtrl = TextEditingController();
  final TextEditingController _addressAltPhoneNoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic> result = Get.arguments;
    if (mapEquals(result, Addresses().toJson())) {
    } else {
      _controller.addresses = Addresses.fromJson(result);
      _controller.fillData();
      fillData();
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.reset();
    _formKey.currentState?.dispose();
    _addressTitleCtrl.dispose();
    _addressflatNoCtrl.dispose();
    _addressLocalityCtrl.dispose();
    _addressLandmarkCtrl.dispose();
    _addressCityCtrl.dispose();
    _addressStateCtrl.dispose();
    _addressPincodeCtrl.dispose();
    _addressPriPhoneNoCtrl.dispose();
    _addressAltPhoneNoCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Add/Update Address"),
        backgroundColor: appColors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: addressListView())),
              const SizedBox(height: 16),
              bottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget addressListView() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          field(
            controller: _addressTitleCtrl,
            label: "Address Title",
            onChanged: (value) => _controller.addressTitle = value,
            isNumericField: false,
            maxLength: 50,
          ),
          field(
            controller: _addressflatNoCtrl,
            label: "Flat No.",
            onChanged: (value) => _controller.addressflatNo = value,
            isNumericField: false,
            maxLength: 50,
          ),
          field(
            controller: _addressLocalityCtrl,
            label: "Locality",
            onChanged: (value) => _controller.addressLocality = value,
            isNumericField: false,
            maxLength: 50,
          ),
          field(
            controller: _addressLandmarkCtrl,
            label: "Landmark",
            onChanged: (value) => _controller.addressLandmark = value,
            isNumericField: false,
            maxLength: 50,
          ),
          field(
            controller: _addressCityCtrl,
            label: "City",
            onChanged: (value) => _controller.addressCity = value,
            isNumericField: false,
            maxLength: 50,
          ),
          field(
            controller: _addressStateCtrl,
            label: "State",
            onChanged: (value) => _controller.addressState = value,
            isNumericField: false,
            maxLength: 50,
          ),
          field(
            controller: _addressPincodeCtrl,
            label: "Pin code",
            onChanged: (value) => _controller.addressPincode = value,
            isNumericField: false,
            maxLength: 50,
          ),
          field(
            controller: _addressPriPhoneNoCtrl,
            label: "Primary Phone No.",
            onChanged: (value) => _controller.addressPriPhoneNo = value,
            isNumericField: true,
            maxLength: 10,
          ),
          field(
            controller: _addressAltPhoneNoCtrl,
            label: "Secondary Phone No.",
            onChanged: (value) => _controller.addressAltPhoneNo = value,
            isNumericField: true,
            maxLength: 10,
          ),
        ],
      ),
    );
  }

  Widget field({
    required TextEditingController controller,
    required String label,
    required void Function(String)? onChanged,
    required bool isNumericField,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        cursorColor: appColors.guideColor,
        decoration: InputDecoration(
          isDense: true,
          hintText: label,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: appColors.grey, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: appColors.grey, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: appColors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: appColors.grey, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: appColors.red, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: appColors.red, width: 1),
          ),
        ),
        onChanged: onChanged,
        keyboardType:
            isNumericField ? TextInputType.phone : TextInputType.streetAddress,
        maxLength: maxLength,
        validator: (String? value) {
          return (GetUtils.isNullOrBlank(value) ?? true)
              ? "Cannot be empty"
              : null;
        },
      ),
    );
  }

  Widget bottomButton() {
    return PoojaCustomButton(
      height: 64,
      text:
          _controller.addresses.id == null ? "Add New Address" : "Save Changes",
      backgroundColor: appColors.guideColor,
      fontColor: appColors.black,
      needCircularBorder: false,
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          await _controller.addUpdateUserAddressCall(
            successCallBack: (message) => divineSnackBar(data: message),
            failureCallBack: (message) => divineSnackBar(data: message),
          );
          Get.back();
        } else {}
      },
    );
  }

  void fillData() {
    _addressTitleCtrl.text = _controller.addresses.addressTitle ?? "";
    _addressflatNoCtrl.text = _controller.addresses.flatNo ?? "";
    _addressLocalityCtrl.text = _controller.addresses.locality ?? "";
    _addressLandmarkCtrl.text = _controller.addresses.landmark ?? "";
    _addressCityCtrl.text = _controller.addresses.city ?? "";
    _addressStateCtrl.text = _controller.addresses.state ?? "";
    _addressPincodeCtrl.text = (_controller.addresses.pincode ?? "").toString();
    _addressPriPhoneNoCtrl.text = (_controller.addresses.phoneNo ?? "").toString();
    _addressAltPhoneNoCtrl.text = (_controller.addresses.alternatePhoneNo ?? "").toString();
    return;
  }
}
