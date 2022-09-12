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

  // void setWordFindChar(List<AnswerKey> puzzles) => puzzles = puzzles;

  // void setIsDone() => isDone = true;

  bool isAnswerCorrect() {
    if (!isAnswerMapFull()) return false;

    String answeredString = answerMap!.map((m) => m.currentValue).join("");

    // if same string, answer is correct..yeay
    return answeredString == question;
  }

  void setSelectedPadKeyPrize(PadKey selectedPadKey) {
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

  void reduceQuestionPrice() {
    questionPrice = questionPrice! - 0.01;
  }

  void increaseQuestionPrice() {
    questionPrice = questionPrice! + 0.01;
  }

  void removePadKey({required lastPadKeyIndex}) {
    // Avoid null element
    if (isAnswerMapFull()) return;

    _insertAnswerKey(lastPadKeyIndex);
    keyboardMap!.removeAt(lastPadKeyIndex);
  }

  _insertAnswerKey(lastPadKeyIndex) {
    // Avoid null element
    if (isAnswerMapFull()) return;

    int firstEmptyAnswerKeyIndex = answerMap!.indexWhere((map) => map.currentValue == null);

    var theEmptyAnswerKey = answerMap![firstEmptyAnswerKeyIndex];
    if (firstEmptyAnswerKeyIndex >= 0) {
      theEmptyAnswerKey.currentValue = keyboardMap![lastPadKeyIndex].value;
      theEmptyAnswerKey.comingKeyPadIndex =
          lastPadKeyIndex; // pass lastClickedKeyPad currentIndex to track coming index
    }
  }

  void reInsertPadKey(AnswerKey answerKey) {
    keyboardMap!.insert(
        // if current keypad shorter then original length then add last index
        answerKey.comingKeyPadIndex! > keyboardMap!.length ? keyboardMap!.length : answerKey.comingKeyPadIndex!,
        PadKey(
          value: answerKey.currentValue,
          currentIndex: answerKey.comingKeyPadIndex,
          isClicked: false,
        ));
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
  int? currentIndex;

  PadKey({this.value, this.currentIndex, this.isClicked});

  PadKey clone() {
    return PadKey(
      value: value,
      isClicked: false,
      currentIndex: currentIndex,
    );
  }
}

class AnswerKey {
  String? currentValue;
  int? comingKeyPadIndex;
  int? correctIndex;
  String? correctValue;
  bool hintShow;

  AnswerKey({
    this.hintShow = false,
    this.correctValue,
    //  this.currentIndex,
    this.currentValue,
    this.correctIndex,
    this.comingKeyPadIndex,
  });

  getCurrentValue() {
    if (correctValue != null) {
      return currentValue;
    } else if (hintShow) {
      return correctValue;
    }
  }

  void clearValue() {
    // currentIndex = null;
    currentValue = null;
  }

  bool isValueMatch() {
    return currentValue == correctValue;
  }

  bool isEmpty() {
    return currentValue == null;
  }

  bool isNotClickable() {
    return isValueMatch() || currentValue == null || hintShow;
  }
}
