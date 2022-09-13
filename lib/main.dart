import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wordpuzzle/Services/question_service.dart';

import 'Models/player.dart';
import 'Models/question.dart';
import 'Utils/constant_data.dart';
import 'game_initialize.dart';

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
    return const MaterialApp(
      title: 'Welcome to Words',
      home: GameInit(),
    );
  }
}
