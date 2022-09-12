class Question {
  String? question;
  bool isDone = false;
  bool isFull = false;
  List<AnswerMap>? userAnswerMap = <AnswerMap>[];
  List<ShuffledCharacters>? keyPad = <ShuffledCharacters>[];

  Question({
    this.question,
    this.userAnswerMap,
    this.keyPad,
  });

  void setWordFindChar(List<AnswerMap> puzzles) => puzzles = puzzles;

  void setIsDone() => isDone = true;

  bool fieldCompleteCorrect() {
    //todo check is this correct to use?
    if (userAnswerMap == null) return false;
    // lets declare class WordFindChar 1st
    // check all field already got value
    // fix color red when value not full but show red color
    bool complete = userAnswerMap!.where((puzzle) => puzzle.currentValue == null).isEmpty;

    if (!complete) {
      // no complete yet
      isFull = false;
      return complete;
    }

    isFull = true;
    // if already complete, check correct or not

    String answeredString = userAnswerMap!.map((m) => m.currentValue).join("");

    // if same string, answer is correct..yeay
    return answeredString == question;
  }

  bool isSelectionCorrect(ShuffledCharacters selectedKey) {
    //todo check is this correct to use?
    if (userAnswerMap == null) return false;
    // lets declare class WordFindChar 1st
    // check all field already got value
    // fix color red when value not full but show red color
    bool complete = userAnswerMap!.where((puzzle) => puzzle.currentValue == null).isEmpty;

    if (!complete) {
      // no complete yet
      isFull = false;
      return complete;
    }

    isFull = true;
    // if already complete, check correct or not

    String answeredString = userAnswerMap!.map((m) => m.currentValue).join("");

    // if same string, answer is correct..yeay
    return answeredString == question;
  }

// more prefer name.. haha
// Question clone() {
//   return Question(
//     answer: answer,
//     question: question,
//   );
// }

// lets generate sample question
}

class ShuffledCharacters {
  String? value;
  bool? isClicked;
 // int? answerIndex;
  int? currentKeyPadIndex;

  ShuffledCharacters({this.value,this.currentKeyPadIndex, this.isClicked});

ShuffledCharacters clone() {
  return ShuffledCharacters(
    value: value,
    isClicked: false,
  //  answerIndex: answerIndex,
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
}
