import '../Models/padkey.dart';
import 'answer_key.dart';

class Question {
  String? question;

  bool isDone = false;
  bool isFull = false;
  bool isTimeUp = false;
  List<AnswerKey>? answerKeyMap = <AnswerKey>[];
  List<PadKey>? pedKeyMap = <PadKey>[];
  int? wrongClickLimit=0;
  int wrongClickCount=0;
  int? level;

  bool isClickLimitFail=false;

  Question({
    this.question,
    this.answerKeyMap,
    this.pedKeyMap,
    this.wrongClickLimit,
    this.level,
  });


}

