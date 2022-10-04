// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoEntity _$VideoEntityFromJson(Map<String, dynamic> json) => VideoEntity(
      url: json['url'] as String? ?? '',
      cover: json['cover'] as String? ?? '',
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      duration: json['duration'] as int? ?? 0,
    );

Map<String, dynamic> _$VideoEntityToJson(VideoEntity instance) =>
    <String, dynamic>{
      'url': instance.url,
      'cover': instance.cover,
      'width': instance.width,
      'height': instance.height,
      'duration': instance.duration,
    };
