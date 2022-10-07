// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostEntity _$PostEntityFromJson(Map<String, dynamic> json) => PostEntity(
      id: json['id'] as int? ?? 0,
      type:
          $enumDecodeNullable(_$PostTypeEnumMap, json['type']) ?? PostType.text,
      text: json['text'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => PostImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      video: json['video'] == null
          ? null
          : VideoEntity.fromJson(json['video'] as Map<String, dynamic>),
      likeCount: json['likeCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      creatorId: json['creatorId'] as int? ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PostEntityToJson(PostEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PostTypeEnumMap[instance.type]!,
      'text': instance.text,
      'images': instance.images,
      'video': instance.video,
      'likeCount': instance.likeCount,
      'isLiked': instance.isLiked,
      'creatorId': instance.creatorId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PostTypeEnumMap = {
  PostType.all: 'all',
  PostType.text: 'text',
  PostType.image: 'image',
  PostType.video: 'video',
};

PostImage _$PostImageFromJson(Map<String, dynamic> json) => PostImage(
      original: json['original'] == null
          ? const ImageEntity()
          : ImageEntity.fromJson(json['original'] as Map<String, dynamic>),
      thumb: json['thumb'] == null
          ? const ImageEntity()
          : ImageEntity.fromJson(json['thumb'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostImageToJson(PostImage instance) => <String, dynamic>{
      'original': instance.original,
      'thumb': instance.thumb,
    };
