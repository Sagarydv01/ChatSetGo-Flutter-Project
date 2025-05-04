import 'dart:io';
import "package:chatsetgo/controller/profile_controller.dart";
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import "../../model/chat_model.dart";
import "../../model/user_model.dart";
import "../../widgets/type_message_bar.dart";
import "../user_profile/user_profile_page.dart";
import "chat_bubble.dart";
import "package:chatsetgo/config/my_images.dart";
import "package:chatsetgo/controller/chat_controller.dart";

class ChatPage extends StatelessWidget {
  final UserModel userModel;

  const ChatPage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    // GetX controllers
    final ChatController chatController = Get.put(ChatController());
    final ProfileController profileController = Get.find<ProfileController>();

    // Controller for message input
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            // Navigate to user profile on avatar tap
            Get.to(UserProfilePage(userModel: userModel));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child:
              userModel.profilePic != null &&
                  userModel.profilePic!.isNotEmpty
                  ? Image.network(
                userModel.profilePic!,
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                MyImages.defaultProfileUrl1,
                width: 35,
                height: 35,
              ),
            ),
          ),
        ),
        title: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            // Navigate to user profile on name/status tap
            Get.to(UserProfilePage(userModel: userModel));
          },
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userModel.name ?? "User",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  Text(
                    "Status",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.call, color: Colors.white),
          ),
          IconButton(
            onPressed: null,
            icon: Icon(Icons.video_call, color: Colors.white),
          ),
        ],
      ),
      // Chat messages list
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 20.0,  // Reduced the bottom padding to bring the input bar closer
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  StreamBuilder<List<ChatModel>>(
                    stream: chatController.getMessages(userModel.id!),
                    // Live updates
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No messages"));
                      } else {
                        return ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            DateTime timestamp = DateTime.parse(
                              snapshot.data![index].timeStamp!,
                            );
                            String formattedTime = DateFormat(
                              'hh:mm a',
                            ).format(timestamp);

                            return ChatBubble(
                              message: snapshot.data![index].message!,
                              isComing:
                              snapshot.data![index].receiverId ==
                                  profileController.currentUser.value.id,
                              time: formattedTime,
                              imageUrl: snapshot.data![index].imageUrl ?? "",
                              // Optional: handle images if needed
                              messageStatus: "Read",
                            );
                          },
                        );
                      }
                    },
                  ),
                  Obx(() {
                    if (chatController.selectedImagePath.value != "") {
                      return Positioned(
                        bottom: 20,  // Adjust to position above the message bar
                        left: 10,
                        right: 10,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(
                                    File(chatController.selectedImagePath.value),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 200,  // Adjust this to fit your needs
                              width: MediaQuery.of(context).size.width - 20,
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: IconButton(
                                onPressed: () {
                                  chatController.selectedImagePath.value = "";
                                },
                                icon: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox();  // Empty box when no image selected
                    }
                  }),
                ],
              ),
            ),
            TypeMessage(userModel: userModel),
          ],
        ),
      ),
    );
  }
}
