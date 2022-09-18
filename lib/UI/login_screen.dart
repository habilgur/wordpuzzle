import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wordpuzzle/UI/play_screen.dart';
import '../Controllers/game_manage_controller.dart';
import '../Controllers/login_screen_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginScreenController>(
      init: LoginScreenController(),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: Stack(
              children: [
                Positioned(
                  top: Get.width / -2,
                  child: Transform.scale(
                    scale: 1.2,
                    child: AnimatedBuilder(
                      animation: controller.rotationAnimation,
                      builder: (context, _) => Stack(
                        fit: StackFit.loose,
                        alignment: Alignment.center,
                        children: [
                          CircleWidget(
                            angle: controller.rotationAnimation.value,
                            size: Get.width * 0.4,
                            firstImageUrl: const Icon(Icons.currency_bitcoin),
                            secondImageUrl: const Icon(Icons.currency_exchange),
                          ),
                          CircleWidget(
                            angle: controller.rotationAnimation.value + 180,
                            size: Get.width * 0.7,
                            firstImageUrl: const Icon(Icons.currency_lira_outlined),
                            secondImageUrl: const Icon(Icons.monetization_on_outlined),
                          ),
                          CircleWidget(
                            angle: controller.rotationAnimation.value + 90,
                            size: Get.width,
                            firstImageUrl: const Icon(Icons.currency_bitcoin),
                            secondImageUrl: const Icon(Icons.currency_exchange),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    width: Get.width,
                    height: Get.height,
                    color: Colors.white.withOpacity(0.2),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: Get.width / 2),
                        const Text(
                          'Word Puzzle Başlıyor!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          'Doğru Kelimeleri bilin, gerçek kripto kazanın',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // const SizedBox(height: 50),
                        // TextField(
                        //   decoration: InputDecoration(
                        //     hintText: 'Enter your wallet address',
                        //     hintStyle: const TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.black,
                        //     ),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   style: const TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: Column(
                            children: const [
                              Text(
                                'Nasıl Oynanır?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                              Divider(
                                indent: 80,
                                endIndent: 80,
                                thickness: 1,
                              ),
                              Text(
                                'Cüzdanım Yok',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                              Divider(
                                indent: 80,
                                endIndent: 80,
                                thickness: 1,
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: Size(Get.width * 0.6, 50),
                            splashFactory: InkRipple.splashFactory,
                          ),
                          child: const Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // register button
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            GameManagerController.to.startGame();
                            Get.to(()=>const PlayScreen());
                            },
                          style: TextButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: Size(Get.width * 0.6, 50),
                            splashFactory: InkRipple.splashFactory,
                          ),
                          child: const Text(
                            'Play',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ));
        },
      );
  }
}

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    Key? key,
    required this.angle,
    required this.size,
    required this.firstImageUrl,
    required this.secondImageUrl,
  }) : super(key: key);
  final double angle;
  final double size;
  final Icon firstImageUrl;
  final Icon secondImageUrl;
  final double radius = 35;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(radius / 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.7), width: 1.1),
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: radius,
                height: radius,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: firstImageUrl
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: radius,
                height: radius,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: secondImageUrl
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
