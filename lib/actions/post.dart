import 'dart:io';
import 'dart:convert';
import 'package:dou_fire/actions/actions.dart';
import 'package:dou_fire/models/entity/user.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:dou_fire/factory.dart';
import 'package:dou_fire/models/entity/notice.dart';
import 'package:dou_fire/models/entity/post.dart';
import 'package:dou_fire/models/state/app.dart';
import 'package:dou_fire/services/weiguan.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class DeletePostAction {
  final PostEntity post;
  DeletePostAction({required this.post});
}

class PostsPublishedAction {
  final List<PostEntity> posts;
  final int userId;
  final int? beforeId;
  final int? afterId;
  final bool refresh;

  PostsPublishedAction({
    required this.posts,
    required this.userId,
    this.beforeId,
    this.afterId,
    this.refresh = false,
  });
}

class PostsLikedAction {
  final List<PostEntity> posts;
  final int userId;
  final int? beforeId;
  final int? afterId;
  final bool refresh;

  PostsLikedAction({
    required this.posts,
    required this.userId,
    this.beforeId,
    this.afterId,
    this.refresh = false,
  });
}

class LikePostAction {
  final int userId;
  final int postId;

  LikePostAction({
    required this.userId,
    required this.postId,
  });
}

class UnLikePostAction {
  final int userId;
  final int postId;

  UnLikePostAction({required this.userId, required this.postId});
}

class PostsFollowingAction {
  final List<PostEntity> posts;
  final int? beforeId;
  final int? afterId;
  final bool refresh;

  PostsFollowingAction({
    required this.posts,
    this.beforeId,
    this.afterId,
    this.refresh = false,
  });
}

ThunkAction<AppState> publishPostAction({
  required PostType type,
  String text = '',
  List<String> images = const [],
  List<String> videos = const [],
  void Function(int)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();

      Map<String, dynamic> data = {
        'type': type.toString().split('.')[1],
        'text': text,
      };

      if (type == PostType.image) {
        for (var i = 0; i < images.length; i++) {
          // data['file${i + 1}'] = UploadFileInfo(File(images[i]), basename(images[i]));
          // data['file${i + 1}'] = await MultipartFile.fromFile(images[i], filename: "${base64Encode(utf8.encode(DateTime.now().toString()))}.png",);
          data['file${i + 1}'] = await MultipartFile.fromFile(
            images[i],
            filename: basename(images[i]),
          );
        }
      } else if (type == PostType.video) {
        for (var i = 0; i < videos.length; i++) {
          data['file${i + 1}'] = await MultipartFile.fromFile(
            videos[i],
            filename: basename(images[i]),
          );
        }
      }

      final response = await service.postForm(
        '/post/create',
        data: FormData.fromMap(data),
      );

      if (response.code == ApiResponse.codeOk) {
        final id = response.data?['id'] as int;
        if (onSucceed != null) onSucceed(id);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> deletePostAction({
  required PostEntity post,
  void Function()? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/post/delete',
        data: {'id': post.id},
      );

      if (response.code == ApiResponse.codeOk) {
        store.dispatch(DeletePostAction(post: post));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> postsPublishedAction({
  required int userId,
  int? limit,
  int? beforeId,
  int? afterId,
  bool refresh = false,
  void Function(List<PostEntity>)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/post/published',
        data: {
          'userId': userId,
          'limit': limit,
          'beforeId': beforeId,
          'afterId': afterId,
        },
      );

      if (response.code == ApiResponse.codeOk) {
        final users = (response.data?['posts'] as List<dynamic>)
            .map<UserEntity>((v) => UserEntity.fromJson(v['creator']))
            .toList();
        store.dispatch(UserInfosAction(users: users));

        final posts = (response.data?['posts'] as List<dynamic>)
            .map<PostEntity>((v) => PostEntity.fromJson(v))
            .toList();
        store.dispatch(PostsPublishedAction(
          posts: posts,
          userId: userId,
          beforeId: beforeId,
          afterId: afterId,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(posts);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> likePostAction({
  required int postId,
  void Function()? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/post/like',
        data: {'postId': postId},
      );

      if (response.code == ApiResponse.codeOk) {
        store.dispatch(
          LikePostAction(
            userId: store.state.accountState.user.id,
            postId: postId,
          ),
        );
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) {
          onFailed(NoticeEntity(message: response.message));
        }
      }
    };

ThunkAction<AppState> unlikePostAction({
  required int postId,
  void Function()? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/post/unlike',
        data: {'postId': postId},
      );

      if (response.code == ApiResponse.codeOk) {
        store.dispatch(
          UnLikePostAction(
            userId: store.state.accountState.user.id,
            postId: postId,
          ),
        );
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) {
          onFailed(NoticeEntity(message: response.message));
        }
      }
    };

ThunkAction<AppState> postsFollowingAcction({
  int? limit,
  int? beforeId,
  int? afterId,
  bool refresh = false,
  void Function(List<PostEntity>)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.get(
        '/post/following',
        data: {
          'limit': limit,
          'beforeId': beforeId,
          'afterId': afterId,
        },
      );

      if (response.code == ApiResponse.codeOk) {
        final users = (response.data!['posts'] as List<dynamic>)
            .map<UserEntity>((v) => UserEntity.fromJson(v['creator']))
            .toList();

        store.dispatch(UserInfosAction(users: users));

        final posts = (response.data!['posts'] as List<dynamic>)
            .map<PostEntity>((v) => PostEntity.fromJson(v))
            .toList();

        store.dispatch(PostsFollowingAction(
          posts: posts,
          beforeId: beforeId,
          afterId: afterId,
          refresh: refresh,
        ));

        if (onSucceed != null) onSucceed(posts);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> postsLikedAction({
  required int userId,
  int? limit,
  int? beforeId,
  int? afterId,
  bool refresh = false,
  void Function(List<PostEntity>)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.get(
        '/post/liked',
        data: {
          'userId': userId,
          'limit': limit,
          'beforeId': beforeId,
          'afterId': afterId,
        },
      );

      if (response.code == ApiResponse.codeOk) {
        final users = (response.data!['posts'] as List<dynamic>)
            .map<UserEntity>((v) => UserEntity.fromJson(v['creator']))
            .toList();

        store.dispatch(UserInfosAction(users: users));

        final posts = (response.data!['posts'] as List<dynamic>)
            .map<PostEntity>((v) => PostEntity.fromJson(v))
            .toList();

        store.dispatch(PostsLikedAction(
          posts: posts,
          userId: userId,
          beforeId: beforeId,
          afterId: afterId,
          refresh: refresh,
        ));

        if (onSucceed != null) onSucceed(posts);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };
