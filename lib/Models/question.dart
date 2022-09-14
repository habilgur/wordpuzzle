import '../Utils/constant_data.dart';

class Question {
  String? question;
  double? questionPrice = 0;
  bool isDone = false;
  bool isFull = false;
  List<AnswerKey>? answerMap = <AnswerKey>[];
  List<PadKey>? keyboardMap = <PadKey>[];

  Question({
    this.question,
    this.questionPrice,
    this.answerMap,
    this.keyboardMap,
  });

  bool isAnswerCorrect() {
    if (!_isAnswerMapFull()) return false;

    String answeredString = answerMap!.map((m) => m.currentValue).join("");

    return answeredString == question;
  }

  void updateQuestionPrize(PadKey selectedPadKey) {
    // Avoid range Error Index
    if (_isAnswerMapFull()) return;

    var firstEmptyAnswerKey = answerMap!.where((k) => k.currentValue == null).first;

    bool isCorrect = firstEmptyAnswerKey.correctValue == selectedPadKey.value;

    if (isCorrect) {
      increaseQuestionPrice();
    } else {
      reduceQuestionPrice();
    }
  }

  ///Deduct ClickPrice from QuestionPrize as default. Option: HintPrize
  void reduceQuestionPrice({double deduct = wrongClickPrice}) {
    //if (questionPrice! -deduct < -0.00001) return; // Avoid Question Price below zero.
    questionPrice = questionPrice! - deduct;
  }

  void increaseQuestionPrice() {
    questionPrice = questionPrice! + correctClickPrice;
  }

  void padKeyClickAction({required PadKey selectedPadKey}) {
    if (_isAnswerMapFull()) return;

    // setAnswer Part
    var theAnswerKey = _findTargetedAnswerKey();
    theAnswerKey.currentValue = selectedPadKey.value;
    theAnswerKey.comingKeyPadIndex = keyboardMap!.indexWhere((k) => k == selectedPadKey);

    // set Pad part
    selectedPadKey.isClicked = true;
    selectedPadKey.isMatched = theAnswerKey.isValueMatch();
  }

  _findTargetedAnswerKey() {
    var isAnyOnDoubleTapAnsKeyExist = answerMap!.any((map) => map.onDoubleTapped == true);
    var isEmptyAnswerKeyExist = answerMap!.any((map) => map.currentValue == null);

    int lookingIndexOfAnsKey = 0;
    if (isAnyOnDoubleTapAnsKeyExist) {
      lookingIndexOfAnsKey = answerMap!.indexWhere((map) => map.onDoubleTapped);
      answerMap![lookingIndexOfAnsKey].toggleDoubleOnTap(); // always lock this properties again
    } else if (isEmptyAnswerKeyExist) {
      lookingIndexOfAnsKey = answerMap!.indexWhere((map) => map.currentValue == null);
    }

    return answerMap![lookingIndexOfAnsKey];
  }

  void answerKeyClickAction(AnswerKey answerKey) {
    if (_isAnswerMapFull()) return;

    // Colorize Key Pad
    keyboardMap![answerKey.comingKeyPadIndex!].isClicked = false;

    // Clear Answer Key value
    answerKey.clearValue();
  }

  void clearBoards() {
    _clearAnswerKeyBoard();
    _clearPadKeyboard();
  }

  void _clearAnswerKeyBoard() {
    var emptyAnswerKeys = answerMap!.where((item) => item.currentValue != null).toList();
    for (var ans in emptyAnswerKeys) {
      if (ans.currentValue != ans.correctValue) {
        ans.clearValue();
      }
    }
  }

  void _clearPadKeyboard() {
    var greyPadKeys = keyboardMap!.where((item) => !item.isMatched! && item.isClicked!).toList();
    for (var key in greyPadKeys) {
      key.clearValue();
    }
  }

  bool _isAnswerMapFull() {
    bool complete = answerMap!.where((puzzle) => puzzle.currentValue == null).isEmpty;
    return isFull = complete;
  }
}

class PadKey {
  String? value;
  bool? isClicked;
  bool? isMatched;

  PadKey({this.value, this.isClicked, this.isMatched});

  PadKey clone() {
    return PadKey(
      value: value,
      isClicked: false,
      isMatched: false,
    );
  }

  getValue() {
    return value;
  }

  isKeyClicked() {
    return isClicked;
  }

  isKeyMatched() {
    return isMatched;
  }

  void toggleClickStatus() {
    isClicked = !isClicked!;
  }

  void clearValue() {
    isClicked = false;
    isMatched = false;
  }
}

class AnswerKey {
  String? currentValue;
  int? comingKeyPadIndex;
  int? correctIndex;
  String? correctValue;
  bool hintShow;
  bool onDoubleTapped;

  AnswerKey({
    this.hintShow = false,
    this.correctValue,
    this.currentValue,
    this.correctIndex,
    this.comingKeyPadIndex,
    this.onDoubleTapped = false,
  });

  getCurrentValue() {
    if (correctValue != null) {
      return currentValue;
    } else if (hintShow) {
      return correctValue;
    }
  }

  void clearValue() {
    currentValue = null;
  }

  bool isValueMatch() {
    return currentValue == correctValue;
  }

  bool isEmpty() {
    return currentValue == null;
  }

  bool isNotClickable({bool isDoubleClicked = false}) {
    if (isDoubleClicked) {
      return currentValue != null; // to able to select empty key with double click skip currentValue == null
    } else {
      return isValueMatch() || currentValue == null || hintShow;
    }
  }

  void toggleDoubleOnTap() {
    onDoubleTapped = !onDoubleTapped;
  }
}
