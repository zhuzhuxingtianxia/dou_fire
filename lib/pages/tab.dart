import 'package:flutter/material.dart';

import '../components/components.dart';

class TabPage extends StatefulWidget {
  static final globalKey = GlobalKey<_TabPageSate>();

  TabPage() : super(key: globalKey);

  @override
  // ignore: library_private_types_in_public_api
  _TabPageSate createState() => _TabPageSate();
}

class _TabPageSate extends State<TabPage> {
  final _navigatorKeys = DFTabBar.tabs
      .map<GlobalKey<NavigatorState>>((v) => GlobalKey<NavigatorState>())
      .toList();

  final _focusScopeNodes =
      DFTabBar.tabs.map<FocusScopeNode>((e) => FocusScopeNode()).toList();

  var _tabIndex = 0;

  void switchTab(int index) {
    setState(() {
      _tabIndex = index;
    });
    // 切换active的tab的焦点
    FocusScope.of(context).setFirstFocus(_focusScopeNodes[index]);
  }

  // 解决嵌套导航安卓物理键返回失效问题
  Future<bool> _onWillPop() async {
    final maybePop = await _navigatorKeys[_tabIndex].currentState?.maybePop();
    // 判断tab是否能返回，取反让其走根导航
    return Future.value(!maybePop!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: IndexedStack(
        index: _tabIndex,
        children: DFTabBar.tabs
            .asMap()
            .entries
            .map<Widget>(
              (entry) => FocusScope(
                node: _focusScopeNodes[entry.key],
                child: Navigator(
                  key: _navigatorKeys[entry.key],
                  onGenerateRoute: (settings) {
                    WidgetBuilder builder;
                    switch (settings.name) {
                      case "/":
                        builder = entry.value['builder'] as WidgetBuilder;
                        break;
                      default:
                        throw Exception('Invalid route: ${settings.name}');
                    }
                    return MaterialPageRoute(
                        builder: builder, settings: settings);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
