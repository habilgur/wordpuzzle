import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:wordpuzzle/Controllers/player_controller.dart';
import 'package:wordpuzzle/Controllers/question_controller.dart';
import 'package:wordpuzzle/Controllers/timer_controller.dart';

import '../UI/finish_screen.dart';
import 'audio_controller.dart';
import 'play_screen_controller.dart';

class GameManagerController extends GetxController {
  static GameManagerController get to => Get.find<GameManagerController>();
  var indexQuest = 0;

  startGame() {
    _resetIndex();
    PlayerController.to.resetPlayerFields();
    QuestionController.to.createQuestionList();
    TimerController.to.startTimer();
  }

  void restartGame() {
    startGame();
  }

  _resetIndex() {
    indexQuest = 0;
  }

  _increaseIndex() {
    indexQuest++;
    update();
  }

  setNextQuestion() {
    PlayScreenController.to.flipCardController.toggleCard();

    QuestionController.to.resetQuestionVariables();

    TimerController.to.startTimer();
    if (QuestionController.to.listQuestions.length - 1 > indexQuest) {
      _increaseIndex();
    } else {
      Get.to(() => const FinishScreen());
    }
  }

  void checkCurrentStatusOfQuestion() async {
    await _checkFailOrDone();
    await _checkIsTimeUP();

  }

  _checkFailOrDone() async {
    if (QuestionController.to.isQuestionWaitingMode()) return;

    var curQues = QuestionController.to.currentQuestion;
    bool isClickLimitExceed = curQues.wrongClickCount >= curQues.wrongClickLimit!;
    String answeredString = curQues.answerKeyMap!.map((m) => m.currentValue).join("");
    var isOK = answeredString == curQues.question;

    if (isClickLimitExceed) {
      await AudioController.to.failedSound();
      curQues.isClickLimitFail = true;
      QuestionController.to.showCorrectAnswer();
      await Future.delayed(const Duration(seconds: 4));
      TimerController.to.stopTimer();
      setNextQuestion();
    } else if (isOK) {

      await AudioController.to.doneSound();
      curQues.isDone = true;
      await Future.delayed(const Duration(seconds: 3));
      Get.find<PlayerController>().addQuestionPrizeToPlayerWallet();
      TimerController.to.stopTimer();
      setNextQuestion();
    }

    // update();
  }

  _checkIsTimeUP()async{
    if(TimerController.to.isCompleted()){

      await AudioController.to.failedSound();
      QuestionController.to.currentQuestion.isTimeUp=true;
      QuestionController.to.showCorrectAnswer();
      await Future.delayed(const Duration(seconds: 5));
      setNextQuestion();

    }
  }
}
