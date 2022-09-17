import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordpuzzle/game_initialize.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Get.to(const GameInit());
          },
          child: const Text("OYUNA BAŞLA"),
        ),
      ],
    );
  }
}
