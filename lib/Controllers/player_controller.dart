import 'package:get/get.dart';

import '../Models/player.dart';
import '../Utils/constant_data.dart';

class PlayerController extends GetxController {
  static PlayerController get to=> Get.find<PlayerController>();

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

  resetPlayerFields(){
    thePlayer.value.skipRight=2;
    thePlayer.value.hintRight=2;
    thePlayer.value.gamePrize=0;

  }

}
