import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'game_initialize.dart';

//todo getx implementation

//todo alt: oyun sonunda bitime puanı ver. Ve bitmeden önce rewarded izlettir.? yada başta?
//todo time limit
//todo remove random key via interstitial ads - add question class isRandomKey properties
// todo  watch rewarded admob win +2 hintRight. Limit it max 2 time per game
// todo günlük oynama sınırı 5 yap eğer oynamak isterse ödüllü izlet ancak max 3 kez izleyebilisin.
//todo her reload ve toplam player ödülü 1 ve katları olduğunda tebrik ve ödüllü

void main() {
  runApp(
    const GetMaterialApp(home: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Welcome to Words',
      home: GameInit(),
      debugShowCheckedModeBanner: false,
    );
  }
}
