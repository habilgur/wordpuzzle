import '../Utils/constant_data.dart';

class Player {
  String name;
  double gamePrize = 0;
  int hintRight = playerHintClickLimit;
  int skipRight = playerSkipLimit;
  int wrongClickCount=0;

  Player({required this.name});

  currentGamePrize() => gamePrize;

  hintRightNum() => hintRight;

  reduceHintRightNum() => hintRight--;
  reduceSkipRightNum() => skipRight--;

  // Ads (+) prize to player point
  addQuestionPrize(double prize) {
    if (prize > 0) {
      gamePrize = gamePrize + prize;
    }
  }
}
