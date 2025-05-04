import 'package:chatsetgo/config/my_images.dart';
import 'package:chatsetgo/config/my_strings.dart';
import 'package:chatsetgo/controller/image_picker_controller.dart';
import 'package:chatsetgo/pages/homepage/chat_list.dart';
import 'package:chatsetgo/pages/homepage/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controller/contact_controller.dart';
import '../group/group_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Instantiate the required controllers
    ContactController contactController = Get.put(ContactController());
    ImagePickerController imagePickerController = Get.put(ImagePickerController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          AppString.appName,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(MyImages.appIconSVG, width: 100),
        ),
        actions: [
          IconButton(onPressed: () {
            contactController.getChatRoomList();
          },
              icon: const Icon(Icons.search)),
          IconButton(onPressed: () {
            Get.toNamed("/profilePage");
          },
              icon: const Icon(Icons.more_vert)),
        ],
        bottom: myTabBar(tabController, context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/contactPage");
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TabBarView(
          controller: tabController,
          children: [
            ChatList(),
            GroupPage(),
            Container(
              alignment: Alignment.center,
              child: Text('Calls View'), // Placeholder for Calls tab
            ),
          ],
        ),
      ),
    );
  }
}
