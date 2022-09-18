import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/game_manage_controller.dart';
import '../Controllers/play_screen_controller.dart';
import '../Controllers/audio_controller.dart';
import '../Controllers/dialog_controller.dart';
import '../Controllers/player_controller.dart';
import '../Controllers/question_controller.dart';
import '../Controllers/timer_controller.dart';
import '../Models/question.dart';
import '../Utils/constant_data.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => await DialogController.to.showExitWarn(),
        child: GetBuilder<GameManagerController>(builder: (_) {
          return GetBuilder<QuestionController>(builder: (_) {
            var currentQues = _.currentQuestion;
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: PlayScreenController.to.randomBg, fit: BoxFit.cover),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
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
        }),
      ),
    );
  }

  Expanded infoPart(Question currentQues) {
    return Expanded(
        flex: 3,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black54,
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
                    "Ödül: ${((PlayerController.to.thePlayer().gamePrize)).toStringAsFixed(2)}₺",
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
                "Ques:${GameManagerController.to.indexQuest + 1} / ${QuestionController.to.listQuestions.length}",
                style: const TextStyle(color: Colors.white),
              ),
              timerPart(), //todo
            ],
          ),
        ));
  }

  questionPart(Question currentQues) {
    return Expanded(
      flex: 5,
      child: FlipCard(
        direction: FlipDirection.values[GameManagerController.to.indexQuest % 2],
        onFlip: () => AudioController.to.flipSound(),
        flipOnTouch: false,
        controller: PlayScreenController.to.flipCardController,
        speed: 400,
        front: Container(
          decoration: BoxDecoration(
              color: Colors.black54,
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
        back: Container(
          decoration: BoxDecoration(
              color: Colors.black54,
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

                if (currentQues.isClickLimitFail || currentQues.isTimeUp) {
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
                    QuestionController.to.toggleAnswerKeyOnSelectStatus(answerKeyItem);
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
                      enableFeedback: false, // mute default click
                      onTap: () async {
                        if (QuestionController.to.isQuestionWaitingMode()) return;
                        await AudioController.to.padKeySound();
                        if (!selectedKeyPad.isKeyClicked()) {
                          QuestionController.to.padKeyClickAction(selectedPadKey: selectedKeyPad);
                        } else if (selectedKeyPad.isKeyClicked() && !selectedKeyPad.isKeyMatched()) {
                          QuestionController.to.togglePadKeyClickStatus(selectedKeyPad);
                          QuestionController.to.clearBoards();
                        }
                      },
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
                      ));
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
            color: Colors.black54,
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
                  iconSize: 30,
                  color: PlayerController.to.thePlayer().skipRight == 0 ? Colors.white70 : Colors.lightBlue,
                  onPressed: () {
                    QuestionController.to.skipQuestion();
                  },
                ),
                Obx(
                  () => Text(
                    "X ${PlayerController.to.thePlayer().skipRight}",
                    style: TextStyle(
                      color: PlayerController.to.thePlayer.value.skipRight == 0 ? Colors.white70 : Colors.white,
                    ),
                  ),
                )
              ],
            ),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.diamond),
                  iconSize: 40,
                  color: PlayerController.to.thePlayer.value.hintRight == 0 ? Colors.white70 : Colors.lightBlue,
                  onPressed: () {
                    QuestionController.to.generateHint();
                  },
                ),
                Text(
                  "X ${PlayerController.to.thePlayer.value.hintRight}",
                  style: TextStyle(
                      color: PlayerController.to.thePlayer.value.hintRight == 0 ? Colors.white70 : Colors.white),
                )
              ],
            ),
            IconButton(
              icon: const Icon(Icons.all_inclusive_outlined),
              iconSize: 30,
              color: Colors.lightBlue,
              onPressed: () {
                QuestionController.to.reShuffleQuestionKeyPad();
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

  timerPart() {
    return GetBuilder<TimerController>(builder: (timerController) {
      debugPrint(timerController.seconds.toString());
      debugPrint("--");
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
        height: 15,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: LinearProgressIndicator(
            valueColor: QuestionController.to.currentQuestion.isTimeUp
                ? const AlwaysStoppedAnimation(Colors.red)
                : const AlwaysStoppedAnimation(Colors.green),

            backgroundColor: Colors.black12,
            value: timerController.seconds / TimerController.maxSeconds,
          ),
        ),
      );
    });
  }
}
