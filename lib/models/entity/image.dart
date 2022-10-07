import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// 该注解表明实体为不可变对象
@immutable
class ImageEntity {
  final String url;
  final int width;
  final int height;
  final int size;

  const ImageEntity(
      {this.url = '', this.width = 0, this.height = 0, this.size = 0});

  factory ImageEntity.fromJson(Map<String, dynamic> json) {
    return ImageEntity(
        url: json['url'] as String,
        width: json['width'] as int,
        height: json['height'] as int,
        size: json['size'] == null ? 0 : json['size'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'width': width, 'height': height, 'size': size};
  }

  double get ratio {
    return width != 0 && height != 0 ? width / height : 16 / 9;
  }
}
