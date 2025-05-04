import 'dart:io';
import 'package:chatsetgo/services/cloudinary_service.dart'; // Cloudinary upload service
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/chat_model.dart';
import '../model/group_model.dart';
import '../model/user_model.dart';
import '../pages/homepage/homepage.dart';

class GroupController extends GetxController {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  var uuid = Uuid();

  RxList<UserModel> groupMembers = <UserModel>[].obs; // Selected group members
  RxList<GroupModel> groupList = <GroupModel>[].obs; // List of groups
  RxString selectedImagePath = "".obs; // Holds the image path for messages
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getGroups(); // Load user's groups on controller init
  }

  // Toggle selection of group members
  void selectMember(UserModel user) {
    if (groupMembers.contains(user)) {
      groupMembers.remove(user);
    } else {
      groupMembers.add(user);
    }
  }

  // Create a group with image and selected members
  Future<void> createGroup(String groupName, String imagePath) async {
    isLoading.value = true;
    String groupId = uuid.v6();

    // Add the current user as group admin
    groupMembers.add(
      UserModel(
        id: auth.currentUser!.uid,
        name: auth.currentUser!.displayName ?? '',
        profilePic: auth.currentUser!.photoURL ?? '',
        email: auth.currentUser!.email ?? '',
        role: "admin",
      ),
    );

    try {
      // Upload group image to Cloudinary
      String? imageUrl = await CloudinaryService.uploadImage(File(imagePath));
      // if (imageUrl == null) {
      //   throw Exception("Image upload failed");
      // }

      // Create group document in Firestore
      await db.collection("groups").doc(groupId).set({
        "id": groupId,
        "name": groupName,
        "profileUrl": imageUrl ?? '',
        "members": groupMembers.map((e) => e.toJson()).toList(),
        "createdAt": DateTime.now().toString(),
        "createdBy": auth.currentUser!.uid,
        "timeStamp": DateTime.now().toString(),
      });

      getGroups(); // Refresh groups
      // successMessage("Group created successfully");
      // ✅ Show success message
      Get.snackbar(
        "Success",
        "Group '$groupName' created successfully!",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAll(HomePage()); // Navigate to homepage
    } catch (e) {
      print("Create group error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Load groups where the current user is a member
  Future<void> getGroups() async {
    isLoading.value = true;
    try {
      List<GroupModel> tempGroup = [];
      final snapshot = await db.collection('groups').get();
      tempGroup =
          snapshot.docs.map((e) => GroupModel.fromJson(e.data())).toList();

      groupList.clear();
      groupList.value =
          tempGroup
              .where(
                (group) => group.members!.any(
                  (member) => member.id == auth.currentUser!.uid,
                ),
              )
              .toList();
    } catch (e) {
      print("Get groups error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Real-time stream for user's groups
  Stream<List<GroupModel>> getGroupss() {
    return db.collection('groups').snapshots().map((snapshot) {
      List<GroupModel> tempGroup =
          snapshot.docs.map((doc) => GroupModel.fromJson(doc.data())).toList();

      groupList.clear();
      groupList.value =
          tempGroup
              .where(
                (group) => group.members!.any(
                  (member) => member.id == auth.currentUser!.uid,
                ),
              )
              .toList();

      return groupList;
    });
  }

  // Send a group message with optional image
  Future<void> sendGroupMessage(
    String message,
    String groupId,
    String imagePath,
  ) async {
    isLoading.value = true;
    try {
      String chatId = uuid.v6();

      // Upload image if provided
      String? imageUrl;
      if (imagePath.isNotEmpty) {
        imageUrl = await CloudinaryService.uploadImage(File(imagePath));
      }

      // Construct chat message
      var newChat = ChatModel(
        id: chatId,
        message: message,
        imageUrl: imageUrl ?? '',
        senderId: auth.currentUser!.uid,
        senderName: auth.currentUser!.displayName ?? '',
        timeStamp: DateTime.now().toString(),
      );

      // Save message to Firestore
      await db
          .collection("groups")
          .doc(groupId)
          .collection("messages")
          .doc(chatId)
          .set(newChat.toJson());

      selectedImagePath.value = "";
    } catch (e) {
      print("Send group message error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Real-time stream of group messages
  Stream<List<ChatModel>> getGroupMessages(String groupId) {
    return db
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ChatModel.fromJson(doc.data()))
                  .toList(),
        );
  }

  // Add a user to an existing group
  Future<void> addMemberToGroup(String groupId, UserModel user) async {
    isLoading.value = true;
    try {
      await db.collection("groups").doc(groupId).update({
        "members": FieldValue.arrayUnion([user.toJson()]),
      });
      getGroups();
    } catch (e) {
      print("Add member error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
