import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wordpuzzle/Services/question_service.dart';

import 'Models/question.dart';

//todo limit hint
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

  @override
  void initState() {
    super.initState();
    listQuestions = QuestionServices().creteQuestionList();
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

  const WordFindWidget(this.size, this.listQuestions, {required Key key}) : super(key: key);

  @override
  State<WordFindWidget> createState() => _WordFindWidgetState();
}

class _WordFindWidgetState extends State<WordFindWidget> {
  late Size size;
  late List<Question> listQuestions;
  int indexQues = 0; // current index question
  int hintCount = 0;
  double questionPrice = 1;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    listQuestions = widget.listQuestions;
    //generatePuzzle();
  }

  @override
  Widget build(BuildContext context) {
    Question currentQues = listQuestions[indexQues];

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Container(
                width: double.maxFinite,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${questionPrice}",
                      textScaleFactor: 3,
                    ),
                  ],
                ),
              )),
          // Container(
          //   padding: const EdgeInsets.all(10),
          //   alignment: Alignment.center,
          //   child: Text(
          //     currentQues.question ?? '',
          //     style: const TextStyle(
          //       fontSize: 25,
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  alignment: Alignment.center,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: currentQues.userAnswerMap!.map((userAnswer) {
                          // later change color based condition
                          Color? color;

                          if (userAnswer.currentValue == userAnswer.correctValue) {
                            color = Colors.green;
                          } else if (userAnswer.currentValue == null) {
                            color = Colors.white;
                          } else {
                            color = Colors.red;
                          }

                          // else if (currentQues.isDone) {
                          //   color = Colors.green[300];
                          // } else if (userAnswer.hintShow) {
                          //   color = Colors.yellow[100];
                          // } else if (currentQues.isFull) {
                          //   color = Colors.red;
                          // }
                          // else {
                          //   color = Colors.white;
                          // }

                          return InkWell(
                            onTap: () {
                              if (userAnswer.currentValue == null || userAnswer.hintShow || currentQues.isDone) return;

                              currentQues.isFull = false;
                              currentQues = QuestionServices().insertKeyPad(currentQues, userAnswer);
                              userAnswer.clearValue();

                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: MediaQuery.of(context).size.width * 0.06,
                              height: constraints.biggest.width / 7 - 6,
                              margin: const EdgeInsets.all(3),
                              child: Text(
                                (userAnswer.currentValue ?? ''),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Wrap(
                            runSpacing: 5,
                            spacing: 5,
                            alignment: WrapAlignment.center,
                            children: List.generate(currentQues.keyPad!.length, (index) {
                              Color color = const Color(0xff7EE7FD);
                              return InkWell(
                                onTap: () async {
                                  currentQues = QuestionServices().removeKeyPad(currentQues, index);


                                  if (currentQues.fieldCompleteCorrect()) {
                                    currentQues.isDone = true;

                                    setState(() {});

                                    await Future.delayed(const Duration(seconds: 1));
                                    nextQuestion();
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.width * 0.12,
                                  width: (MediaQuery.of(context).size.width - 4 * (10 - 1)) / 10,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    currentQues.keyPad![index].value!,
                                    style: const TextStyle(
                                      // fontSize: Size.aspectRatio*0.1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textScaleFactor: 1.3,
                                  ),
                                ),
                              );
                            }),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cleaning_services),
                        iconSize: 30,
                        color: Colors.white,
                        onPressed: () {
                          currentQues = QuestionServices().clearQuestionBoard(currentQues);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        iconSize: 30,
                        color: hintCount > 1 ? Colors.grey : Colors.white,
                        onPressed: () {
                          generateHint();
                          setState(() {});
                        },
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
    hintCount = 0; //number hint per ques we hit
    setState(() {});
  }

  void nextQuestion() {
    if (listQuestions.length - 1 > indexQues) {
      indexQues++;
    }
  }

  generateHint() async {
    if (hintCount > 1) return;

    // let declare hint
    Question currentQues = listQuestions[indexQues];

    List<AnswerMap> mapWithNoHints =
        currentQues.userAnswerMap!.where((item) => !item.hintShow && item.currentIndex == null).toList();

    if (mapWithNoHints.isNotEmpty) {
      hintCount++;
      int indexHint = Random().nextInt(mapWithNoHints.length);

      var userAnswer = mapWithNoHints[indexHint];
      userAnswer.currentValue = userAnswer.correctValue;
      userAnswer.hintShow = true;
      userAnswer.currentIndex = userAnswer.correctIndex;

      // remove hint from keypad ( avoid multiple removing find first occurrence then clear)
      var theValue = currentQues.keyPad!.where((element) => element.value == userAnswer.correctValue).first;
      currentQues.keyPad!.remove(theValue);

      if (currentQues.fieldCompleteCorrect()) {
        currentQues.isDone = true;

        setState(() {});

        await Future.delayed(const Duration(seconds: 1));
        nextQuestion();
      }

      // my wrong..not refresh.. damn..haha
      setState(() {});
    }
  }
}
