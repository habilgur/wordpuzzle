import 'dart:math';
import 'package:get/get.dart';
import '../Controllers/player_controller.dart';
import '../Models/question.dart';
import '../Utils/constant_data.dart';
import '../WordBank/turkish_list.dart';
import '../Models/answer_key.dart';
import '../Models/padkey.dart';
import '../UI/finish_screen.dart';
import '../WordBank/alphabet.dart';
import 'audio_controller.dart';
import 'play_screen_controller.dart';

class QuestionController extends GetxController {
  static QuestionController get to => Get.find<QuestionController>();
  var _listQuestions = [];
  var indexQuest = 0;

  var _currentQuestion = Question();

  @override
  void onInit() {
    _listQuestions = _creteQuestionList();
    super.onInit();
  }

  List<Question> get listQuestions {
    return [..._listQuestions];
  }

  Question get currentQuestion => _currentQuestion = listQuestions[indexQuest];

  _increaseIndex() {
    indexQuest++;
    update();
  }

  _resetIndex() {
    indexQuest = 0;
    update();
  }

  void restartGame() {
    _resetIndex();
    _listQuestions = _creteQuestionList().obs;
  }

  void clearBoards() {
    _clearAnswerKeyBoard();
    _clearPadKeyMap();
    update();
  }

  _isAnswerMapFull() {
    bool complete = _currentQuestion.answerKeyMap!.where((puzzle) => puzzle.currentValue == null).isEmpty;
    return complete;
  }

  void checkCurrentStatusOfQuestion() async {
    await _checkFailOrDone();
  }

  _checkFailOrDone() async {
    if (isUIWaitingMode()) return;
    bool isClickLimitExceed = _currentQuestion.wrongClickCount >= _currentQuestion.wrongClickLimit!;
    String answeredString = _currentQuestion.answerKeyMap!.map((m) => m.currentValue).join("");
    var isOK = answeredString == _currentQuestion.question;

    if (isClickLimitExceed) {
      await AudioController.to.failedSound();
      _currentQuestion.isClickLimitFail = true;
      _showCorrectAnswer();
      await Future.delayed(const Duration(seconds: 5));
      _setNextQuestion();
    } else if (isOK) {
      await AudioController.to.doneSound();
      _currentQuestion.isDone = true;
      await Future.delayed(const Duration(seconds: 5));
      Get.find<PlayerController>().addQuestionPrizeToPlayerWallet();
      _setNextQuestion();
    }

    // update();
  }

  _showCorrectAnswer() {
    for (var key in _currentQuestion.answerKeyMap!) {
      key.currentValue = key.correctValue;
    }
    update();
  }

  _setNextQuestion() async {
    PlayScreenController().flipCardController.toggleCard();
    _resetQuestionVariables();

    if (listQuestions.length - 1 > indexQuest) {
      _increaseIndex();
    } else {
      Get.to(const FinishScreen());
    }
  }

  _resetQuestionVariables() {
    _currentQuestion.isDone = false;
    _currentQuestion.isClickLimitFail = false;
    _currentQuestion.wrongClickCount = 0;
  }

  isUIWaitingMode() {
    return (_currentQuestion.isDone || _currentQuestion.isClickLimitFail);
  }

  void generateHint() async {
    if (isUIWaitingMode()) return;
    var playerController = Get.find<PlayerController>();
    if (playerController.thePlayer().hintRight == 0) return;
    playerController.reduceHintRightNum();

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
      var theValue = _currentQuestion.pedKeyMap!.where((element) => element.value == userAnswer.correctValue).first;
      _currentQuestion.pedKeyMap!.remove(theValue);

      //checkAnswerCorrect();
    }
  }

  void skipQuestion() {
    if (isUIWaitingMode()) return;
    var playerController = Get.find<PlayerController>();
    if (playerController.thePlayer().skipRight == 0) return;
    _listQuestions.add(_createAQuestion());
    playerController.reduceSkipRightNum();
    _setNextQuestion();
  }

  /// CREATE QUESTIONS ------------------------------------------------------------
  List<Question> _creteQuestionList() {
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

  Question _createAQuestion() {
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

  reShuffleQuestionKeyPad() {
    if (isUIWaitingMode()) return;
    _currentQuestion.pedKeyMap!.shuffle();
    update();
  }

  /// ANSWER KEY ------------------------------------------------------------
  void toggleAnswerKeyOnSelectStatus(AnswerKey answerKeyItem) {
    answerKeyItem.onSelected = !answerKeyItem.onSelected;
    update();
  }

  void _clearAnswerKeyBoard() {
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
    if (!selectedPadKey.isMatched!) _currentQuestion.wrongClickCount++;
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

  void _clearPadKeyMap() {
    var greyPadKeys = _currentQuestion.pedKeyMap!.where((item) => !item.isMatched! && item.isClicked!).toList();
    for (var key in greyPadKeys) {
      key.clearValue();
    }
  }
}
