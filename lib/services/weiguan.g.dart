// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weiguan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) => ApiResponse(
      code: json['code'] as int? ?? ApiResponse.codeOk,
      message: json['message'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ApiResponseToJson(ApiResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
