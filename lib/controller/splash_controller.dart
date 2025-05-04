import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/welcome_page.dart';

class SplashController extends GetxController {
  final auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    splashHandle();
  }

  Future<void> splashHandle() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool("isFirstTime") ?? true;

    if (isFirstTime) {
      await prefs.setBool("isFirstTime", false);
      Get.offAll(() => const WelcomePage());
    } else {
      if (auth.currentUser != null) {
        Get.offAllNamed("/homePage");
      } else {
        Get.offAllNamed("/authPage");
      }
    }
  }
}
