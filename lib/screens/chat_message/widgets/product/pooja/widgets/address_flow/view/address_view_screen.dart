import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../common/colors.dart';
import '../../../../../../../../common/common_functions.dart';
import '../../../../../../../../common/routes.dart';
import '../../../pooja_dharam/get_user_address_response.dart';
import '../../custom_widget/pooja_custom_button.dart';
import '../../custom_widget/pooja_loader.dart';
import 'address_view_controller.dart';

class AddressViewScreen extends StatefulWidget {
  const AddressViewScreen({super.key});

  @override
  State<AddressViewScreen> createState() => _AddressViewScreenState();
}

class _AddressViewScreenState extends State<AddressViewScreen>
    with AfterLayoutMixin<AddressViewScreen>, TickerProviderStateMixin {
  final AddressViewController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Details Needed For Pooja"),
        backgroundColor: appColors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () {
                    return _controller.isLoading
                        ? const PoojaLoader()
                        : addressListView();
                  },
                ),
              ),
              const SizedBox(height: 16),
              _controller.index == -1 ? bottomButton() : useButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget addressListView() {
    final GetUserAddressResponse res = _controller.getAddress;
    final GetUserAddressResponseData data =
        res.data ?? GetUserAddressResponseData();
    final List<Addresses> addresses = data.addresses ?? [];
    return addresses.isEmpty
        ? const Center(child: Text("No addresses available. try adding one!"))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: addresses.length,
            itemBuilder: (BuildContext context, int index) {
              final Addresses address = addresses[index];

              final String addressTitle = address.addressTitle ?? "";
              final String flat = address.flatNo ?? "";
              final String local = address.locality ?? "";
              final String land = address.landmark ?? "";
              final String city = address.city ?? "";
              final String state = address.state ?? "";
              final String pin = (address.pincode ?? "").toString();
              final String addressFull =
                  "$flat, $local, $land, $city, $state, $pin";
              final phoneNo = address.phoneNo ?? "";
              final alternatePhoneNo = address.alternatePhoneNo ?? "";

              String phoneFull = "";
              if (phoneNo != "" && alternatePhoneNo != "") {
                phoneFull = "$phoneNo, $alternatePhoneNo";
              } else if (phoneNo != "" && alternatePhoneNo == "") {
                phoneFull = "$phoneNo";
              } else if (phoneNo == "" && alternatePhoneNo != "") {
                phoneFull = "$alternatePhoneNo";
              } else if (phoneNo == "" && alternatePhoneNo == "") {
                phoneFull = "-";
              } else {
                phoneFull = "-";
              }
              return Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(
                    color: _controller.index == index
                        ? appColors.guideColor
                        : appColors.transparent,
                    width: 1.0,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    _controller.index = _controller.index != index ? index : -1;
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                addressTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () async {
                                await routingForAddress(args: address.toJson());
                              },
                              icon: Image.asset(
                                "assets/images/address_new_edit.png",
                                height: 16,
                                width: 16,
                                fit: BoxFit.fill,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await deleteAddress(addressId: address.id ?? 0);
                              },
                              icon: Image.asset(
                                "assets/images/address_new_delete.png",
                                height: 16,
                                width: 16,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/address_new_location.png",
                              height: 16,
                              width: 16,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                addressFull,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/address_new_phone.png",
                              height: 16,
                              width: 16,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                phoneFull,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget useButton() {
    return PoojaCustomButton(
      height: 64,
      text: "Proceed",
      backgroundColor: appColors.guideColor,
      fontColor: appColors.black,
      needCircularBorder: false,
      onPressed: () async {
        final Addresses address =
            _controller.getAddress.data?.addresses?[_controller.index] ??
                Addresses();
        _controller.assignGlobalSelectedAddress(address);
        await Get.toNamed(RouteName.poojaDharamSummaryScreen);
      },
    );
  }

  Widget bottomButton() {
    return PoojaCustomButton(
      height: 64,
      text: "Add Address",
      backgroundColor: appColors.guideColor,
      fontColor: appColors.black,
      needCircularBorder: false,
      onPressed: () async {
        await routingForAddress(args: Addresses().toJson());
      },
    );
  }

  Future<void> routingForAddress({required Map<String, dynamic> args}) async {
    await Get.toNamed(RouteName.addressAddUpdateScreen, arguments: args);
    await getUserAddress();
    return Future<void>.value();
  }

  Future<void> deleteAddress({required int addressId}) async {
    await _controller.deleteUserAddress(
      addressId: addressId,
      successCallBack: (message) => divineSnackBar(data: message),
      failureCallBack: (message) => divineSnackBar(data: message),
    );
    await getUserAddress();
    return Future<void>.value();
  }

  Future<void> getUserAddress() async {
    await _controller.getUserAddressCall(
      successCallBack: (message) => divineSnackBar(data: message),
      failureCallBack: (message) => divineSnackBar(data: message),
    );
    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    if (_controller.getAddress.data?.addresses?.isEmpty ?? true) {
      await getUserAddress();
    } else {}
    return Future<void>.value();
  }
}
