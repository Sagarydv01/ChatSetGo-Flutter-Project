import 'package:chatsetgo/config/my_images.dart';
import 'package:chatsetgo/pages/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/contact_controller.dart';
import '../../controller/profile_controller.dart';
import 'chat_tile.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the required ContactController using GetX
    final contactController = Get.find<ContactController>();
    final profileController = Get.find<ProfileController>();

    return RefreshIndicator(
      child: Obx(
        () => ListView(
          // Convert chatRoomList to a List<Widget> using map and toList
          children:
              contactController.chatRoomList
                  .map(
                    (e) => InkWell(
                      onTap: () {
                        // Navigate and refresh chat list when returning
                        Get.to(
                          () => ChatPage(
                            userModel:
                                e.receiver!.id ==
                                        profileController.currentUser.value.id
                                    ? e.sender!
                                    : e.receiver!,
                          ),
                        )?.then((_) {
                          contactController.getChatRoomList();
                        });
                      },
                      child: ChatTile(
                        profilePic:
                            (e.receiver!.id ==
                                    profileController.currentUser.value.id
                                ? e.sender!.profilePic
                                : e.receiver!.profilePic) ??
                            MyImages.defaultProfileUrl1,
                        // Use default image if null
                        name:
                            (e.receiver!.id ==
                                    profileController.currentUser.value.id
                                ? e.sender!.name
                                : e.receiver!.name) ??
                            "User",
                        // Use default name if null
                        lastMessage: e.lastMessage ?? "Last Message",
                        // Use default message if null
                        lastMessageTime:
                            e.lastMessageTime ??
                            "Time", // Use default time if null
                      ),
                    ),
                  )
                  .toList(), // Convert Iterable<Widget> to List<Widget>
        ),
      ),
      onRefresh: () async {
        // Call the method to refresh chat room list
        await contactController.getChatRoomList();
      },
    );
  }
}
