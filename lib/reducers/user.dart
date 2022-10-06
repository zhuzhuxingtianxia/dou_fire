import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, UserInfoAction>(_userInfo),
  TypedReducer<UserState, UserInfosAction>(_userInfos),
  TypedReducer<UserState, UsersFollowingAction>(_usersFollowing),
  TypedReducer<UserState, FollowersAction>(_followers),
  TypedReducer<UserState, FollowerUserAction>(_followUser),
  TypedReducer<UserState, UnFollowUserAction>(_unfollowUser),
]);

UserState _userInfo(UserState state, UserInfoAction action) {
  var userId = action.user.id.toString();

  var users = Map<String, UserEntity>.from(state.users);
  users[userId] = action.user;
  return state.copyWith(
    users: users,
  );
}

UserState _userInfos(UserState state, UserInfosAction action) {
  var users = Map<String, UserEntity>.from(state.users);
  users.addAll(Map.fromIterable(
    action.users,
    key: (v) => (v as UserEntity).id.toString(),
    value: (v) => v,
  ));
  return state.copyWith(
    users: users,
  );
}

UserState _usersFollowing(UserState state, UsersFollowingAction action) {
  var userId = action.userId.toString();
  var users = Map<String, UserEntity>.from(state.users);
  users.addAll(Map.fromIterable(
    action.users,
    key: (v) => (v as UserEntity).id.toString(),
    value: (v) => v,
  ));
  return state.copyWith(
    users: users,
  );
}

UserState _followers(UserState state, FollowersAction action) {
  return state.copyWith();
}

UserState _followUser(UserState state, FollowerUserAction action) {
  return state.copyWith();
}

UserState _unfollowUser(UserState state, UnFollowUserAction action) {
  return state.copyWith();
}
