import 'dart:math';
import 'package:wordpuzzle/Models/question.dart';
import 'package:wordpuzzle/WordBank/turkish_list.dart';

import '../WordBank/alphabet.dart';

PadKey lastClickedKeyPad = PadKey();

class QuestionServices {
  List<Question> creteQuestionList() {
    List<Question> quesList = [];
    var theList=turkishWords.where((item) => item.length<12).toList();

    //todo make 10 dynamic
    for (int i = 0; i <= 10; i++) {
      var question = theList[Random().nextInt(theList.length)].toLowerCase();

      // Create User Answer Map
      var userAnswerMap = List.generate(question.split("").length, (index) {
        return AnswerKey(correctValue: question.split("")[index], correctIndex: index);
      });

      // create Shuffled Chars
      List<PadKey> shuffledPadKeys = createShufflePadKeys(question);

      // Finalize Question
      quesList.add(
        Question(
          question: question,
          questionPrice: 1,// todo make it dynamic via question
          keyboardMap: shuffledPadKeys,
          answerMap: userAnswerMap,
        ),
      );
    }

    return quesList;
  }

  List<PadKey> createShufflePadKeys(String question) {
    //todo random key number set
    var randomKey= turkishAlphabet[Random().nextInt(turkishAlphabet.length)].toLowerCase();

    List<String> questionWithRandomKeys= question.split("");
    questionWithRandomKeys.add(randomKey);

    List<PadKey> shuffledCharsKeyPad = [];
    for (int i = 0; i < questionWithRandomKeys.length ; i++) {
      shuffledCharsKeyPad.add(
        PadKey(
          value: questionWithRandomKeys[i],
          currentIndex: i,
          isClicked: false,
        ).clone(),
      );
    }
    // Shuffle SChar
    shuffledCharsKeyPad.shuffle();

    return shuffledCharsKeyPad;
  }


  reShuffleQuestionKeyPad({required Question currentQuestion}) {
    if (currentQuestion.isDone) return;
    currentQuestion.keyboardMap!.shuffle();
    return currentQuestion;
  }






}
