import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService extends GetxService {
  SharedPreferences? prefs;

  Future<SharedPreferenceService> init() async{
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future remove(String key) {
    return prefs!.remove(key);
  }

  Future erase() {
    return prefs!.clear();
  }
}
