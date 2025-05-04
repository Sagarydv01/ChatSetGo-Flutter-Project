import 'package:chatsetgo/config/my_images.dart';
import 'package:chatsetgo/pages/user_profile/receiver_user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/profile_controller.dart';
import '../../model/user_model.dart';

class UserProfilePage extends StatelessWidget {
  final UserModel userModel;
  const UserProfilePage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    // Controllers for managing authentication and profile
    AuthController authController = Get.put(AuthController());
    ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to update profile page
              Get.toNamed("/updateProfilePage");
            },
            icon: Icon(
              Icons.edit,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Pass user details to the ReceiverUserInfo widget
            ReceiverUserInfo(
              profileImage:
              userModel.profilePic ?? MyImages.defaultProfileUrl1, // Use default if no profile pic
              userName: userModel.name ?? "User", // Default name if null
              userEmail: userModel.email ?? "", // Default empty email if null
            ),
            Spacer(),
            // Logout button
            ElevatedButton(
              onPressed: () {
                authController.signOut(); // Sign out the user
              },
              child: Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
