import 'dart:io';

import 'package:chatsetgo/controller/contact_controller.dart';
import 'package:chatsetgo/controller/profile_controller.dart';
import 'package:chatsetgo/model/chat_room_model.dart';
import 'package:chatsetgo/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../model/chat_model.dart';
import '../services/cloudinary_service.dart';

class ChatController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  var uuid = Uuid();
  RxString selectedImagePath = "".obs;
  ProfileController profileController = Get.put(ProfileController());
  ContactController contactController = Get.put(ContactController());

  RxBool isLoading = false.obs;

  String getRoomId(String targetUserId) {
    String currentUserId = auth.currentUser!.uid;

    if (currentUserId[0].codeUnitAt(0) > targetUserId[0].codeUnitAt(0)) {
      return currentUserId + targetUserId;
    } else {
      return targetUserId + currentUserId;
    }
  }

  UserModel getSender(UserModel currentUser, UserModel targetUser) {
    String currentUserId = currentUser.id!;
    String targetUserId = targetUser.id!;

    if (currentUserId[0].codeUnitAt(0) > targetUserId[0].codeUnitAt(0)) {
      return currentUser;
    } else {
      return targetUser;
    }
  }

  UserModel getReceiver(UserModel currentUser, UserModel targetUser) {
    String currentUserId = currentUser.id!;
    String targetUserId = targetUser.id!;

    if (currentUserId[0].codeUnitAt(0) > targetUserId[0].codeUnitAt(0)) {
      return targetUser;
    } else {
      return currentUser;
    }
  }

  Future<void> sendMessage(String targetUserId, String message, UserModel targetUser) async {
    isLoading.value = true;

    try {
      String chatId = uuid.v6();
      String roomId = getRoomId(targetUserId);

      DateTime timeStamp = DateTime.now();
      String currentTime = DateFormat('hh:mm a').format(timeStamp);

      UserModel sender = getSender(profileController.currentUser.value, targetUser);
      UserModel receiver = getReceiver(profileController.currentUser.value, targetUser);

      String imageUrl = "";

      if (selectedImagePath.value.isNotEmpty) {
        final uploadedUrl = await CloudinaryService.uploadImage(File(selectedImagePath.value));
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        } else {
          // Handle upload failure
          print("Image upload failed.");
          return;
        }
      }

      var newChat = ChatModel(
        id: chatId,
        senderId: auth.currentUser!.uid,
        senderName: profileController.currentUser.value.name,
        receiverId: targetUserId,
        receiverName: targetUser.name,
        message: message,
        imageUrl: imageUrl,
        timeStamp: DateTime.now().toString(),
      );

      var roomDetails = ChatRoomModel(
        id: roomId,
        lastMessage: message,
        lastMessageTime: currentTime,
        sender: sender,
        receiver: receiver,
        timeStamp: DateTime.now().toString(),
        unReadMessNo: 0,
      );

      await db.collection("chats").doc(roomId).collection("messages").doc(chatId).set(newChat.toJson());
      await db.collection("chats").doc(roomId).set(roomDetails.toJson());

      await contactController.saveContact(targetUser);

      selectedImagePath.value = "";
    } catch (e) {
      print("Error sending message: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Stream<List<ChatModel>> getMessages(String targetUserId) {
    String roomId = getRoomId(targetUserId);
    return db
        .collection("chats")
        .doc(roomId)
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => ChatModel.fromJson(doc.data())).toList(),
    );
  }
}
