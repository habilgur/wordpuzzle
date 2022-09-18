import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordpuzzle/UI/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () => Get.to(()=>const LoginScreen()), // todo go to after 2 sc
        child: const Text("Login"),
      ),
    ));
  }
}
