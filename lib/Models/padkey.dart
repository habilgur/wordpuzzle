
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


  void clearValue() {
    isClicked = false;
    isMatched = false;
  }
}