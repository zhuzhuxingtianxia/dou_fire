import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final postReducer = combineReducers<PostState>([
  TypedReducer<PostState, DeletePostAction>(_deletePost),
  TypedReducer<PostState, PostsPublishedAction>(_postsPublished),
  TypedReducer<PostState, PostsLikedAction>(_postsLiked),
  TypedReducer<PostState, LikePostAction>(_likePost),
  TypedReducer<PostState, UnLikePostAction>(_unlikePost),
  TypedReducer<PostState, PostsFollowingAction>(_postsFollowing),
]);

PostState _deletePost(PostState state, DeletePostAction action) {
  var creatorId = action.post.creatorId.toString();

  var postsPublished = Map<String, List<int>>.from(state.postsPublished);
  postsPublished[creatorId]?.remove(action.post.id);

  var postsFollowing = List<int>.from(state.postsFollowing);
  postsFollowing.remove(action.post.id);

  return state.copyWith(
    postsPublished: postsPublished,
    postsFollowing: postsFollowing,
  );
}

PostState _postsPublished(PostState state, PostsPublishedAction action) {
  var userId = action.userId.toString();

  var posts = Map<String, PostEntity>.from(state.posts);
  posts.addAll(Map.fromIterable(
    action.posts,
    key: (v) => (v as PostEntity).id.toString(),
    value: (v) => v,
  ));

  return state.copyWith();
}

PostState _postsLiked(PostState state, PostsLikedAction action) {
  return state.copyWith();
}

PostState _likePost(PostState state, LikePostAction action) {
  var postId = action.postId.toString();
  var userId = action.userId.toString();

  var posts = Map<String, PostEntity>.from(state.posts);
  posts[postId] = posts[postId]!.copyWith(isLiked: true);

  var postsLiked = Map<String, List<int>>.from(state.postsLiked);
  postsLiked[userId] = postsLiked[userId] ?? [];
  postsLiked[userId]!
    ..remove(action.postId)
    ..insert(0, action.postId);

  return state.copyWith(
    posts: posts,
    postsLiked: postsLiked,
  );
}

PostState _unlikePost(PostState state, UnLikePostAction action) {
  var postId = action.postId.toString();
  var userId = action.userId.toString();

  var posts = Map<String, PostEntity>.from(state.posts);
  posts[postId] = posts[postId]!.copyWith(isLiked: false);

  var postsLiked = Map<String, List<int>>.from(state.postsLiked);
  postsLiked[userId] = postsLiked[userId] ?? [];
  postsLiked[userId]!.remove(action.postId);

  return state.copyWith(
    posts: posts,
    postsLiked: postsLiked,
  );
}

PostState _postsFollowing(PostState state, PostsFollowingAction action) {
  final posts = Map<String, PostEntity>.from(state.posts);
  posts.addAll(Map.fromIterable(
    action.posts,
    key: (v) => (v as PostEntity).id.toString(),
    value: (v) => v,
  ));
  return state.copyWith();
}
