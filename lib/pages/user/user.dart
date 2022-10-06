import 'package:cached_network_image/cached_network_image.dart';
import 'package:dou_fire/theme.dart';
import 'package:dou_fire/utils/number.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../components/components.dart';

class UserPage extends StatefulWidget {
  final int userId;
  const UserPage({super.key, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _tabs = ['动态', '喜欢', '关注'];
  static final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        user: store.state.userState.users[widget.userId.toString()] ??
            UserEntity(id: widget.userId),
        postsPublished: (store
                    .state.postState.postsLiked[widget.userId.toString()] ??
                [])
            .map<PostEntity>((v) => store.state.postState.posts[v.toString()]!)
            .toList(),
        postsLiked: (store
                    .state.postState.postsLiked[widget.userId.toString()] ??
                [])
            .map<PostEntity>((v) => store.state.postState.posts[v.toString()]!)
            .toList(),
        usersFollowing: (store
                    .state.userState.usersFollowing[widget.userId.toString()] ??
                [])
            .map<UserEntity>((v) => store.state.userState.users[v.toString()]!)
            .toList(),
      ),
      builder: (context, vm) => Scaffold(
        body: DefaultTabController(
          length: _tabs.length,
          child: _Body(
            store: StoreProvider.of<AppState>(context),
            vm: vm,
            tabs: _tabs,
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final UserEntity user;
  final List<PostEntity> postsPublished;
  final List<PostEntity> postsLiked;
  final List<UserEntity> usersFollowing;

  _ViewModel({
    required this.user,
    required this.postsPublished,
    required this.postsLiked,
    required this.usersFollowing,
  });
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;
  final List<String> tabs;

  const _Body({
    required this.store,
    required this.vm,
    required this.tabs,
  });

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final scrollController = ScrollController();

  var _isLoading = false;
  var _isLoadingPostsPublished = false;
  var _isLoadingPostsLiked = false;
  var _isLoadingUsersFollowing = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);

    _loadUserInfo();
    _loadPostsPublished(recent: true, more: false);
    _loadPostsLiked(recent: true, more: false);
    _loadUsersFollowing(recent: true, more: false);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    final index = DefaultTabController.of(context)?.index;
    // 判断是否滚动到底部
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (index == 0) {
        _loadPostsPublished();
      } else if (index == 1) {
        _loadPostsLiked();
      } else if (index == 2) {
        _loadUsersFollowing();
      }
    }
  }

  void _loadUserInfo() {
    widget.store.dispatch(userInfoAction(
      userId: widget.vm.user.id,
      onFailed: (notice) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ),
      ),
    ));
  }

  void _loadPostsPublished({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<void>? completer,
  }) {
    if (_isLoadingPostsPublished) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoadingPostsPublished = true;
      });
    }

    int? beforeId;
    if (more && widget.vm.postsPublished.isNotEmpty) {
      beforeId = widget.vm.postsPublished.last.id;
    }
    int? afterId;
    if (recent && widget.vm.postsPublished.isNotEmpty) {
      afterId = widget.vm.postsPublished.first.id;
    }

    widget.store.dispatch(postsPublishedAction(
      userId: widget.vm.user.id,
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoadingPostsPublished = false;
          });
        }

        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoadingPostsPublished = false;
          });
        }

        completer?.complete();
      },
    ));
  }

  void _loadPostsLiked({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<void>? completer,
  }) {
    if (_isLoadingPostsLiked) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoadingPostsLiked = true;
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
      userId: widget.vm.user.id,
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoadingPostsLiked = false;
          });
        }

        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoadingPostsLiked = false;
          });
        }

        completer?.complete();
      },
    ));
  }

  void _loadUsersFollowing({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<void>? completer,
  }) {
    if (_isLoadingUsersFollowing) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoadingUsersFollowing = true;
      });
    }

    int? offset;
    if (more) {
      offset = widget.vm.usersFollowing.length;
    }

    widget.store.dispatch(usersFollowingAction(
      userId: widget.vm.user.id,
      offset: offset,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoadingUsersFollowing = false;
          });
        }

        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoadingUsersFollowing = false;
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

  // 关注
  void _followUser() {
    setState(() {
      _isLoading = true;
    });

    // widget.store.dispatch(followUserAction());
  }

  //取消关注
  void _unfollowUser() {
    setState(() {
      _isLoading = true;
    });

    // widget.store.dispatch(unfollowUserAction());
  }

  void _followOrUnfollowUser() {
    if (widget.vm.user.isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  Widget _buildSilverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        actions: <Widget>[
          TextButton(
            onPressed: _followOrUnfollowUser,
            child: Text(
              widget.vm.user.isFollowing ? '取消关注' : '关注',
              style: TextStyle(
                color: DFTheme.whiteNormal,
                fontSize: DFTheme.fontSizeLarge,
              ),
            ),
          ),
        ],
        expandedHeight: MediaQuery.of(context).size.width * 3 / 4,
        forceElevated: innerBoxIsScrolled,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            image: widget.vm.user.avatar == ''
                ? null
                : DecorationImage(
                    image: CachedNetworkImageProvider(widget.vm.user.avatar),
                    fit: BoxFit.cover,
                  ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  widget.vm.user.username,
                  style: TextStyle(
                    color: DFTheme.whiteLight,
                    fontSize: DFTheme.fontSizeLarge,
                    fontWeight: DFTheme.fontWeightHeavy,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  widget.vm.user.intro,
                  maxLines: 3,
                  style: TextStyle(color: DFTheme.whiteNormal),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: DFTheme.whiteNormal),
                    children: <TextSpan>[
                      TextSpan(
                        style: TextStyle(color: DFTheme.whiteLight),
                        text: numberWithProperUnit(widget.vm.user.postCount),
                      ),
                      const TextSpan(text: ' 动态 '),
                      TextSpan(
                        style: TextStyle(color: DFTheme.whiteLight),
                        text: numberWithProperUnit(widget.vm.user.likeCount),
                      ),
                      const TextSpan(text: ' 喜欢 '),
                      TextSpan(
                        style: TextStyle(color: DFTheme.whiteLight),
                        text:
                            numberWithProperUnit(widget.vm.user.followingCount),
                      ),
                      const TextSpan(text: ' 关注 '),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom: TabBar(
          tabs: widget.tabs
              .map<Widget>((name) => Tab(
                    text: name,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Future<void> _refreshPostsPublished() {
    final completer = Completer();
    _loadPostsPublished(
      more: false,
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  Widget _buildPostsPublished(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refreshPostsPublished,
          child: CustomScrollView(
            key: const PageStorageKey<String>('postsPublished'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Post(
                    key: Key(widget.vm.postsPublished[index].id.toString()),
                    post: widget.vm.postsPublished[index],
                  ),
                  childCount: widget.vm.postsPublished.length,
                ),
              ),
              Visibility(
                visible: _isLoadingPostsPublished,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _refreshPostsLiked() {
    final completer = Completer();
    _loadPostsLiked(
      more: false,
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  Widget _buildPostsLiked(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refreshPostsLiked,
          child: CustomScrollView(
            key: const PageStorageKey<String>('postsLiked'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Post(
                    key: Key(widget.vm.postsLiked[index].id.toString()),
                    post: widget.vm.postsLiked[index],
                  ),
                  childCount: widget.vm.postsLiked.length,
                ),
              ),
              Visibility(
                visible: _isLoadingPostsLiked,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _refreshUsersFollowing() {
    final completer = Completer();
    _loadUsersFollowing(
      more: false,
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  Widget _buildUsersFollowing(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refreshUsersFollowing,
          child: CustomScrollView(
            key: const PageStorageKey<String>('usersFollowing'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => UserTile(
                    key: Key(widget.vm.usersFollowing[index].id.toString()),
                    user: widget.vm.usersFollowing[index],
                  ),
                  childCount: widget.vm.usersFollowing.length,
                ),
              ),
              Visibility(
                visible: _isLoadingUsersFollowing,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      children: widget.tabs
          .map<Widget>((name) => SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (context) {
                    if (name == '动态') {
                      return _buildPostsPublished(context);
                    } else if (name == '喜欢') {
                      return _buildPostsLiked(context);
                    } else if (name == '关注') {
                      return _buildUsersFollowing(context);
                    } else {
                      return const Divider(height: 0);
                    }
                  },
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            _buildSilverAppBar(context, innerBoxIsScrolled),
          ],
          body: _buildTabBarView(),
          controller: scrollController,
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
