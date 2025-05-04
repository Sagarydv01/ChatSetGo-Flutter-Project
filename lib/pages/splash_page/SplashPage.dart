import 'package:chatsetgo/config/my_images.dart';
import 'package:chatsetgo/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController splashController = Get.put(SplashController());

    return Scaffold(
      body: Center(
        child: SvgPicture.asset(MyImages.appIconSVG),
      ),
    );
  }
}
