import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controller/profile_controller.dart';
import '../../config/my_images.dart'; // Custom SVG paths and images

class ReceiverUserInfo extends StatelessWidget {
  final String? profileImage; // Nullable: may be null or empty
  final String userName;
  final String userEmail;

  const ReceiverUserInfo({
    super.key,
    required this.profileImage,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Column(
        children: [
          // Profile image section
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: _buildProfileImage(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // User name
          Text(
            userName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          // User email
          Text(
            userEmail,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 20),

          // Action buttons row (Call, Video, Chat)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                iconPath: MyImages.profileAudioCallSvg,
                text: "Call",
                color: const Color(0xff039C00),
              ),
              _buildActionButton(
                iconPath: MyImages.profileVideoCallSvg,
                text: "Video",
                color: const Color(0xffFF9900),
              ),
              _buildActionButton(
                iconPath: MyImages.appIconSVG,
                text: "Chat",
                color: const Color(0xff0057FF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the user profile image widget.
  /// If the profileImage URL is empty or null, shows a local asset image.
  Widget _buildProfileImage() {
    if (profileImage != null && profileImage!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: profileImage!,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            Image.asset(MyImages.defaultProfileUrl1, fit: BoxFit.cover),
      );
    } else {
      // Show local fallback image when no profileImage is set
      return Image.asset(
        MyImages.defaultProfileUrl1,
        fit: BoxFit.cover,
      );
    }
  }

  /// Builds a reusable action button with icon and label
  Widget _buildActionButton({
    required String iconPath,
    required String text,
    required Color color,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Get.theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 25,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
