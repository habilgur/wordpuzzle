import '../Utils/constant_data.dart';

class Player {
  String name;
  double point = 0;
  int hintRight = playerHintClickLimit;

  Player({required this.name});

  currentPoint() => point;

  hintRightNum() => hintRight;

  reduceHintRightNum() => hintRight--;

  // Ads (+) prize to player point
  addQuestionPrize(double prize) {
    if (prize > 0) {
      point = point + prize;
    }
  }
}
