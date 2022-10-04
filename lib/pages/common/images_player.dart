import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../theme.dart';
import '../../models/models.dart';

class ImagesPlayerPage extends StatelessWidget {
  final List<ImageEntity> images;
  final List<File> files;
  final int initialIndex;

  const ImagesPlayerPage({
    super.key,
    this.images = const [],
    this.files = const [],
    this.initialIndex = 0,
  }) : assert(images.length != 0 || files.length != 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Body(
        images: images,
        files: files,
        initialIndex: initialIndex,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final List<ImageEntity> images;
  final List<File> files;
  final int initialIndex;

  const _Body({
    this.images = const [],
    this.files = const [],
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: Feedback.wrapForTap(() => Navigator.of(context).pop(), context),
      child: Container(
        color: DFTheme.blackDark,
        child: CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1.0,
            height: screenSize.height,
            initialPage: initialIndex,
          ),
          items: images.isNotEmpty
              ? images
                  .map<CachedNetworkImage>(
                    (image) => CachedNetworkImage(
                      imageUrl: image.url,
                      placeholder: (BuildContext context, String text) =>
                          Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  )
                  .toList()
              : files
                  .map<Image>(
                    (image) => Image.file(
                      image,
                      fit: BoxFit.contain,
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
