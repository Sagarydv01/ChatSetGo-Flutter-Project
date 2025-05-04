import 'package:flutter/material.dart';

PreferredSizeWidget myTabBar(TabController tabController, BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: TabBar(
      controller: tabController,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 4,
      labelStyle: Theme.of(context).textTheme.labelLarge,
      unselectedLabelStyle: Theme.of(context).textTheme.labelLarge,
      indicatorColor: Theme.of(context).colorScheme.primary,
      tabs: const [
        Tab(text: "Chats"),
        Tab(text: "Groups"),
        Tab(text: "Calls"),
      ],
    ),
  );
}
