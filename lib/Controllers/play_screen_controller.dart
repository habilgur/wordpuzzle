



import 'dart:math';

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayScreenController extends GetxController{
  static PlayScreenController get to => Get.find<PlayScreenController>();

  late  FlipCardController flipCardController;
  late  AssetImage randomBg;

  @override
  void onInit() {
    flipCardController=FlipCardController();
     randomBg=AssetImage("assets/images/pic_${Random().nextInt(21)+1}-min.jpg");
    super.onInit();
  }

}