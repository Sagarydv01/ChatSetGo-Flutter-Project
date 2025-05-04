import 'package:chatsetgo/pages/chat/chat_page.dart';
import 'package:chatsetgo/pages/profile_page/profilePage.dart';
import 'package:get/get.dart';

import '../pages/auth/auth_page.dart';
import '../pages/contact_page/contact_page.dart';
import '../pages/homepage/homepage.dart';
import '../pages/user_profile/user_profile_page.dart';
import '../pages/user_profile/user_update_profile.dart';

// Define a list of pages with their routes and transition effects
var pagePath = [
  // Authentication Page Route
  GetPage(
    name: "/authPage",  // URL for this page
    page: () => AuthPage(),  // The widget for this page
    transition: Transition.fadeIn,  // Transition effect when navigating
    transitionDuration: Duration(milliseconds: 500),  // Transition duration
  ),

  // Home Page Route
  GetPage(
    name: "/homePage",
    page: () => HomePage(),
    transition: Transition.fadeIn,  // Fade transition effect
    transitionDuration: Duration(milliseconds: 500),
  ),

  // Chat Page Route
  // GetPage(
  //   name: "/chat_page",
  //   page: () => ChatPage(),
  //   transition: Transition.fadeIn,  // Fade transition effect
  //   transitionDuration: Duration(milliseconds: 500),
  // ),

  // Uncommented User Profile Page Route (commented out in your code)
  // GetPage(
  //   name: "/userProfilePage",
  //   page: () => UserProfilePage(),
  //   transition: Transition.fadeIn,  // Fade transition effect
  //   transitionDuration: Duration(milliseconds: 500),
  // ),

  // Uncommented Update User Profile Page Route (commented out in your code)
  // GetPage(
  //   name: "/updateUserProfilePage",
  //   page: () => UserUpdateProfile(),
  //   transition: Transition.fadeIn,  // Fade transition effect
  //   transitionDuration: Duration(milliseconds: 500),
  // ),

  // Profile Page Route
  GetPage(
    name: "/profilePage",  // URL for the profile page
    page: () => ProfilePage(),  // The widget for the profile page
    transition: Transition.leftToRightWithFade,  // Custom transition: Slide from left and fade
    transitionDuration: Duration(milliseconds: 500),  // Transition duration
  ),
  // Contact Page Route
  GetPage(
    name: "/contactPage",
    page: () => ContactPage(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(milliseconds: 500),
  ),
];
