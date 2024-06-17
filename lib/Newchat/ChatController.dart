import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  var walletBalance = 0.obs;
  var joinedDate = ''.obs;
  var lastConsultedDate = ''.obs;
  var userDetails = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    try {
      // Fetching the user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc('user_id').get();

      walletBalance.value = userDoc['walletBalance'];
      joinedDate.value = userDoc['joinedDate'];
      lastConsultedDate.value = userDoc['lastConsultedDate'];
      userDetails.value = {
        'name': userDoc['name'],
        'dob': userDoc['dob'],
        'gender': userDoc['gender'],
        'time': userDoc['time'],
        'location': userDoc['location'],
        'status': userDoc['status'],
        'issue': userDoc['issue']
      };
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
