import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:dou_fire/theme.dart';
import '../../models/models.dart';
import '../../actions/actions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登陆'),
      ),
      body: _Login(),
    );
  }
}

class _Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  final _formKey = GlobalKey<FormState>();
  final _form = LoginFrom();
  //控制焦点
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
      });

      StoreProvider.of(context).dispatch(accountLoginAction(
        onSucceed: (UserEntity user) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacementNamed('/tab');
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
        form: _form,
      ));
    }
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.account_circle),
                          hintText: '用户名',
                        ),
                        onSaved: (newValue) => _form.username = newValue!,
                        focusNode: _usernameFocus,
                        textInputAction: TextInputAction.next,
                        //验证逻辑处理
                        // validator: (v) => '',
                        onEditingComplete: () {
                          _usernameFocus.unfocus();
                          //密码输入框获取焦点
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.vpn_key),
                          hintText: '密码',
                        ),
                        obscureText: true,
                        onSaved: (value) => _form.password = value!,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: _submit,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: DFTheme.marginSizeNormal),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                //样式方式1
                                /*
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.all(
                                        DFTheme.paddingSizeNormal),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColorDark),
                                ),*/
                                // 样式方式2
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColorDark,
                                  padding: const EdgeInsets.all(
                                      DFTheme.paddingSizeNormal),
                                ),
                                onPressed: _submit,
                                child: Text(
                                  '登陆',
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
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '还没有账号？',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/register'),
                      child: Text(
                        '注册一个',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    )
                  ],
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
