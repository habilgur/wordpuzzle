import 'package:get/get.dart';
import '../Controllers/dialog_controller.dart';
import '../Controllers/padkey_controller.dart';
import '../Controllers/player_controller.dart';
import '../Controllers/question_controller.dart';

import 'answer_key_controller.dart';
import 'audio_controller.dart';


class Initializer{

  Future<void> initControllers()async{

    Get.put(QuestionController());
    Get.put(PlayerController());
    Get.put(AnswerKeyController());
    Get.put(PadKeyController());
    Get.put(AudioController());
    Get.put(DialogController());

  }
}

