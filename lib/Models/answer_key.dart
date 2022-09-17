class AnswerKey  {
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
    if (currentValue != null) {
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
    var result = isValueMatch() || currentValue != null || hintShow;
    return result;
  }

  bool isClickable() {
    var result =  currentValue == null ;
    return result;
  }


}
