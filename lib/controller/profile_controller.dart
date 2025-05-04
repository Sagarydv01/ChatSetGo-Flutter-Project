import 'dart:io';

import 'package:chatsetgo/services/cloudinary_service.dart'; // Import Cloudinary service for image upload
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for user authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore to access user data in the database

import '../model/user_model.dart'; // Import the UserModel class to map user data

class ProfileController extends GetxController {
  final FirebaseAuth _auth =
      FirebaseAuth
          .instance; // FirebaseAuth instance to manage user authentication
  final FirebaseFirestore _db =
      FirebaseFirestore
          .instance; // Firestore instance to interact with Firestore database

  RxBool isLoading =
      false.obs; // Observable to track loading state (for UI feedback)
  Rx<UserModel> currentUser =
      UserModel().obs; // Observable for storing the current user data

  @override
  void onInit() async {
    super.onInit();
    await getUserDetails(); // Fetch user details when the controller is initialized
  }

  // Method to fetch user details from Firestore
  Future<void> getUserDetails() async {
    final user = _auth.currentUser; // Get the currently authenticated user
    if (user == null) return; // If no user is logged in, return

    try {
      // Fetch the user document from the Firestore 'users' collection based on the user UID
      final doc = await _db.collection("users").doc(user.uid).get();

      // If the document exists and contains data, map the data to UserModel
      if (doc.exists && doc.data() != null) {
        currentUser.value = UserModel.fromJson(doc.data()!);
      }
    } catch (e) {
      print(
        'Error fetching user data: $e',
      ); // Catch and print any error while fetching data
    }
  }

  // Method to update the user's profile details in Firestore
  Future<void> updateProfile({
    File? newImage, // Optional new image file for the profile picture
    required String name, // New name for the user
    required String about, // New about description for the user
    required String mobileNumber, // New mobile number for the user
  }) async {
    isLoading.value =
        true; // Set loading state to true (indicates the update process is in progress)
    final userId = _auth.currentUser?.uid; // Get the current user's UID
    if (userId == null) return; // If no user is logged in, return

    try {
      // Store the current user's profile picture URL
      String? imageUrl = currentUser.value.profilePic;

      // If a new image is provided, upload it to Cloudinary
      if (newImage != null) {
        final uploadedUrl = await CloudinaryService.uploadImage(
          newImage,
        ); // Upload image using CloudinaryService
        if (uploadedUrl != null) {
          imageUrl =
              uploadedUrl; // Update the image URL if the upload was successful
        }
      }

      // Update the user's information in Firestore with the new data
      await _db.collection('users').doc(userId).update({
        'name': name, // Update the name field
        'about': about, // Update the about field
        'mobileNumber': mobileNumber, // Update the mobile number field
        'profilePic': imageUrl, // Update the profile picture field
      });

      // After successful update, fetch the updated user details
      await getUserDetails(); // Refresh profile with the latest data

      // Display a success message using Get.snackbar
      Get.snackbar('Success', 'Profile Updated!');
    } catch (e) {
      // If an error occurs, display an error message
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value =
          false; // Set loading state to false (indicates the process has finished)
    }
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error fetching user: $e");
      rethrow;
    }
  }
}
