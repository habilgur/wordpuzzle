import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/player_controller.dart';
import '../Controllers/question_controller.dart';
import '../Models/question.dart';
import '../Utils/constant_data.dart';

final playerController = Get.find<PlayerController>();
final questionController = Get.find<QuestionController>();

class PlayScreen extends StatelessWidget {
  final AssetImage randomBg;

  const PlayScreen(this.randomBg, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(builder: (_) {
      var currentQues = _.currentQuestion;
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: randomBg, fit: BoxFit.cover),
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
    });
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
              Obx(() => Text(
                    "Ödül: ${((playerController.thePlayer().gamePrize)).toStringAsFixed(2)}₺",
                    textScaleFactor: 3,
                    style: const TextStyle(color: Colors.white),
                  )),
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
                "Ques:${questionController.indexQuest + 1} / ${questionController.listQuestions.length}",
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
    var screenSize = Get.size;
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: currentQues.answerKeyMap!.map((answerKeyItem) {
                Color? color;

                if (currentQues.isClickLimitFail) {
                  color = Colors.red;
                } else if (currentQues.isDone) {
                  color = correctColor;
                } else if (answerKeyItem.isValueMatch()) {
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
                    if (!answerKeyItem.isClickable()) return;
                    questionController.toggleAnswerKeyOnSelectStatus(answerKeyItem);
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
    var screenSize = Get.size;
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
                children: List.generate(currentQues.pedKeyMap!.length, (index) {
                  var selectedKeyPad = currentQues.pedKeyMap![index];
                  Color color = Colors.white;
                  return InkWell(
                    onDoubleTap: () {},
                    onTap: () async {
                      if (currentQues.isClickLimitFail == true) return;
                      // if (!questionController.isAnswerCorrect() &&
                      //     currentQues.wrongClickCount >= currentQues.wrongClickLimit! - 1) {
                      //   //todo show correct answer
                      //   await Future.delayed(const Duration(seconds: 4));
                      //   questionController.nextQuestion();
                      // } else if (currentQues.wrongClickCount >= currentQues.wrongClickLimit! - 1) {
                      //   return;
                      // }
                      if (!selectedKeyPad.isKeyClicked()) {
                        questionController.padKeyClickAction(selectedPadKey: selectedKeyPad);
                      } else if (selectedKeyPad.isKeyClicked() && !selectedKeyPad.isKeyMatched()) {
                        questionController.togglePadKeyClickStatus(selectedKeyPad);
                        questionController.clearBoards();
                      }
                      questionController.checkCurrentStatusOfQuestion();
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

  actionButtonsPart(currentQues) {
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
                  color: playerController.thePlayer().skipRight == 0 ? Colors.white70 : Colors.cyanAccent,
                  onPressed: () {
                    questionController.skipQuestion();
                  },
                ),
                Obx(
                  () => Text(
                    "X ${playerController.thePlayer().skipRight}",
                    style: TextStyle(
                      color: playerController.thePlayer.value.skipRight == 0 ? Colors.white70 : Colors.white,
                    ),
                  ),
                )
              ],
            ),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.diamond),
                  iconSize: 35,
                  color: playerController.thePlayer.value.hintRight == 0 ? Colors.white70 : Colors.cyanAccent,
                  onPressed: () {
                    questionController.generateHint();
                  },
                ),
                Text(
                  "X ${playerController.thePlayer.value.hintRight}",
                  style:
                      TextStyle(color: playerController.thePlayer.value.hintRight == 0 ? Colors.white70 : Colors.white),
                )
              ],
            ),
            IconButton(
              icon: const Icon(Icons.all_inclusive_outlined),
              iconSize: 35,
              color: Colors.cyanAccent,
              onPressed: () {
                questionController.reShuffleQuestionKeyPad();
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

// void restartGame() {
//   controller.listQuestions = QuestionServices().creteQuestionList();
//   indexQues = 0;
//   setState(() {});
// }
//
// void nextQuestion() {
//   if ( questionServices.listQuestions.length - 1 > indexQues) {
//     setState(() {
//       indexQues++;
//     });
//   } else {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => const FinishScreen()));
//   }
// }

// generateHint() async {
//   Question currentQues =  questionServices.listQuestions[indexQues] as Question;
//
//   if (thePlayer.hintRight == 0) return;
//   thePlayer.reduceHintRightNum();
//
//   // Clear board and fill keyPad again to avoid empty search for already removed items from keyPad..
//   currentQues.clearBoards();
//
//   List<AnswerKey> mapWithNoHints = currentQues.answerMap!.where((item) => !item.hintShow && item.isEmpty()).toList();
//
//   if (mapWithNoHints.isNotEmpty) {
//     int indexHint = Random().nextInt(mapWithNoHints.length);
//
//     var userAnswer = mapWithNoHints[indexHint];
//     userAnswer.currentValue = userAnswer.correctValue;
//     userAnswer.hintShow = true;
//
//     // remove hint from keypad ( avoid multiple removing find first occurrence then clear)
//     var theValue = currentQues.keyboardMap!.where((element) => element.value == userAnswer.correctValue).first;
//     currentQues.keyboardMap!.remove(theValue);
//
//     if (currentQues.isAnswerCorrect()) {
//       setState(() {
//         currentQues.isDone = true;
//         currentQues.wrongClickCount = 0;
//         thePlayer.gamePrize = thePlayer.gamePrize + correctAnswerPrize;
//       });
//
//       await Future.delayed(const Duration(seconds: 2));
//       nextQuestion();
//     }
//
//     // my wrong..not refresh.. damn..haha
//     setState(() {});
//   }
// }
}
