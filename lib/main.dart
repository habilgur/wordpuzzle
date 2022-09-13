import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wordpuzzle/Services/question_service.dart';

import 'Models/player.dart';
import 'Models/question.dart';
import 'Utils/constant_data.dart';

//todo  watch rewarded admob win +2 hintRight. Limit it max 2 time per game
//todo skip butonu yap 3 adet skip hakkı olsun bunun için her skipte bir soru ekle questionliste

// todo günlük oynama sınırı 5 yap eğer oynamak isterse ödüllü izlet ancak max 3 kez izleyebilisin.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Welcome to Words', home: WordFind());
  }
}

class WordFind extends StatefulWidget {
  const WordFind({super.key});

  @override
  State<WordFind> createState() => _WordFindState();
}

class _WordFindState extends State<WordFind> {
  // sent size to our widget
  GlobalKey<_WordFindWidgetState> globalKey = GlobalKey();

  // make list question for puzzle
  // make class 1st
  late List<Question> listQuestions;
  late Player thePlayer;

  @override
  void initState() {
    super.initState();
    listQuestions = QuestionServices().creteQuestionList();
    thePlayer = Player(name: "test");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.green,
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      color: Colors.blue,
                      // lets make our word find widget
                      // sent list to our widget
                      child: WordFindWidget(
                        constraints.biggest,
                        listQuestions,
                        thePlayer,
                        key: globalKey,
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // reload btn test
                  globalKey.currentState?.generatePuzzle(
                      // loop: listQuestions.map((ques) => ques.clone()).toList(),
                      );
                },
                child: const Text("reload"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WordFindWidget extends StatefulWidget {
  final Size size;
  final List<Question> listQuestions;
  final Player thePlayer;

  const WordFindWidget(this.size, this.listQuestions, this.thePlayer, {required Key key}) : super(key: key);

  @override
  State<WordFindWidget> createState() => _WordFindWidgetState();
}

class _WordFindWidgetState extends State<WordFindWidget> {
  late Size size;
  late List<Question> listQuestions;
  late Player thePlayer;
  int indexQues = 0; // current index question
  //int hintCount = 0;
  //double questionPrice = 1;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    listQuestions = widget.listQuestions;
    thePlayer = widget.thePlayer;
  }

  @override
  Widget build(BuildContext context) {
    Question currentQues = listQuestions[indexQues];
    var screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text("KeyP:$keyPrize"),
              Text("CCP:$correctClickPrice"),
              Text("WCP:$wrongClickPrice"),
            ],
          ),
          Expanded(
              flex: 3,
              child: Container(
                width: double.maxFinite,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "${thePlayer.point.toStringAsFixed(3)} ₺",
                        textScaleFactor: 3,
                      ),
                    ),
                    Center(
                      child: Text(
                        "${currentQues.questionPrice!.toStringAsFixed(3)} ₺",
                        textScaleFactor: 3,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: currentQues.answerMap!.map((answerKeyItem) {
                            // later change color based condition
                            Color? color;

                            if (answerKeyItem.isEmpty()) {
                              color = Colors.white;
                            } else if (answerKeyItem.isValueMatch()) {
                              color = Colors.green;
                            } else {
                              color = Colors.red;
                            }

                            return InkWell(
                              onTap: () {
                                if (answerKeyItem.isNotClickable()) return;

                                currentQues.reInsertPadKey(answerKeyItem);
                                answerKeyItem.clearValue();

                                setState(() {});
                              },
                              child: Container(
                                width: screenSize.width * 1 / screenDivideNum,
                                height: screenSize.width * 0.11,
                                decoration:
                                    BoxDecoration(color: color, border: Border.all(color: Colors.blueAccent, width: 2)),
                                alignment: Alignment.center,
                                child: Text(
                                  (answerKeyItem.currentValue ?? ''),
                                  style: const TextStyle(
                                    // fontSize: Size.aspectRatio*0.1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textScaleFactor: 2,
                                ),
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
                              Color color = const Color(0xff7EE7FD);
                              return InkWell(
                                onTap: () async {
                                  currentQues.updateQuestionPrize(selectedKeyPad);
                                  currentQues.removePadKey(lastPadKeyIndex: index);

                                  if (currentQues.isAnswerCorrect()) {
                                    currentQues.isDone = true;
                                    thePlayer.addQuestionPrize(currentQues.questionPrice!);

                                    setState(() {});

                                    await Future.delayed(const Duration(seconds: 1));
                                    nextQuestion();
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.width * 0.14,
                                  width: MediaQuery.of(context).size.width * 0.13,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    currentQues.keyboardMap![index].value!,
                                    style: const TextStyle(
                                      // fontSize: Size.aspectRatio*0.1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textScaleFactor: 1.8,
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
                    IconButton(
                      icon: const Icon(Icons.cleaning_services),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () {
                        currentQues.clearQuestionBoard();
                        setState(() {});
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite),
                          iconSize: 30,
                          color: thePlayer.hintRight == 0 ? Colors.grey : Colors.white,
                          onPressed: () {
                            generateHint();
                            setState(() {});
                          },
                        ),
                        Text(
                          "X ${thePlayer.hintRight}",
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () {
                        currentQues = QuestionServices().reShuffleQuestionKeyPad(currentQuestion: currentQues);
                        setState(() {});
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.green,
              )),
        ],
      ),
    );
  }

  void generatePuzzle() {
    listQuestions = QuestionServices().creteQuestionList();
    indexQues = 0;
    setState(() {});
  }

  void nextQuestion() {
    if (listQuestions.length - 1 > indexQues) {
      indexQues++;
    }
  }

  //todo hintCount dynamic
  generateHint() async {
    Question currentQues = listQuestions[indexQues];

    // if (hintClickPrice > currentQues.questionPrice!) return; // Avoid Question Price below zero.
    if (thePlayer.hintRight == 0) return;
    thePlayer.reduceHintRightNum();

    // Clear board and fill keyPad again to avoid empty search for already removed items from keyPad..
    currentQues.clearQuestionBoard();

    List<AnswerKey> mapWithNoHints = currentQues.answerMap!.where((item) => !item.hintShow && item.isEmpty()).toList();

    if (mapWithNoHints.isNotEmpty) {
      //currentQues.reduceQuestionPrice(deduct: hintClickPrice);
      // hintCount++;
      int indexHint = Random().nextInt(mapWithNoHints.length);

      var userAnswer = mapWithNoHints[indexHint];
      userAnswer.currentValue = userAnswer.correctValue;
      userAnswer.hintShow = true;

      // remove hint from keypad ( avoid multiple removing find first occurrence then clear)
      var theValue = currentQues.keyboardMap!.where((element) => element.value == userAnswer.correctValue).first;
      currentQues.keyboardMap!.remove(theValue);

      if (currentQues.isAnswerCorrect()) {
        currentQues.isDone = true;
        thePlayer.addQuestionPrize(currentQues.questionPrice!);

        setState(() {});

        await Future.delayed(const Duration(seconds: 1));
        nextQuestion();
      }

      // my wrong..not refresh.. damn..haha
      setState(() {});
    }
  }
}
