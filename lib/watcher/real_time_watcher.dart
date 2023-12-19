import 'package:rxdart/rxdart.dart';

class RealTimeWatcher {
  final _nameSubject = BehaviorSubject<String>();

  // Stream getter
  Stream<String> get nameStream => _nameSubject.stream;

  // The current value of name
  String get currentName => _nameSubject.valueOrNull ?? "";

  set strValue(String newName) {
    if (_nameSubject.valueOrNull != newName) {
      _nameSubject.add(newName);
    }
  }

  void dispose() {
    _nameSubject.close();
  }
}
