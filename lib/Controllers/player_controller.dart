import 'package:get/get.dart';

import '../Models/player.dart';
import '../Utils/constant_data.dart';

class PlayerController extends GetxController {
  static PlayerController get to=> PlayerController();

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
    thePlayer.value.gamePrize += correctAnswerPrize;

    update();
  }
}
