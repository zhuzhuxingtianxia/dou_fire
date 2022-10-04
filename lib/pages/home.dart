import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:dou_fire/components/components.dart';
import 'package:dou_fire/models/models.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        postsFollowing: store.state.postState.postsFollowing
            .map<PostEntity?>((v) => store.state.postState.posts[v.toString()])
            .toList(),
      ),
      builder: (context, vm) => Scaffold(
        appBar: AppBar(
          title: const Text('首页'),
        ),
        body: _Body(
          key: _bodyKey,
          store: StoreProvider.of<AppState>(context),
          vm: vm,
        ),
        bottomNavigationBar: const DFTabBar(tabIndex: 0),
      ),
    );
  }
}

class _ViewModel {}

class _BodyState extends State<HomePage> {}
