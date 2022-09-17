import 'dart:math';

import 'package:get/get.dart';
import 'package:wordpuzzle/Controllers/player_controller.dart';
import 'package:wordpuzzle/Models/question.dart';
import 'package:wordpuzzle/Utils/constant_data.dart';
import 'package:wordpuzzle/WordBank/turkish_list.dart';
import '../Models/answer_key.dart';
import '../Models/padkey.dart';
import '../UI/finish_screen.dart';
import '../WordBank/alphabet.dart';

class QuestionController extends GetxController {
  var _listQuestions = [];
  var indexQuest = 0;

  var _currentQuestion = Question();

  @override
  void onInit() {
    _listQuestions = creteQuestionList().obs;
    super.onInit();
  }

  List<Question> get listQuestions {
    return [..._listQuestions];
  }

  Question get currentQuestion => _currentQuestion = listQuestions[indexQuest];

  increaseIndex() {
    indexQuest++;
    update();
  }

  resetIndex() {
    indexQuest = 0;
    update();
  }

  void nextQuestion() {
    if (listQuestions.length - 1 > indexQuest) {
      increaseIndex();
    } else {
      Get.to(const FinishScreen());
    }
  }

  void restartGame() {
    resetIndex();
    _listQuestions = creteQuestionList().obs;
  }

  void clearBoards() {
    clearAnswerKeyBoard();
    clearPadKeyMap();
    update();
  }

  bool _isAnswerMapFull() {
    bool complete = _currentQuestion.answerKeyMap!.where((puzzle) => puzzle.currentValue == null).isEmpty;
    return complete;
  }

  checkAnswerCorrect() async {
    if (!_isAnswerMapFull()) return false;

    String answeredString = _currentQuestion.answerKeyMap!.map((m) => m.currentValue).join("");

    var isOK = answeredString == _currentQuestion.question;

    if (isOK) {
      _currentQuestion.isDone = true;
      _currentQuestion.wrongClickCount = 0;

      var thePlayer = Get.find<PlayerController>().thePlayer();
      thePlayer.gamePrize += correctAnswerPrize;

      await Future.delayed(const Duration(seconds: 2));
      nextQuestion();
    }
  }

  generateHint() async {
    var thePlayer = Get.find<PlayerController>().thePlayer();
    if (Get.find<PlayerController>().thePlayer.value.hintRight == 0) return;
    thePlayer.reduceHintRightNum();

    // Clear board and fill keyPad again to avoid empty search for already removed items from keyPad..
    clearBoards();

    List<AnswerKey> mapWithNoHints =
        _currentQuestion.answerKeyMap!.where((item) => !item.hintShow && item.isEmpty()).toList();

    if (mapWithNoHints.isNotEmpty) {
      int indexHint = Random().nextInt(mapWithNoHints.length);

      var userAnswer = mapWithNoHints[indexHint];
      userAnswer.currentValue = userAnswer.correctValue;
      userAnswer.hintShow = true;

      // remove hint from keypad ( avoid multiple removing find first occurrence then clear)
      var theValue =
          _currentQuestion.pedKeyMap!.where((element) => element.value == userAnswer.correctValue).first;
      _currentQuestion.pedKeyMap!.remove(theValue);

      if (checkAnswerCorrect()) {
        _currentQuestion.isDone = true;
        _currentQuestion.wrongClickCount = 0;
        thePlayer.gamePrize = thePlayer.gamePrize + correctAnswerPrize;

        await Future.delayed(const Duration(seconds: 2));
        nextQuestion();
      }
    }
  }

  /// CREATE QUESTIONS ------------------------------------------------------------
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
          pedKeyMap: shuffledPadKeys,
          answerKeyMap: userAnswerMap,
          wrongClickLimit: userAnswerMap.length - 2,
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
      pedKeyMap: shuffledPadKeys,
      answerKeyMap: userAnswerMap,
    );
  }

  List<String> createRandomKeys(String question) {
    List<String> randomList = [];
    var randomCharNum = question.length < 5 ? 3 : 4;

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
          isClicked: false,
        ).clone(),
      );
    }
    // Shuffle SChar
    shuffledCharsKeyPad.shuffle();

    return shuffledCharsKeyPad;
  }

  void createHintThenRemoveFromShuffledKeys(List<AnswerKey> userAnswerMap, List<PadKey> shuffledPadKeys) {
    int rand1 = 0, rand2 = 0, rand3 = 0;
    List<int> rndList = [];
    while (rand1 == rand2 || rand2 == rand3 || rand1 == rand3) {
      rand1 = Random().nextInt(userAnswerMap.length);
      rand2 = Random().nextInt(userAnswerMap.length);
      rand3 = Random().nextInt(userAnswerMap.length);
      if (rand1 != rand2 && rand2 != rand3 && rand1 != rand3) {
        rndList.add(rand1);
        rndList.add(rand2);
        rndList.add(rand3);
      }
    }

    // Set how much hint display via question lenght
    if (userAnswerMap.length <= 4) {
      rndList.remove(rand1);
      rndList.remove(rand2); // 1 hint
    } else if (userAnswerMap.length <= 6) {
      rndList.remove(rand3); // 2 hint
    }

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

  reShuffleQuestionKeyPad({required Rx<Question> currentQuestion}) {
    if (_currentQuestion.isDone) return;
    _currentQuestion.pedKeyMap!.shuffle();
    return _currentQuestion;
  }

  /// ANSWER KEY ------------------------------------------------------------
  void toggleAnswerKeyOnSelectStatus(AnswerKey answerKeyItem) {
    answerKeyItem.onSelected = !answerKeyItem.onSelected;
    update();
  }

  void clearAnswerKeyBoard() {
    var emptyAnswerKeys = _currentQuestion.answerKeyMap!.where((item) => item.currentValue != null).toList();
    for (var ans in emptyAnswerKeys) {
      if (ans.currentValue != ans.correctValue) {
        ans.clearValue();
      }
    }
  }

  /// PAD KEY ------------------------------------------------------------

  void padKeyClickAction({required PadKey selectedPadKey}) {
    if (_isAnswerMapFull()) return;

    // setAnswer Part
    var theAnswerKey = _findTargetedAnswerKey();
    theAnswerKey.currentValue = selectedPadKey.value;
    theAnswerKey.comingKeyPadIndex = _currentQuestion.pedKeyMap!.indexWhere((k) => k == selectedPadKey);

    // set Pad part
    selectedPadKey.isClicked = !selectedPadKey.isClicked!;
    selectedPadKey.isMatched = theAnswerKey.isValueMatch();
    if(!selectedPadKey.isMatched!) _currentQuestion.wrongClickCount++;
    update();
  }

  _findTargetedAnswerKey() {
    var isAnyOnSelectedAnsKeyExist = _currentQuestion.answerKeyMap!.any((map) => map.onSelected == true);
    var isEmptyAnswerKeyExist = _currentQuestion.answerKeyMap!.any((map) => map.currentValue == null);

    int lookingIndexOfAnsKey = 0;
    if (isAnyOnSelectedAnsKeyExist) {
      lookingIndexOfAnsKey = _currentQuestion.answerKeyMap!.indexWhere((map) => map.onSelected);
      Get.find<QuestionController>().toggleAnswerKeyOnSelectStatus(
          _currentQuestion.answerKeyMap![lookingIndexOfAnsKey]); // always lock this properties again
    } else if (isEmptyAnswerKeyExist) {
      lookingIndexOfAnsKey = _currentQuestion.answerKeyMap!.indexWhere((map) => map.currentValue == null);
    }

    return _currentQuestion.answerKeyMap![lookingIndexOfAnsKey];
  }

  void togglePadKeyClickStatus(selectedKeyPad) {
    selectedKeyPad.isClicked = !selectedKeyPad.isClicked!;
    update();
  }

  void clearPadKeyMap() {
    var greyPadKeys = _currentQuestion.pedKeyMap!.where((item) => !item.isMatched! && item.isClicked!).toList();
    for (var key in greyPadKeys) {
      key.clearValue();
    }
  }
}
