import 'dart:math';
import 'package:wordpuzzle/Models/question.dart';
import 'package:wordpuzzle/WordBank/turkish_list.dart';

ShuffledCharacters lastClickedKeyPad = ShuffledCharacters();

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
      List<ShuffledCharacters> shuffledKeyPad = createShuffleKeyPad(question);

      // Finalize Question
      quesList.add(
        Question(
          question: question,
          keyPad: shuffledKeyPad,
          userAnswerMap: userAnswerMap,
        ),
      );
    }

    return quesList;
  }

  List<ShuffledCharacters> createShuffleKeyPad(String question) {
    List<ShuffledCharacters> shuffledCharsKeyPad = [];
    for (int i = 0; i <= question.length - 1; i++) {
      shuffledCharsKeyPad.add(
        ShuffledCharacters(
          value: question.split("")[i],
          //answerIndex: i,
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

  Question insertKeyPad(Question currentQues, AnswerMap map) {
    currentQues.keyPad!.insert(
        // if current keypad shorter then original length then add last index
        map.comingKeyPadIndex! > currentQues.keyPad!.length
            ? currentQues.keyPad!.length
            : map.comingKeyPadIndex!,
        ShuffledCharacters(
          value: map.currentValue,
          currentKeyPadIndex: map.comingKeyPadIndex,
          isClicked: false,
        ));
    return currentQues;
  }

  Question removeKeyPad(Question currentQues, lastKeyPadIndex) {
    // Pass Clicked KeyPad value to board
    int findFirstIndexOfMapWithEmptyValue = currentQues.userAnswerMap!.indexWhere((map) => map.currentValue == null);

    if (findFirstIndexOfMapWithEmptyValue >= 0) {
      currentQues.userAnswerMap![findFirstIndexOfMapWithEmptyValue].currentIndex = lastKeyPadIndex;
      currentQues.userAnswerMap![findFirstIndexOfMapWithEmptyValue].currentValue =
          currentQues.keyPad![lastKeyPadIndex].value;
      currentQues.userAnswerMap![findFirstIndexOfMapWithEmptyValue].comingKeyPadIndex =
          lastKeyPadIndex; // pass lastClickedKeyPad currentIndex to track coming index
    }

    currentQues.keyPad!.removeAt(lastKeyPadIndex);

    return currentQues;
  }

  Question clearQuestionBoard(Question currentQues) {
    var emptyMaps=currentQues.userAnswerMap!.where((item) => item.currentValue!=null).toList();
    for (var map in emptyMaps) {
      if (map.currentValue != map.correctValue) {
        insertKeyPad(currentQues, map);
        map.clearValue();
      }
    }


    return currentQues;
  }

  
}
