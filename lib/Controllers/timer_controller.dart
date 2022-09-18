
import 'dart:async';
import 'package:get/get.dart';
import '../Controllers/game_manage_controller.dart';

class TimerController extends GetxController {
  static TimerController get to=> Get.find<TimerController>();

  static const maxSeconds = 120;
  var seconds = maxSeconds;
  Timer? timer;

  /// Start Timer
  void startTimer({bool rest = true}) {
    if (rest) {
      resetTimer();
      update();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        GameManagerController.to.checkCurrentStatusOfQuestion();
        update();
      } else {
        stopTimer(rest: false);
        resetTimer();

      }
    });
  }

  /// Stop Timer
  void stopTimer({bool rest = true}) {
    if (rest) {
      resetTimer();
      update();
    }
    timer?.cancel();
    update();
  }

  /// Reset Timer
  void resetTimer() {
    seconds = maxSeconds;
    update();
  }

  /// is Timer Active?
  bool isTimerRuning() {
    return timer == null ? false : timer!.isActive;
  }

  /// is Timer Completed?
  bool isCompleted() {
    return  seconds == 0;
  }
}