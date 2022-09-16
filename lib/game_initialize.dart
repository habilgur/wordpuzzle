import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Models/player.dart';
import 'Models/question.dart';
import 'UI/play_screen.dart';


class GameInit extends StatefulWidget {
  const GameInit({super.key});

  @override
  State<GameInit> createState() => _GameInitState();
}

class _GameInitState extends State<GameInit> {
  late List<Question> listQuestions;
  late Player thePlayer;
  late AssetImage randomBg;


  @override
  void initState() {
    super.initState();

    thePlayer = Player(name: "test");
     randomBg=AssetImage("assets/images/pic_${Random().nextInt(21)+1}-min.jpg");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return PlayScreen(thePlayer,randomBg);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
