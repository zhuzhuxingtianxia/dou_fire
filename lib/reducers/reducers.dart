import 'package:redux_persist/redux_persist.dart';

import '../models/models.dart';
import '../actions/actions.dart';
import 'account.dart';
import 'publish.dart';
import 'post.dart';
import 'user.dart';

AppState appReducer(AppState state, action) {
  if (action is ResetStateAction) {
    return AppState();
  } else if (action is ResetPublishStateAction) {
    return state.copyWith(
      publishSate: const PublishSate(),
    );
  }
  // else if (action is PersistLoadedAction<AppState>) {
  //   return action.state ?? state;
  // } else if (action is PersistErrorAction) {
  //   // ignore: avoid_print
  //   print(action.error);
  //   return AppState();
  // }
  else {
    return state.copyWith(
      accountState: accountReducer(state.accountState, action),
      publishSate: publishReducer(state.publishSate, action),
      postState: postReducer(state.postState, action),
      userState: userReducer(state.userState, action),
    );
  }
}
