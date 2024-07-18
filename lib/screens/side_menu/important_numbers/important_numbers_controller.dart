import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../model/important_numbers.dart';
import '../../../repository/important_number_repository.dart';
import '../../../utils/enum.dart';

class ImportantNumbersController extends GetxController {
  final ImportantNumberRepo repository;

  List<MobileNumber> importantNumbers = <MobileNumber>[];
  Loading loading = Loading.initial;
  List<Contact> allContacts = <Contact>[].obs;
  List<Map<String, bool>> allAdded = <Map<String, bool>>[];

  ImportantNumbersController(this.repository);

  @override
  void onInit() async {
    super.onInit();
    loading = Loading.loading;
    await fetchImportantNumbers();
    getContactList();
    // getContactList();
    update();
  }

  bool checkForContactExist(MobileNumber numbers) {
    Item item = Item(label: numbers.title ?? "", value: numbers.mobileNumber ?? "");
    List<String> numberList = [];
    if (item.value != null && item.value!.contains(",")) {
      numberList = item.value!.split(",").toList();
    }
    bool isExist = false;
    if (allContacts.isEmpty) return isExist;
    for (Contact contact in allContacts) {
      if (contact.phones != null) {
        for (var element in contact.phones!) {
          //  log(element.value!);
          if (contact.displayName == item.label
              // &&
              // numberList.every((el) => el.contains(element.value!))
              ) {
            return isExist = true;
          }
        }
      }
    }
    return isExist;
  }

  getContactList() async {
    PermissionStatus contact = await Permission.contacts.status;
    /*if(contact.isDenied){
      PermissionStatus askPermission = await Permission.contacts.request();
      if(askPermission.isDenied){
        divineSnackBar(data: 'contactPermissionRequired'.tr);
      }
    }*/
    if (contact.isGranted) {
      allContacts = await ContactsService.getContacts();
      for(int i = 0 ; i < importantNumbers.length ; i++){
        importantNumbers[i].isExist = checkForContactExist(importantNumbers[i]);
        update();
      }
    } else {
      divineSnackBar(data: 'contactPermissionRequired'.tr);
    }
  }

  addContact({
    required String givenName,
    required List<String> contactNumbers,
  }) async {
    PermissionStatus permission = await Permission.contacts.request();
    if (permission.isGranted) {
      List<Item> phoneItems = contactNumbers.map((contactNo) {
        return Item(label: "mobile", value: contactNo);
      }).toList();
      Contact newContact = Contact(
          givenName: givenName, //This fields are mandatory to save contact
          phones: phoneItems);
      await ContactsService.addContact(newContact);
      divineSnackBar(data: "contactSaved".tr);
      // fetchImportantNumbers();
      for(int i = 0 ; i < importantNumbers.length ; i++){
        if(contactNumbers.join(",") == importantNumbers[i].mobileNumber){
          importantNumbers[i].isExist = true;
          update();
          break;
        }
      }
    } else {
      openAppSettings();
    }
  }

  fetchImportantNumbers() async {
    try {
      final response = await repository.fetchData();
      if (response.data != null) {
        importantNumbers = response.data!;
      }
      loading = Loading.loaded;
      update();
    } catch (error) {
      divineSnackBar(data: error.toString(), color: appColors.redColor);
    }
  }
}
