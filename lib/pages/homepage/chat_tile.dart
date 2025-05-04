import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String lastMessageTime;
  final String? profilePic; // Profile picture URL, nullable

  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    this.profilePic,
  });

  // Generates a pastel color based on the name hash
  Color _colorFromName(String name) {
    final h = name.hashCode;
    final rand = Random(h);
    return Color.fromARGB(
      255,
      120 + rand.nextInt(136),
      120 + rand.nextInt(136),
      120 + rand.nextInt(136),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _colorFromName(name);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Avatar circle
          ClipOval(
            child: profilePic != null && profilePic!.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: profilePic!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) => Container(
                color: bgColor,
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: const Icon(Icons.person, color: Colors.white, size: 30),
              ),
            )
                : Container(
              color: bgColor,
              width: 60,
              height: 60,
              alignment: Alignment.center,
              child: const Icon(Icons.person, color: Colors.white, size: 30),
            ),
          ),

          const SizedBox(width: 15),

          // Name and last message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                Text(
                  lastMessage,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),

          // Message time
          const SizedBox(width: 10),
          Text(
            lastMessageTime,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
