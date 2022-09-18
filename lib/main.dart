import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Controllers/init_controllers.dart';
import 'UI/splash_screen.dart';


//todo question level type 3-4-5 ?? Sıralama nasıl olacak ?
//todo admob
//todo signIn Google
//todo FireStore

//todo package name change
//todo time limit??

//todo alt: oyun sonunda bitime puanı ver. Ve bitmeden önce rewarded izlettir.? yada başta?
//todo remove random key via interstitial ads - add question class isRandomKey properties
// todo  watch rewarded admob win +2 hintRight. Limit it max 2 time per game
// todo günlük oynama sınırı 5 yap eğer oynamak isterse ödüllü izlet ancak max 3 kez izleyebilisin.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Initializer().initControllers();
  runApp(
    const GetMaterialApp(home: MyApp(),debugShowCheckedModeBanner: false),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}


