import 'package:meta/meta.dart';

import 'package:dou_fire/config.dart';
import 'package:dou_fire/models/state/account.dart';
import 'package:dou_fire/models/state/post.dart';
import 'package:dou_fire/models/state/publish.dart';
import 'package:dou_fire/models/state/user.dart';

@immutable
class AppState {
  final String version;
  final AccountState accountState;
  final PostState postState;
  final PublishSate publishSate;
  final UserState userState;

  AppState({
    String? version,
    AccountState? accountState,
    PostState? postState,
    PublishSate? publishSate,
    UserState? userState,
  })  : version = version ?? Config.packageInfo.version,
        accountState = accountState ?? AccountState(),
        postState = postState ?? const PostState(),
        publishSate = publishSate ?? const PublishSate(),
        userState = userState ?? const UserState();

  factory AppState.fromJson(dynamic json) {
    return AppState();
  }

  Map<String, dynamic> toJson() {
    return {};
  }

  AppState copyWith({
    String? version,
    AccountState? accountState,
    PostState? postState,
    PublishSate? publishSate,
    UserState? userState,
  }) =>
      AppState(
          version: version,
          accountState: accountState,
          postState: postState,
          publishSate: publishSate,
          userState: userState);
}
