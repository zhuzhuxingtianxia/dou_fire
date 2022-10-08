import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable()
@immutable
class VideoEntity {
  final String url;
  final String cover;
  final int width;
  final int height;
  final int duration;

  const VideoEntity({
    this.url = '',
    this.cover = '',
    this.width = 0,
    this.height = 0,
    this.duration = 0,
  });

  factory VideoEntity.fromJson(Map<String, dynamic> json) =>
      _$VideoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$VideoEntityToJson(this);

  double get ratio {
    return width != 0 && height != 0 ? width / height : 16 / 9;
  }

  VideoEntity copyWith({
    String? url,
    String? cover,
    int? width,
    int? height,
    int? duration,
  }) =>
      VideoEntity(
        url: url ?? this.url,
        cover: cover ?? this.cover,
        width: width ?? this.width,
        height: height ?? this.height,
        duration: duration ?? this.duration,
      );
}
