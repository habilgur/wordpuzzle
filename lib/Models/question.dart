import '../Utils/constant_data.dart';

class Question {
  String? question;

  bool isDone = false;
  bool isFull = false;
  List<AnswerKey>? answerMap = <AnswerKey>[];
  List<PadKey>? keyboardMap = <PadKey>[];

  Question({
    this.question,
    this.answerMap,
    this.keyboardMap,
  });

  bool isAnswerCorrect() {
    if (!_isAnswerMapFull()) return false;

    String answeredString = answerMap!.map((m) => m.currentValue).join("");

    return answeredString == question;
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
    var isAnyOnSelectedAnsKeyExist = answerMap!.any((map) => map.onSelected == true);
    var isEmptyAnswerKeyExist = answerMap!.any((map) => map.currentValue == null);

    int lookingIndexOfAnsKey = 0;
    if (isAnyOnSelectedAnsKeyExist) {
      lookingIndexOfAnsKey = answerMap!.indexWhere((map) => map.onSelected);
      answerMap![lookingIndexOfAnsKey].toggleDoubleOnTap(); // always lock this properties again
    } else if (isEmptyAnswerKeyExist) {
      lookingIndexOfAnsKey = answerMap!.indexWhere((map) => map.currentValue == null);
    }

    return answerMap![lookingIndexOfAnsKey];
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
  bool onSelected;

  AnswerKey({
    this.hintShow = false,
    this.correctValue,
    this.currentValue,
    this.correctIndex,
    this.comingKeyPadIndex,
    this.onSelected = false,
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

  bool isNotClickable() {
    return isValueMatch() || currentValue != null || hintShow;
  }

  void toggleDoubleOnTap() {
    onSelected = !onSelected;
  }
}
