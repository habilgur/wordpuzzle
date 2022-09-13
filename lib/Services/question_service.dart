import 'dart:math';
import 'package:wordpuzzle/Models/question.dart';
import 'package:wordpuzzle/Utils/constant_data.dart';
import 'package:wordpuzzle/WordBank/turkish_list.dart';
import '../WordBank/alphabet.dart';

class QuestionServices {
  List<Question> creteQuestionList() {
    List<Question> quesList = [];
    var theList = turkishWords.where((item) => item.length < 12).toList();

    for (int i = 0; i <= gameQuestionLength; i++) {
      var question = theList[Random().nextInt(theList.length)].toLowerCase();

      // Create User Answer Map
      var userAnswerMap = List.generate(question.split("").length, (index) {
        return AnswerKey(correctValue: question.split("")[index], correctIndex: index);
      });

      // Lets create Random Keys
      var questionWithRandomKeys = createRandomKeys(question);

      // Create Shuffled Chars
      List<PadKey> shuffledPadKeys = createShufflePadKeys(questionWithRandomKeys);

      // Set Hinted AnswerMap for Game Start
      createHintThenRemoveFromShuffledKeys(userAnswerMap, shuffledPadKeys);

      // Generate Question List
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

  Question createAQuestion() {
    var theList = turkishWords.where((item) => item.length < 12).toList();


      var question = theList[Random().nextInt(theList.length)].toLowerCase();

      // Create User Answer Map
      var userAnswerMap = List.generate(question.split("").length, (index) {
        return AnswerKey(correctValue: question.split("")[index], correctIndex: index);
      });

      // Lets create Random Keys
      var questionWithRandomKeys = createRandomKeys(question);

      // Create Shuffled Chars
      List<PadKey> shuffledPadKeys = createShufflePadKeys(questionWithRandomKeys);

      // Set Hinted AnswerMap for Game Start
      createHintThenRemoveFromShuffledKeys(userAnswerMap, shuffledPadKeys);

      // Generate Question
      return Question(
        question: question,
        questionPrice: question.length * questionTilePrize,
        keyboardMap: shuffledPadKeys,
        answerMap: userAnswerMap,
      );

  }

  List<String> createRandomKeys(String question) {
    List<String> randomList = [];
    var randomCharNum = question.length < 5 ? 1 : 2;

    for (int i = 0; i < randomCharNum; i++) {
      var randomKey = turkishAlphabet[Random().nextInt(turkishAlphabet.length)].toLowerCase();
      randomList.add(randomKey);
    }

    List<String> questionWithRandomKeys = [question.split(""), randomList].expand((x) => x).toList();
    return questionWithRandomKeys;
  }

  List<PadKey> createShufflePadKeys(List<String> questionWithRandomKeys) {
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

  void createHintThenRemoveFromShuffledKeys(List<AnswerKey> userAnswerMap, List<PadKey> shuffledPadKeys) {
    int rand1 = 0, rand2 = 0;
    List<int> rndList = [];
    while (rand1 == rand2) {
      rand1 = Random().nextInt(userAnswerMap.length);
      rand2 = Random().nextInt(userAnswerMap.length);
      if (rand1 != rand2) {
        rndList.add(rand1);
        rndList.add(rand2);
      }
    }

    // Set how much hint display via question lenght
    userAnswerMap.length < 6 ? rndList.remove(rndList.last) : rndList;

    // change current value to correct value and hintShow true in userAnswerMap randomly according question length
    for (int index in rndList) {
      var answerKeyWithHint = userAnswerMap[index];
      answerKeyWithHint.hintShow = true;
      answerKeyWithHint.currentValue = answerKeyWithHint.correctValue;

      // Remove hinted value from shuffle Keys
      var removeKeyPadWithHint = shuffledPadKeys.where((k) => k.value == answerKeyWithHint.currentValue).first;
      shuffledPadKeys.remove(removeKeyPadWithHint);
    }
  }

  reShuffleQuestionKeyPad({required Question currentQuestion}) {
    if (currentQuestion.isDone) return;
    currentQuestion.keyboardMap!.shuffle();
    return currentQuestion;
  }
}
