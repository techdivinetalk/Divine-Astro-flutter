import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:get/get.dart';

class ImportantNumbersController extends GetxController {
  addContact(
      {required String givenName,
      required String middleName,
      required String contactNo}) async {
    Contact newContact = Contact(
        givenName: givenName, //This fields are mandatory to save contact
        middleName: middleName, //This fields are mandatory to save contact
        phones: [Item(label: "mobile", value: "+91 $contactNo")]);
    await ContactsService.addContact(newContact);
    divineSnackBar(data: "Contact saved successfully");
  }
}
