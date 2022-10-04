import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:dou_fire/actions/actions.dart';
import 'package:dou_fire/models/entity/notice.dart';
import 'package:dou_fire/models/entity/user.dart';
import 'package:dou_fire/models/form/account.dart';
import 'package:dou_fire/models/state/app.dart';
import 'package:dou_fire/theme.dart';
import '../common/input.dart';
import 'edit_mobile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        user: store.state.accountState.user,
      ),
      builder: ((context, vm) => Scaffold(
            appBar: AppBar(
              title: const Text('个人资料'),
            ),
            body: _Body(store: StoreProvider.of<AppState>(context), vm: vm),
          )),
    );
  }
}

class _ViewModel {
  final UserEntity user;

  _ViewModel({
    required this.user,
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
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadAccountInfo();
  }

  void _loadAccountInfo() {
    setState(() {
      _isLoading = true;
    });

    widget.store.dispatch(accountInfoAction(
      onSucceed: (user) {
        setState(() {
          _isLoading = false;
        });
      },
      onFailed: (NoticeEntity notice) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => InputPage(
                      title: '设置用户名',
                      hintText: '2-20 个中英文字符',
                      initialValue: widget.vm.user.username,
                      submit: (
                              {required input,
                              required onSucceed,
                              required onFailed}) =>
                          widget.store.dispatch(accountEditAction(
                        form: ProfileForm(username: input),
                        onSucceed: (user) => onSucceed(),
                        onFailed: onFailed,
                      )),
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                title: const Text(
                  '用户名',
                  style: TextStyle(fontSize: DFTheme.fontSizeLarge),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      widget.vm.user.username,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditMobilePage(
                      initialForm: ProfileForm(mobile: widget.vm.user.mobile),
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                title: const Text(
                  '手机',
                  style: TextStyle(fontSize: DFTheme.fontSizeLarge),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      widget.vm.user.mobile.isEmpty
                          ? '未填写'
                          : widget.vm.user.mobile,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
            ],
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
