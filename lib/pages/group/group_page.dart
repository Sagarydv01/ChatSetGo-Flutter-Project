import 'package:chatsetgo/pages/homepage/chat_tile.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ChatTile(
          name: "Group Name",
          lastMessage: "last message",
          lastMessageTime: "lastMessageTime",
        ),
      ],
    );
  }
}
