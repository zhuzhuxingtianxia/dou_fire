import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../entity/user.dart';

part 'user.g.dart';

@JsonSerializable()
@immutable
class UserState {
  final Map<String, UserEntity> users;
  final Map<String, List<int>> usersFollowing; //关注
  final Map<String, List<int>> followers; // 粉丝

  const UserState({
    this.users = const {},
    this.usersFollowing = const {},
    this.followers = const {},
  });

  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateToJson(this);

  UserState copyWith({
    Map<String, UserEntity>? users,
    Map<String, List<int>>? usersFollowing,
    Map<String, List<int>>? followers,
  }) =>
      UserState(
        users: users ?? this.users,
        usersFollowing: usersFollowing ?? this.usersFollowing,
        followers: followers ?? this.followers,
      );
}
