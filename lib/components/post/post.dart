import 'package:dou_fire/models/entity/image.dart';
import 'package:dou_fire/models/entity/video.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../pages/common/images_player.dart';

class _PostState extends State {
  Widget _buildImages(List<PostImage> images) {
    return LayoutBuilder(builder: (context, constraints) {
      final double margin = 5;
      final columns = 3;
      final width = (constraints.maxWidth - (columns - 1) * margin) / columns;
      final height = width;

      return Wrap(
        spacing: margin,
        runSpacing: margin,
        children: images
            .asMap()
            .entries
            .map<Widget>(
              (entry) => GestureDetector(
                onTap: Feedback.wrapForTap(
                    () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ImagesPlayerPage(
                            images: images
                                .map<ImageEntity>((image) => image.original)
                                .toList(),
                            initialIndex: entry.key,
                          ),
                        )),
                    context),
                child: CachedNetworkImage(
                  imageUrl: entry.value.thumb.url,
                  fit: BoxFit.cover,
                  width: width,
                  height: height,
                ),
              ),
            )
            .toList(),
      );
    });
  }

  Widget _buildVideo(VideoEntity video) {
    return VideoPlayerWithCover(video: widget.post.video);
  }

  Widget _buildBody(BuildContext context) {
    switch (widget.post.type) {
    }
  }
}
