// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeEntity _$NoticeEntityFromJson(Map<String, dynamic> json) => NoticeEntity(
      message: json['message'] as String? ?? '',
      level: $enumDecodeNullable(_$NoticeLevelEnumMap, json['level']) ??
          NoticeLevel.error,
      duration: json['duration'] == null
          ? const Duration(seconds: 4)
          : durationFromMillseconds(json['duration'] as int),
    );

Map<String, dynamic> _$NoticeEntityToJson(NoticeEntity instance) =>
    <String, dynamic>{
      'message': instance.message,
      'level': _$NoticeLevelEnumMap[instance.level]!,
      'duration': durationToMilliseconds(instance.duration),
    };

const _$NoticeLevelEnumMap = {
  NoticeLevel.info: 'info',
  NoticeLevel.warning: 'warning',
  NoticeLevel.error: 'error',
};
