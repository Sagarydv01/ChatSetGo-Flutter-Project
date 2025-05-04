import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/my_images.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isComing;
  final String time;
  final String imageUrl;
  final String messageStatus;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isComing,
    required this.time,
    required this.imageUrl,
    required this.messageStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isComing ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 9.0),
          child: Column(
            crossAxisAlignment: isComing ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              // Chat bubble container
              Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: isComing
                      ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )
                      : const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),

                // If imageUrl is empty, show only text message
                // Else, show cached image (if available) and optional text below
                child: imageUrl.isEmpty
                    ? Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cached image with placeholder and error handling
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Optional message under the image
                    message.isEmpty
                        ? const SizedBox()
                        : Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              // Display time and status if message is sent (not received)
              isComing
                  ? Text(time)
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    MyImages.chatStatusSvg,
                    width: 25,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
