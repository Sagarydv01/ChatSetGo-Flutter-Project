import 'package:chatsetgo/controller/chat_controller.dart';
import 'package:chatsetgo/controller/contact_controller.dart';
import 'package:chatsetgo/pages/chat/chat_page.dart';
import 'package:chatsetgo/pages/contact_page/contact_search.dart';
import 'package:chatsetgo/pages/contact_page/new_contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/my_images.dart';
import '../../controller/profile_controller.dart';
import '../group/new_group.dart';
import '../homepage/chat_tile.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isSearchEnable = false.obs;

    // Instantiate the required controllers
    ContactController contactController = Get.put(ContactController());
    ChatController chatController = Get.put(ChatController());
    ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contacts'),
        actions: [
          Obx(
                () => IconButton(
              onPressed: () {
                // Toggle search bar visibility
                isSearchEnable.value = !isSearchEnable.value;
              },
              icon: isSearchEnable.value
                  ? const Icon(Icons.close)
                  : const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            // Show search bar if enabled
            Obx(() => isSearchEnable.value ? const ContactSearch() : const SizedBox()),

            const SizedBox(height: 10),

            // New contact tile
            NewContactTile(
              btnName: "New Contact",
              icon: Icons.person,
              onTap: () {
                // TODO: Add your "create contact" logic
              },
            ),

            const SizedBox(height: 10),

            // New group tile
            NewContactTile(
              btnName: "New Group",
              icon: Icons.group_add,
              onTap: () {
                Get.to(NewGroup());
              },
            ),

            const SizedBox(height: 20),

            const Row(
              children: [
                Text(
                  "Contacts on ChatSetGo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Render contact list
            Obx(() {
              if (contactController.userList.isEmpty) {
                return const Center(
                  child: Text(
                    "No contacts found.",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return Column(
                children: contactController.userList.map((user) {
                  return InkWell(
                    onTap: () async {
                      await contactController.saveContact(user); // Save contact
                      Get.to(ChatPage(userModel: user)); // Navigate to chat
                    },
                    child: ChatTile(
                      profilePic: user.profilePic,
                      name: user.name ?? "Unknown",
                      lastMessage: user.about ?? "Hello",
                      lastMessageTime: user.email == profileController.currentUser.value.email
                          ? "You"
                          : "",
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
