import 'dart:io';
import 'dart:convert';
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
  DeletePostAction();
}

class PostsPublishedAction {}

class PostsLikedAction {}

class LikePostAction {}

class UnLikePostAction {}

class PostsFollowingAction {
  final List<PostEntity> posts;
  final int beforeId;
  final int afterId;
  final bool refresh;

  PostsFollowingAction({
    required this.posts,
    this.beforeId = 0,
    this.afterId = 0,
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
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };
