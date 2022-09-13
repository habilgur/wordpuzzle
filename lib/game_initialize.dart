import 'package:flutter/material.dart';

import 'Models/player.dart';
import 'Models/question.dart';
import 'Services/question_service.dart';
import 'UI/play_screen.dart';
import 'main.dart';

class GameInit extends StatefulWidget {
  const GameInit({super.key});

  @override
  State<GameInit> createState() => _GameInitState();
}

class _GameInitState extends State<GameInit> {
  // sent size to our widget
  //GlobalKey<_WordFindWidgetState> globalKey = GlobalKey();

  // make list question for puzzle
  // make class 1st
  late List<Question> listQuestions;
  late Player thePlayer;

  @override
  void initState() {
    super.initState();

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
                      child: PlayScreen(thePlayer),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void restartGame() {}
}
