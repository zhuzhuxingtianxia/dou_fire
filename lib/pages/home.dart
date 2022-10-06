import 'dart:async';

import 'package:dou_fire/actions/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../components/components.dart';
import '../models/models.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        postsFollowing: store.state.postState.postsFollowing
            .map<PostEntity>((v) => store.state.postState.posts[v.toString()]!)
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

class _ViewModel {
  final List<PostEntity> postsFollowing;
  _ViewModel({required this.postsFollowing});
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;

  const _Body({super.key, required this.store, required this.vm});

  @override
  State<StatefulWidget> createState() {
    return _BodyState();
  }
}

class _BodyState extends State<_Body> {
  final _scrollController = ScrollController();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    _loadPostsFollowing(recent: true, more: false);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  void _scrollListener() {
    // 判断是否滚动到底部
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadPostsFollowing();
    }
  }

  void _loadPostsFollowing({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<void>? completer,
  }) {
    if (_isLoading) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoading = true;
      });
    }

    int? beforeId;
    if (more && widget.vm.postsFollowing.isNotEmpty) {
      beforeId = widget.vm.postsFollowing.last.id;
    }

    int? afterId;
    if (recent && widget.vm.postsFollowing.isNotEmpty) {
      afterId = widget.vm.postsFollowing.first.id;
    }

    widget.store.dispatch(postsFollowingAcction(
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoading = false;
          });
        }

        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoading = false;
          });
        }

        completer?.complete();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  Future<void> _refresh() {
    final completer = Completer<void>();
    _loadPostsFollowing(
      more: false,
      refresh: true,
      completer: completer,
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.vm.postsFollowing.length,
            itemBuilder: (context, index) => Post(
                key: Key(widget.vm.postsFollowing[index].id.toString()),
                post: widget.vm.postsFollowing[index]),
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
