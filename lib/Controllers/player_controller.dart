import 'package:get/get.dart';

import '../Models/player.dart';

class PlayerController extends GetxController {
  final thePlayer = Player(name: "test").obs;

  reduceSkipRightNum() {
    thePlayer.update((val) {
      val!.skipRight--;
    });
  }
}
