import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../utils/json.dart';

part 'notice.g.dart';

enum NoticeLevel { info, warning, error }

@JsonSerializable()
@immutable // 该注解表明实体为不可变对象
class NoticeEntity {
  final String message;
  final NoticeLevel level;

  @JsonKey(
    fromJson: durationFromMillseconds,
    toJson: durationToMilliseconds,
  )
  final Duration duration;

  const NoticeEntity({
    this.message = '',
    this.level = NoticeLevel.error,
    this.duration = const Duration(seconds: 4),
  });

  factory NoticeEntity.fromJson(Map<String, dynamic> json) =>
      _$NoticeEntityFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeEntityToJson(this);
}
