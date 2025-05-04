import 'dart:io';

import 'package:chatsetgo/pages/homepage/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/my_images.dart';
import '../../controller/group_controller.dart';
import '../../controller/image_picker_controller.dart';

class GroupTitle extends StatelessWidget {
  const GroupTitle({super.key});

  @override
  Widget build(BuildContext context) {
    GroupController groupController = Get.put(GroupController());

    // Image path observable to hold the selected image path
    RxString imagePath = "".obs;
    // Image picker controller to handle image selection
    ImagePickerController imagePickerController = Get.put(
      ImagePickerController(),
    );
    RxString groupName = "".obs; // Observable to hold the group name

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Group"), // AppBar with a title
      ),
      floatingActionButton: Obx(
            () => FloatingActionButton(
          backgroundColor: groupName.isEmpty
              ? Colors.grey
              : Theme.of(context).colorScheme.primary,
          onPressed: () {
            if (groupName.isEmpty) {
              Get.snackbar("Error", "Please enter group name");
            } else {
              groupController.createGroup(groupName.value, imagePath.value);
            }
          },
          child: groupController.isLoading.value
              ? const CircularProgressIndicator(
            color: Colors.white,
          )
              : Icon(
            Icons.done,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0), // Padding around the body
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Container to hold the group title section
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    Theme.of(
                      context,
                    ).colorScheme.primaryContainer, // Background color
                borderRadius: BorderRadius.circular(10), // Rounded corners
                border: Border.all(color: Colors.blueGrey, width: 1),
              ),
              child: Row(
                children: [
                  // Expanded widget to allow child to take available space
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Aligns items in the center
                      children: [
                        // Circle for profile image placeholder
                        Obx(
                          () => InkWell(
                            onTap: () async {
                              imagePath.value = await imagePickerController
                                  .pickImage(ImageSource.gallery);
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child:
                                  imagePath.value == ""
                                      ? const Icon(Icons.group, size: 40)
                                      : ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: Image.file(
                                          File(imagePath.value),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Space between the circle and text
                        // TextFormField for group name input
                        TextFormField(
                          onChanged: (value) {
                            groupName.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Group Name",
                            prefixIcon: Icon(Icons.group),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      groupController.groupMembers
                          .map(
                            (e) => ChatTile(
                              profilePic:
                                  e.profilePic ?? MyImages.defaultProfileUrl1,
                              name: e.name ?? 'Unknown',
                              lastMessage: e.about ?? '',
                              lastMessageTime: '',
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
