import 'dart:ui';

const int screenDivideNum = 13;
const double wrongClickPrice = 0.04;  // Only set [wrongClickPrice]
const double oneGameStartPrice = wrongClickPrice * 60; // must be always equal 60 moves - Only set [wrongClickPrice]

const int playerHintClickLimit = 2;
const int playerSkipLimit = 2;
const int gameQuestionLength = 20;


//const Color correctColor= Color(0xFF00BCD4);
const Color correctColor = Color(0xFF4CAF50);
const Color wrongColor = Color(0xFF9E9E9E);
