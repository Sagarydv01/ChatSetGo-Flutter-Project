import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../config/my_images.dart';
import '../controller/chat_controller.dart';
import '../controller/image_picker_controller.dart';
import '../model/user_model.dart';
import 'image_picker_bottom_sheet.dart';

class TypeMessage extends StatelessWidget {
  final UserModel userModel;

  const TypeMessage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.put(ChatController());
    TextEditingController messageController = TextEditingController();
    ImagePickerController imagePickerController = Get.put(ImagePickerController());
    RxString message = "".obs;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).colorScheme.primaryContainer,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     blurRadius: 10,
        //     spreadRadius: 2,
        //   ),
        // ],
      ),
      child: Row(
        children: [
          // Emoji Button
          GestureDetector(
            onTap: () {
              // Handle Emoji Button Tap
            },
            child: Container(
              width: 30,
              height: 30,
              child: SvgPicture.asset(MyImages.chatEmojiSVG, width: 25),
            ),
          ),
          SizedBox(width: 10),

          // TextField for message input
          Expanded(
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) {
                if (event.isControlPressed && event.logicalKey.keyLabel == 'Enter' && event.runtimeType.toString() == 'RawKeyDownEvent') {
                  if (messageController.text.trim().isNotEmpty || chatController.selectedImagePath.value.isNotEmpty) {
                    chatController.sendMessage(
                      userModel.id!,
                      messageController.text.trim(),
                      userModel,
                    );
                    messageController.clear();
                    message.value = "";
                  }
                }
              },
              child: TextField(
                controller: messageController,
                onChanged: (value) => message.value = value,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),

          // Image picker button
          Obx(
                () => chatController.selectedImagePath.value.isEmpty
                ? GestureDetector(
              onTap: () {
                // Call Image Picker
                imagePickerBottomSheet(
                  context,
                  chatController.selectedImagePath,
                  imagePickerController,
                );
              },
              child: Container(
                width: 30,
                height: 30,
                child: SvgPicture.asset(
                  MyImages.chatGallerySvg,
                  width: 25,
                ),
              ),
            )
                : SizedBox(),
          ),

          SizedBox(width: 10),

          // Send or Mic Button based on the input
          Obx(
                () => message.value.isNotEmpty || chatController.selectedImagePath.value.isNotEmpty
                ? GestureDetector(
              onTap: () {
                if (messageController.text.isNotEmpty || chatController.selectedImagePath.value.isNotEmpty) {
                  chatController.sendMessage(
                    userModel.id!,
                    messageController.text,
                    userModel,
                  );
                  messageController.clear();
                  message.value = "";
                }
              },
              child: Container(
                width: 30,
                height: 30,
                child: chatController.isLoading.value
                    ? CircularProgressIndicator()
                    : SvgPicture.asset(MyImages.chatSendSvg, width: 25),
              ),
            )
                : GestureDetector(
              onTap: () {
                // Handle Mic Button functionality
              },
              child: Container(
                width: 30,
                height: 30,
                child: SvgPicture.asset(MyImages.chatMicSvg, width: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
