import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../theme.dart';
import '../../pages/pages.dart';
import '../../models/models.dart';

class VideoPlayerWithCover extends StatefulWidget {
  final VideoEntity video;

  const VideoPlayerWithCover({super.key, required this.video});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerWithCoverState createState() => _VideoPlayerWithCoverState();
}

class _VideoPlayerWithCoverState extends State<VideoPlayerWithCover> {
  var _isPlayMode = false;

  void _switchToPlayMode() {
    setState(() {
      _isPlayMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isPlayMode
        ? VideoPlayerWithControlBar(
            video: widget.video,
            isAutoPlay: true,
          )
        : GestureDetector(
            onTap: Feedback.wrapForTap(_switchToPlayMode, context),
            child: AspectRatio(
              aspectRatio: widget.video.ratio,
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(imageUrl: widget.video.cover),
                  Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: DFTheme.blackLighter,
                      child: Icon(
                        Icons.play_arrow,
                        size: 50,
                        color: DFTheme.whiteLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

// 有控制条的播放器
class VideoPlayerWithControlBar extends StatefulWidget {
  final VideoEntity? video;
  final File? file;
  final bool isAutoPlay;
  final bool isFull;
  final VideoPlayerController? controller;

  const VideoPlayerWithControlBar({
    super.key,
    this.video,
    this.file,
    this.isAutoPlay = false,
    this.isFull = false,
    this.controller,
  }) : assert(video != null || file != null);

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerWithControlBarState();
  }
}

class _VideoPlayerWithControlBarState extends State<VideoPlayerWithControlBar> {
  // 用于停止播放正在播放的视频
  static VideoPlayerController? _activeController;

  late VideoPlayerController _controller;
  var _isInitialized = false;
  var _isPlaying = false;
  var _isEnded = false;
  var _isControlBarVisible = true;
  Timer? _controlBarInvisibleTimer;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      if (widget.video != null) {
        _controller = VideoPlayerController.network(widget.video!.url);
      } else if (widget.file != null) {
        _controller = VideoPlayerController.file(widget.file!);
      }
      _controller
        ..addListener(_controllerListener)
        ..initialize();
    } else {
      _controller = widget.controller!;
      _controller.addListener(_controllerListener);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller
        ..removeListener(_controllerListener)
        ..dispose();
    } else {
      _controller.removeListener(_controllerListener);
    }

    if (_activeController == _controller) {
      _activeController = null;
    }

    if (_controlBarInvisibleTimer?.isActive == true) {
      _controlBarInvisibleTimer?.cancel();
    }

    super.dispose();
  }

  void _controllerListener() {
    if (!_controller.value.isInitialized) {
      //判断是否完成初始化工作
      return;
    }
    if (!_isInitialized) {
      _isInitialized = true;

      if (widget.isAutoPlay && !_isPlaying) {
        _play();
      }
    }

    if (!_isEnded && _controller.value.position >= _controller.value.duration) {
      _isEnded = true;
      _isControlBarVisible = true;
    } else if (_isEnded &&
        _controller.value.position < _controller.value.duration) {
      _isEnded = false;
      _isControlBarVisible = false;
    }

    if (_controller.value.isPlaying && !_isEnded) {
      _isPlaying = true;
    } else {
      _isPlaying = false;
    }
    setState(() {});
  }

  void _play() {
    if (_activeController != _controller) {
      if (_activeController != null && _activeController!.value.isPlaying) {
        _activeController?.pause();
      }
      _activeController = _controller;
    }

    if (_isEnded) {
      _controller.seekTo(const Duration(seconds: 0));
    } else {
      _controller.play();
    }

    if (_isControlBarVisible) {
      if (_controlBarInvisibleTimer?.isActive == true) {
        _controlBarInvisibleTimer?.cancel();
      }
      _controlBarInvisibleTimer = Timer(const Duration(seconds: 4), () {
        if (_isPlaying) {
          setState(() {
            _isControlBarVisible = false;
          });
        }
      });
    }
  }

  void _togglePlaying() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _play();
    }
  }

  void _toggleControlling() {
    setState(() {
      _isControlBarVisible = !_isControlBarVisible;
    });
  }

  void _toggleFull() async {
    if (widget.isFull) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              VideoPlayerPage(
            video: widget.video,
            file: widget.file,
            controller: _controller,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      );
    }
  }

  Widget _buildControlBar(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: Feedback.wrapForTap(_togglePlaying, context),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: DFTheme.blackLighter,
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 45,
                color: DFTheme.whiteLight,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: DefaultTextStyle(
            style: TextStyle(color: DFTheme.whiteLight),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                      '${(_controller.value.position.inSeconds / 60).floor().toString().padLeft(2, '0')}: ${(_controller.value.position.inSeconds % 60).toString().padLeft(2, '0')}'),
                ),
                Flexible(
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    colors: VideoProgressColors(
                      backgroundColor: DFTheme.greyNormal,
                      bufferedColor: DFTheme.whiteNormal,
                      playedColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                      '${((_controller.value.duration.inSeconds) / 60).floor().toString().padLeft(2, '0')}: ${(_controller.value.position.inSeconds % 60).toString().padLeft(2, '0')}'),
                ),
                GestureDetector(
                  onTap: Feedback.wrapForTap(_toggleFull, context),
                  child: Icon(
                    widget.isFull ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: DFTheme.whiteLight,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Feedback.wrapForTap(_toggleControlling, context),
      child: AspectRatio(
        aspectRatio: _isInitialized ? _controller.value.aspectRatio : 16 / 9,
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: _isInitialized,
              child: VideoPlayer(_controller),
            ),
            Visibility(
              visible: _isInitialized && _isControlBarVisible,
              child: _buildControlBar(context),
            ),
            Visibility(
              visible:
                  _isInitialized && _isPlaying == false && _isEnded == false,
              child: Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
