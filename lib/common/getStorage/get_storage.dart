
import 'package:get_storage/get_storage.dart';

class GetStorages {

  static set(String key, dynamic value) {
    final box = GetStorage();
    return box.write(key, value);
  }

  static get(String key) {
    final box = GetStorage();
    return box.read(key);
  }

  static removeStorage(){
    final box = GetStorage();
    return box.erase();
  }
}
