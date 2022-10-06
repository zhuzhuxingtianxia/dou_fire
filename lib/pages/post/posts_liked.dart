import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../components/components.dart';

class PostsLikePage extends StatelessWidget {
  final int userId;

  PostsLikePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      builder: (context, vm) => Scaffold(
        appBar: AppBar(
          title: const Text('喜欢'),
        ),
        body: _Body(
          store: StoreProvider.of<AppState>(context),
          vm: vm,
        ),
      ),
      converter: (store) => _ViewModel(
        userId: userId,
        postsLiked: (store.state.postState.postsLiked[userId.toString()] ?? [])
            .map<PostEntity>((v) => store.state.postState.posts[v.toString()]!)
            .toList(),
      ),
    );
  }
}

class _ViewModel {
  final int userId;
  final List<PostEntity> postsLiked;

  _ViewModel({
    required this.userId,
    required this.postsLiked,
  });
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;
  const _Body({required this.store, required this.vm});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _scrollController = ScrollController();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    _loadPostsLiked(recent: true, more: false);
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
      _loadPostsLiked();
    }
  }

  void _loadPostsLiked({
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
    if (more && widget.vm.postsLiked.isNotEmpty) {
      beforeId = widget.vm.postsLiked.last.id;
    }

    int? afterId;
    if (recent && widget.vm.postsLiked.isNotEmpty) {
      afterId = widget.vm.postsLiked.first.id;
    }

    widget.store.dispatch(postsLikedAction(
      userId: widget.vm.userId,
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (posts) {
        setState(() {
          _isLoading = false;
        });

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
    _loadPostsLiked(
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
            itemCount: widget.vm.postsLiked.length,
            itemBuilder: (context, index) => Post(
              key: Key(widget.vm.postsLiked[index].id.toString()),
              post: widget.vm.postsLiked[index],
            ),
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
