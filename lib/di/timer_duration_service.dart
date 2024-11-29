import 'dart:async';

import 'package:get/get.dart';

class TimeDurationService extends GetxService {
  Timer? chatTimer;
  Rx<Duration> chatDuration = Duration(minutes: 0).obs;
  int orderId = 0;

  startMinuteTimer(int minDuration, int id) {
    if (chatTimer?.isActive == null || !(chatTimer?.isActive ?? true)) {
      orderId = id;
      chatDuration.value = Duration(seconds: minDuration);
      chatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        chatDuration.value = Duration(seconds: chatDuration.value.inSeconds - 1);
        if (chatDuration.value.inSeconds <= 0) {
          stopTimer();
        }
      });
    }
  }

  String formattedTime() {
    String duration = '';
    if (chatDuration.value.inHours > 0) {
      duration = '${chatDuration.value.inHours.toString().padLeft(2, '0')}:';
    }
    duration =
        "$duration${(chatDuration.value.inMinutes % 60).toString().padLeft(2, '0')}:${(chatDuration.value.inSeconds % 60).toString().padLeft(2, '0')}";
    return duration;
  }

  stopTimer() {
    orderId = 0;
    chatDuration.value = Duration.zero;
    chatTimer?.cancel();
  }
}
