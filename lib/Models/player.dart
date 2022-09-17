import '../Utils/constant_data.dart';

class Player {
  String name;
  double gamePrize = 0;
  int hintRight = playerHintClickLimit;
  int skipRight = playerSkipLimit;


  Player({required this.name});


}
