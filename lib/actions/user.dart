import 'package:dou_fire/actions/actions.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:dou_fire/services/weiguan.dart';
import '../factory.dart';
import '../models/models.dart';

class UserInfoAction {
  final UserEntity user;

  UserInfoAction({required this.user});
}

class UserInfosAction {
  final List<UserEntity> users;

  UserInfosAction({required this.users});
}

class UsersFollowingAction {
  final List<UserEntity> users;
  final int userId;
  final int? offset;
  final bool refresh;

  UsersFollowingAction({
    required this.users,
    required this.userId,
    this.offset,
    this.refresh = false,
  });
}

class FollowersAction {
  final List<UserEntity> users;
  final int userId;
  final int? offset;
  final bool refresh;

  FollowersAction({
    required this.users,
    required this.userId,
    this.offset,
    this.refresh = false,
  });
}

class FollowUserAction {
  final int userId;
  final int followingId;

  FollowUserAction({
    required this.userId,
    required this.followingId,
  });
}

class UnFollowUserAction {
  final int userId;
  final int followingId;

  UnFollowUserAction({
    required this.userId,
    required this.followingId,
  });
}

ThunkAction<AppState> userInfoAction({
  required int userId,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/user/info',
        data: {'userId': userId},
      );

      if (response.code == ApiResponse.codeOk) {
        final user =
            UserEntity.fromJson(response.data?['user'] as Map<String, dynamic>);
        store.dispatch(UserInfoAction(user: user));
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> userInfosAction({
  required List<int> userIds,
  void Function(List<UserEntity>)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/user/infos',
        data: {'userIds': userIds},
      );

      if (response.code == ApiResponse.codeOk) {
        final users = (response.data?['users'] as List<dynamic>)
            .map((value) => UserEntity.fromJson(value))
            .toList();
        store.dispatch(UserInfosAction(users: users));
        if (onSucceed != null) onSucceed(users);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> usersFollowingAction({
  required int userId,
  int? limit,
  int? offset,
  bool refresh = false,
  void Function(List<UserEntity>)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/user/followings',
        data: {
          'userId': userId,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.code == ApiResponse.codeOk) {
        final users = (response.data?['users'] as List<dynamic>)
            .map((value) => UserEntity.fromJson(value))
            .toList();

        store.dispatch(UsersFollowingAction(
          users: users,
          userId: userId,
          offset: offset,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(users);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> followersAction({
  required int userId,
  int? limit,
  int? offset,
  bool refresh = false,
  void Function(List<UserEntity>)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/user/followers',
        data: {
          'userId': userId,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.code == ApiResponse.codeOk) {
        final users = (response.data?['users'] as List<dynamic>)
            .map((value) => UserEntity.fromJson(value))
            .toList();

        store.dispatch(FollowersAction(
          users: users,
          userId: userId,
          offset: offset,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(users);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> followUserAction({
  required int followingId,
  void Function()? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/user/follow',
        data: {'userId': followingId},
      );

      if (response.code == ApiResponse.codeOk) {
        store.dispatch(FollowUserAction(
          userId: store.state.accountState.user.id,
          followingId: followingId,
        ));

        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> unfollowUserAction({
  required int followingId,
  void Function()? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/user/unfollow',
        data: {'userId': followingId},
      );

      if (response.code == ApiResponse.codeOk) {
        store.dispatch(UnFollowUserAction(
          userId: store.state.accountState.user.id,
          followingId: followingId,
        ));

        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };
