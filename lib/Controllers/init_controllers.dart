import 'package:get/get.dart';
import 'package:wordpuzzle/Controllers/game_manage_controller.dart';
import '../Controllers/play_screen_controller.dart';
import '../Controllers/timer_controller.dart';
import '../Controllers/dialog_controller.dart';
import '../Controllers/player_controller.dart';
import '../Controllers/question_controller.dart';

import 'audio_controller.dart';
import 'login_screen_controller.dart';


class Initializer{

  Future<void> initControllers()async{

    Get.put(LoginScreenController());
    Get.put(GameManagerController());
    Get.put(QuestionController());
    Get.put(PlayScreenController());
    Get.put(TimerController());
    Get.put(PlayerController());
    Get.put(AudioController());
    Get.put(DialogController());




  }
}

