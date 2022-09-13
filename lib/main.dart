import 'package:flutter/material.dart';
import 'game_initialize.dart';

//todo time limit
//todo remove random key via interstitial ads - add question class isRandomKey properties
// todo  watch rewarded admob win +2 hintRight. Limit it max 2 time per game
// todo günlük oynama sınırı 5 yap eğer oynamak isterse ödüllü izlet ancak max 3 kez izleyebilisin.

void main() {
  runApp(
    const MyApp(),
  );
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
