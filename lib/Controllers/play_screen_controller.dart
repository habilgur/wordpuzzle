



import 'package:flip_card/flip_card_controller.dart';
import 'package:get/get.dart';

class PlayScreenController extends GetxController{
  static PlayScreenController get to => Get.find<PlayScreenController>();

  late  FlipCardController flipCardController;

  @override
  void onInit() {
    flipCardController=FlipCardController();
    super.onInit();
  }

}