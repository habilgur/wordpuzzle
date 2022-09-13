import '../Utils/constant_data.dart';

class Player {
  String name;
  double point = 0;
  int hintRight = playerHintClickLimit;
  int skipRight = playerSkipLimit;

  Player({required this.name});

  currentPoint() => point;

  hintRightNum() => hintRight;

  reduceHintRightNum() => hintRight--;
  reduceSkipRightNum() => skipRight--;

  // Ads (+) prize to player point
  addQuestionPrize(double prize) {
    if (prize > 0) {
      point = point + prize;
    }
  }
}
