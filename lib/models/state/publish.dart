import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models.dart';

part 'publish.g.dart';

@JsonSerializable()
@immutable
class PublishSate {
  final PostType type;
  final String text;
  final List<String> images;
  final List<String> videos;

  const PublishSate({
    this.type = PostType.image,
    this.text = '',
    this.images = const [],
    this.videos = const [],
  });

  factory PublishSate.fromJson(Map<String, dynamic> json) =>
      _$PublishSateFromJson(json);

  Map<String, dynamic> toJson() => _$PublishSateToJson(this);

  PublishSate copyWith({
    PostType? type,
    String? text,
    List<String>? images,
    List<String>? videos,
  }) =>
      PublishSate(
        type: type ?? this.type,
        text: text ?? this.text,
        images: images ?? this.images,
        videos: videos ?? this.videos,
      );
}
