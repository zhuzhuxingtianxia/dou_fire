// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publish.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublishSate _$PublishSateFromJson(Map<String, dynamic> json) => PublishSate(
      type: $enumDecodeNullable(_$PostTypeEnumMap, json['type']) ??
          PostType.image,
      text: json['text'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PublishSateToJson(PublishSate instance) =>
    <String, dynamic>{
      'type': _$PostTypeEnumMap[instance.type]!,
      'text': instance.text,
      'images': instance.images,
      'videos': instance.videos,
    };

const _$PostTypeEnumMap = {
  PostType.all: 'all',
  PostType.text: 'text',
  PostType.image: 'image',
  PostType.video: 'video',
};
