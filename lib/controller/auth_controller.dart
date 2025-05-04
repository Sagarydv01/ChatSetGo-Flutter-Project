import 'package:chatsetgo/controller/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;
  var isLogin = true.obs;

  // Toggle between login/signup tabs
  void toggleAuthTab(bool loginSelected) {
    isLogin.value = loginSelected;
  }

  // Login method with Firebase Authentication
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await Get.find<ProfileController>().getUserDetails(); // Fetch user details after login

      isLoading.value = false;

      // Navigate to home so ProfilePage rebuilds with the new data
      Get.offAllNamed("/homePage");

      return true;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == "user-not-found") {
        Get.snackbar("Login Error", "No user found for that email",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } else if (e.code == "wrong-password") {
        Get.snackbar("Login Error", "Wrong password provided for that user",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Login Error", "An unexpected error occurred",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
    return false;
  }

  // Create a new user with Firebase Authentication
  Future<void> createUser(String name, String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await initUser(name, email);

      await Get.find<ProfileController>().getUserDetails(); // Fetch user details after signup

      Get.offAllNamed("/homePage");
      Get.snackbar("Account Created", "Welcome $name!, Your account has been created.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        Get.snackbar("Sign Up Error", "Password provided is too weak",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } else if (e.code == "email-already-in-use") {
        Get.snackbar("Sign Up Error", "Account already exists for that email",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Sign Up Error", "An unexpected error occurred",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
    isLoading.value = false;
  }

  // Sign out the user and reset profile data
  Future<void> signOut() async {
    await _auth.signOut();

    Get.find<ProfileController>().currentUser.value = UserModel();  // Reset user data
    Get.offAllNamed("/authPage"); // Redirect to auth page after logout
  }

  // Initialize user data on signup
  Future<void> initUser(String name, String email) async {
    var newUser = UserModel(
      id: _auth.currentUser?.uid,
      name: name,
      email: email,
    );

    try {
      await db.collection("users").doc(_auth.currentUser!.uid).set(
        newUser.toJson(),
      );
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Reset password functionality
  void resetPassword(String email) async {
    try {
      isLoading.value = true;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      isLoading.value = false;
      Get.snackbar("Success", "Password reset email sent.",
          snackPosition: SnackPosition.BOTTOM);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.message ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

}
