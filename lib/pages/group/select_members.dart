import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/my_images.dart';
import '../../controller/group_controller.dart';

class SelectedMembers extends StatelessWidget {
  const SelectedMembers({super.key});

  @override
  Widget build(BuildContext context) {
    GroupController groupController = Get.put(GroupController());

    return Obx(
          () => Row(
        children:
        groupController.groupMembers
            .map(
              (e) => Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: CachedNetworkImage(
                    imageUrl:
                    e.profilePic ??
                        MyImages.defaultProfileUrl1,
                    placeholder:
                        (context, url) =>
                    const CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) =>
                    const Icon(Icons.person),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      groupController.groupMembers.remove(e);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.close, size: 16, color: Colors.black,),
                    ),
                  )
              )],
          ),
        )
            .toList(),
      ),
    );
  }
}
