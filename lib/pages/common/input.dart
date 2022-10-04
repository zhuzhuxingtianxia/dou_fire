import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../theme.dart';
import '../../models/models.dart';

class InputPage extends StatelessWidget {
  static final _bodyKey = GlobalKey<_BodyState>();

  final String title;
  final String hintText;
  final String initialValue;
  final int? maxLength;
  final int? maxLines;
  final bool obscureText;
  final Function(
      {required String input,
      required void Function() onSucceed,
      required void Function(NoticeEntity) onFailed}) submit;
  final FormFieldValidator<String>? validator;

  const InputPage({
    super.key,
    this.title = '',
    this.hintText = '',
    this.initialValue = '',
    this.maxLength,
    this.maxLines,
    this.obscureText = false,
    required this.submit,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
          )
        ],
      ),
      body: _Body(
        key: _bodyKey,
        initialValue: initialValue,
        hintText: hintText,
        maxLength: maxLength,
        maxLines: maxLines,
        obscureText: obscureText,
        submit: submit,
        validator: validator,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final String hintText;
  final String initialValue;
  final int? maxLength;
  final int? maxLines;
  final bool obscureText;
  final Function(
      {required String input,
      required void Function() onSucceed,
      required void Function(NoticeEntity) onFailed}) submit;
  final FormFieldValidator<String>? validator;

  const _Body({
    super.key,
    required this.hintText,
    required this.initialValue,
    this.maxLength,
    this.maxLines,
    required this.obscureText,
    required this.submit,
    this.validator,
  });

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _textcontroller;
  var input = '';

  @override
  void initState() {
    super.initState();

    _textcontroller = TextEditingController(text: widget.initialValue);
  }

  void submit() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.submit(
          input: input,
          onSucceed: () => Navigator.of(context).pop(),
          onFailed: (notice) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(notice.message),
                  duration: notice.duration,
                ),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DFTheme.paddingSizeNormal),
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: widget.hintText,
              suffixIcon: IconButton(
                onPressed: () => _textcontroller.clear(),
                icon: const Icon(Icons.clear),
              ),
            ),
            validator: widget.validator,
            onSaved: (v) => input = v ?? '',
            autofocus: true,
            maxLength: widget.maxLength,
            maxLengthEnforcement:
                MaxLengthEnforcement.truncateAfterCompositionEnds,
            maxLines: widget.maxLines,
            obscureText: widget.obscureText,
            controller: _textcontroller,
          ),
        ],
      ),
    );
  }
}
