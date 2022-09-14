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
    if (!isAnswerMapFull()) return false;

    String answeredString = answerMap!.map((m) => m.currentValue).join("");

    return answeredString == question;
  }

  void updateQuestionPrize(PadKey selectedPadKey) {
    // Avoid range Error Index
    if (isAnswerMapFull()) return;

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

  void makePadKeySelected({required lastPadKeyIndex}) {
    // Avoid null element
    if (isAnswerMapFull()) return;
    var indexOfInsertedAnsKey= _insertAnswerKeyAndReturnItsIndex(lastPadKeyIndex);

    // Colorize & control is  Key Pad matched
    keyboardMap![lastPadKeyIndex].isClicked = true;
    keyboardMap![lastPadKeyIndex].isMatched = answerMap![indexOfInsertedAnsKey].isValueMatch();


    //Remove Key Pad
    //keyboardMap!.removeAt(lastPadKeyIndex);
  }

  _insertAnswerKeyAndReturnItsIndex(lastPadKeyIndex) {
    // Avoid null element
    if (isAnswerMapFull()) return;

    var isAnyOnDoubleTapAnsKeyExist = answerMap!.any((map) => map.onDoubleTapped == true);
    var isEmptyAnswerKeyExist = answerMap!.any((map) => map.currentValue == null);

    int lookingIndexOfAnsKey = 0;
    if (isAnyOnDoubleTapAnsKeyExist) {
      lookingIndexOfAnsKey = answerMap!.indexWhere((map) => map.onDoubleTapped);
    } else if (isEmptyAnswerKeyExist) {
      lookingIndexOfAnsKey = answerMap!.indexWhere((map) => map.currentValue == null);
    }

    var theLookingAnswerKey = answerMap![lookingIndexOfAnsKey];
    if (isAnyOnDoubleTapAnsKeyExist || isEmptyAnswerKeyExist) {
      theLookingAnswerKey.currentValue = keyboardMap![lastPadKeyIndex].value;
      theLookingAnswerKey.comingKeyPadIndex = lastPadKeyIndex;
      // pass lastClickedKeyPad comingKeyPadIndex to track coming index

      if (isAnyOnDoubleTapAnsKeyExist) theLookingAnswerKey.toggleDoubleOnTap(); // always lock this properties again
      return lookingIndexOfAnsKey;

    }
  }

  void reInsertPadKey(AnswerKey answerKey) {
    // Colorize Key Pad
    keyboardMap![answerKey.comingKeyPadIndex!].isClicked = false;

    // Remove Pad Keys
    // keyboardMap!.insert(
    //     // if current keypad shorter then original length then add last index
    //     answerKey.comingKeyPadIndex! > keyboardMap!.length ? keyboardMap!.length : answerKey.comingKeyPadIndex!,
    //     PadKey(
    //       value: answerKey.currentValue,
    //       currentIndex: answerKey.comingKeyPadIndex,
    //       isClicked: false,
    //     ));
  }

  void clearQuestionBoard() {
    var emptyMaps = answerMap!.where((item) => item.currentValue != null).toList();
    for (var map in emptyMaps) {
      if (map.currentValue != map.correctValue) {
        reInsertPadKey(map);
        map.clearValue();
      }
    }
  }

  bool isAnswerMapFull() {
    bool complete = answerMap!.where((puzzle) => puzzle.currentValue == null).isEmpty;
    return isFull = complete;
  }
}

class PadKey {
  String? value;
  bool? isClicked;
  bool? isMatched;
  int? currentIndex;

  PadKey({this.value, this.currentIndex, this.isClicked, this.isMatched});

  PadKey clone() {
    return PadKey(
      value: value,
      isClicked: false,
      currentIndex: currentIndex,
      isMatched: false,
    );
  }

  getValue(){
    return value;
  }

  isKeyClicked(){
    return isClicked;
  }
  isKeyMatched(){
    return isMatched;
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
      return currentValue != null;
      //isValueMatch()  || hintShow; // to able to select empty key with double click skip currentValue == null
    } else {
      return isValueMatch() || currentValue == null || hintShow;
    }
  }

  void toggleDoubleOnTap() {
    onDoubleTapped = !onDoubleTapped;
  }
}
