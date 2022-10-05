import 'dart:io';

import 'package:dou_fire/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/models.dart';
import '../actions/actions.dart';
import '../components/components.dart';
import 'pages.dart';

class PublishPage extends StatelessWidget {
  static final _bodyKey = GlobalKey<_BodyState>();

  const PublishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        type: store.state.publishSate.type,
        text: store.state.publishSate.text,
        images: store.state.publishSate.images,
        videos: store.state.publishSate.videos,
      ),
      builder: (context, vm) => Scaffold(
        appBar: AppBar(
          title: const Text('发动态'),
          actions: <Widget>[
            GestureDetector(
              onTap: Feedback.wrapForTap(
                () => _bodyKey.currentState?.submit(),
                context,
              ),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                child: const Text(
                  '提交',
                  style: TextStyle(
                    fontSize: DFTheme.fontSizeLarge,
                  ),
                ),
              ),
            ),
            PopupMenuButton<String>(
              initialValue: PostType.image.toString(),
              onSelected: (value) => _bodyKey.currentState?.switchType(
                PostType.values.firstWhere((v) => v.toString() == value),
              ),
              itemBuilder: (context) => PostType.values
                  // skip(1)跳过第0个，从第1个开始
                  .skip(1)
                  .map<PopupMenuEntry<String>>((v) => PopupMenuItem<String>(
                        value: v.toString(),
                        child: Text(PostEntity.typeNames[v]!),
                      ))
                  .toList(),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                child: Text(
                  PostEntity.typeNames[vm.type] ?? '',
                  style: TextStyle(
                    fontSize: DFTheme.fontSizeLarge,
                    color: DFTheme.whiteNormal,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _Body(
          key: _bodyKey,
          store: StoreProvider.of<AppState>(context),
          vm: vm,
        ),
        bottomNavigationBar: const DFTabBar(
          tabIndex: 1,
        ),
      ),
    );
  }
}

class _ViewModel {
  final PostType type;
  final String text;
  final List<String> images;
  final List<String> videos;

  const _ViewModel({
    this.type = PostType.text,
    this.text = '',
    this.images = const [],
    this.videos = const [],
  });
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;
  const _Body({super.key, required this.store, required this.vm});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late TextEditingController _textEditingController;
  var _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(text: widget.vm.text);
  }

  void switchType(PostType type) {
    widget.store.dispatch(
      PublishSaveAction(
        type: type,
      ),
    );
  }

  void _saveText(String value) {
    widget.store.dispatch(
      PublishSaveAction(
        text: value.trim(),
      ),
    );
  }

  Future _addFile() async {
    var source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('从相册获取'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
          ListTile(
            title: const Text('用相机拍摄'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
        ],
      ),
    );

    if (source == null) {
      return;
    }

    if (widget.vm.type == PostType.image) {
      var file = await ImagePicker.platform.pickImage(source: source);
      if (file != null) {
        widget.store.dispatch(PublishAddImageAction(
          image: file.path,
        ));
      }
    } else if (widget.vm.type == PostType.video) {
      var file = await ImagePicker.platform.pickVideo(source: source);
      if (file != null) {
        widget.store.dispatch(PublishAddVideoAction(
          video: file.path,
        ));
      }
    }
  }

  _removeFile(File file) {
    if (widget.vm.type == PostType.image) {
      widget.store.dispatch(PublishRemoveImageAction(
        image: file.path,
      ));
    } else if (widget.vm.type == PostType.video) {
      widget.store.dispatch(PublishRemoveVideoAction(
        video: file.path,
      ));
    }
  }

  void submit() {
    if (_isSubmitting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请勿重复提交'),
        ),
      );
      return;
    }

    if ((widget.vm.type == PostType.text && widget.vm.text == '') ||
        (widget.vm.type == PostType.image && widget.vm.images.length == 0) ||
        (widget.vm.type == PostType.video && widget.vm.videos.length == 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('内容不能为空'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    widget.store.dispatch(
      publishPostAction(
        type: widget.vm.type,
        text: widget.vm.text,
        images: widget.vm.images,
        videos: widget.vm.videos,
        onSucceed: (id) {
          setState(() {
            _isSubmitting = false;
          });

          widget.store.dispatch(ResetPublishStateAction());
          _textEditingController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('发布成功'),
              duration: const Duration(hours: 24),
              action: SnackBarAction(
                onPressed: () =>
                    ScaffoldMessenger.of(context).removeCurrentSnackBar(),
                label: '知道了',
              ),
            ),
          );
        },
        onFailed: (notice) {
          setState(() {
            _isSubmitting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('发布失败：${notice.message}'),
              duration: const Duration(hours: 24),
              action: SnackBarAction(
                onPressed: () =>
                    ScaffoldMessenger.of(context).removeCurrentSnackBar(),
                label: '知道了',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePicker() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double margin = 5;
        const columns = 3;
        final width = (constraints.maxWidth - (columns - 1) * margin) / columns;
        final height = width;

        final images = widget.vm.images.map<File>((v) => File(v)).toList();

        final children = images
            .asMap()
            .entries
            .map<Widget>(
              (entry) => Container(
                width: width,
                height: height,
                color: DFTheme.greyLight,
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: Feedback.wrapForTap(
                          () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ImagesPlayerPage(
                                    files: images,
                                    initialIndex: entry.key,
                                  ),
                                ),
                              ),
                          context),
                      child: Image.file(
                        entry.value,
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: Feedback.wrapForTap(
                            () => _removeFile(entry.value), context),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.clear,
                            color: DFTheme.whiteLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList();

        if (widget.vm.images.length < 6) {
          children.add(
            GestureDetector(
              onTap: Feedback.wrapForTap(_addFile, context),
              child: Container(
                width: width,
                height: height,
                color: DFTheme.greyLight,
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: DFTheme.greyNormal,
                    size: 32,
                  ),
                ),
              ),
            ),
          );
        }

        return Wrap(
          spacing: margin,
          runSpacing: margin,
          children: children,
        );
      },
    );
  }

  Widget _buildVideoPicker() {
    final videos = widget.vm.videos.map<File>((v) => File(v));

    final children = videos
        .map<Widget>(
          (video) => Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              VideoPlayerWithControlBar(file: video),
              Container(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: Feedback.wrapForTap(() => _removeFile(video), context),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.clear,
                      color: DFTheme.whiteLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();

    // ignore: prefer_is_empty
    if (widget.vm.videos.length < 1) {
      children.add(
        AspectRatio(
          aspectRatio: 16 / 9,
          child: GestureDetector(
            onTap: Feedback.wrapForTap(_addFile, context),
            child: Center(
              child: Icon(
                Icons.add,
                color: DFTheme.greyNormal,
                size: 32,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          // 点击空白区域失去焦点
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          //ListView 内容过多可滚动
          child: ListView(
            padding: const EdgeInsets.all(DFTheme.paddingSizeNormal),
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: DFTheme.whiteLight,
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '说点啥',
                    border: InputBorder.none,
                  ),
                  onChanged: _saveText,
                  autofocus: widget.vm.type == PostType.text,
                  maxLength: widget.vm.type == PostType.text ? 10000 : 1000,
                  maxLengthEnforcement:
                      MaxLengthEnforcement.truncateAfterCompositionEnds,
                  maxLines: widget.vm.type == PostType.text ? 10 : 5,
                  controller: _textEditingController,
                ),
              ),
              Visibility(
                visible: widget.vm.type == PostType.image,
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: _buildImagePicker(),
                ),
              ),
              Visibility(
                visible: widget.vm.type == PostType.video,
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: _buildVideoPicker(),
                ),
              ),
              Visibility(
                visible: _isSubmitting,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
