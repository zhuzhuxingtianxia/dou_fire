// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserState _$UserStateFromJson(Map<String, dynamic> json) => UserState(
      users: (json['users'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, UserEntity.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      usersFollowing: (json['usersFollowing'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, (e as List<dynamic>).map((e) => e as int).toList()),
          ) ??
          const {},
      followers: (json['followers'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, (e as List<dynamic>).map((e) => e as int).toList()),
          ) ??
          const {},
    );

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
      'users': instance.users,
      'usersFollowing': instance.usersFollowing,
      'followers': instance.followers,
    };
