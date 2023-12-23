import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/app_exception.dart';
import '../../di/shared_preference_service.dart';
import "../../model/blocked_customers_response.dart";
import '../../model/res_blocked_customers.dart';
import '../../model/res_login.dart';
import '../../repository/user_repository.dart';

class BlockUserController extends GetxController {
  BlockUserController(this.userRepository);

  final UserRepository userRepository;
  UserData? userData;
  final preferenceService = Get.find<SharedPreferenceService>();
  RxBool blockedUserDataSync = false.obs;
  BlockedCustomersResponse? blockedUserData;
  List<BlockedUserList> allBlockedUsers = [];
  List<BlockedUserList> searchesBlockedUsers = [];
  late TextEditingController controller;

  //List<getCustomer> astroBlockCustomer = <AstroBlockCustomer>[];

  @override
  void onInit() {
    super.onInit();
    controller = TextEditingController();
    userData = preferenceService.getUserDetail();
    getBlockedCustomerList();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void getBlockedCustomerList() async {
    try {
      Map<String, dynamic> params = {"role_id": userData?.roleId};
      blockedUserData = await userRepository.getBlockedCustomerList(params);
      allBlockedUsers = blockedUserData!.data!;
      searchesBlockedUsers = blockedUserData!.data!;

      // astroBlockCustomer =
      //     blockedUserData?.data.firstOrNull?.astroBlockCustomer ?? [];
      update(["updateList"]);
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
    blockedUserDataSync.value = true;
  }

  void unblockUser({required int customerId}) async {
    blockedUserDataSync.value = false;
    Map<String, dynamic> params = {
      "role_id": userData?.roleId,
      "customer_id": customerId,
      "is_block": 0
    };
    try {
      ResBlockedCustomers response =
          await userRepository.blockUnblockCustomer(params);

      Get.back();
      CustomException(response.message ?? "");
      getBlockedCustomerList();
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
    blockedUserDataSync.value = true;
  }

  onSearch(String value) {

    List<BlockedUserList> searchResult = [];
    if(value.isEmpty && value.trim() == "") {
      allBlockedUsers = searchesBlockedUsers;
      update(['updateList']);
      return;
    }
    allBlockedUsers = searchesBlockedUsers;
    for(int i=0; i<allBlockedUsers.length; i++) {
      if(allBlockedUsers[i].getCustomers!.name!.toLowerCase().contains(value.toLowerCase())) {
        searchResult.add(allBlockedUsers[i]);
      }
    }
    allBlockedUsers = searchResult;
    update(['updateList']);
  }
}

String staticBlockedUser = '''
{
	"data": [{
		"id": 629,
		"name": "Test UAT",
		"phone_no": "9762934935",
		"email": "robin@divine.com",
		"image": "astrologers/May2023/EZWI8n7ejtQ4KywqYwIa.jpg",
		"astro_block_customer": [{
				"id": 71,
				"customer_id": 2147483647,
				"astrologer_id": 629,
				"is_block": 1,
				"created_at": "2023-08-16T09:13:51.000000Z",
				"updated_at": "2023-08-16T09:13:51.000000Z",
				"role_id": null,
				"get_customers": null,
				"name": "Jay Shah",
				"image": "https://divinenew.s3.ap-south-1.amazonaws.com/astrologers/May2023/EZWI8n7ejtQ4KywqYwIa.jpg"
			},
			{
				"id": 71,
				"customer_id": 2147483647,
				"astrologer_id": 629,
				"is_block": 1,
				"created_at": "2023-08-16T09:13:51.000000Z",
				"updated_at": "2023-08-16T09:13:51.000000Z",
				"role_id": null,
				"get_customers": null,
				"name": "Nik Fury",
				"image": "https://divinenew.s3.ap-south-1.amazonaws.com/astrologers/May2023/EZWI8n7ejtQ4KywqYwIa.jpg"
			},
			{
				"id": 71,
				"customer_id": 2147483647,
				"astrologer_id": 629,
				"is_block": 1,
				"created_at": "2023-08-16T09:13:51.000000Z",
				"updated_at": "2023-08-16T09:13:51.000000Z",
				"role_id": null,
				"get_customers": null,
				"name": "Virat kohli",
				"image": "https://divinenew.s3.ap-south-1.amazonaws.com/astrologers/May2023/EZWI8n7ejtQ4KywqYwIa.jpg"
			},
			{
				"id": 71,
				"customer_id": 2147483647,
				"astrologer_id": 629,
				"is_block": 1,
				"created_at": "2023-08-16T09:13:51.000000Z",
				"updated_at": "2023-08-16T09:13:51.000000Z",
				"role_id": null,
				"get_customers": null,
				"name": "Sunil Shetty",
				"image": "https://divinenew.s3.ap-south-1.amazonaws.com/astrologers/May2023/EZWI8n7ejtQ4KywqYwIa.jpg"
			},
			{
				"id": 71,
				"customer_id": 2147483647,
				"astrologer_id": 629,
				"is_block": 1,
				"created_at": "2023-08-16T09:13:51.000000Z",
				"updated_at": "2023-08-16T09:13:51.000000Z",
				"role_id": null,
				"get_customers": null,
				"name": "Anupam Khan",
				"image": "https://divinenew.s3.ap-south-1.amazonaws.com/astrologers/May2023/EZWI8n7ejtQ4KywqYwIa.jpg"
			}, {
				"id": 71,
				"customer_id": 2147483647,
				"astrologer_id": 629,
				"is_block": 1,
				"created_at": "2023-08-16T09:13:51.000000Z",
				"updated_at": "2023-08-16T09:13:51.000000Z",
				"role_id": null,
				"get_customers": null,
				"name": "Hardik Pandya",
				"image": "https://divinenew.s3.ap-south-1.amazonaws.com/astrologers/May2023/EZWI8n7ejtQ4KywqYwIa.jpg"
			},
			{
				"id": 71,
				"customer_id": 2147483647,
				"astrologer_id": 629,
				"is_block": 1,
				"created_at": "2023-08-16T09:13:51.000000Z",
				"updated_at": "2023-08-16T09:13:51.000000Z",
				"role_id": null,
				"get_customers": null,
				"name": "Sachin Tendulkar",
				"image": "https://divinenew.s3.ap-south-1.amazonaws.com/astrologers/May2023/EZWI8n7ejtQ4KywqYwIa.jpg"
			},
			{
				"id": 71,
				"customer_id": 2147483647,
				"astrologer_id": 629,
				"is_block": 1,
				"created_at": "2023-08-16T09:13:51.000000Z",
				"updated_at": "2023-08-16T09:13:51.000000Z",
				"role_id": null,
				"get_customers": null,
				"name": "Dhoni",
				"image": "https://divinenew.s3.ap-south-1.amazonaws.com/astrologers/May2023/EZWI8n7ejtQ4KywqYwIa.jpg"
			},
			{
				"id": 71,
				"customer_id": 2147483647,
				"astrologer_id": 629,
				"is_block": 1,
				"created_at": "2023-08-16T09:13:51.000000Z",
				"updated_at": "2023-08-16T09:13:51.000000Z",
				"role_id": null,
				"get_customers": null,
				"name": "Amit Shah",
				"image": "https://divinenew.s3.ap-south-1.amazonaws.com/astrologers/May2023/EZWI8n7ejtQ4KywqYwIa.jpg"
			}
		]
	}],
	"success": true,
	"status_code": 200,
	"message": "get block customer details Successfully"
}
''';
