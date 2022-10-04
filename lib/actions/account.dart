import 'package:dou_fire/factory.dart';
import 'package:dou_fire/models/models.dart';
import 'package:dou_fire/services/weiguan.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'reset.dart';

class AccountInfoAction {
  final UserEntity user;
  AccountInfoAction({
    required this.user,
  });
}

ThunkAction<AppState> accountRegisterAction({
  required RegisterFrom form,
  void Function(UserEntity)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/account/register',
        data: form.toJson(),
      );

      if (response.code == ApiResponse.codeOk) {
        final user = UserEntity.fromJson(response.data!['user']);
        if (onSucceed != null) onSucceed(user);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> accountLoginAction({
  required LoginFrom form,
  void Function(UserEntity)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/account/login',
        data: form.toJson(),
      );

      if (response.code == ApiResponse.codeOk) {
        final user = UserEntity.fromJson(response.data!['user']);
        store.dispatch(AccountInfoAction(user: user));
        if (onSucceed != null) onSucceed(user);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> accountLogoutAction({
  void Function()? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post('/account/logout');

      if (response.code == ApiResponse.codeOk) {
        store.dispatch(ResetStateAction());
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> accountInfoAction({
  void Function(UserEntity)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.get('/account/info');

      if (response.code == ApiResponse.codeOk) {
        final user = UserEntity.fromJson(response.data!['user']);
        store.dispatch(AccountInfoAction(user: user));
        if (onSucceed != null) onSucceed(user);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> accountEditAction({
  required ProfileForm form,
  void Function(UserEntity)? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/account/edit',
        data: form.toJson(),
      );

      if (response.code == ApiResponse.codeOk) {
        final user = UserEntity.fromJson(response.data!['user']);
        store.dispatch(accountInfoAction());
        if (onSucceed != null) onSucceed(user);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> accountSendMobileVerifyCodeAction({
  required String mobile,
  void Function()? onSucceed,
  void Function(NoticeEntity)? onFailed,
}) =>
    (Store<AppState> store) async {
      final service = await Factory().getService();
      final response = await service.post(
        '/account/send/mobile/verify/code',
        data: {'moblie': mobile},
      );

      if (response.code == ApiResponse.codeOk) {
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };
