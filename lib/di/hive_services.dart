import 'package:hive/hive.dart';

class HiveServices {
  final String boxName;
  static late Box _box;

  HiveServices({required this.boxName});

  /// To initialize the hive box. Remember to call before using any service
  initialize() async {
    _box = await Hive.openBox(boxName);
  }

  addData({required String data, required String key}) async {
    await _box.put(key, data);
  }

  deleteAllData() async {
    _box = await Hive.openBox(boxName);
    await _box.deleteFromDisk();
  }

  /// Returns true is data is present in the box.
  bool checkData() {
    return _box.isNotEmpty;
  }

  getData({required String key}) async {
    return await _box.get(key);
  }

  close() async {
    await _box.close();
  }
}
