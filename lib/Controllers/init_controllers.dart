import 'package:get/get.dart';
import 'package:wordpuzzle/Controllers/play_screen_controller.dart';
import '../Controllers/dialog_controller.dart';
import '../Controllers/player_controller.dart';
import '../Controllers/question_controller.dart';

import 'audio_controller.dart';
import 'login_screen_controller.dart';


class Initializer{

  Future<void> initControllers()async{

    Get.put(PlayScreenController());
    Get.put(QuestionController());
    Get.put(PlayerController());
    Get.put(LoginScreenController());
    Get.put(AudioController());
    Get.put(DialogController());


  }
}

