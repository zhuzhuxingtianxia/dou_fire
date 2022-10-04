// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterFrom _$RegisterFromFromJson(Map<String, dynamic> json) => RegisterFrom(
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$RegisterFromToJson(RegisterFrom instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

LoginFrom _$LoginFromFromJson(Map<String, dynamic> json) => LoginFrom(
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$LoginFromToJson(LoginFrom instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

ProfileForm _$ProfileFormFromJson(Map<String, dynamic> json) => ProfileForm(
      username: json['username'] as String?,
      password: json['password'] as String?,
      avatar: json['avatar'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$ProfileFormToJson(ProfileForm instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'avatar': instance.avatar,
      'mobile': instance.mobile,
      'email': instance.email,
      'code': instance.code,
    };
