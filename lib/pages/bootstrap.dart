import 'package:dou_fire/actions/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:dou_fire/models/state/app.dart';

// 启动页
class BootstrapPage extends StatelessWidget {
  const BootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  var _isFailed = false;

  @override
  void initState() {
    super.initState();

    _bootstrap();
  }

  void _bootstrap() {
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(accountInfoAction(
      onSucceed: (user) {
        //  pushReplacementNamed 替换界面
        Navigator.of(context)
            .pushReplacementNamed(user.id == 0 ? '/login' : '/tab');
      },
      onFailed: (notice) {
        setState(() {
          _isFailed = true;
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
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(flex: 5),
          // 安百分比缩放的盒子
          const FractionallySizedBox(
            widthFactor: 0.3,
            child: Image(
              image: AssetImage('assets/logo_1024.png'),
            ),
          ),
          const Spacer(),
          _isFailed
              ? Column(
                  children: <Widget>[
                    const Text('网络请求出错'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isFailed = false;
                        });
                        _bootstrap();
                      },
                      child: const Text(
                        '再试一次',
                        style: TextStyle(color: Colors.blue),
                        // TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                    )
                  ],
                )
              : const Text('网络请求中...'),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
