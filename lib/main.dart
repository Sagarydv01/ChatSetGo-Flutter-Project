import "package:chatsetgo/config/my_themes.dart";
import "package:chatsetgo/config/page_path.dart";
import "package:chatsetgo/controller/profile_controller.dart";
import "package:chatsetgo/pages/splash_page/SplashPage.dart";
import "package:chatsetgo/pages/welcome_page.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:get/get.dart";

import "controller/auth_controller.dart";
import "firebase_options.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  await dotenv.load(fileName: ".env");  // load .env

  Get.put(AuthController());
  Get.put(ProfileController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChatSetGo",
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      // home: WelcomePage(),
      home: SplashPage(),
      getPages: pagePath,
    );
  }
}
