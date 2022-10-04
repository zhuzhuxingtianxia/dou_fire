import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, UserInfoAction>(_userInfo),
]);

UserState _userInfo(UserState state, UserInfoAction action) {
  return state.copyWith();
}
