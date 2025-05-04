import 'dart:io'; // For image file handling
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:chatsetgo/controller/image_picker_controller.dart';
import 'package:chatsetgo/controller/profile_controller.dart';
import 'package:chatsetgo/controller/auth_controller.dart';
import 'package:chatsetgo/widgets/buttons.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Reactive variables and controllers
    RxBool isEdit = false.obs;
    RxString imagePath = ''.obs;

    // Instantiate controllers using GetX
    final profileController = Get.put(ProfileController());
    final authController = Get.put(AuthController());
    final imagePickerController = Get.put(ImagePickerController());

    // Pre-fill the input fields with current user data
    final nameController = TextEditingController(text: profileController.currentUser.value.name);
    final emailController = TextEditingController(text: profileController.currentUser.value.email);
    final phoneController = TextEditingController(text: profileController.currentUser.value.mobileNumber);
    final aboutController = TextEditingController(text: profileController.currentUser.value.about);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: authController.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Profile Image Section
                        Obx(() => buildProfileImage(
                          isEditMode: isEdit.value,
                          context: context,
                          imagePath: imagePath,
                          profilePicUrl: profileController.currentUser.value.profilePic,
                          onTap: () async {
                            imagePath.value = await imagePickerController.pickImage(ImageSource.gallery);
                          },
                        )),
                        const SizedBox(height: 20),

                        // Name Field
                        Obx(() => TextField(
                          controller: nameController,
                          enabled: isEdit.value,
                          decoration: InputDecoration(
                            filled: isEdit.value,
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Name',
                            border: const OutlineInputBorder(),
                          ),
                        )),
                        const SizedBox(height: 20),

                        // Email Field (non-editable)
                        TextField(
                          controller: emailController,
                          enabled: false,
                          decoration: const InputDecoration(
                            filled: false,
                            prefixIcon: Icon(Icons.email_rounded),
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Phone Field
                        Obx(() => TextField(
                          controller: phoneController,
                          enabled: isEdit.value,
                          decoration: InputDecoration(
                            filled: isEdit.value,
                            prefixIcon: const Icon(Icons.phone),
                            labelText: 'Phone',
                            border: const OutlineInputBorder(),
                          ),
                        )),
                        const SizedBox(height: 20),

                        // About Field
                        Obx(() => TextField(
                          controller: aboutController,
                          enabled: isEdit.value,
                          decoration: InputDecoration(
                            filled: isEdit.value,
                            prefixIcon: const Icon(Icons.info),
                            labelText: 'About',
                            border: const OutlineInputBorder(),
                          ),
                        )),
                        const SizedBox(height: 20),

                        // Save or Edit Button
                        Obx(() => profileController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isEdit.value
                                ? PrimaryButton(
                              btnName: "Save",
                              icon: Icons.save,
                              onPressed: () async {
                                // Save profile changes
                                await profileController.updateProfile(
                                  newImage: imagePath.value.isNotEmpty
                                      ? File(imagePath.value)
                                      : null,
                                  name: nameController.text.trim(),
                                  mobileNumber: phoneController.text.trim(),
                                  about: aboutController.text.trim(),
                                );
                                // Exit edit mode and clear image path
                                isEdit.value = false;
                                imagePath.value = '';
                              },
                            )
                                : PrimaryButton(
                              btnName: "Edit",
                              icon: Icons.edit,
                              onPressed: () {
                                isEdit.value = true;
                              },
                            ),
                          ],
                        )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🖼 Reusable widget to handle profile image display
  Widget buildProfileImage({
    required bool isEditMode,
    required BuildContext context,
    required RxString imagePath,
    required String? profilePicUrl,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isEditMode ? onTap : null,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(100),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: isEditMode
          // Show local file if selected in edit mode
              ? Obx(() => imagePath.value == ''
              ? const Icon(Icons.add)
              : Image.file(
            File(imagePath.value),
            fit: BoxFit.cover,
          ))
              : (profilePicUrl == null || profilePicUrl.isEmpty
          // Default icon if no image URL
              ? const Icon(Icons.image)
              : CachedNetworkImage(
            imageUrl: profilePicUrl,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          )),
        ),
      ),
    );
  }
}
