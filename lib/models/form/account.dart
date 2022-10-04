import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class RegisterFrom {
  String username;
  String password;

  RegisterFrom({this.username = '', this.password = ''});

  factory RegisterFrom.fromJson(Map<String, dynamic> json) =>
      _$RegisterFromFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterFromToJson(this);
}

@JsonSerializable()
class LoginFrom {
  String username;
  String password;

  LoginFrom({this.username = '', this.password = ''});

  factory LoginFrom.fromJson(Map<String, dynamic> json) =>
      _$LoginFromFromJson(json);

  Map<String, dynamic> toJson() => _$LoginFromToJson(this);
}

@JsonSerializable()
class ProfileForm {
  String? username;
  String? password;
  String? avatar;
  String? mobile;
  String? email;
  String? code;

  ProfileForm({
    this.username,
    this.password,
    this.avatar,
    this.mobile,
    this.email,
    this.code,
  });

  factory ProfileForm.fromJson(Map<String, dynamic> json) =>
      _$ProfileFormFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileFormToJson(this);
}
