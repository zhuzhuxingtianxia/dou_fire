import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'image.dart';
import 'video.dart';

part 'post.g.dart';

enum PostType { all, text, image, video }

@JsonSerializable()
@immutable
class PostEntity {
  static final typeNames = {
    PostType.all: '全部',
    PostType.text: '文字',
    PostType.image: '图片',
    PostType.video: '视频'
  };

  final int id;
  final PostType type;
  final String text;
  final List<PostImage> images;
  final VideoEntity? video;
  final int likeCount;
  final bool isLiked;
  final int creatorId;
  final DateTime createdAt;

  PostEntity({
    this.id = 0,
    this.type = PostType.text,
    this.text = '',
    this.images = const [],
    this.video,
    this.likeCount = 0,
    this.isLiked = false,
    this.creatorId = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get typeDesc {
    return typeNames[type] ?? '';
  }

  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PostEntityToJson(this);

  PostEntity copyWith({
    int? id,
    PostType? type,
    String? text,
    List<PostImage>? images,
    VideoEntity? video,
    int? likeCount,
    bool? isLiked,
    int? creatorId,
    DateTime? createdAt,
  }) =>
      PostEntity(
          id: id ?? this.id,
          type: type ?? this.type,
          text: text ?? this.text,
          images: images ?? this.images,
          video: video,
          likeCount: likeCount ?? this.likeCount,
          isLiked: isLiked ?? this.isLiked,
          creatorId: creatorId ?? this.creatorId,
          createdAt: createdAt);
}

class PostImage {
  final ImageEntity original;
  final ImageEntity thumb;

  PostImage({
    this.original = const ImageEntity(),
    this.thumb = const ImageEntity(),
  });

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
        original: json['original'] as ImageEntity,
        thumb: json['thumb'] as ImageEntity);
  }

  Map<String, dynamic> toJson() {
    return {'original': '', 'thumb': ''};
  }
}
