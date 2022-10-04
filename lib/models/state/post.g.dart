// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostState _$PostStateFromJson(Map<String, dynamic> json) => PostState(
      posts: (json['posts'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, PostEntity.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      postsPublished: (json['postsPublished'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, (e as List<dynamic>).map((e) => e as int).toList()),
          ) ??
          const {},
      postsLiked: (json['postsLiked'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, (e as List<dynamic>).map((e) => e as int).toList()),
          ) ??
          const {},
      postsFollowing: (json['postsFollowing'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PostStateToJson(PostState instance) => <String, dynamic>{
      'posts': instance.posts,
      'postsPublished': instance.postsPublished,
      'postsLiked': instance.postsLiked,
      'postsFollowing': instance.postsFollowing,
    };
