import 'package:chatsetgo/controller/profile_controller.dart';
import 'package:chatsetgo/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/chat_room_model.dart';

class ContactController extends GetxController {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<ChatRoomModel> chatRoomList = <ChatRoomModel>[].obs;

  ProfileController profileController = Get.put(ProfileController());

  @override
  void onInit() async {
    super.onInit();
    await getUserList();
    await getChatRoomList();
    await getContacts();
  }

  // Fetch user list from Firestore and populate userList
  Future<void> getUserList() async {
    isLoading.value = true;
    try {
      userList.clear();
      await db.collection("users").get().then((value) {
        userList.value =
            value.docs.map((e) => UserModel.fromJson(e.data())).toList();
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
    isLoading.value = false;
  }

  // Fetch chat rooms and filter only those relevant to current user
  Future<void> getChatRoomList() async {
    try {
      List<ChatRoomModel> myChatRoomList = [];

      await db
          .collection('chats')
          .orderBy('timeStamp', descending: true)
          .get()
          .then((value) {
            myChatRoomList =
                value.docs
                    .map((e) => ChatRoomModel.fromJson(e.data()))
                    .toList();
          });

      // Filter chat rooms where current user is sender or receiver
      chatRoomList.value =
          myChatRoomList
              .where((e) => e.id!.contains(auth.currentUser!.uid))
              .toList(); // Convert Iterable to List
    } catch (e) {
      print("Error fetching chat rooms: $e");
    }
  }

  // Save contact to Firestore
  Future<void> saveContact(UserModel user) async {
    isLoading.value = true;

    try {
      String currentUserId = auth.currentUser!.uid;

      // Create a contact document under /users/{currentUserId}/contacts/
      await db.collection('users')
          .doc(currentUserId)
          .collection('contacts')
          .doc(user.id)  // Save the contact's user ID
          .set(user.toJson()); // Assuming UserModel has a toJson method

      // Optionally: You could also add the contact to the target user's contact list
      await db.collection('users')
          .doc(user.id)  // Target user's ID
          .collection('contacts')
          .doc(currentUserId)  // Add current user as a contact
          .set(profileController.currentUser.value.toJson());

      print("Contact saved successfully.");
    } catch (e) {
      print("Error saving contact: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch contacts from Firestore and return as a stream
  Stream<List<UserModel>> getContacts() {
    return db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("contacts")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
  }
}
