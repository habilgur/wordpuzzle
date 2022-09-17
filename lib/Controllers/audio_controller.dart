import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  late AudioPlayer player;

  @override
  void onInit() {
    player = AudioPlayer();
    super.onInit();
  }

  Future<void> padKeySound() async {
    await player.setAsset('assets/audio/put.mp3');
    player.play();
  }

  Future<void> failedSound() async {
    await player.setAsset('assets/audio/timeUp.mp3');
    player.play();
  }

  Future<void> doneSound() async {
    await player.setAsset('assets/audio/correct.mp3');
    player.play();
  }

}
