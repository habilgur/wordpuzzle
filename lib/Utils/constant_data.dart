import 'dart:ui';

const int screenDivideNum = 13;
const int quesPointMultiply = 2; // Don't change it.
const double keyPrize = 0.01;

const double correctClickPrice = keyPrize;
const double wrongClickPrice = keyPrize * quesPointMultiply; // wrongClickPrice==questionTilePrize must be equal
const double prizePerQuestionTile =0.002;
const int playerHintClickLimit = 2;
const int playerSkipLimit = 2;
const int gameQuestionLength =20;


const Color correctColor= Color(0xFF00BCD4);
const Color wrongColor= Color(0xFF9E9E9E);
