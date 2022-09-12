import 'dart:math';
import 'package:wordpuzzle/Models/question.dart';
import 'package:wordpuzzle/WordBank/turkish_list.dart';

import '../WordBank/alphabet.dart';

KeyValue lastClickedKeyPad = KeyValue();

class QuestionServices {
  List<Question> creteQuestionList() {
    List<Question> quesList = [];

    //todo make 10 dynamic
    for (int i = 0; i <= 10; i++) {
      var question = turkishWords[Random().nextInt(turkishWords.length)].toLowerCase();

      // Create User Answer Map
      var userAnswerMap = List.generate(question.split("").length, (index) {
        return AnswerMap(correctValue: question.split("")[index], correctIndex: index);
      });

      // create Shuffled Chars
      List<KeyValue> shuffledKeyPad = createShuffleKeyPad(question);

      // Finalize Question
      quesList.add(
        Question(
          question: question,
          questionPrice: 1,// todo make it dynamic via question
          keyPad: shuffledKeyPad,
          userAnswerMap: userAnswerMap,
        ),
      );
    }

    return quesList;
  }

  List<KeyValue> createShuffleKeyPad(String question) {
    //todo random key number set
    var randomKey= turkishAlphabet[Random().nextInt(turkishAlphabet.length)].toLowerCase();

    List<String> questionWithRandomKeys= question.split("");
    questionWithRandomKeys.add(randomKey);

    List<KeyValue> shuffledCharsKeyPad = [];
    for (int i = 0; i < questionWithRandomKeys.length ; i++) {
      shuffledCharsKeyPad.add(
        KeyValue(
          value: questionWithRandomKeys[i],
          currentKeyPadIndex: i,
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
    currentQuestion.keyPad!.shuffle();
    return currentQuestion;
  }






}
