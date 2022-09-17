import 'package:wordpuzzle/Models/padkey.dart';
import 'answer_key.dart';

class Question {
  String? question;

  bool isDone = false;
  bool isFull = false;
  List<AnswerKey>? answerKeyMap = <AnswerKey>[];
  List<PadKey>? pedKeyMap = <PadKey>[];
  int? wrongClickLimit=0;
  int wrongClickCount=0;

  bool isClickLimitFail=false;

  Question({
    this.question,
    this.answerKeyMap,
    this.pedKeyMap,
    this.wrongClickLimit,
    t
  });

}

