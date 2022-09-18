
import 'package:get/get.dart';

import 'dart:math';

import 'package:flutter/animation.dart';

class LoginScreenController extends GetxController with GetTickerProviderStateMixin {
  static LoginScreenController get to=> LoginScreenController();

  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 8000),
  );

  late final rotationAnimation = Tween<double>(
    begin: 0,
    end: 2 * pi,
  ).animate(animationController);

  @override
  void onInit() {
    super.onInit();
    animationController.repeat();
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
  }
}