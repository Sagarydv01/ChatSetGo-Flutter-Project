import 'package:chatsetgo/config/my_images.dart';
import 'package:chatsetgo/controller/group_controller.dart';
import 'package:chatsetgo/pages/group/group_title.dart';
import 'package:chatsetgo/pages/group/select_members.dart';
import 'package:chatsetgo/pages/homepage/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/contact_controller.dart';

class NewGroup extends StatelessWidget {
  const NewGroup({super.key});

  @override
  Widget build(BuildContext context) {
    ContactController contactController = Get.put(ContactController());
    GroupController groupController = Get.put(GroupController());

    return Scaffold(
      appBar: AppBar(title: const Text("Create New Group")),
      floatingActionButton: Obx(() {
        // Button color changes based on the number of selected members
        bool isEnabled = groupController.groupMembers.isNotEmpty;
        return FloatingActionButton(
          backgroundColor: isEnabled
              ? Theme.of(context).colorScheme.primary
              : Colors.grey, // Change to grey if no members are selected
          onPressed: isEnabled
              ? () {
            // Navigate to the next screen if members are selected
            Get.to(() => const GroupTitle());
          }
              : null, // Disable button if no members are selected
          child: Icon(
            Icons.arrow_forward,
            color: isEnabled ? Colors.white : Colors.black, // Change icon color based on state
          ),
        );
      }),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Display selected members
            SelectedMembers(),
            const SizedBox(height: 10),
            // Label for selecting contacts
            Text(
              "Select Contacts",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Expanded(
              child: StreamBuilder(
                stream: contactController.getContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No contacts found"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          groupController.selectMember(snapshot.data![index]);
                        },
                        child: ChatTile(
                          name: snapshot.data![index].name ?? 'Unknown',
                          lastMessage: snapshot.data![index].about ?? '',
                          lastMessageTime: '',
                          profilePic:
                          snapshot.data![index].profilePic ?? MyImages.defaultProfileUrl1,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
