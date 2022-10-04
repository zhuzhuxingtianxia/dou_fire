import 'package:dou_fire/models/entity/user.dart';

class AccountState {
  final UserEntity user;

  AccountState({UserEntity? user}) : user = user ?? UserEntity();

  factory AccountState.fromJson(Map<String, dynamic> json) {
    return AccountState(user: UserEntity.fromJson(json['user']));
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson()};
  }

  AccountState copyWith({UserEntity? user}) => AccountState(user: user);
}
