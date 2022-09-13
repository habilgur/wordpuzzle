import 'dart:math';
import 'package:wordpuzzle/Models/question.dart';
import 'package:wordpuzzle/Utils/constant_data.dart';
import 'package:wordpuzzle/WordBank/turkish_list.dart';
import '../WordBank/alphabet.dart';

PadKey lastClickedKeyPad = PadKey();

class QuestionServices {
  List<Question> creteQuestionList() {
    List<Question> quesList = [];
    var theList = turkishWords.where((item) => item.length < 12).toList();

    //todo make 10 dynamic
    for (int i = 0; i <= 10; i++) {
      var question = theList[Random().nextInt(theList.length)].toLowerCase(); // todo check unique

      // Create User Answer Map
      var userAnswerMap = List.generate(question.split("").length, (index) {
        return AnswerKey(
            correctValue: question.split("")[index], correctIndex: index);
      });

      // change current value to correct value and hintShow true in userAnswerMap randomly according question length

      // shuffle Keys with out hint true

      // create Shuffled Chars
      List<PadKey> shuffledPadKeys = createShufflePadKeys(question);

      quesList.add(
        Question(
          question: question,
          questionPrice: question.length * questionTilePrize,
          keyboardMap: shuffledPadKeys,
          answerMap: userAnswerMap,
        ),
      );
    }

    return quesList;
  }

  List<PadKey> createShufflePadKeys(String question) {
    var randomList = [];
    var randomCharNum = question.length < 7 ? 1 : 2;
    for (int i = 0; i < randomCharNum; i++) {
      var randomKey = turkishAlphabet[Random().nextInt(turkishAlphabet.length)].toLowerCase();
      randomList.add(randomKey);
    }

    var questionWithRandomKeys = [question.split(""), randomList].expand((x) => x).toList();

    List<PadKey> shuffledCharsKeyPad = [];
    for (int i = 0; i < questionWithRandomKeys.length; i++) {
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
