import 'package:dou_fire/models/state/publish.dart';
import 'package:redux/redux.dart';

import '../actions/actions.dart';

final publishReducer = combineReducers<PublishSate>([
  TypedReducer<PublishSate, PublishSaveAction>(_save),
  TypedReducer<PublishSate, PublishAddImageAction>(_addImage),
  TypedReducer<PublishSate, PublishRemoveImageAction>(_removeImage),
  TypedReducer<PublishSate, PublishAddVideoAction>(_addVideo),
  TypedReducer<PublishSate, PublishRemoveVideoAction>(_removeVideo),
]);

PublishSate _save(PublishSate state, PublishSaveAction action) {
  return state.copyWith(
    type: action.type,
    text: action.text,
  );
}

PublishSate _addImage(PublishSate state, PublishAddImageAction action) {
  var images = List<String>.from(state.images);
  images.add(action.image);
  return state.copyWith(
    images: images,
  );
}

PublishSate _removeImage(PublishSate state, PublishRemoveImageAction action) {
  var images = List<String>.from(state.images);
  images.remove(action.image);
  return state.copyWith(
    images: images,
  );
}

PublishSate _addVideo(PublishSate state, PublishAddVideoAction action) {
  var videos = List<String>.from(state.videos);
  videos.add(action.video);
  return state.copyWith(
    videos: videos,
  );
}

PublishSate _removeVideo(PublishSate state, PublishRemoveVideoAction action) {
  var videos = List<String>.from(state.videos);
  videos.add(action.video);
  return state.copyWith(
    videos: videos,
  );
}
