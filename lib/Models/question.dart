class Question {
  String? question;
  double? questionPrice = 0;
  bool isDone = false;
  bool isFull = false;
  List<AnswerMap>? userAnswerMap = <AnswerMap>[];
  List<KeyValue>? keyPad = <KeyValue>[];

  Question({
    this.question,
    this.questionPrice,
    this.userAnswerMap,
    this.keyPad,
  });

  void setWordFindChar(List<AnswerMap> puzzles) => puzzles = puzzles;

  void setIsDone() => isDone = true;

  bool isAnswerCorrect() {

    if (!isAnswerFull()) return false;

    String answeredString = userAnswerMap!.map((m) => m.currentValue).join("");

    // if same string, answer is correct..yeay
    return answeredString == question;
  }

  void setSelectedKeyPrize(KeyValue selectedKey) {

    // Avoid range Error Index
    if(isAnswerFull()) return;

    var firstEmptyMap = userAnswerMap!.where((puzzle) => puzzle.currentValue == null).first;


    bool isCorrect = firstEmptyMap.correctValue == selectedKey.value;

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

   void removeKeyPad(lastKeyPadIndex) {
    // Avoid null element
    if(isAnswerFull()) return;

    int findFirstIndexOfMapWithEmptyValue = userAnswerMap!.indexWhere((map) => map.currentValue == null);

    if (findFirstIndexOfMapWithEmptyValue >= 0) {
      userAnswerMap![findFirstIndexOfMapWithEmptyValue].currentIndex = lastKeyPadIndex;
      userAnswerMap![findFirstIndexOfMapWithEmptyValue].currentValue =
          keyPad![lastKeyPadIndex].value;
      userAnswerMap![findFirstIndexOfMapWithEmptyValue].comingKeyPadIndex =
          lastKeyPadIndex; // pass lastClickedKeyPad currentIndex to track coming index
    }

    keyPad!.removeAt(lastKeyPadIndex);

  }

  void  insertKeyPad( AnswerMap map) {
    keyPad!.insert(
      // if current keypad shorter then original length then add last index
        map.comingKeyPadIndex! > keyPad!.length
            ? keyPad!.length
            : map.comingKeyPadIndex!,
        KeyValue(
          value: map.currentValue,
          currentKeyPadIndex: map.comingKeyPadIndex,
          isClicked: false,
        ));

  }

  void  clearQuestionBoard() {
    var emptyMaps=userAnswerMap!.where((item) => item.currentValue!=null).toList();
    for (var map in emptyMaps) {
      if (map.currentValue != map.correctValue) {
        insertKeyPad( map);
        map.clearValue();
      }
    }


  }

  bool isAnswerFull(){
      bool complete = userAnswerMap!.where((puzzle) => puzzle.currentValue == null).isEmpty;
      return isFull = complete;

  }

}

class KeyValue {
  String? value;
  bool? isClicked;

  // int? answerIndex;
  int? currentKeyPadIndex;

  KeyValue({this.value, this.currentKeyPadIndex, this.isClicked});

  KeyValue clone() {
    return KeyValue(
      value: value,
      isClicked: false,
      currentKeyPadIndex: currentKeyPadIndex,

    );
  }
}

class AnswerMap {
  String? currentValue;
  int? currentIndex;
  int? comingKeyPadIndex;
  int? correctIndex;
  String? correctValue;
  bool hintShow;

  AnswerMap({
    this.hintShow = false,
    this.correctValue,
    this.currentIndex,
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
    currentIndex = null;
    currentValue = null;
  }

  bool isTrue() {
    return currentValue == correctValue;
  }

  bool isEmpty() {
    return currentIndex == null;
  }
}
