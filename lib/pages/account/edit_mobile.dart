import 'package:dou_fire/actions/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:dou_fire/models/models.dart';
import 'package:dou_fire/theme.dart';

class EditMobilePage extends StatelessWidget {
  static final _bodyKey = GlobalKey<_BodyState>();

  final ProfileForm initialForm;
  EditMobilePage({super.key, initialForm})
      : initialForm = initialForm ?? ProfileForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置手机'),
        actions: <Widget>[
          TextButton(
            onPressed: () => _bodyKey.currentState!.submit(),
            child: Text(
              '完成',
              style: TextStyle(
                color: DFTheme.whiteNormal,
                fontSize: DFTheme.fontSizeLarge,
              ),
            ),
          ),
        ],
      ),
      body: _Body(
        key: _bodyKey,
        store: StoreProvider.of<AppState>(context),
        initialForm: initialForm,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final ProfileForm initialForm;

  const _Body({super.key, required this.store, required this.initialForm});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();

  late ProfileForm _form;
  @override
  void initState() {
    super.initState();

    _form = widget.initialForm;
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.store.dispatch(accountEditAction(
        form: _form,
        onSucceed: (user) => Navigator.of(context).pop(),
        onFailed: (notice) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notice.message),
            duration: notice.duration,
          ),
        ),
      ));
    }
  }

  void _sendVerifyCode() {
    _formKey.currentState!.save();

    widget.store.dispatch(
      accountSendMobileVerifyCodeAction(
        mobile: _form.mobile ?? '',
        onSucceed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('发送成功'),
          ),
        ),
        onFailed: (notice) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notice.message),
            duration: notice.duration,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DFTheme.paddingSizeNormal),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '手机号',
                    suffixIcon: IconButton(
                      onPressed: _sendVerifyCode,
                      icon: const Icon(Icons.send),
                    ),
                  ),
                  initialValue: _form.mobile,
                  onSaved: (value) => _form.mobile = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '验证码，6 位数字',
                  ),
                  onSaved: (value) => _form.code = value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
