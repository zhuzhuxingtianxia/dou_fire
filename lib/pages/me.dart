import 'package:cached_network_image/cached_network_image.dart';
import 'package:dou_fire/config.dart';
import 'package:dou_fire/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/components.dart';
import '../../models/models.dart';
import '../../actions/actions.dart';
import '../theme.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        user: store.state.accountState.user,
      ),
      builder: (context, vm) => Scaffold(
        appBar: AppBar(
          title: const Text('我的'),
        ),
        body: _Me(
          store: StoreProvider.of<AppState>(context),
          vm: vm,
        ),
        bottomNavigationBar: const DFTabBar(
          tabIndex: 2,
        ),
      ),
    );
  }
}

class _ViewModel {
  final UserEntity user;

  const _ViewModel({
    required this.user,
  });
}

class _Me extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;

  const _Me({
    required this.store,
    required this.vm,
  });
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<_Me> {
  var _isLoading = false;

  void _logout() {
    setState(() {
      _isLoading = true;
    });
    // widget.store
    StoreProvider.of(context).dispatch(
      accountLogoutAction(onSucceed: () {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(TabPage.globalKey.currentContext!)
            .pushReplacementNamed('/login');
        // 或者
        // Navigator.of(context, rootNavigator: true)
        //     .pushReplacementNamed('/login');
      }, onFailed: (NoticeEntity notice) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: GestureDetector(
                      onTap: Feedback.wrapForTap(
                          () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserPage(userId: widget.vm.user.id),
                                ),
                              ),
                          context),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: widget.vm.user.avatar == ''
                            ? null
                            : CachedNetworkImageProvider(widget.vm.user.avatar),
                        child: widget.vm.user.avatar == ''
                            ? const Icon(Icons.account_circle)
                            : null,
                      ),
                    ),
                    title: Text(
                      widget.vm.user.username,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(widget.vm.user.mobile.isEmpty
                        ? '尚未填写手机'
                        : widget.vm.user.mobile),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostsLikePage(
                          userId: widget.vm.user.id,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: const Text('喜欢'),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UsersFollowingPage(
                          userId: widget.vm.user.id,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: const Text('关注'),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FollowersPage(
                          userId: widget.vm.user.id,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: const Text('粉丝'),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: DFTheme.marginSizeNormal),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorDark,
                        padding:
                            const EdgeInsets.all(DFTheme.paddingSizeNormal),
                      ),
                      onPressed: _logout,
                      child: Text(
                        '退出',
                        style: TextStyle(
                          color: DFTheme.whiteLight,
                          fontSize: DFTheme.fontSizeLarge,
                          letterSpacing: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                  '${Config.packageInfo.appName} v${Config.packageInfo.version} @${Config.domain}'),
            ),
          ],
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
