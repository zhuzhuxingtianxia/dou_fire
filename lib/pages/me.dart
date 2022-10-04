import 'package:dou_fire/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../theme.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: _Me(),
    );
  }
}

class _Me extends StatefulWidget {
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
          padding: const EdgeInsets.all(DFTheme.paddingSizeNormal),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: DFTheme.marginSizeNormal),
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
              ],
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
