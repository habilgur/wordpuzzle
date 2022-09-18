import 'package:get/get.dart';

import '../Models/player.dart';
import '../Utils/constant_data.dart';
import 'question_controller.dart';

class PlayerController extends GetxController {
  static PlayerController get to => Get.find<PlayerController>();

  final thePlayer = Player(name: "test").obs;

  reduceSkipRightNum() {
    thePlayer.update((val) {
      val!.skipRight--;
    });
  }

  currentGamePrize() => thePlayer.value.gamePrize;

  hintRightNum() => thePlayer.value.hintRight;

  reduceHintRightNum() => thePlayer.value.hintRight--;

  // Ads (+) prize to player point
  addQuestionPrizeToPlayerWallet() {
    var currentQuestion = QuestionController.to.currentQuestion;
    double regularPrize = correctAnswerPrize;
    double bonus = correctAnswerPrize * 2;
    double result = regularPrize;

    // if user find the answer in 1 wrong try
    if (currentQuestion.wrongClickCount ==0) {
      result = bonus;
    }
    thePlayer.value.gamePrize += result;

    update();
  }

  resetPlayerFields() {
    thePlayer.value.skipRight = 2;
    thePlayer.value.hintRight = 2;
    thePlayer.value.gamePrize = 0;
  }
}
