import 'package:dou_fire/pages/tab.dart';
import 'package:flutter/material.dart';

import '../../pages/pages.dart';

class DFTabBar extends StatelessWidget {
  static final tabs = [
    {
      'title': '首页',
      'icon': const Icon(Icons.home),
      'builder': (BuildContext context) => const HomePage()
    },
    {
      'title': '发布',
      'icon': const Icon(Icons.add),
      'builder': (BuildContext context) => const PublishPage()
    },
    {
      'title': '我',
      'icon': const Icon(Icons.account_circle),
      'builder': (BuildContext context) => const MePage()
    },
  ];

  final int tabIndex;

  const DFTabBar({super.key, this.tabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: tabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => TabPage.globalKey.currentState?.switchTab(index),
      items: tabs
          .map<BottomNavigationBarItem>(
            (e) => BottomNavigationBarItem(
              icon: e['icon'] as Widget,
              label: e['title'] as String,
            ),
          )
          .toList(),
    );
  }
}
