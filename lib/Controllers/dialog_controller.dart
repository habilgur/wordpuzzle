import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../UI/welcome_screen.dart';

class DialogController extends GetxController {
  var bgColor = Colors.blueGrey;
  final textStyle = const TextStyle(color: Colors.white);

  Future showExitWarn() async {
    return await Get.defaultDialog(
      barrierDismissible: false,
      title: "Uyarı",
      middleText: "Oyundan çıkmak istiyor musunuz?",
      backgroundColor: bgColor,
      titleStyle: textStyle,
      middleTextStyle: textStyle,
      cancel: TextButton(child: Text("EVET", style: textStyle), onPressed: () => Get.to(const WelcomeScreen())),
      confirm: TextButton(child: Text("HAYIR", style: textStyle), onPressed: () => Get.back()),
      actions: <Widget>[],
    );
  }
}
