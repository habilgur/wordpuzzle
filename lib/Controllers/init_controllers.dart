import 'package:get/get.dart';
import 'package:wordpuzzle/Controllers/padkey_controller.dart';
import 'package:wordpuzzle/Controllers/player_controller.dart';
import 'package:wordpuzzle/Controllers/question_controller.dart';

import 'answer_key_controller.dart';


class Initializer{

  Future<void> initControllers()async{

    Get.put(QuestionController());
    Get.put(PlayerController());
    Get.put(AnswerKeyController());
    Get.put(PadKeyController());

  }
}

