import 'dart:math';
import 'package:flutter/material.dart';
import '../Models/player.dart';
import '../Models/question.dart';
import '../Services/question_service.dart';
import '../Utils/constant_data.dart';
import 'finish_screen.dart';

class PlayScreen extends StatefulWidget {
  final Player thePlayer;
  final AssetImage randomBg;

  const PlayScreen(this.thePlayer, this.randomBg, {super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late List<Question> listQuestions;
  late Player thePlayer;
  int indexQues = 0; // current index question

  @override
  void initState() {
    super.initState();
    listQuestions = QuestionServices().creteQuestionList();
    thePlayer = widget.thePlayer;
  }

  @override
  Widget build(BuildContext context) {
    Question currentQues = listQuestions[indexQues];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: widget.randomBg, fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            infoPart(currentQues),
            const SizedBox(height: 2),
            questionPart(currentQues),
            const SizedBox(height: 2),
            actionButtonsPart(currentQues),
            const SizedBox(height: 2),
            bannerPart(),
          ],
        ),
      ),
    );
  }

  Expanded infoPart(Question currentQues) {
    return Expanded(
        flex: 3,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: Colors.white70,
                width: 1,
              )),
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ödül: ${((thePlayer.gamePrize)).toStringAsFixed(2)}₺",
                textScaleFactor: 3,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "Kalan Harf Hakkı: ${currentQues.wrongClickLimit! - currentQues.wrongClickCount} ",
                textScaleFactor: 1.5,
                style: const TextStyle(color: Colors.white),
              ),
              const Text(
                "Her doğru cevap + $correctAnswerPrize ₺ değerindedir. ",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Ques:${indexQues + 1} / ${listQuestions.length}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ));
  }

  questionPart(Question currentQues) {
    return Expanded(
      flex: 5,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: Colors.white70,
              width: 1,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            answerKeys(currentQues),
            padKeys(currentQues),
          ],
        ),
      ),
    );
  }

  answerKeys(Question currentQues) {
    var screenSize = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: currentQues.answerMap!.map((answerKeyItem) {
                Color? color;

                if (answerKeyItem.isValueMatch()) {
                  color = correctColor;
                } else if (answerKeyItem.onSelected) {
                  color = Colors.green.shade200;
                } else if (answerKeyItem.isEmpty()) {
                  color = Colors.white30;
                } else {
                  color = Colors.grey;
                }

                return InkWell(
                  onTap: () {
                    if (answerKeyItem.isNotClickable()) return;
                    setState(() {
                      answerKeyItem.toggleDoubleOnTap();
                    });
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 2),
                      Container(
                        width: screenSize.width * 1 / screenDivideNum,
                        height: screenSize.width * 0.15,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            )),
                        child: Text(
                          (answerKeyItem.getCurrentValue() ?? ''),
                          textScaleFactor: 2,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  padKeys(Question currentQues) {
    var screenSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.center,
                children: List.generate(currentQues.keyboardMap!.length, (index) {
                  var selectedKeyPad = currentQues.keyboardMap![index];
                  Color color = Colors.white;
                  return InkWell(
                    onDoubleTap: () {},
                    onTap: () async {
                      if (!currentQues.isAnswerCorrect() &&
                          currentQues.wrongClickCount >= currentQues.wrongClickLimit! - 1) {
                        //todo show correct answer
                        await Future.delayed(const Duration(seconds: 4));
                        nextQuestion();
                      } else if (currentQues.wrongClickCount >= currentQues.wrongClickLimit! - 1) {
                        return;
                      }
                      if (!selectedKeyPad.isKeyClicked()) {
                        setState(() {
                          currentQues.padKeyClickAction(selectedPadKey: selectedKeyPad);
                        });

                        if (currentQues.isAnswerCorrect()) {
                          setState(() {
                            currentQues.isDone = true;
                            currentQues.wrongClickCount = 0;
                            thePlayer.gamePrize = thePlayer.gamePrize + correctAnswerPrize;
                          });

                          await Future.delayed(const Duration(seconds: 2));
                          nextQuestion();
                        }
                      } else if (selectedKeyPad.isKeyClicked() && !selectedKeyPad.isKeyMatched()) {
                        setState(() {
                          selectedKeyPad.toggleClickStatus();
                          currentQues.clearBoards();
                        });
                      }
                      if (selectedKeyPad.isKeyClicked() && !selectedKeyPad.isKeyMatched()) {
                        currentQues.wrongClickCount++;
                      }
                    },
                    child: AnimatedPhysicalModel(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.fastOutSlowIn,
                      elevation: selectedKeyPad.isKeyClicked() ? 9 : 1,
                      shape: BoxShape.circle,
                      color: Colors.white,
                      shadowColor: Colors.black,
                      child: Container(
                        height: screenSize.width * 0.14,
                        width: screenSize.width * 0.13,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedKeyPad.isKeyClicked() ? Colors.white70 : Colors.grey.shade200,
                            width: 1.5,
                          ),
                          color: selectedKeyPad.isKeyMatched()
                              ? correctColor
                              : selectedKeyPad.isKeyClicked()
                                  ? wrongColor
                                  : color,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: selectedKeyPad.isKeyMatched()
                            ? const Icon(Icons.check, color: Colors.white)
                            : (!selectedKeyPad.isKeyMatched() && selectedKeyPad.isKeyClicked())
                                ? const Icon(Icons.close, color: Colors.white)
                                : Text(
                                    selectedKeyPad.getValue()!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textScaleFactor: 1.8,
                                  ),
                      ),
                    ),
                  );
                }),
              )),
        ],
      ),
    );
  }

  actionButtonsPart(Question currentQues) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: Colors.white70,
              width: 1,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // IconButton(
            //   icon: const Icon(Icons.cleaning_services),
            //   iconSize: 30,
            //   color: Colors.white,
            //   onPressed: () {
            //     currentQues.clearBoards();
            //     setState(() {});
            //   },
            // ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.double_arrow_sharp),
                  iconSize: 35,
                  color: thePlayer.skipRight == 0 ? Colors.white70 : Colors.cyanAccent,
                  onPressed: () {
                    if (thePlayer.skipRight == 0) return;
                    listQuestions.add(QuestionServices().createAQuestion());
                    thePlayer.reduceSkipRightNum();
                    nextQuestion();
                    //setState(() {});
                  },
                ),
                Text(
                  "X ${thePlayer.skipRight}",
                  style: TextStyle(
                    color: thePlayer.skipRight == 0 ? Colors.white70 : Colors.white,
                  ),
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.diamond),
                  iconSize: 35,
                  color: thePlayer.hintRight == 0 ? Colors.white70 : Colors.cyanAccent,
                  onPressed: () {
                    generateHint();
                    setState(() {});
                  },
                ),
                Text(
                  "X ${thePlayer.hintRight}",
                  style: TextStyle(color: thePlayer.hintRight == 0 ? Colors.white70 : Colors.white),
                )
              ],
            ),
            IconButton(
              icon: const Icon(Icons.all_inclusive_outlined),
              iconSize: 35,
              color: Colors.cyanAccent,
              onPressed: () {
                currentQues = QuestionServices().reShuffleQuestionKeyPad(currentQuestion: currentQues);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Expanded bannerPart() {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // ElevatedButton(
          //   onPressed: () {},
          //   child: const Text("Banner Area"),
          // ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------------
  ///                                FUNCTIONS
  /// -------------------------------------------------------------------------------

  void restartGame() {
    listQuestions = QuestionServices().creteQuestionList();
    indexQues = 0;
    setState(() {});
  }

  void nextQuestion() {
    if (listQuestions.length - 1 > indexQues) {
      setState(() {
        indexQues++;
      });
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const FinishScreen()));
    }
  }

  generateHint() async {
    Question currentQues = listQuestions[indexQues];

    if (thePlayer.hintRight == 0) return;
    thePlayer.reduceHintRightNum();

    // Clear board and fill keyPad again to avoid empty search for already removed items from keyPad..
    currentQues.clearBoards();

    List<AnswerKey> mapWithNoHints = currentQues.answerMap!.where((item) => !item.hintShow && item.isEmpty()).toList();

    if (mapWithNoHints.isNotEmpty) {
      int indexHint = Random().nextInt(mapWithNoHints.length);

      var userAnswer = mapWithNoHints[indexHint];
      userAnswer.currentValue = userAnswer.correctValue;
      userAnswer.hintShow = true;

      // remove hint from keypad ( avoid multiple removing find first occurrence then clear)
      var theValue = currentQues.keyboardMap!.where((element) => element.value == userAnswer.correctValue).first;
      currentQues.keyboardMap!.remove(theValue);

      if (currentQues.isAnswerCorrect()) {
        setState(() {
          currentQues.isDone = true;
          currentQues.wrongClickCount = 0;
          thePlayer.gamePrize = thePlayer.gamePrize + correctAnswerPrize;
        });

        await Future.delayed(const Duration(seconds: 2));
        nextQuestion();
      }

      // my wrong..not refresh.. damn..haha
      setState(() {});
    }
  }
}
