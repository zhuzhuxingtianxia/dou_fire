import 'package:dou_fire/models/state/publish.dart';
import 'package:redux/redux.dart';

import '../actions/actions.dart';

final publishReducer = combineReducers<PublishSate>([
  TypedReducer<PublishSate, PublishInfoAction>(_publishInfo),
]);

PublishSate _publishInfo(PublishSate state, PublishInfoAction action) {
  return state.copyWith();
}
