import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/strings.dart';
import 'package:divine_astrologer/utils/utils.dart';
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
  void onInit() {
    super.onInit();
    loading = Loading.loading;
    fetchImportantNumbers();
    getContactList();
    update();
  }

  bool checkForContactExist(MobileNumber numbers) {
    Item item =
        Item(label: numbers.title ?? "", value: numbers.mobileNumber ?? "");
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
          if (contact.displayName == item.label &&
              numberList.every((el) => el.contains(element.value!))) {
            return isExist = true;
          }
        }
      }
    }
    return isExist;
  }

  getContactList() async {
    PermissionStatus contact = await Permission.contacts.status;
    if (contact.isGranted) {
      allContacts = await ContactsService.getContacts();
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
      fetchImportantNumbers();
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
      divineSnackBar(data: error.toString(),color: AppColors.redColor);
    }
  }
}
