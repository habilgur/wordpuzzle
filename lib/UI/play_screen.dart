import 'dart:math';
import 'package:flutter/material.dart';
import '../Models/player.dart';
import '../Models/question.dart';
import '../Services/question_service.dart';
import '../Utils/constant_data.dart';
import 'finish_screen.dart';

class PlayScreen extends StatefulWidget {
  final Player thePlayer;

  const PlayScreen(this.thePlayer, {super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late Size size;
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
    var screenSize = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white60, Colors.blueGrey, Colors.grey]),
        color: Colors.white,
        // backgroundBlendMode:BlendMode.colorBurn ,
        //image: DecorationImage(image: AssetImage("assets/images/pic_1.png"), fit: BoxFit.cover),
      ),
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Ques:${indexQues + 1} / ${listQuestions.length}"),
                const Text("CCP:$correctClickPrice"),
                const Text("WCP:$wrongClickPrice"),
              ],
            ),
            Expanded(
                flex: 3,
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "${thePlayer.point.toStringAsFixed(2)} ₺",
                          textScaleFactor: 3,
                        ),
                      ),
                      Center(
                        child: Text(
                          "${currentQues.questionPrice!.toStringAsFixed(2)} ₺",
                          textScaleFactor: 2,
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
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
                              } else if (answerKeyItem.onDoubleTapped) {
                                color = Colors.yellow;
                              } else if (answerKeyItem.isEmpty()) {
                                color = Colors.white70;
                              } else {
                                color = Colors.grey;
                              }

                              return InkWell(
                                onDoubleTap: () {
                                  // Make Key selectable
                                  if (answerKeyItem.isNotClickable(isDoubleClicked: true)) return;

                                  setState(() {
                                    answerKeyItem.toggleDoubleOnTap();
                                  });
                                },
                                onTap: () {
                                  if (answerKeyItem.isNotClickable()) return;

                                  setState(() {
                                    currentQues.answerKeyClickAction(answerKeyItem);
                                  });
                                },
                                child: Row(
                                  children: [
                                    const SizedBox(width: 2),
                                    Container(
                                      width: screenSize.width * 1 / screenDivideNum,
                                      height: screenSize.width * 0.11,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: color,
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1.5,
                                          )),
                                      child: Text(
                                        (answerKeyItem.getCurrentValue() ?? ''),
                                        textScaleFactor: 2,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
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
                  ),
                  Expanded(
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
                                    if (!selectedKeyPad.isKeyClicked()) {
                                      setState(() {
                                        currentQues.padKeyClickAction(selectedPadKey: selectedKeyPad);
                                      });

                                      if (currentQues.isAnswerCorrect()) {
                                        setState(() {
                                          currentQues.isDone = true;
                                          thePlayer.addQuestionPrize(currentQues.questionPrice!);
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
                                  },
                                  child: AnimatedPhysicalModel(
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.fastOutSlowIn,
                                    elevation: selectedKeyPad.isKeyClicked() ? 9 : 1,
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    shadowColor: Colors.black,
                                    child: Container(
                                      height: MediaQuery.of(context).size.width * 0.14,
                                      width: MediaQuery.of(context).size.width * 0.13,
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
                                      child: Text(
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
                  ),
                  Row(
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
                            icon: const Icon(Icons.skip_next),
                            iconSize: 35,
                            color: thePlayer.skipRight == 0 ? Colors.grey : Colors.white,
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
                              color: thePlayer.skipRight == 0 ? Colors.grey : Colors.white,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            iconSize: 35,
                            color: thePlayer.hintRight == 0 ? Colors.grey :Colors.white,
                            onPressed: () {
                              generateHint();
                              setState(() {});
                            },
                          ),
                          Text(
                            "X ${thePlayer.hintRight}",
                            style: TextStyle(color: thePlayer.hintRight == 0 ? Colors.grey : Colors.white),
                          )
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        iconSize: 35,
                        color: Colors.white,
                        onPressed: () {
                          currentQues = QuestionServices().reShuffleQuestionKeyPad(currentQuestion: currentQues);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: const Text("Banner Area"),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          thePlayer.addQuestionPrize(currentQues.questionPrice!);
        });

        await Future.delayed(const Duration(seconds: 2));
        nextQuestion();
      }

      // my wrong..not refresh.. damn..haha
      setState(() {});
    }
  }
}
