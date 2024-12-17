import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';

class RoundedTabBar extends StatelessWidget {
  final TabController tabController;
  final List<Widget> tabs;
  final String? label;

  const RoundedTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ButtonsTabBar(
              duration: 50,
              borderWidth: 0,
              splashColor: Colors.transparent,
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                color: Colors.grey.shade100,
                fontWeight: FontWeight.w600,
              ),
              contentCenter: true,
              radius: 100,
              tabs: tabs,
              controller: tabController,
              unselectedBackgroundColor: Colors.grey.shade100,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
