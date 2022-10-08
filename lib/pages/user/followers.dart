import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../components/components.dart';

// 粉丝界面
class FollowersPage extends StatelessWidget {
  final int userId;

  const FollowersPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        userId: userId,
        followers: (store.state.userState.followers[userId.toString()] ?? [])
            .map<UserEntity>((v) => store.state.userState.users[v.toString()]!)
            .toList(),
      ),
      builder: (context, vm) => Scaffold(
        appBar: AppBar(
          title: const Text('粉丝'),
        ),
        body: _Body(
          store: StoreProvider.of<AppState>(context),
          vm: vm,
        ),
      ),
    );
  }
}

class _ViewModel {
  final int userId;
  final List<UserEntity> followers;

  _ViewModel({
    required this.userId,
    required this.followers,
  });
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;

  const _Body({
    required this.store,
    required this.vm,
  });

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
    _loadFollowers(recent: true, more: false);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadFollowers();
    }
  }

  void _loadFollowers({
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

    int? offset;
    if (more) {
      offset = widget.vm.followers.length;
    }

    widget.store.dispatch(followersAction(
      userId: widget.vm.userId,
      offset: offset,
      refresh: refresh,
      onSucceed: (users) {
        setState(() {
          _isLoading = false;
        });

        completer?.complete();
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });

        completer?.complete();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  Future _refresh() {
    final completer = Completer();
    _loadFollowers(
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
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) => UserTile(
              key: Key(widget.vm.followers[index].id.toString()),
              user: widget.vm.followers[index],
            ),
            separatorBuilder: (context, index) => const Divider(
              height: 1,
            ),
            itemCount: widget.vm.followers.length,
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
