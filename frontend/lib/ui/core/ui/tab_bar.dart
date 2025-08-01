import 'package:flutter/material.dart';

class AppTabBar extends StatefulWidget {
  final List<String> labels;
  final List<Widget> children;

  const AppTabBar(this.labels, this.children, {super.key});

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.children.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: tabController,
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSecondary,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.secondary,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              dividerHeight: 0,
              tabs: widget.labels.map((l) => Tab(text: l)).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
              height: 500,
              child: TabBarView(
                controller: tabController,
                children: widget.children,
              )),
        ],
      ),
    );
  }
}
