import 'package:contacts_service/contacts_service.dart';
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

  ImportantNumbersController(this.repository);

  @override
  void onInit() {
    super.onInit();
    loading = Loading.loading;
    fetchImportantNumbers();
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
      divineSnackBar(data: "Contact saved successfully");
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
    } catch (err) {
      Get.snackbar("Error", err.toString()).show();
    }
  }
}
