import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../theme.dart';
import '../../actions/actions.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册'),
      ),
      body: const Center(
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();
  final _form = RegisterFrom();
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

      StoreProvider.of(context).dispatch(accountRegisterAction(
        onSucceed: (UserEntity user) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop(true);
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
                          label: Text('用户名'),
                          hintText: '2-20 个中英文字符',
                        ),
                        onSaved: (value) => _form.username = value!,
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
                          label: Text('密码'),
                          hintText: '长度 6-20',
                        ),
                        obscureText: true,
                        onSaved: (value) => _form.password = value!,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: _submit,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: DFTheme.marginSizeNormal,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColorDark,
                                  padding: const EdgeInsets.all(
                                      DFTheme.paddingSizeNormal),
                                ),
                                onPressed: _submit,
                                child: Text(
                                  '注册',
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
