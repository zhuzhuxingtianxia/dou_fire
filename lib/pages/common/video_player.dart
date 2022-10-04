import 'package:dou_fire/components/components.dart';
import 'package:dou_fire/theme.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import '../../models/models.dart';

class VideoPlayerPage extends StatelessWidget {
  final VideoEntity? video;
  final File? file;
  final VideoPlayerController? controller;

  const VideoPlayerPage({
    super.key,
    this.video,
    this.file,
    this.controller,
  }) : assert(video != null || file != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: DFTheme.blackDark,
        child: VideoPlayerWithControlBar(
          video: video,
          file: file,
          isAutoPlay: true,
          isFull: true,
          controller: controller,
        ),
      ),
    );
  }
}
